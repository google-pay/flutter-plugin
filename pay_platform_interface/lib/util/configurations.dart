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
import 'package:pay_platform_interface/core/payment_configuration.dart';

class Configurations {
  static Future<Map<String, dynamic>> build(PaymentConfiguration config) async {
    final parameters = await config.toMap();

    switch (config.provider) {
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
