import 'dart:async';

import 'package:flutter/services.dart';

import 'google_pay_platform_interface.dart';

class GooglePayChannel extends GooglePayPlatform {
  static GooglePayChannel _instance = GooglePayChannel();
  static GooglePayChannel get instance => _instance;

  static const MethodChannel channel =
      const MethodChannel('plugins.flutter.io/google_pay_mobile');

  @override
  Future<bool> userCanPay(Map<String, dynamic> paymentProfile) {
    throw UnimplementedError('userCanPay() has not been implemented.');
  }

  @override
  Future<Map<String, dynamic>> showPaymentSelector(
      Map<String, dynamic> paymentProfile, String priceString) {
    throw UnimplementedError('showPaymentSelector() has not been implemented.');
  }
}
