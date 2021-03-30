part of '../../pay.dart';

abstract class PayButton extends StatefulWidget {
  late final Pay _payClient;

  final double width;
  final double height;
  final EdgeInsets margin;

  final void Function(Map<String, dynamic> result) onPaymentResult;
  final void Function(Object? error)? onError;
  final Widget? childOnError;
  final Widget? loadingIndicator;

  PayButton(
    Key? key,
    String paymentConfigurationAsset,
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

  VoidCallback _defaultOnPressed(
      VoidCallback? onPressed, List<PaymentItem> paymentItems) {
    return () async {
      onPressed?.call();
      try {
        final result =
            await _payClient.showPaymentSelector(paymentItems: paymentItems);
        onPaymentResult(result);
      } catch (error) {
        onError?.call(error);
      }
    };
  }

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
        width: !isError ? widget.width : null,
        height: !isError ? widget.height : null,
        child: child,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Future<bool> _userCanPay() async {
    try {
      return await widget._payClient.userCanPay();
    } catch (error) {
      widget.onError?.call(error);
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _userCanPayFuture = _userCanPay();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget._isPlatformSupported) {
      return containerizeChildOrShrink(isError: true);
    }

    return FutureBuilder<bool>(
      future: _userCanPayFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
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
