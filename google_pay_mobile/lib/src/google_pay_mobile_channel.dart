part of '../google_pay_mobile.dart';

class GooglePayMobileChannel extends GooglePayChannel {
  @override
  Future<bool> userCanPay(Map<String, dynamic> paymentProfile) =>
      GooglePayChannel.channel.invokeMethod('userCanPay', paymentProfile);

  @override
  Future<Map<String, dynamic>> showPaymentSelector(
      Map<String, dynamic> paymentData) async {
    return jsonDecode(await GooglePayChannel.channel
        .invokeMethod('showPaymentSelector', paymentData));
  }
}
