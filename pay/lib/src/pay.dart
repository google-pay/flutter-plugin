/// Copyright 2021 Google LLC.
/// SPDX-License-Identifier: Apache-2.0

part of '../pay.dart';

const supportedProviders = {
  TargetPlatform.android: ['google_pay'],
  TargetPlatform.iOS: ['apple_pay'],
};

class Pay {
  final PayPlatform _payPlatform;
  late final List<PaymentConfiguration> _configurations;
  late final _assetInitializationFuture;

  Pay(this._configurations) : _payPlatform = PayMethodChannel();

  Pay.withAssets(List<String> configAssets)
      : _payPlatform = PayMethodChannel() {
    _assetInitializationFuture = _loadConfigAssets(configAssets);
  }

  Future _loadConfigAssets(List<String> configurationAssets) async =>
      _configurations = await Future.wait(
          configurationAssets.map((ca) => PaymentConfiguration.fromAsset(ca)));

  PaymentConfiguration _findConfig([PayProvider? provider]) => provider == null
      ? _configurations.first
      : _configurations.firstWhere((c) => c.provider == provider);

  Future<bool> userCanPay([PayProvider? provider]) async {
    await _assetInitializationFuture;
    final configuration = _findConfig(provider);

    if (supportedProviders[defaultTargetPlatform]!
        .contains(configuration.provider.toSimpleString())) {
      return _payPlatform.userCanPay(configuration);
    }

    return Future.value(false);
  }

  Future<Map<String, dynamic>> showPaymentSelector({
    PayProvider? provider,
    required List<PaymentItem> paymentItems,
  }) async {
    await _assetInitializationFuture;
    final configuration = _findConfig(provider);
    return _payPlatform.showPaymentSelector(configuration, paymentItems);
  }
}
