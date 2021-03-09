part of '../../pay_mobile.dart';

enum ApplePayButtonType { pay, checkout, donate }
enum ApplePayButtonColor { black, white, flat }

extension ApplePayButtonTypeAsset on ApplePayButtonType {
  String? get asset => {
        ApplePayButtonType.pay: 'buy_with_gpay',
        ApplePayButtonType.checkout: 'gpay_logo',
        ApplePayButtonType.donate: 'donate_with_gpay',
      }[this];

  double? get assetWidth => {
        ApplePayButtonType.pay: 135.0,
        ApplePayButtonType.checkout: 54.0,
        ApplePayButtonType.donate: 167.0,
      }[this];
}

extension ApplePayButtonColorAsset on ApplePayButtonColor {
  String? get assetSuffix => {
        ApplePayButtonColor.black: '_dark',
        ApplePayButtonColor.white: '_clear',
        ApplePayButtonColor.flat: '_clear',
      }[this];
}

class RawApplePayButton extends StatelessWidget {
  static const double _height = 43;
  static const double _minHorizontalPadding = 30;

  final GestureTapCallback onPressed;
  final ApplePayButtonType type;
  final ApplePayButtonColor color;

  RawApplePayButton({
    Key? key,
    required this.onPressed,
    this.type = ApplePayButtonType.pay,
    this.color = ApplePayButtonColor.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget rawButton = RawMaterialButton(
      fillColor:
          color == ApplePayButtonColor.black ? Colors.black : Colors.white,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: color == ApplePayButtonColor.flat
            ? BorderSide(
                color: Color(0xFFDEDEDE),
                width: 2,
              )
            : BorderSide.none,
      ),
    );

    return Container(
      decoration: color == ApplePayButtonColor.white
          ? BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 2,
                offset: Offset(0, 1),
              )
            ])
          : null,
      width: type.assetWidth! + (2 * _minHorizontalPadding),
      height: _height,
      child: rawButton,
    );
  }
}
