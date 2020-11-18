part of '../google_pay_mobile.dart';

class GooglePayMobileChannel extends GooglePayChannel {
  @override
  Future<bool> userCanPay(Map<String, dynamic> paymentProfile) async =>
      await GooglePayChannel.channel
          .invokeMethod('userCanPay', jsonEncode(paymentProfile));

  @override
  Future<Map<String, dynamic>> showPaymentSelector(
          Map<String, dynamic> paymentData) async =>
      jsonDecode(await GooglePayChannel.channel
          .invokeMethod('showPaymentSelector', jsonEncode(paymentData)));
}
