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
    double? width,
    double height = RawGooglePayButton.defaultAssetHeight,
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
    _googlePayButton = RawGooglePayButton(
        style: style,
        type: type,
        onPressed: _defaultOnPressed(onPressed, paymentItems));
  }

  @override
  List<TargetPlatform> get _supportedPlatforms => [TargetPlatform.android];

  @override
  Widget get _payButton => _googlePayButton;
}
