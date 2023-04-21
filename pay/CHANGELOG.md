# Changelog


## 1.1.1 (2023-02-02)
* Update `pay_android` to 1.1.0, which includes the latest version of the `flutter_svg` package.

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
