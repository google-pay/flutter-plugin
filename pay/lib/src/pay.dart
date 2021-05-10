part of '../pay.dart';

const supportedProviders = {
  TargetPlatform.android: ['google_pay'],
  TargetPlatform.iOS: ['apple_pay'],
};

class Pay {
  final PayPlatform _payPlatform;
  Future? _initializationFuture;
  late final PaymentConfiguration _configuration;

  Pay._(Map<String, dynamic> paymentConfiguration)
      : _payPlatform = PayMethodChannel() {
    _configuration = PaymentConfiguration.fromMap(paymentConfiguration);
  }

  Pay.fromJson(String paymentConfigurationString)
      : this._(jsonDecode(paymentConfigurationString));

  Pay.fromAsset(
    String paymentConfigurationAsset, {
    Future<Map<String, dynamic>> Function(String value) profileLoader =
        _defaultProfileLoader,
  })  : _payPlatform = PayMethodChannel(),
        _initializationFuture = profileLoader(paymentConfigurationAsset) {
    _loadPaymentConfiguration();
  }

  static Future<Map<String, dynamic>> _defaultProfileLoader(
          String paymentConfigurationAsset) async =>
      await rootBundle.loadStructuredData(
          'assets/$paymentConfigurationAsset', (s) async => jsonDecode(s));

  Future _loadPaymentConfiguration() async {
    _configuration = PaymentConfiguration.fromMap(await _initializationFuture);
  }

  Future<Map<String, dynamic>> _getPaymentData() async {
    await _initializationFuture;
    return await _configuration.parameters;
  }

  Future<bool> userCanPay() async {
    // Wait for the client to finish instantiation before issuing calls
    await _initializationFuture;

    if (supportedProviders[defaultTargetPlatform]!
        .contains(_configuration.provider.toSimpleString())) {
      return _payPlatform.userCanPay(await _getPaymentData());
    }

    return Future.value(false);
  }

  Future<Map<String, dynamic>> showPaymentSelector({
    required List<PaymentItem> paymentItems,
  }) async {
    await _initializationFuture;
    return _payPlatform.showPaymentSelector(
        await _getPaymentData(), paymentItems);
  }
}
