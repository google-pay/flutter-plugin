part of '../../pay.dart';

typedef PayGestureTapCallback = void Function(Pay client);

class GooglePayButtonWidget extends StatelessWidget {
  final Pay _googlePayClient;
  final GooglePayButton _googlePayButton;

  final Widget _childOnError;
  final Widget _loadingIndicator;

  GooglePayButtonWidget._(
    Key key,
    this._googlePayClient,
    this._googlePayButton,
    this._childOnError,
    this._loadingIndicator,
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
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _googlePayClient.userCanPay(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return SizedBox(
              width: double.infinity,
              child: _googlePayButton,
            );
          } else if (snapshot.hasError) {
            return _childOnError ?? SizedBox.shrink();
          }
        }

        return _loadingIndicator ?? SizedBox.shrink();
      },
    );
  }
}
