/// Copyright 2021 Google LLC
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///     https://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'core/payment_configuration.dart';
import 'core/payment_item.dart';
import 'util/configurations.dart';
import 'pay_platform_interface.dart';

class PayMethodChannel extends PayPlatform {
  final MethodChannel _channel =
      const MethodChannel('plugins.flutter.io/pay_channel');

  /// Completes with a [PlatformException] if the platform code fails.
  @override
  Future<bool> userCanPay(PaymentConfiguration paymentConfiguration) async {
    final configurationMap = await Configurations.build(paymentConfiguration);
    return await _channel.invokeMethod(
        'userCanPay', jsonEncode(configurationMap));
  }

  /// Completes with a [PlatformException] if the platform code fails.
  @override
  Future<Map<String, dynamic>> showPaymentSelector(
    PaymentConfiguration paymentConfiguration,
    List<PaymentItem> paymentItems,
  ) async {
    final configurationMap = await Configurations.build(paymentConfiguration);
    final paymentResult = await _channel.invokeMethod('showPaymentSelector', {
      'payment_profile': jsonEncode(configurationMap),
      'payment_items': paymentItems.map((item) => item.toMap()).toList(),
    });

    return jsonDecode(paymentResult);
  }
}
