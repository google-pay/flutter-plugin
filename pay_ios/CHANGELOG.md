# Changelog

## 1.0.5 (2021-10-04)

### Features
* [#36] Make the package available for iOS versions lower than 12.0.
* [#90, #61] Capture the dismissal of the payment selector and expose it to the Flutter end through the `onError` callback.

### Fixes
* [#80] Fix not being able to capture a payment result on the second and further payment attempts.

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