part of '../../google_pay_mobile.dart';

double _minWidth = 90;
double _minWidthLong = 152;
double _defaultWidthLong = 200;
double _height = 43;

enum ButtonColor { black, white, flat }

extension ButtonColorAsset on ButtonColor {
  String get asset => {
        ButtonColor.black: 'buy_with_gpay_dark.svg',
        ButtonColor.white: 'buy_with_gpay_clear.svg',
        ButtonColor.flat: 'buy_with_gpay_clear.svg',
      }[this];
}

class GooglePayButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String type;
  final ButtonColor color;

  GooglePayButton(
      {Key key,
      @required this.onPressed,
      this.type = 'pay',
      this.color = ButtonColor.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget rawButton = RawMaterialButton(
        fillColor: color == ButtonColor.black ? Colors.black : Colors.white,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: color == ButtonColor.flat
              ? BorderSide(color: Color(0xFFDEDEDE), width: 2)
              : BorderSide.none,
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SizedBox(
            width: 134,
            height: 22,
            child: SvgPicture.asset('assets/${color.asset}',
                package: 'google_pay_mobile',
                semanticsLabel: 'Buy with Google Pay text')));

    return Container(
        decoration: color == ButtonColor.white
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
        child: rawButton);
  }
}
