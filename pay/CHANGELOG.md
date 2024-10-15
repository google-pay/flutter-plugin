# Changelog

## 3.0.0-beta.2 (2024-10-10)
Include logic to prevent a subscription for payment result `EventChannel`s from being created on platforms that don't support it.

## 3.0.0-beta.1 (2024-10-10)
### ⚠ BREAKING CHANGE
Introduce an event channel to communicate the Flutter and native ends for Android integrations. This change is only breaking for users of the [advanced integration](https://pub.dev/packages/pay#advanced-usage). The other paths are unaffected and can use this version transparently.

### Features

* Use an event channel to handle payment result information on Android.
* Add a complete example of the advanced integration path (see [`advanced.dart`](example/lib/advanced.dart)).

### Fixes
* ([#277](https://github.com/google-pay/flutter-plugin/issues/277), [#274](https://github.com/google-pay/flutter-plugin/issues/274), [#261](https://github.com/google-pay/flutter-plugin/issues/261), [#206](https://github.com/google-pay/flutter-plugin/issues/206)) Avoid lifecycle conflicts on Android when the activity managing the payment operation is re-created before the payment result is returned.

## 2.0.0 (2024-02-27)
### ⚠ BREAKING CHANGE
Update the Google Pay button to support the last 4 digits of a suitable card for this payment, and extend configuration capabilities.

### Features

* ⚠ Introduce the new dynamic button for Google Pay on Android. See the [changelog for `pay_android:2.0.0`](../pay_android/CHANGELOG.md#200-2024-02-27) for a detailed breakdown of the changes.
* Update minimum supported SDK version to Flutter 3.10/Dart 3.0 ([#233](https://github.com/google-pay/flutter-plugin/issues/233)).
* Use `flutter_lints` for static checks ([#182](https://github.com/google-pay/flutter-plugin/issues/182), [#210](https://github.com/google-pay/flutter-plugin/issues/210)).
* Introduce new properties and fixes for the Apple Pay button. See the [changelog for `pay_ios:1.0.11`](../pay_ios/CHANGELOG.md#1011-2024-01-21) for a detailed breakdown of the changes.

### Retired APIs

* ⚠ Removed the `Pay.withAssets` constructor. See the [readme in the `pay_platform_interface` package](../pay_platform_interface/README.md#usage) to review the recommended logic to initialize the `Pay` client.

## 2.0.0-beta01 (2024-02-01)
### ⚠ BREAKING CHANGE
Update the Google Pay button to support the last 4 digits of a suitable card for this payment, and extend configuration capabilities.

### Features

* ⚠ Introduce the new dynamic button for Google Pay on Android. See the [changelog for `pay_android:1.1.0-beta01`](../pay_android/CHANGELOG.md#110-beta01-2024-01-19) for a detailed breakdown of the changes.
* Update minimum supported SDK version to Flutter 3.10/Dart 3.0 ([#233](https://github.com/google-pay/flutter-plugin/issues/233)).
* Use `flutter_lints` for static checks ([#182](https://github.com/google-pay/flutter-plugin/issues/182), [#210](https://github.com/google-pay/flutter-plugin/issues/210)).
* Introduce new properties and fixes for the Apple Pay button. See the [changelog for `pay_ios:1.0.11`](../pay_ios/CHANGELOG.md#1011-2024-01-21) for a detailed breakdown of the changes.

### Retired APIs

* ⚠ Removed the `Pay.withAssets` constructor. See the [readme in the `pay_platform_interface` package](../pay_platform_interface/README.md#usage) to review the recommended logic to initialize the `Pay` client.

## 1.1.2 (2023-07-31)
* Update `pay_android` to 1.0.11, which includes lifecycle fixes.

## 1.1.1 (2023-02-02)
* Update `pay_android` to 1.0.10, which includes the latest version of the `flutter_svg` package.

## 1.1.0 (2023-01-24)

### ⚠ DEPRECATION WARNING

### Features
* Widgets inheriting from `PayButton` now receive the payment configuration using the `paymentConfiguration` parameter, which expects a `PaymentConfiguration` object. This allows building configuration objects from assets or strings (see [#7](https://github.com/google-pay/flutter-plugin/issues/7)). The previous `paymentConfigurationAsset` property is still available and marked as deprecated for backwards compatibility, and will be removed in future releases. See the new example application and readme to learn more.
* Use a `Map` to configure a `Pay` client, where the key is a `PayProvider` and the value is a `PaymentConfiguration`. 

## 1.0.11 (2022-09-14)

* Update `pay_android` to `1.0.8`, which includes the new specification for the Google Pay button.

## 1.0.10 (2022-06-01)

* Update `pay_ios` to `1.0.7`, which adds the `transactionIdentifier` property to the payment result.

## 1.0.9 (2022-05-24)

* Add support for Flutter 3 in the sample application.
* Update `pay_android` to `1.0.7`, which adds support for Flutter 3 to the package.

## 1.0.8 (2022-01-31)

* Update `pay_ios` to `1.0.6`, which adds `postalAddress` to the payment result.

## 1.0.7 (2022-01-04)

* Update `pay_android` to `1.0.6`, which uses a stable version of `flutter_svg`.

## 1.0.6 (2021-10-04)

### Features
* Make the package available for iOS versions lower than 12.0 ([#36](https://github.com/google-pay/flutter-plugin/issues/36)).
* Capture the dismissal of the payment selector and expose it to the Flutter end through the `onError` callback ([#90](https://github.com/google-pay/flutter-plugin/issues/90), [#61](https://github.com/google-pay/flutter-plugin/issues/61)).

### Fixes
* Fix not being able to capture a payment result on the second and further payment attempts ([#80](https://github.com/google-pay/flutter-plugin/issues/80)).

## 1.0.5 (2021-06-08)

### Fixes

* Expose the `PaymentConfiguration` class through the `pay` package ([#53](https://github.com/google-pay/flutter-plugin/issues/53)).
* Fix incorrect `late init` use at initialization time for the `Pay` class ([#54](https://github.com/google-pay/flutter-plugin/issues/54)).

## 1.0.4 (2021-06-01)
Enrich `dartdoc` comments to facilitate the adoption of the package.

## 1.0.3 (2021-05-26)

### Fixes

* Fix incorrect handling of billing and shipping addresses for Apple Pay.

## 1.0.2 (2021-05-25)

* Update dependencies.

### Fixes

* Correctly flag the package as a plugin.

## 1.0.1 (2021-05-18)

### Fixes

* Updated the guide in the readme.

## 1.0.0 (2021-05-10)
Initial release of this plugin.

### Features

* Support for Apple Pay and Google Pay.
* Two integration paths: a set of simple drop-and-go widgets, and separate classes to create custom integrations. 
* Support for multiple payment providers for a single platform.
* Support for the languages supported by the payment providers.
