part of '../../pay.dart';

typedef PayGestureTapCallback = void Function(Pay client);

class GooglePayButton extends StatefulWidget {
  final Pay googlePayClient;
  final RawGooglePayButton googlePayButton;

  final Widget? childOnError;
  final Widget? loadingIndicator;

  const GooglePayButton._(
    Key? key,
    this.googlePayClient,
    this.googlePayButton,
    this.childOnError,
    this.loadingIndicator,
  ) : super(key: key);

  factory GooglePayButton({
    Key? key,
    required paymentConfigurationAsset,
    required PayGestureTapCallback onPressed,
    type,
    color,
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
          if (snapshot.data == true) {
            return widget.googlePayButton;
          } else if (snapshot.hasError) {
            return widget.childOnError ?? SizedBox.shrink();
          }
        }

        return widget.loadingIndicator ?? SizedBox.shrink();
      },
    );
  }
}
