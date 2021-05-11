/// Copyright 2021 Google LLC.
/// SPDX-License-Identifier: Apache-2.0

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
    final paymentData = await _getPaymentData();
    return _payPlatform.showPaymentSelector(paymentData, paymentItems);
  }
}
