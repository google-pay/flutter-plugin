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

// Instantiate the client for a wallet
Pay _googlePayClient = Pay.fromAsset('default_payment_profile.json');

// Show the button if supported
Widget _getPaymentButtons() {
  return FutureBuilder<bool>(
    future: _googlePayClient.userCanPay(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.data == true) {
          return SizedBox(
              width: double.infinity,
              child: GooglePayButton(
                  color: GooglePayButtonColor.flat,
                  type: GooglePayButtonType.pay,
                  onPressed: googlePayButtonPressed));
        } else if (snapshot.hasError) {
          // TODO: Handle error
        }
      }

      // TODO: Show loading indicator
      // eg.: return CircularProgressIndicator();
    },
  );
}

// Respond to button taps and load payment info
void googlePayButtonPressed() async {
  var result = await _googlePayClient.showPaymentSelector(price: /* item price */);
}
```

## Resources
|| Android (Google Pay) | iOS (Apple Pay) |
|:---:|:---:|:---:|
| Console | [Google Pay Business Console](https://pay.google.com/business/console/) |  (coming soon)  |
| Reference | [API reference](https://developers.google.com/pay/api/android/reference/client)
| Style guidelines | [Brand guidelines](https://developers.google.com/pay/api/android/guides/brand-guidelines)