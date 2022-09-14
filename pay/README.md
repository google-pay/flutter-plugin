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
2. Create a [merchant identifier](https://help.apple.com/developer-account/#/devb2e62b839?sub=dev103e030bb) for your business.
3. Create a [payment processing certificate](https://help.apple.com/developer-account/#/devb2e62b839?sub=devf31990e3f) to encrypt payment information.

#### Google Pay:
1. Take a look at the [integration requirements](https://developers.google.com/pay/api/android/overview).
2. Sign up to the [business console](https://pay.google.com/business/console) and create an account.

## Usage
To start using this plugin, add `pay` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/):

```yaml
dependencies:
  pay: ^1.0.11
```

### Payment configuration
Create a payment profile with the desired configuration for your payment, either using a local file or loading it from a remote server. Take a look at some examples under the [`example/assets/` folder](https://github.com/google-pay/flutter-plugin/tree/main/pay/example/assets) and explore the documentation for a complete list of options available:
* [Google Pay](https://developers.google.com/pay/api/android/reference/request-objects#PaymentDataRequest)
* [Apple Pay](https://developer.apple.com/documentation/businesschatapi/applepaypaymentrequest) ([sample request](https://developer.apple.com/documentation/businesschatapi/messages_sent/interactive_messages/apple_pay_in_business_chat/sending_an_apple_pay_payment_request))

### Example
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
  paymentConfigurationAsset: 'default_payment_profile_apple_pay.json',
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
  paymentConfigurationAsset: 'default_payment_profile_google_pay.json',
  paymentItems: _paymentItems,
  type: GooglePayButtonType.pay,
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

Pay _payClient = Pay.withAssets([
  'default_payment_profile_apple_pay.json',
  'default_payment_profile_google_pay.json'
]);
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
            type: GooglePayButtonType.pay,
            onPressed: onGooglePayPressed);
        } else {
          // userCanPay returned false
          // Consider showing an alternative payment method
        }
      }
    },
  );
}
```
Finally, handle the `onPressed` event and trigger the payment selector as follows:

```dart
void onGooglePayPressed() async {
  final result = await _payClient.showPaymentSelector(
    provider: PayProvider.google_pay,
    paymentItems: _paymentItems,
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