# Changelog

## 1.0.6 (2021-10-04)

### Features
* [#36] Make the package available for iOS versions lower than 12.0.
* [#90, #61] Capture the dismissal of the payment selector and expose it to the Flutter end through the `onError` callback.

### Fixes
* [#80] Fix not being able to capture a payment result on the second and further payment attempts.

## 1.0.5 (2021-06-08)

### Fixes

* Expose the `PaymentConfiguration` class through the `pay` package (#53).
* Fix incorrect `late init` use at initialization time for the `Pay` class (#54).

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
