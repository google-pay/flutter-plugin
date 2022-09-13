/// Copyright 2021 Google LLC.
/// SPDX-License-Identifier: Apache-2.0

part of '../../pay.dart';

/// A widget to show the Google Pay button according to the rules and
/// constraints specified in [PayButton].
///
/// Example usage:
/// ```dart
/// GooglePayButton(
///   paymentConfigurationAsset: 'google_pay_config.json',
///   paymentItems: _paymentItems,
///   type: GooglePayButtonType.pay,
///   margin: const EdgeInsets.only(top: 15.0),
///   onPaymentResult: onGooglePayResult,
///   loadingIndicator: const Center(
///     child: CircularProgressIndicator(),
///   ),
/// )
/// ```
class GooglePayButton extends PayButton {
  late final Widget _googlePayButton;

  GooglePayButton({
    Key? key,
    required String paymentConfigurationAsset,
    required void Function(Map<String, dynamic> result) onPaymentResult,
    required List<PaymentItem> paymentItems,
    GooglePayButtonType type = GooglePayButtonType.pay,
    double width = RawGooglePayButton.minimumButtonWidth,
    double height = RawGooglePayButton.defaultButtonHeight,
    EdgeInsets margin = EdgeInsets.zero,
    VoidCallback? onPressed,
    void Function(Object? error)? onError,
    Widget? childOnError,
    Widget? loadingIndicator,
  })  : assert(width >= RawGooglePayButton.minimumButtonWidth),
        assert(height >= RawGooglePayButton.defaultButtonHeight),
        super(
          key,
          paymentConfigurationAsset,
          onPaymentResult,
          width,
          height,
          margin,
          onError,
          childOnError,
          loadingIndicator,
        ) {
    _googlePayButton = RawGooglePayButton(
        type: type, onPressed: _defaultOnPressed(onPressed, paymentItems));
  }

  @override
  final List<TargetPlatform> _supportedPlatforms = [TargetPlatform.android];

  @override
  late final Widget _payButton = _googlePayButton;
}
