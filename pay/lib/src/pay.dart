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

part of '../pay.dart';

/// List of supported payment providers and platform pairs.
const supportedProviders = {
  TargetPlatform.android: [PayProvider.google_pay],
  TargetPlatform.iOS: [PayProvider.apple_pay],
};

/// High level layer to easily manage cross-platform integrations.
///
/// This class simplifies using the plugin and abstracts platform-specific
/// directives.
/// To use it, instantiate it with a list of configurations for the payment
/// providers supported:
/// ```dart
/// final payConfiguration = PaymentConfiguration.fromJsonString(<string>);
/// final payClient = Pay({<PayProvider>: payConfiguration});
/// await payClient.showPaymentSelector(<PayProvider>, paymentItems);
/// ```
class Pay {
  /// The implementation of the platform interface to talk to the native ends.
  final PayPlatform _payPlatform;

  /// Map of configurations for the payment providers targeted.
  final Map<PayProvider, PaymentConfiguration> _configurations;

  /// Creates an instance with a dictionary of [_configurations] and
  /// instantiates the [_payPlatform] to communicate with the native platforms.
  Pay(this._configurations) : _payPlatform = PayMethodChannel();

  /// Determines whether a user can pay with the selected [provider].
  ///
  /// This method wraps the [userCanPay] method in the platform interface. It
  /// makes sure that the [provider] exists and is available in the platform
  /// running the logic.
  Future<bool> userCanPay(PayProvider provider) async {
    await throwIfProviderIsNotDefined(provider);
    if (supportedProviders[defaultTargetPlatform]!.contains(provider)) {
      return _payPlatform.userCanPay(_configurations[provider]!);
    }

    return Future.value(false);
  }

  /// Shows the payment selector to initiate a payment process.
  ///
  /// This method wraps the [showPaymentSelector] method in the platform
  /// interface, and opens the payment selector for the [provider] of choice,
  /// with the [paymentItems] in the price summary.
  Future<Map<String, dynamic>> showPaymentSelector(
    PayProvider provider,
    List<PaymentItem> paymentItems,
  ) async {
    await throwIfProviderIsNotDefined(provider);
    return _payPlatform.showPaymentSelector(
        _configurations[provider]!, paymentItems);
  }

  /// Verifies that the selected provider has been previously configured or
  /// throws otherwise.
  Future<void> throwIfProviderIsNotDefined(PayProvider provider) async {
    if (!_configurations.containsKey(provider)) {
      throw ProviderNotConfiguredException(
          'No configuration has been provided for the provider ($provider)');
    }
  }
}

/// Thrown to indicate that the configuration for a request provider has not
/// been provided.
class ProviderNotConfiguredException implements Exception {
  ProviderNotConfiguredException(this.message);

  /// A human-readable error message, possibly null.
  final String? message;

  @override
  String toString() => 'ProviderNotConfiguredException: $message';
}
