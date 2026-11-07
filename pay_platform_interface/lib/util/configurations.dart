// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:pay_platform_interface/core/payment_configuration.dart';
import 'package:pay_platform_interface/generated/package_info.dart';

/// A utility class to handle configuration objects and metadata associated
/// with this plugin.
class Configurations {
  /// Complements the payment configuration object with metadata about the
  /// package.
  ///
  /// Takes the configuration included in [configuration] and returns an updated
  /// version of the object with additional metadata.
  static Map<String, dynamic> extractParameters(
      Map<String, dynamic> configuration) {
    PayProvider provider =
        PayProviders.fromString(configuration['provider'] as String)!;
    Map<String, dynamic> configurationParams =
        configuration['data'] as Map<String, dynamic>;

    switch (provider) {
      case PayProvider.apple_pay:
        return configurationParams;

      case PayProvider.google_pay:

        // Add information about the package.
        final updatedMerchantInfo = {
          ...(configurationParams['merchantInfo'] ?? {}) as Map,
          'softwareInfo': {
            'id': 'flutter/pay-plugin',
            'version': PackageInfo.version
          }
        };

        final updatedPaymentConfiguration = Map<String, Object>.unmodifiable(
            {...configurationParams, 'merchantInfo': updatedMerchantInfo});

        return updatedPaymentConfiguration;
    }
  }
}
