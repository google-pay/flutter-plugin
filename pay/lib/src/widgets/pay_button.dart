part of '../../pay.dart';

abstract class PayButton extends StatefulWidget {
  late final Pay _payClient;

  final EdgeInsets margin;

  final onPaymentResult;
  final onError;
  final Widget? childOnError;
  final Widget? loadingIndicator;

  PayButton(
    Key? key,
    paymentConfigurationAsset,
    this.onPaymentResult,
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

  Widget containerizeChildOrShrink([Widget? child]) {
    if (child != null) {
      return Container(
        margin: widget.margin,
        child: child,
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
    if (!widget._isPlatformSupported) return containerizeChildOrShrink();

    return FutureBuilder<bool>(
      future: _userCanPayFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            widget.onError(snapshot.error);
          }

          if (snapshot.data == true) {
            return containerizeChildOrShrink(widget._payButton);
          } else {
            return containerizeChildOrShrink(widget.childOnError);
          }
        }

        return containerizeChildOrShrink(widget.loadingIndicator);
      },
    );
  }
}
