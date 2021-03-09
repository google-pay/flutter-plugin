part of '../pay.dart';

class Pay {
  final PayPlatform _payPlatform;
  Future? _initializationFuture;
  late final Map<String, dynamic> _paymentProfile;

  Pay._(Map<String, dynamic> paymentProfile)
      : _payPlatform = PayAndroidChannel() {
    _paymentProfile = _populateProfile(paymentProfile);
  }

  Pay.fromJson(String paymentProfileString)
      : this._(jsonDecode(paymentProfileString));

  Pay.fromAsset(String paymentProfileAsset,
      {Future<Map<String, dynamic>> profileLoader(String value) =
          _defaultProfileLoader})
      : _payPlatform = PayAndroidChannel(),
        _initializationFuture = profileLoader(paymentProfileAsset) {
    _loadPaymentProfile();
  }

  static Future<Map<String, dynamic>> _defaultProfileLoader(
          String paymentProfileAsset) async =>
      await rootBundle.loadStructuredData(
          'assets/$paymentProfileAsset', (s) async => jsonDecode(s));

  Future _loadPaymentProfile() async {
    _paymentProfile = _populateProfile(await _initializationFuture);
  }

  Map<String, dynamic> _populateProfile(Map<String, dynamic> paymentProfile) {
    final updatedMerchantInfo = {
      ...paymentProfile['merchantInfo'] ?? {},
      'softwareInfo': {'id': 'pay-flutter-plug-in', 'version': '0.9.9'}
    };

    return Map.unmodifiable(
        {...paymentProfile, 'merchantInfo': updatedMerchantInfo});
  }

  Future<Map> get paymentProfile async {
    await _initializationFuture;
    return _paymentProfile;
  }

  Future<String> get environment async => (await paymentProfile)['environment'];

  Future<bool> userCanPay() async {
    // Wait for the client to finish instantiation before issuing calls
    await _initializationFuture;
    return _payPlatform.userCanPay(_paymentProfile);
  }

  Future<Map<String, dynamic>> showPaymentSelector({
    required String price,
  }) async {
    await _initializationFuture;
    return _payPlatform.showPaymentSelector(_paymentProfile, price);
  }
}
