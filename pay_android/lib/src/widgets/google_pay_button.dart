part of '../../pay_android.dart';

enum GooglePayButtonType {
  book,
  buy,
  checkout,
  donate,
  order,
  pay,
  plain,
  subscribe,
  view
}
enum GooglePayButtonStyle { black, white, flat }

class RawGooglePayButton extends StatelessWidget {
  static const double minimumButtonWidth =
      _GooglePayButtonTypeAsset.defaultAssetWidth;
  static const double defaultButtonHeight = 36;

  static const _defaultLocale = 'en';
  static const _supportedLocales = [
    _defaultLocale,
    'ar',
    'bg',
    'ca',
    'cs',
    'da',
    'de',
    'el',
    'es',
    'et',
    'fi',
    'fr',
    'hr',
    'id',
    'it',
    'ja',
    'ko',
    'ms',
    'nl',
    'no',
    'pl',
    'pt',
    'ru',
    'sk',
    'sl',
    'sr',
    'sv',
    'th',
    'tr',
    'uk',
    'zh'
  ];

  final VoidCallback? onPressed;
  final GooglePayButtonStyle style;
  final GooglePayButtonType type;

  const RawGooglePayButton({
    Key? key,
    this.onPressed,
    this.style = GooglePayButtonStyle.black,
    this.type = GooglePayButtonType.pay,
  }) : super(key: key);

  String _assetPath(context) {
    final assetName = '${type.asset}_${style.assetSuffix}.svg';
    if ([GooglePayButtonType.plain, GooglePayButtonType.buy].contains(type)) {
      return 'assets/$assetName';
    }

    final langCode = Localizations.maybeLocaleOf(context)?.languageCode;
    final supportedLangCode =
        _supportedLocales.contains(langCode) ? langCode : _defaultLocale;

    return 'assets/$supportedLangCode/$assetName';
  }

  @override
  Widget build(BuildContext context) {
    final Widget rawButton = RawMaterialButton(
      fillColor:
          style == GooglePayButtonStyle.black ? Colors.black : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: style == GooglePayButtonStyle.flat
            ? const BorderSide(
                color: Color(0xFFDEDEDE),
                width: 2,
              )
            : BorderSide.none,
      ),
      child: SvgPicture.asset(
        _assetPath(context),
        package: 'pay_android',
        semanticsLabel: 'Buy with Google Pay text',
        height: 19,
      ),
    );

    return Container(
      decoration: style == GooglePayButtonStyle.white
          ? BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 2,
                offset: const Offset(0, 1),
              )
            ])
          : null,
      height: defaultButtonHeight,
      child: rawButton,
    );
  }
}

extension _GooglePayButtonTypeAsset on GooglePayButtonType {
  static const defaultAsset = 'gpay_logo';
  static const defaultAssetWidth = 54.0;

  String get asset =>
      {
        GooglePayButtonType.book: 'book_with',
        GooglePayButtonType.buy: 'buy_with',
        GooglePayButtonType.checkout: 'checkout_with',
        GooglePayButtonType.donate: 'donate_with',
        GooglePayButtonType.order: 'order_with',
        GooglePayButtonType.pay: 'pay_with',
        GooglePayButtonType.plain: defaultAsset,
        GooglePayButtonType.subscribe: 'subscribe_with',
        GooglePayButtonType.view: 'view_in'
      }[this] ??
      defaultAsset;
}

extension _GooglePayButtonStyleAsset on GooglePayButtonStyle {
  static const defaultAssetSuffix = 'dark';

  String get assetSuffix =>
      {
        GooglePayButtonStyle.black: defaultAssetSuffix,
        GooglePayButtonStyle.white: 'light',
        GooglePayButtonStyle.flat: 'light',
      }[this] ??
      defaultAssetSuffix;
}
