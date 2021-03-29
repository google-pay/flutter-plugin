part of '../../pay.dart';

abstract class PayButton extends StatefulWidget {
  late final Pay _payClient;

  final double? width;
  final double height;
  final EdgeInsets margin;

  final onPaymentResult;
  final onError;
  final Widget? childOnError;
  final Widget? loadingIndicator;

  PayButton(
    Key? key,
    paymentConfigurationAsset,
    this.onPaymentResult,
    this.width,
    this.height,
    this.margin,
    this.onError,
    this.childOnError,
    this.loadingIndicator,
  ) : super(key: key) {
    _payClient = Pay.fromAsset(paymentConfigurationAsset);
  }

  _defaultOnPressed(onPressed, paymentItems) => () async {
        onPressed?.call();
        onPaymentResult(
          await _payClient.showPaymentSelector(paymentItems: paymentItems),
        );
      };

  List<TargetPlatform> get _supportedPlatforms;
  Widget get _payButton;

  bool get _isPlatformSupported =>
      _supportedPlatforms.contains(defaultTargetPlatform);

  @override
  _PayButtonState createState() => _PayButtonState();
}

class _PayButtonState extends State<PayButton> {
  late final Future<bool> _userCanPayFuture;

  Widget containerizeChildOrShrink({Widget? child, bool isError = false}) {
    if (child != null) {
      return Container(
        margin: widget.margin,
        child: child,
        width: !isError ? widget.width : null,
        height: !isError ? widget.height : null,
      );
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  void initState() {
    super.initState();
    _userCanPayFuture = widget._payClient.userCanPay();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget._isPlatformSupported)
      return containerizeChildOrShrink(isError: true);

    return FutureBuilder<bool>(
      future: _userCanPayFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            widget.onError(snapshot.error);
          }

          if (snapshot.data == true) {
            return containerizeChildOrShrink(child: widget._payButton);
          } else {
            return containerizeChildOrShrink(
                child: widget.childOnError, isError: true);
          }
        }

        return containerizeChildOrShrink(
            child: widget.loadingIndicator, isError: true);
      },
    );
  }
}
