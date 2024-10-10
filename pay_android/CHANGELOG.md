# Changelog

## 3.0.0-beta.1 (2024-10-10)
### ⚠ BREAKING CHANGE
Introduce an event channel to communicate the Flutter and native ends using a continuous stream of information. This addresses various challenges derived from activity lifecycle management events on Android

### Features

* Add a separate event channel (named `plugins.flutter.io/pay/payment_result`) to handle payment result information. An `EventChannel` object is required to consume this information.

### Fixes
* ([#277](https://github.com/google-pay/flutter-plugin/issues/277), [#274](https://github.com/google-pay/flutter-plugin/issues/274), [#261](https://github.com/google-pay/flutter-plugin/issues/261), [#206](https://github.com/google-pay/flutter-plugin/issues/206)) Avoid lifecycle conflicts when the activity managing the payment operation is re-created before the payment result is returned.

## 2.0.0 (2024-02-27)
### ⚠ BREAKING CHANGE
Update the Google Pay button to support the last 4 digits of a suitable card for this payment, and extend its configuration capabilities.

### Features

* Introduce the new dynamic button for Google Pay (#110). This view is part of the Google Pay Android SDK, and handles graphics and translations. The component also introduces updates to the Google Pay button. This includes:
    * ⚠ Adding the `paymentConfiguration` mandatory parameter to configure the dynamic component of the button.
    * ⚠ Removing the `add` property in `GooglePayButtonType`. If you are using this package to integrate the Google Wallet API, stay tuned for updates on [a new plugin for Google Wallet](https://github.com/google-wallet) coming soon.
    * ⚠ Renaming the `GooglePayButtonStyle` to `GooglePayButtonTheme` to increase consistency with the Android API.
    * Adding the `cornerRadius` parameter to let you adjust the corner roundness of the button (#187).
* Update the minimum supported SDK version to Flutter 3.10/Dart 3.0 (#233).
* Use `flutter_lints` for static checks (#182, #210).

## 2.0.0-beta01 (2024-02-01)
### ⚠ BREAKING CHANGE
Update the Google Pay button to support the last 4 digits of a suitable card for this payment, and extend its configuration capabilities.

### Features

* Introduce the new dynamic button for Google Pay (#110). This view is part of the Google Pay Android SDK, and handles graphics and translations. The component also introduces updates to the Google Pay button. This includes:
    * ⚠ Adding the `paymentConfiguration` mandatory parameter to configure the dynamic component of the button.
    * ⚠ Removing the `add` property in `GooglePayButtonType`. If you are using this package to integrate the Google Wallet API, stay tuned for updates on [a new plugin for Google Wallet](https://github.com/google-wallet) coming soon.
    * ⚠ Renaming the `GooglePayButtonStyle` to `GooglePayButtonTheme` to increase consistency with the Android API.
    * Adding the `cornerRadius` parameter to let you adjust the corner roundness of the button (#187).
* Update the minimum supported SDK version to Flutter 3.10/Dart 3.0 (#233).
* Use `flutter_lints` for static checks (#182, #210).

## 1.0.11 (2023-07-31)

* Update dependencies' versions

## 1.0.10 (2023-02-02)

* Bump `flutter_svg` to version 2.0.5.

## 1.0.9 (2023-01-24)

* Support for the latest platform interface.

## 1.0.8 (2022-09-14)

* Update the Google Pay button to adhere to the new specification and [brand guidelines](https://developers.google.com/pay/api/android/guides/brand-guidelines).

## 1.0.7 (2022-05-24)

* Add support for Flutter 3.0

## 1.0.6 (2022-01-04)

* Update `flutter_svg` to `1.0.0`.
* Use the latest `pay_platform_interface`.

## 1.0.5 (2021-10-04)

### Features
* Capture the dismissal of the payment selector and expose it to the Flutter end through the `onError` callback ([#90](https://github.com/google-pay/flutter-plugin/issues/90), [#61](https://github.com/google-pay/flutter-plugin/issues/61)).

## 1.0.4 (2021-05-31)
Enrich `dartdoc` comments to facilitate the adoption of the package.

## 1.0.2 (2021-05-25)

* Update dependencies.

## 1.0.1 (2021-05-18)

### Fixes

* Use absolute routes for intra-repo links.

## 1.0.0 (2021-05-18)
Initial release of the Android bit for the [pay](https://pub.dev/packages/pay) plugin.

### Features

* Includes a button widget with the flavors and styles available for Google Pay.
