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

/// An implementation of the contract in this plugin that uses a [MethodChannel]
/// to communicate with the native end.
///
/// Example of a simple method channel to communicate with the native ends:
///
/// ```dart
/// PayPlatform platform = PayMethodChannel();
/// platform.userCanPay(configuration);
/// platform.showPaymentSelector(configuration, paymentItems);
/// ```
class PayMethodChannel extends PayPlatform {
  // The channel used to send messages down the native pipe.
  final MethodChannel _channel =
      const MethodChannel('plugins.flutter.io/pay_channel');

  /// Determines wehther a user can pay with the provider in the configuration.
  ///
  /// Completes with a [PlatformException] if the native call fails or returns
  /// a boolean for the [paymentConfiguration] otherwise.
  @override
  Future<bool> userCanPay(PaymentConfiguration paymentConfiguration) async {
    final configurationMap = await Configurations.build(paymentConfiguration);
    return await _channel.invokeMethod(
        'userCanPay', jsonEncode(configurationMap));
  }

  /// Shows the payment selector to confirm the payment transaction.
  ///
  /// Shows the payment selector with the [paymentItems] specified and the
  /// [paymentConfiguration] attached, returning the payment method selected as
  /// a result if the operation completes successfully, or throws a
  /// [PlatformException] if there's an error on the native end.
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
