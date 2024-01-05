/// Copyright 2023 Google LLC.
/// SPDX-License-Identifier: Apache-2.0

part of '../../pay.dart';

class PaymentConfirmation {
  final Pay _payClient;
  PaymentConfirmation(Pay payClient) : _payClient = payClient;

  void confirmPayment(bool completedSuccessfully) {
    _payClient.userCanPay(PayProvider.google_pay);
  }
}

typedef PaymentConfirmCallback = Function(
    Map<String, dynamic> result, PaymentConfirmation handler);

/// A widget to show the Apple Pay button according to the rules and constraints
/// specified in [PayButton].
///
/// Example usage:
/// ```dart
/// ApplePayButton(
///   paymentConfiguration: _paymentConfiguration,
///   paymentItems: _paymentItems,
///   style: ApplePayButtonStyle.black,
///   type: ApplePayButtonType.buy,
///   margin: const EdgeInsets.only(top: 15.0),
///   onPaymentResult: onApplePayResult,
///   loadingIndicator: const Center(
///     child: CircularProgressIndicator(),
///   ),
/// )
/// ```
class ApplePayButton extends PayButton {
  late final Widget _applePayButton;

  ApplePayButton({
    Key? key,
    @Deprecated(
        'Prefer to use [paymentConfiguration]. Take a look at the readme to see examples')
    String? paymentConfigurationAsset,
    PaymentConfiguration? paymentConfiguration,
    PaymentResultCallback? onPaymentResult,
    PaymentConfirmCallback? onPaymentResultWithConfirm,
    required List<PaymentItem> paymentItems,
    ApplePayButtonStyle style = ApplePayButtonStyle.black,
    ApplePayButtonType type = ApplePayButtonType.plain,
    double width = RawApplePayButton.minimumButtonWidth,
    double height = RawApplePayButton.minimumButtonHeight,
    EdgeInsets margin = EdgeInsets.zero,
    VoidCallback? onPressed,
    void Function(Object? error)? onError,
    Widget? childOnError,
    Widget? loadingIndicator,
  })  : assert(width >= RawApplePayButton.minimumButtonWidth),
        assert(height >= RawApplePayButton.minimumButtonHeight),
        super(
          key,
          PayProvider.apple_pay,
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
    _applePayButton = RawApplePayButton(
        style: style,
        type: type,
        onPressed: _defaultOnPressed(onPressed, paymentItems));

    paymentCallback = (result) => {
          onPaymentResult?.call(result),
          onPaymentResultWithConfirm?.call(
              result, PaymentConfirmation(_payClient))
        };
  }

  @override
  final List<TargetPlatform> _supportedPlatforms = [TargetPlatform.iOS];

  @override
  late final Widget _payButton = _applePayButton;
}
