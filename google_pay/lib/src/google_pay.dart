part of '../google_pay.dart';

class GooglePay {
  final GooglePayPlatform _googlePayPlatform;
  Future _initializationFuture;

  Map<String, dynamic> _paymentProfile;

  GooglePay(
      {@required String paymentProfileAsset,
      Future<Map<String, dynamic>> profileLoader(String value) =
          _defaultProfileLoader})
      : _googlePayPlatform = GooglePayMobileChannel() {
    _initializationFuture =
        _initializeClient(paymentProfileAsset, profileLoader);
  }

  static Future<Map<String, dynamic>> _defaultProfileLoader(
          String paymentProfileAsset) async =>
      await rootBundle.loadStructuredData(
          'assets/$paymentProfileAsset', (s) async => jsonDecode(s));

  Future _initializeClient(String paymentProfileAsset,
      Future<Map<String, dynamic>> profileLoader(String value)) async {
    var paymentProfile = await profileLoader(paymentProfileAsset);
    var map = {
      ...paymentProfile['merchantInfo'] ?? {},
      'softwareInfo': {'id': 'google-pay-flutter-plug-in', 'version': '0.9.9'}
    };
    var updatedMerchantInfo = map;

    _paymentProfile = Map.unmodifiable(
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
    return _googlePayPlatform.userCanPay(_paymentProfile);
  }

  Future<Map<String, dynamic>> showPaymentSelector(
      {@required String price}) async {
    await _initializationFuture;
    return _googlePayPlatform.showPaymentSelector(_paymentProfile, price);
  }
}
