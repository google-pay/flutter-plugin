part of '../../google_pay_mobile.dart';

double _minWidth = 90;
double _minWidthLong = 152;
double _defaultWidthLong = 200;
double _height = 43;

class GooglePayButton extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String type;
  final String color;

  GooglePayButton(
      {Key key,
      @required this.onPressed,
      this.type = 'pay',
      this.color = 'black'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget rawButton = RawMaterialButton(
        fillColor: Colors.black,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SizedBox(
            width: 134,
            height: 22,
            child: SvgPicture.asset('assets/buy_with_gpay_dark.svg',
                package: 'google_pay_mobile',
                semanticsLabel: 'Buy with Google Pay text')));

    return SizedBox(
        width: _defaultWidthLong, height: _height, child: rawButton);
  }
}
