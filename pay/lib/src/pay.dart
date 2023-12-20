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

  /// Map of configurations for the payment providers targeted.
  Map<PayProvider, PaymentConfiguration>? _configurations;

  // Future to keep track of asynchronous initialization items.
  Future? _assetInitializationFuture;

  /// Creates an instance with a dictionary of [_configurations] and
  /// instantiates the [_payPlatform] to communicate with the native platforms.
  Pay(this._configurations)
      : _payPlatform = defaultTargetPlatform == TargetPlatform.iOS
            ? IosPayMethodChannel()
            : PayMethodChannel();

  /// Alternative constructor to create a [Pay] object with a list of
  /// configurations in [String] format.
  @Deprecated(
      'Prefer to use [Pay({ [PayProvider]: [PaymentConfiguration] })]. Take a look at the readme to see examples')
  Pay.withAssets(List<String> configAssets)
      : _payPlatform = defaultTargetPlatform == TargetPlatform.iOS
            ? IosPayMethodChannel()
            : PayMethodChannel() {
    _assetInitializationFuture = _loadConfigAssets(configAssets);
  }

  /// Load the list of configurations from the assets.
  Future _loadConfigAssets(List<String> configurationAssets) async =>
      _configurations = Map.fromEntries(await Future.wait(configurationAssets
          .map((ca) => PaymentConfiguration.fromAsset(ca))
          .map((c) async => MapEntry(((await c).provider), await c))));

  /// Determines whether a user can pay with the selected [provider].
  ///
  /// This method wraps the [userCanPay] method in the platform interface. It
  /// makes sure that the [provider] exists and is available in the platform
  /// running the logic.
  Future<bool> userCanPay(PayProvider provider) async {
    await throwIfProviderIsNotDefined(provider);
    if (supportedProviders[defaultTargetPlatform]!.contains(provider)) {
      return _payPlatform.userCanPay(_configurations![provider]!);
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
        _configurations![provider]!, paymentItems);
  }

  /// Update the payment status with the native platform.
  /// Works only on iOS.
  Future<void> updatePaymentStatus(bool isSuccess) async {
    if (_payPlatform is IosPayMethodChannel) {
      await _assetInitializationFuture;
      final iosPayPlatform = _payPlatform as IosPayMethodChannel;
      return iosPayPlatform.updatePaymentStatus(isSuccess);
    }
  }

  /// Verifies that the selected provider has been previously configured or
  /// throws otherwise.
  Future throwIfProviderIsNotDefined(PayProvider provider) async {
    await _assetInitializationFuture;
    if (!_configurations!.containsKey(provider)) {
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
