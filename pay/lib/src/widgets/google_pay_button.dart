part of '../../pay.dart';

typedef PayGestureTapCallback = void Function(Pay client);

class GooglePayButton extends StatefulWidget {
  final Pay googlePayClient;
  final RawGooglePayButton googlePayButton;

  final onError;
  final Widget? childOnError;
  final Widget? loadingIndicator;

  const GooglePayButton._(
    Key? key,
    this.googlePayClient,
    this.googlePayButton,
    this.onError,
    this.childOnError,
    this.loadingIndicator,
  ) : super(key: key);

  factory GooglePayButton({
    Key? key,
    required paymentConfigurationAsset,
    required PayGestureTapCallback onPressed,
    type,
    color,
    onError,
    childOnError,
    loadingIndicator,
  }) {
    Pay googlePayClient = Pay.fromAsset(paymentConfigurationAsset);
    RawGooglePayButton googlePayButton = RawGooglePayButton(
      onPressed: () => onPressed(googlePayClient),
      type: type,
      color: color,
    );

    return GooglePayButton._(
      key,
      googlePayClient,
      googlePayButton,
      onError,
      childOnError,
      loadingIndicator,
    );
  }

  @override
  _GooglePayButtonState createState() => _GooglePayButtonState();
}

class _GooglePayButtonState extends State<GooglePayButton> {
  late final Future<bool> _userCanPayFuture;

  @override
  void initState() {
    super.initState();
    _userCanPayFuture = widget.googlePayClient.userCanPay();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _userCanPayFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            widget.onError(snapshot.error);
          }

          if (snapshot.data == true) {
            return widget.googlePayButton;
          } else {
            return widget.childOnError ?? SizedBox.shrink();
          }
        }

        return widget.loadingIndicator ?? SizedBox.shrink();
      },
    );
  }
}
