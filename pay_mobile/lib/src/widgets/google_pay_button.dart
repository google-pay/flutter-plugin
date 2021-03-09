part of '../../pay_mobile.dart';

enum GooglePayButtonType { pay, checkout, donate }
enum GooglePayButtonColor { black, white, flat }

extension on GooglePayButtonType {
  static const _defaultAsset = 'gpay_logo';
  static const _defaultAssetWidth = 54.0;

  String get asset =>
      {
        GooglePayButtonType.pay: 'buy_with_gpay',
        GooglePayButtonType.checkout: _defaultAsset,
        GooglePayButtonType.donate: 'donate_with_gpay',
      }[this] ??
      _defaultAsset;

  double get assetWidth =>
      {
        GooglePayButtonType.pay: 135.0,
        GooglePayButtonType.checkout: _defaultAssetWidth,
        GooglePayButtonType.donate: 167.0,
      }[this] ??
      _defaultAssetWidth;
}

extension on GooglePayButtonColor {
  static const _defaultAssetSuffix = '_dark';

  String get assetSuffix =>
      {
        GooglePayButtonColor.black: _defaultAssetSuffix,
        GooglePayButtonColor.white: '_clear',
        GooglePayButtonColor.flat: '_clear',
      }[this] ??
      _defaultAssetSuffix;
}

class RawGooglePayButton extends StatelessWidget {
  static const double _height = 43;
  static const double _minHorizontalPadding = 30;

  final GestureTapCallback onPressed;
  final GooglePayButtonType type;
  final GooglePayButtonColor color;

  const RawGooglePayButton({
    Key? key,
    required this.onPressed,
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
      child: SvgPicture.asset(
        'assets/${type.asset}${color.assetSuffix}.svg',
        package: 'pay_mobile',
        semanticsLabel: 'Buy with Google Pay text',
        width: type.assetWidth,
        height: 22,
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
      width: type.assetWidth + (2 * _minHorizontalPadding),
      height: _height,
      child: rawButton,
    );
  }
}
