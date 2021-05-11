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

import 'dart:convert';

import 'package:flutter/services.dart';

enum PayProvider { apple_pay, google_pay }

typedef ConfigLoader = Future<Map<String, dynamic>> Function(String value);

class PaymentConfiguration {
  late final PayProvider provider;
  late final Future<Map<String, dynamic>> _parameters;

  PaymentConfiguration._(Map<String, dynamic> configuration)
      : assert(configuration.containsKey('provider')),
        assert(configuration.containsKey('data')),
        assert(PayProviders.isValidProvider(configuration['provider'])),
        provider = PayProviders.fromString(configuration['provider'])!,
        _parameters = Future.value(configuration['data']);

  PaymentConfiguration.fromJsonString(String paymentConfigurationString)
      : this._(jsonDecode(paymentConfigurationString));

  static Future<PaymentConfiguration> fromAsset(
      String paymentConfigurationAsset,
      {ConfigLoader profileLoader = _defaultProfileLoader}) async {
    final configuration = await profileLoader(paymentConfigurationAsset);
    return PaymentConfiguration._(configuration);
  }

  static Future<Map<String, dynamic>> _defaultProfileLoader(
          String paymentConfigurationAsset) async =>
      await rootBundle.loadStructuredData(
          'assets/$paymentConfigurationAsset', (s) async => jsonDecode(s));

  Future<Map<String, dynamic>> toMap() async {
    return _parameters;
  }
}

extension PayProviders on PayProvider {
  static PayProvider? fromString(String providerString) => {
        'apple_pay': PayProvider.apple_pay,
        'google_pay': PayProvider.google_pay,
      }[providerString];

  static bool isValidProvider(String providerString) =>
      fromString(providerString) != null;

  String? toSimpleString() => {
        PayProvider.apple_pay: 'apple_pay',
        PayProvider.google_pay: 'google_pay',
      }[this];
}
