part of '../../pay.dart';

typedef PayGestureTapCallback = void Function(Pay client);

class GooglePayButtonWidget extends StatefulWidget {
  final Pay googlePayClient;
  final GooglePayButton googlePayButton;

  final Widget childOnError;
  final Widget loadingIndicator;

  GooglePayButtonWidget._(
    Key key,
    this.googlePayClient,
    this.googlePayButton,
    this.childOnError,
    this.loadingIndicator,
  ) : super(key: key);

  factory GooglePayButtonWidget({
    Key key,
    @required paymentConfigurationAsset,
    @required PayGestureTapCallback onPressed,
    type,
    color,
    childOnError,
    loadingIndicator,
  }) {
    Pay googlePayClient = Pay.fromAsset(paymentConfigurationAsset);
    GooglePayButton googlePayButton = GooglePayButton(
      onPressed: () => onPressed(googlePayClient),
      type: type,
      color: color,
    );

    return GooglePayButtonWidget._(
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

class _GooglePayButtonState extends State<GooglePayButtonWidget> {
  Future<bool> _userCanPayFuture;

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
