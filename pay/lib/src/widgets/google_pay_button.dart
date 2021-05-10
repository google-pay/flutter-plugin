/// Copyright 2021 Google LLC.
/// SPDX-License-Identifier: Apache-2.0

part of '../../pay.dart';

class GooglePayButton extends PayButton {
  late final Widget _googlePayButton;

  GooglePayButton({
    Key? key,
    required String paymentConfigurationAsset,
    required void Function(Map<String, dynamic> result) onPaymentResult,
    required List<PaymentItem> paymentItems,
    GooglePayButtonStyle style = GooglePayButtonStyle.black,
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
        style: style,
        type: type,
        onPressed: _defaultOnPressed(onPressed, paymentItems));
  }

  @override
  final List<TargetPlatform> _supportedPlatforms = [TargetPlatform.android];

  @override
  late final Widget _payButton = _googlePayButton;
}
