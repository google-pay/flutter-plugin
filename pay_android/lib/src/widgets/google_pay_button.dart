/// Copyright 2023 Google LLC
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///     https://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.

part of '../../pay_android.dart';

/// The types of button supported on Google Pay.
enum GooglePayButtonType {
  add,
  book,
  buy,
  checkout,
  donate,
  order,
  pay,
  plain,
  subscribe
}

/// A button widget that follows the Google Pay button styles and design
/// guidelines.
///
/// This widget is a representation of the Google Pay button in Flutter. The
/// button is drawn on the Flutter end using official assets, featuring all
/// the labels, and styles available, and can be used independently as a
/// standalone component.
///
/// To use this button independently, simply add it to your layout:
/// ```dart
/// RawGooglePayButton(
///   type: GooglePayButtonType.pay,
///   onPressed: () => print('Button pressed'));
/// ```
class RawGooglePayButton extends StatelessWidget {
  /// The default width for the Google Pay Button.
  static const double minimumButtonWidth =
      _GooglePayButtonTypeAsset.defaultAssetWidth;

  /// The default height for the Google Pay Button.
  static const double defaultButtonHeight = 48;

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

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// The type of button depending on the activity initiated with the payment
  /// transaction.
  final GooglePayButtonType type;

  /// Creates a Google Pay button widget with the parameters specified.
  const RawGooglePayButton({
    Key? key,
    this.onPressed,
    this.type = GooglePayButtonType.pay,
  }) : super(key: key);

  /// Utility method to generate the path to the asset for the button.
  ///
  /// The path is generated based on the button type and style, and the
  /// language code of the [context], and is returned as a [String].
  String _assetPath(BuildContext context) {
    final assetName = '${type.asset}.svg';
    if ([GooglePayButtonType.plain].contains(type)) {
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
      fillColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(
          color: Color(0xFF747775),
          width: 1,
        ),
      ),
      child: SvgPicture.asset(
        _assetPath(context),
        package: 'pay_android',
        semanticsLabel: 'Buy with Google Pay text',
        height: 26,
      ),
    );

    return SizedBox(
      height: defaultButtonHeight,
      child: rawButton,
    );
  }
}

/// A set of utility methods associated to the [GooglePayButtonType]
/// enumeration.
extension _GooglePayButtonTypeAsset on GooglePayButtonType {
  static const payLogoAsset = 'gpay_logo';
  static const defaultAssetWidth = 168.0;

  /// Returns the asset name for each [GooglePayButtonType] or falls back to
  /// [payLogoAsset].
  String get asset =>
      {
        GooglePayButtonType.add: 'add_to',
        GooglePayButtonType.book: 'book_with',
        GooglePayButtonType.buy: 'buy_with',
        GooglePayButtonType.checkout: 'checkout_with',
        GooglePayButtonType.donate: 'donate_with',
        GooglePayButtonType.order: 'order_with',
        GooglePayButtonType.pay: 'pay_with',
        GooglePayButtonType.plain: payLogoAsset,
        GooglePayButtonType.subscribe: 'subscribe_with'
      }[this] ??
      payLogoAsset;
}
