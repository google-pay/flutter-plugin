part of '../pay_mobile.dart';

class PayMobileChannel extends PayChannel {
  @override
  Future<bool> userCanPay(Map<String, dynamic> paymentProfile) async =>
      await channel.invokeMethod('userCanPay', jsonEncode(paymentProfile));

  @override
  Future<Map<String, dynamic>> showPaymentSelector(
          Map<String, dynamic> paymentProfile, String price) async =>
      jsonDecode(await channel.invokeMethod('showPaymentSelector',
          {'payment_profile': jsonEncode(paymentProfile), 'price': price}));
}
