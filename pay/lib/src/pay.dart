/// Copyright 2023 Google LLC.
/// SPDX-License-Identifier: Apache-2.0

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
/// final payClient = Pay.withAssets(paymentConfigurationAssets)
/// await payClient.showPaymentSelector(paymentItems: paymentItems);
/// ```
class Pay {
  /// The implementation of the platform interface to talk to the native ends.
  final PayPlatform _payPlatform;

  /// List of configurations for the payment providers targeted.
  late final Map<PayProvider, PaymentConfiguration> _configurations;

  /// Creates an instance with a dictionary of [_configurations] and
  /// instantiates the [_payPlatform] to communicate with the native platforms.
  Pay(this._configurations) : _payPlatform = PayMethodChannel();

  /// Determines whether a user can pay with the selected [provider].
  ///
  /// This method wraps the [userCanPay] method in the platform interface. It
  /// makes sure that the [provider] exists and is available in the platform
  /// running the logic.
  Future<bool> userCanPay(PayProvider provider) async {
    throwIfProviderIsNotDefined(provider);
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
    throwIfProviderIsNotDefined(provider);
    return _payPlatform.showPaymentSelector(
        _configurations[provider]!, paymentItems);
  }

  /// Verifies that the selected provider has been previously configured or
  /// throws otherwise.
  void throwIfProviderIsNotDefined(PayProvider provider) {
    if (!_configurations.containsKey(provider)) {
      throw Exception(
          'No configuration has been provided for the provider: $provider');
    }
  }
}
