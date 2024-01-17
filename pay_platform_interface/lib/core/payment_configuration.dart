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

import 'dart:convert';

import 'package:flutter/services.dart';

import '../util/configurations.dart';

/// The payment providers supported by this package.
enum PayProvider { apple_pay, google_pay }

/// A type used to define the signature of methods and objects used to load
/// payment configurations from various sources.
typedef ConfigLoader = Future<Map<String, dynamic>> Function(String value);

/// An object that holds information about a payment transaction.
///
/// This object helps load and store configuration information needed to
/// issue a payment transaction for a given provider. It offers multiple
/// options to create an instance, based on the source of the configuration.
///
/// For example, if the payment configuration is in string format as a result
/// of loading it from a remote server:
///
/// ```dart
/// PaymentConfiguration.fromJsonString(
///     '{"provider": "apple_pay", "data": {}}');
/// ```
///
/// Or, if the configuration is loaded from the `assets` folder instead:
///
/// ```dart
/// PaymentConfiguration.fromAsset('configuration_asset.json');
/// ```
class PaymentConfiguration {
  /// The payment provider for this configuration.
  final PayProvider provider;

  /// The configuration parameters for a given payment provider.
  final Future<Map<String, dynamic>> _parameters;

  /// The raw configuration provided
  final String _rawConfigurationData;

  /// Creates a [PaymentConfiguration] object with the properties in the map
  /// and ensures the necessary fields are present and valid.
  PaymentConfiguration._(Map<String, dynamic> configuration)
      : assert(configuration.containsKey('provider')),
        assert(configuration.containsKey('data')),
        assert(
            PayProviders.isValidProvider(configuration['provider'] as String)),
        provider =
            PayProviders.fromString(configuration['provider'] as String)!,
        _rawConfigurationData = jsonEncode(configuration['data']),
        _parameters = Configurations.extractParameters(configuration);

  /// Creates a [PaymentConfiguration] object from the
  /// [paymentConfigurationString] in JSON format.
  PaymentConfiguration.fromJsonString(String paymentConfigurationString)
      : this._(jsonDecode(paymentConfigurationString) as Map<String, dynamic>);

  /// Creates a [PaymentConfiguration] object wrapped in a [Future] from a
  /// configuration loaded from an external source.
  ///
  /// The configuration is referenced in the [paymentConfigurationAsset] and
  /// retrieved with the [profileLoader] specified. If empty, a default loader
  /// is used to get the configuration from the `assets` folder in the package.
  ///
  /// Here's an example of a configuration loaded with a bespoke loader:
  ///
  /// ```dart
  /// Future<Map<String, dynamic>> _fileSystemLoader(String filePath) async =>
  ///     jsonDecode(File(filePath).readAsStringSync());
  /// final config = await PaymentConfiguration.fromAsset('path-to-file.json',
  ///     profileLoader: _fileSystemLoader);
  /// ```
  static Future<PaymentConfiguration> fromAsset(
      String paymentConfigurationAsset,
      {ConfigLoader profileLoader = _defaultProfileLoader}) async {
    final configuration = await profileLoader(paymentConfigurationAsset);
    return PaymentConfiguration._(configuration);
  }

  /// Configuration loader used as a default option in the [fromAsset] method.
  ///
  /// This loader retrieves the configuration with the
  /// [paymentConfigurationAsset] key from the `assets` folder in the
  /// package and decodes the JSON content before returning it back to the
  /// caller.
  static Future<Map<String, dynamic>> _defaultProfileLoader(
          String paymentConfigurationAsset) async =>
      await rootBundle.loadStructuredData('assets/$paymentConfigurationAsset',
          (s) async => jsonDecode(s) as Map<String, dynamic>);

  /// Returns the core configuration map in this object.
  Future<Map<String, dynamic>> parameterMap() async {
    return _parameters;
  }

  /// Returns the raw data in the configuration
  String rawConfigurationData() {
    return _rawConfigurationData;
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
