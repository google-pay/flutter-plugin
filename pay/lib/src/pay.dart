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
  late final List<PaymentConfiguration> _configurations;

  // Future to keep track of asynchronous initialization items.
  Future? _assetInitializationFuture;

  /// Creates an instance of the class with a list of [_configurations] and
  /// instantiates the [_payPlatform] to communicate with the native platforms.
  Pay(this._configurations) : _payPlatform = PayMethodChannel();

  /// Alternative constructor to create a [Pay] object with a list of
  /// configurations in [String] format.
  Pay.withAssets(List<String> configAssets)
      : _payPlatform = PayMethodChannel() {
    _assetInitializationFuture = _loadConfigAssets(configAssets);
  }

  /// Load the list of configurations from the assets.
  Future _loadConfigAssets(List<String> configurationAssets) async =>
      _configurations = await Future.wait(
          configurationAssets.map((ca) => PaymentConfiguration.fromAsset(ca)));

  /// Helper method to load the payment configuration for a given [provider].
  PaymentConfiguration _findConfig([PayProvider? provider]) => provider == null
      ? _configurations.first
      : _configurations.firstWhere((c) => c.provider == provider);

  /// Determines whether a user can pay with the selected [provider].
  ///
  /// This method wraps the [userCanPay] method in the platform interface. It
  /// makes sure that the [provider] exists and is available in the platform
  /// running the logic.
  Future<bool> userCanPay([PayProvider? provider]) async {
    await _assetInitializationFuture;
    final configuration = _findConfig(provider);

    if (supportedProviders[defaultTargetPlatform]!
        .contains(configuration.provider.toSimpleString())) {
      return _payPlatform.userCanPay(configuration);
    }

    return Future.value(false);
  }

  /// Shows the payment selector to initiate a payment process.
  ///
  /// This method wraps the [showPaymentSelector] method in the platform
  /// interface, and opens the payment selector for the [provider] of choice,
  /// with the [paymentItems] in the price summary.
  Future<Map<String, dynamic>> showPaymentSelector({
    PayProvider? provider,
    required List<PaymentItem> paymentItems,
  }) async {
    await _assetInitializationFuture;
    final configuration = _findConfig(provider);
    return _payPlatform.showPaymentSelector(configuration, paymentItems);
  }
}
