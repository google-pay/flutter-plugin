part of '../google_pay.dart';

class GooglePay {
  final GooglePayPlatform _googlePayPlatform;
  Future _initializationFuture;

  Map<String, dynamic> _paymentProfile;

  GooglePay({@required String paymentProfileAsset})
      : _googlePayPlatform = GooglePayMobileChannel() {
    _initializationFuture = _initializeClient(paymentProfileAsset);
  }

  Future _initializeClient(String paymentProfileAsset) async {
    // Load configuration from file
    String jsonData =
        await rootBundle.loadString('assets/$paymentProfileAsset');
    _paymentProfile = jsonDecode(jsonData);

    // Add merchant info
    _paymentProfile['merchantInfo']['softwareInfo'] = {
      'id': 'google-pay-flutter-plug-in',
      'version': '0.9.9'
    };
  }

  Future<bool> userCanPay() async {
    // Wait for the client to finish instantiation before issuing calls
    await _initializationFuture;
    return _googlePayPlatform.userCanPay(_paymentProfile);
  }

  Future<Map<String, dynamic>> showPaymentSelector({@required String price}) {
    return _googlePayPlatform.showPaymentSelector(_paymentProfile, price);
  }
}
