part of '../../pay.dart';

class ApplePayButton extends PayButton {
  late final Widget _applePayButton;

  ApplePayButton({
    Key? key,
    required String paymentConfigurationAsset,
    required void Function(Map<String, dynamic> result) onPaymentResult,
    required List<PaymentItem> paymentItems,
    ApplePayButtonStyle style = ApplePayButtonStyle.black,
    ApplePayButtonType type = ApplePayButtonType.plain,
    double? width,
    double height = RawApplePayButton.minimumButtonHeight,
    EdgeInsets margin = EdgeInsets.zero,
    VoidCallback? onPressed,
    void Function(Object? error)? onError,
    Widget? childOnError,
    Widget? loadingIndicator,
  }) : super(
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
    _applePayButton = RawApplePayButton(
        style: style,
        type: type,
        onPressed: _defaultOnPressed(onPressed, paymentItems));
  }

  @override
  List<TargetPlatform> get _supportedPlatforms => [TargetPlatform.iOS];

  @override
  Widget get _payButton => _applePayButton;
}
