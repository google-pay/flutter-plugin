# pay – Facilitate payments on Flutter
[![pub package](https://img.shields.io/pub/v/pay.svg)](https://pub.dartlang.org/packages/pay)

A Flutter plugin to add payment wallets to your application.

## Platform Support
| Android (Google Pay) | iOS (Apple Pay) |
|:---:|:---:|
|    ✔️    |  (coming soon)  |

## Getting started
Before you start, create an account on the payment services you are planning to support:

### Android (Google Pay):
1. Take a look at the [integration requirements](https://developers.google.com/pay/api/android/overview).
2. Sign up to the [business console](https://pay.google.com/business/console) and create an account.

## Usage
To use this plugin, add `pay` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### Payment configuration
Create a payment profile with the desired configuration for your payment, either using a local file or loading it from a remote server. Take a look at some examples under the [`example/assets/` folder](example/assets) and explore the documentation for a complete list of options available:
* [Android (Google Pay)](https://developers.google.com/pay/api/android/reference/request-objects#PaymentDataRequest)

### Example
```dart
import 'package:pay/pay.dart';

// Add the button to your UI
GooglePayButton(
  paymentConfigurationAsset: 'default_payment_profile.json',
  style: GooglePayButtonStyle.flat,
  type: GooglePayButtonType.pay,
  onPressed: googlePayButtonPressed,
  childOnError: Text('Google Pay is not available.'),
  loadingIndicator: Center(
    child: CircularProgressIndicator(),
  ),
)

// Respond to button taps and load payment info
void googlePayButtonPressed(paymentClient) async {
  var result = await paymentClient.showPaymentSelector(price: /* item price */);
}
```

## Resources
|| Android (Google Pay) | iOS (Apple Pay) |
|:---:|:---:|:---:|
| Console | [Google Pay Business Console](https://pay.google.com/business/console/) |  (coming soon)  |
| Reference | [API reference](https://developers.google.com/pay/api/android/reference/client)
| Style guidelines | [Brand guidelines](https://developers.google.com/pay/api/android/guides/brand-guidelines)