/// Copyright 2023 Google LLC.
/// SPDX-License-Identifier: Apache-2.0

part of '../../pay.dart';

/// A widget to show the Google Pay button according to the rules and
/// constraints specified in [PayButton].
///
/// Example usage:
/// ```dart
/// GooglePayButton(
///   paymentConfiguration: _paymentConfiguration,
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
    @Deprecated(
        'Prefer to use [paymentConfiguration]. Take a look at the readme to see examples')
    String? paymentConfigurationAsset,
    PaymentConfiguration? paymentConfiguration,
    PaymentResultCallback? onPaymentResult,
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
          PayProvider.google_pay,
          paymentConfigurationAsset,
          paymentConfiguration,
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
