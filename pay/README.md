[![pub package](https://img.shields.io/pub/v/pay.svg)](https://pub.dartlang.org/packages/pay)

A plugin to add payments to your Flutter application.

## Platform Support
| Android | iOS |
|:---:|:---:|
| Google Pay | Apple Pay |

## Getting started
Before you start, create an account with the payment providers you are planning to support and follow the setup instructions:

#### Apple Pay:
1. Take a look at the [integration requirements](https://developer.apple.com/documentation/passkit/apple_pay/setting_up_apple_pay_requirements).
2. Create a [merchant identifier](https://developer.apple.com/help/account/configure-app-capabilities/configure-apple-pay#create-a-merchant-identifier) for your business.
3. Create a [payment processing certificate](https://developer.apple.com/help/account/configure-app-capabilities/configure-apple-pay#create-a-payment-processing-certificate) to encrypt payment information.

#### Google Pay:
1. Take a look at the [integration requirements](https://developers.google.com/pay/api/android/overview).
2. Sign up to the [business console](https://pay.google.com/business/console) and create an account.

## Usage
To start using this plugin, add `pay` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/):

```yaml
dependencies:
  pay: ^2.0.0-beta01
```

Define the configuration for your payment provider(s). Take a look at the parameters available in the documentation for [Apple Pay](https://developer.apple.com/documentation/passkit/pkpaymentrequest) and [Google Pay](https://developers.google.com/pay/api/android/reference/request-objects), and explore the [sample configurations in this package](https://github.com/google-pay/flutter-plugin/tree/main/pay/example/lib/payment_configurations.dart).

### Example
This snippet assumes the existence a payment configuration for Apple Pay ([`defaultApplePayConfigString`](https://github.com/google-pay/flutter-plugin/tree/main/pay/example/lib/payment_configurations.dart#L27)) and another one for Google Pay ([`defaultGooglePayConfigString`](https://github.com/google-pay/flutter-plugin/tree/main/pay/example/lib/payment_configurations.dart#L63)):
```dart
import 'package:pay/pay.dart';

const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: PaymentItemStatus.final_price,
  )
];

ApplePayButton(
  paymentConfiguration: PaymentConfiguration.fromJsonString(
      defaultApplePayConfigString),
  paymentItems: _paymentItems,
  style: ApplePayButtonStyle.black,
  type: ApplePayButtonType.buy,
  margin: const EdgeInsets.only(top: 15.0),
  onPaymentResult: onApplePayResult,
  loadingIndicator: const Center(
    child: CircularProgressIndicator(),
  ),
),

GooglePayButton(
  paymentConfiguration: PaymentConfiguration.fromJsonString(
      defaultGooglePayConfigString),
  paymentItems: _paymentItems,
  type: GooglePayButtonType.buy,
  margin: const EdgeInsets.only(top: 15.0),
  onPaymentResult: onGooglePayResult,
  loadingIndicator: const Center(
    child: CircularProgressIndicator(),
  ),
),

void onApplePayResult(paymentResult) {
  // Send the resulting Apple Pay token to your server / PSP
}

void onGooglePayResult(paymentResult) {
  // Send the resulting Google Pay token to your server / PSP
}
```

### Alternative methods to load your payment configurations
#### JSON strings
The example above uses the `PaymentConfiguration.fromJsonString` method to load your payment configuration from a string in JSON format ([example](https://github.com/google-pay/flutter-plugin/tree/main/pay/example/lib/payment_configurations.dart#L27)). This configuration can be retrieved from a remote location at runtime ([recommended](https://github.com/google-pay/flutter-plugin/tree/main/pay/example/lib/payment_configurations.dart#L18)) or provided at build time.

#### Asset files
You can also place payment configurations under your `assets` folder and load them at runtime. Suppose that you add a JSON file with the name `google_pay_config.json` to your `assets` folder to configure your Google Pay integration. You can load it and use it to create a `PaymentConfiguration` object for the button (e.g.: using a `FutureBuilder`):

```dart
final Future<PaymentConfiguration> _googlePayConfigFuture = 
    PaymentConfiguration.fromAsset('google_pay_config.json');

FutureBuilder<PaymentConfiguration>(
  future: _googlePayConfigFuture,
  builder: (context, snapshot) => snapshot.hasData
      ? GooglePayButton(
          paymentConfiguration: snapshot.data!,
          paymentItems: _paymentItems,
          type: GooglePayButtonType.buy,
          margin: const EdgeInsets.only(top: 15.0),
          onPaymentResult: onGooglePayResult,
          loadingIndicator: const Center(
            child: CircularProgressIndicator(),
          ),
        )
      : const SizedBox.shrink()),
```

## Advanced usage
If you prefer to have more control over each individual request and the button separately, you can instantiate a payment client and add the buttons to your layout independently:

```dart
import 'package:pay/pay.dart';

const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: PaymentItemStatus.final_price,
  )
];

late final Pay _payClient;

// When you are ready to load your configuration
_payClient = Pay({
    PayProvider.google_pay: PaymentConfiguration.fromJsonString(
        payment_configurations.defaultGooglePay),
    PayProvider.apple_pay: PaymentConfiguration.fromJsonString(
        payment_configurations.defaultApplePay),
  });
```

As you can see, you can add multiple configurations to your payment client, one for each payment provider supported.

Now, you can use the `userCanPay` method to determine whether the user can start a payment process with a given provider. This call returns a `Future<bool>` result that you can use to decide what to do next. For example, you can feed the `Future` to a `FutureBuilder` that shows a different UI based on the result of the call:

```dart
@override
Widget build(BuildContext context) {
  return FutureBuilder<bool>(
    future: _payClient.userCanPay(PayProvider.google_pay),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.data == true) {
          return RawGooglePayButton(
              type: GooglePayButtonType.buy,
              onPressed: onGooglePayPressed);
        } else {
          // userCanPay returned false
          // Consider showing an alternative payment method
        }
      } else {
        // The operation hasn't finished loading
        // Consider showing a loading indicator 
      }
    },
  );
}
```
Finally, handle the `onPressed` event and trigger the payment selector as follows:

```dart
void onGooglePayPressed() async {
  final result = await _payClient.showPaymentSelector(
    PayProvider.google_pay,
    _paymentItems,
  );
  // Send the resulting Google Pay token to your server / PSP
}
```

## Additional resources
Take a look at the following resources to manage your payment accounts and learn more about the APIs for the supported providers:

|  | Google Pay | Apple Pay |
|:---|:---|:---|
| Platforms | Android | iOS |
| Documentation | [Overview](https://developers.google.com/pay/api/android/overview) | [Overview](https://developer.apple.com/apple-pay/implementation/)
| Console | [Google Pay Business Console](https://pay.google.com/business/console/) |  [Developer portal](https://developer.apple.com/account/)  |
| Reference | [API reference](https://developers.google.com/pay/api/android/reference/client) | [Apple Pay API](https://developer.apple.com/documentation/passkit/apple_pay/)
| Style guidelines | [Brand guidelines](https://developers.google.com/pay/api/android/guides/brand-guidelines) | [Buttons and Marks](https://developer.apple.com/design/human-interface-guidelines/apple-pay/overview/buttons-and-marks/)

<br>
<sup>Note: This is not an officially supported Google product.</sup>