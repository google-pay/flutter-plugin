part of '../../pay_mobile.dart';

enum GooglePayButtonType { pay, checkout, donate }
enum GooglePayButtonColor { black, white, flat }

extension GooglePayButtonTypeAsset on GooglePayButtonType {
  String get asset => {
        GooglePayButtonType.pay: 'buy_with_gpay',
        GooglePayButtonType.checkout: 'gpay_logo',
        GooglePayButtonType.donate: 'donate_with_gpay',
      }[this];

  double get assetWidth => {
        GooglePayButtonType.pay: 104.0,
        GooglePayButtonType.checkout: 41.0,
        GooglePayButtonType.donate: 129.0,
      }[this];
}

extension GooglePayButtonColorAsset on GooglePayButtonColor {
  String get assetSuffix => {
        GooglePayButtonColor.black: '_dark',
        GooglePayButtonColor.white: '_clear',
        GooglePayButtonColor.flat: '_clear',
      }[this];
}

class GooglePayButton extends StatelessWidget {
  static const double _minWidth = 90;
  static const double _minWidthLong = 152;
  static const double _defaultWidthLong = 200;
  static const double _height = 43;

  final GestureTapCallback onPressed;
  final GooglePayButtonType type;
  final GooglePayButtonColor color;

  GooglePayButton({
    Key key,
    @required this.onPressed,
    this.type = GooglePayButtonType.pay,
    this.color = GooglePayButtonColor.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget rawButton = RawMaterialButton(
      fillColor:
          color == GooglePayButtonColor.black ? Colors.black : Colors.white,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: color == GooglePayButtonColor.flat
            ? BorderSide(
                color: Color(0xFFDEDEDE),
                width: 2,
              )
            : BorderSide.none,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: SizedBox(
        width: type.assetWidth + 30,
        height: 22,
        child: SvgPicture.asset(
          'assets/${type.asset}${color.assetSuffix}.svg',
          package: 'pay_mobile',
          semanticsLabel: 'Buy with Google Pay text',
        ),
      ),
    );

    return Container(
      decoration: color == GooglePayButtonColor.white
          ? BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 1),
              )
            ])
          : null,
      width: _defaultWidthLong,
      height: _height,
      child: rawButton,
    );
  }
}
