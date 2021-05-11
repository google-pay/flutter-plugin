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

import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

enum PayProvider { apple_pay, google_pay }

class PaymentConfiguration {
  final PayProvider provider;
  final Future<Map<String, dynamic>> parameters;

  PaymentConfiguration.fromMap(Map<String, dynamic> configuration)
      : assert(configuration.containsKey('provider')),
        assert(configuration.containsKey('data')),
        assert(PayProviders.isValidProvider(configuration['provider'])),
        provider = PayProviders.fromString(configuration['provider'])!,
        parameters = _populateConfiguration(
            PayProviders.fromString(configuration['provider'])!,
            configuration['data']);

  static Future<Map<String, dynamic>> _populateConfiguration(
      PayProvider provider, Map<String, dynamic> parameters) async {
    switch (provider) {
      case PayProvider.apple_pay:
        return Future.value(parameters);

      case PayProvider.google_pay:
        final updatedMerchantInfo = {
          ...(parameters['merchantInfo'] ?? {}) as Map,
          'softwareInfo': {
            'id': 'flutter/pay-plugin',
            'version': (await _getPackageConfiguration())['version']
          }
        };
  PaymentConfiguration.fromJsonString(String paymentConfigurationString)
      : this._(jsonDecode(paymentConfigurationString));

        final updatedPaymentConfiguration = Map<String, Object>.unmodifiable(
            {...parameters, 'merchantInfo': updatedMerchantInfo});

        return updatedPaymentConfiguration;
    }
  static Future<PaymentConfiguration> fromAsset(
      String paymentConfigurationAsset,
      {ConfigLoader profileLoader = _defaultProfileLoader}) async {
    final configuration = await profileLoader(paymentConfigurationAsset);
    return PaymentConfiguration._(configuration);
  }

  static Future<Map> _getPackageConfiguration() async {
    final configurationFile = await rootBundle
        .loadString('packages/pay_platform_interface/pubspec.yaml');
    return Future.value(loadYaml(configurationFile));
  static Future<Map<String, dynamic>> _defaultProfileLoader(
          String paymentConfigurationAsset) async =>
      await rootBundle.loadStructuredData(
          'assets/$paymentConfigurationAsset', (s) async => jsonDecode(s));
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
