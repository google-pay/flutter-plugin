import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'pay_platform_interface.dart';

class PayMethodChannel extends PayPlatform {
  final MethodChannel channel =
      const MethodChannel('plugins.flutter.io/pay_channel');

  @override
  Future<bool> userCanPay(Map<String, dynamic> paymentProfile) async =>
      await channel.invokeMethod('userCanPay', jsonEncode(paymentProfile));

  @override
  Future<Map<String, dynamic>> showPaymentSelector(
          Map<String, dynamic> paymentProfile, String price) async =>
      jsonDecode(
        await channel.invokeMethod('showPaymentSelector', {
          'payment_profile': jsonEncode(paymentProfile),
          'price': price,
        }),
      );
}
