import 'dart:async';

import 'package:flutter/services.dart';

import 'google_pay_platform_interface.dart';

class GooglePayChannel extends GooglePayPlatform {
  final MethodChannel channel =
      const MethodChannel('plugins.flutter.io/google_pay_channel');

  @override
  Future<bool> userCanPay(Map<String, dynamic> paymentProfile) {
    throw UnimplementedError('userCanPay() has not been implemented.');
  }

  @override
  Future<Map<String, dynamic>> showPaymentSelector(
      Map<String, dynamic> paymentProfile, String price) {
    throw UnimplementedError('showPaymentSelector() has not been implemented.');
  }
}
