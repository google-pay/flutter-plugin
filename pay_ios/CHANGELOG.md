# Changelog

## 1.0.11 (2024-01-21)
Introduce new properties and fixes for the Apple Pay button.

### Features

* Surface the `cornerRadius` property to the `ApplePayButton` widget to allow changing the corner roundness of the Apple Pay button ([#127](https://github.com/google-pay/flutter-plugin/issues/127)).

### Fixes

* Make the `ApplePayButton` widget reactive to changes in the items used to calculate the price ([#235](https://github.com/google-pay/flutter-plugin/issues/235)).

## 1.0.10 (2024-01-19)
Bump versions of dependencies and update static analysis tooling.

### Features

* Use `flutter_lints` for static checks ([#182](https://github.com/google-pay/flutter-plugin/issues/182), [#210](https://github.com/google-pay/flutter-plugin/issues/210)).
* Update minimum supported SDK version to Flutter 3.10/Dart 3.0.

## 1.0.9 (2023-07-31)

* Fix typo in public property.

## 1.0.8 (2023-01-24)

* Support for the latest platform interface.

## 1.0.7 (2021-06-01)

* Include the [`transactionIdentifier`](https://developer.apple.com/documentation/passkit/pkpaymenttoken/1617003-transactionidentifier) property in the Apple Pay result.

## 1.0.6 (2022-01-31)

### ⚠ BREAKING CHANGES

* The payment result object contains the following changes:
  * Added a `postalAddress` property.
  * Changed the resulting `name` in `PKContact` from `String` to `Dictionary`.
  * Trimmed `null` properties before returning the JSON object.

### Fixes
* Univocally use the dot character (.) to separate the whole and the decimal part in a decimal number ([#84](https://github.com/google-pay/flutter-plugin/issues/84)).
* Include billing and shipping addresses on the response ([#72](https://github.com/google-pay/flutter-plugin/issues/72)).

## 1.0.5 (2021-10-04)

### Features
* Make the package available for iOS versions lower than 12.0 ([#36](https://github.com/google-pay/flutter-plugin/issues/36)).
* Capture the dismissal of the payment selector and expose it to the Flutter end through the `onError` callback ([#90](https://github.com/google-pay/flutter-plugin/issues/90), [#61](https://github.com/google-pay/flutter-plugin/issues/61)).

### Fixes
* Fix not being able to capture a payment result on the second and further payment attempts ([#80](https://github.com/google-pay/flutter-plugin/issues/80)).

## 1.0.4 (2021-05-27)
Enrich `dartdoc` comments to facilitate the adoption of the package.

### Fixes

* Fix iOS not returning a result after consecutive payment attempts.

## 1.0.3 (2021-05-26)

### Fixes

* Fix incorrect handling of billing and shipping addresses.

## 1.0.2 (2021-05-25)

* Update dependencies.

## 1.0.1 (2021-05-18)

### Fixes

* Fixed typo in the documentation.

## 1.0.0 (2021-05-18)
Initial release of the iOS bit for the [pay](https://pub.dev/packages/pay) plugin.

### Features

* Includes a button widget with the flavors and styles available for Apple Pay.