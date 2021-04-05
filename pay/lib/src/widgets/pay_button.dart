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
  late final Future<bool> userCanPayFuture;

  Future<bool> userCanPay() async {
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
    userCanPayFuture = userCanPay();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget._isPlatformSupported) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<bool>(
      future: userCanPayFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return Container(
              margin: widget.margin,
              width: widget.width,
              height: widget.height,
              child: widget._payButton,
            );
          } else {
            return ButtonPlaceholderContainer(
              margin: widget.margin,
              child: widget.childOnError,
            );
          }
        }

        return ButtonPlaceholderContainer(
          margin: widget.margin,
          child: widget.loadingIndicator,
        );
      },
    );
  }
}

class ButtonPlaceholder extends StatelessWidget {
  final Widget? child;
  final EdgeInsets margin;

  ButtonPlaceholderContainer({
    Key? key,
    this.child,
    required this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child == null
        ? const SizedBox.shrink()
        : Container(margin: margin, child: child);
  }
}
