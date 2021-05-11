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
import 'package:yaml/yaml.dart';

import 'core/payment_configuration.dart';
import 'core/payment_item.dart';
import 'pay_platform_interface.dart';

class PayMethodChannel extends PayPlatform {
  final MethodChannel _channel =
      const MethodChannel('plugins.flutter.io/pay_channel');

  /// Completes with a [PlatformException] if the platform code fails.
  @override
  Future<bool> userCanPay(PaymentConfiguration paymentConfiguration) async {
    final configurationMap = await _buildConfiguration(paymentConfiguration);
    return await _channel.invokeMethod(
        'userCanPay', jsonEncode(configurationMap));
  }

  /// Completes with a [PlatformException] if the platform code fails.
  @override
  Future<Map<String, dynamic>> showPaymentSelector(
    PaymentConfiguration paymentConfiguration,
    List<PaymentItem> paymentItems,
  ) async {
    final configurationMap = await _buildConfiguration(paymentConfiguration);
    final paymentResult = await _channel.invokeMethod('showPaymentSelector', {
      'payment_profile': jsonEncode(configurationMap),
      'payment_items': paymentItems.map((item) => item.toMap()).toList(),
    });

    return jsonDecode(paymentResult);
  }

  static Future<Map<String, dynamic>> _buildConfiguration(
      PaymentConfiguration paymentConfiguration) async {
    final parameters = await paymentConfiguration.toMap();

    switch (paymentConfiguration.provider) {
      case PayProvider.apple_pay:
        return parameters;

      case PayProvider.google_pay:
        final updatedMerchantInfo = {
          ...(parameters['merchantInfo'] ?? {}) as Map,
          'softwareInfo': {
            'id': 'flutter/pay-plugin',
            'version': (await _getPackageConfiguration())['version']
          }
        };

        final updatedPaymentConfiguration = Map<String, Object>.unmodifiable(
            {...parameters, 'merchantInfo': updatedMerchantInfo});

        return updatedPaymentConfiguration;
    }
  }

  static Future<Map> _getPackageConfiguration() async {
    final configurationFile = await rootBundle
        .loadString('packages/pay_platform_interface/pubspec.yaml');
    return loadYaml(configurationFile);
  }
}
