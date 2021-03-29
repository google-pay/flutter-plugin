part of '../../pay_android.dart';

enum GooglePayButtonType { pay, checkout, donate }
enum GooglePayButtonStyle { black, white, flat }

extension _GooglePayButtonTypeAsset on GooglePayButtonType {
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

extension _GooglePayButtonStyleAsset on GooglePayButtonStyle {
  static const _defaultAssetSuffix = '_dark';

  String get assetSuffix =>
      {
        GooglePayButtonStyle.black: _defaultAssetSuffix,
        GooglePayButtonStyle.white: '_clear',
        GooglePayButtonStyle.flat: '_clear',
      }[this] ??
      _defaultAssetSuffix;
}

class RawGooglePayButton extends StatelessWidget {
  static const double defaultAssetHeight = 43;
  static const double _minHorizontalPadding = 30;

  final VoidCallback? onPressed;
  final GooglePayButtonStyle style;
  final GooglePayButtonType type;

  const RawGooglePayButton({
    Key? key,
    this.onPressed,
    this.style = GooglePayButtonStyle.black,
    this.type = GooglePayButtonType.pay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Widget rawButton = RawMaterialButton(
      fillColor:
          style == GooglePayButtonStyle.black ? Colors.black : Colors.white,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: style == GooglePayButtonStyle.flat
            ? BorderSide(
                color: Color(0xFFDEDEDE),
                width: 2,
              )
            : BorderSide.none,
      ),
      child: SvgPicture.asset(
        'assets/${type.asset}${style.assetSuffix}.svg',
        package: 'pay_android',
        semanticsLabel: 'Buy with Google Pay text',
        width: type.assetWidth,
        height: 22,
      ),
    );

    return Container(
      decoration: style == GooglePayButtonStyle.white
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
      height: defaultAssetHeight,
      child: rawButton,
    );
  }
}
