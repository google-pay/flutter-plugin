A plugin to add payments to your Flutter application.
  
| <sub>pay</sub> | <sub>pay_android</sub> | <sub>pay_ios</sub> | <sub>pay_platform_interface |
|:---:|:---:|:---:|:---:|
| [![pub package](https://img.shields.io/pub/v/pay.svg)](https://pub.dartlang.org/packages/pay) | [![pub package](https://img.shields.io/pub/v/pay_android.svg)](https://pub.dartlang.org/packages/pay_android) | [![pub package](https://img.shields.io/pub/v/pay_ios.svg)](https://pub.dartlang.org/packages/pay_ios) | [![pub package](https://img.shields.io/pub/v/pay_platform_interface.svg)](https://pub.dartlang.org/packages/pay_platform_interface) |

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

## Installation
This adds the `pay` package to the [list of dependencies in your pubspec.yaml file](https://flutter.io/platform-plugins/) with the following command:

```shell
flutter pub add pay
```

## Usage

Define the configuration for your payment provider(s). Take a look at the parameters available in the documentation for [Apple Pay](https://developer.apple.com/documentation/passkit/pkpaymentrequest) and [Google Pay](https://developers.google.com/pay/api/android/reference/request-objects), and explore the [sample configurations in this package](https://github.com/google-pay/flutter-plugin/tree/main/pay/example/lib/payment_configurations.dart).

### Example
This snippet assumes the existence of a payment configuration for Apple Pay ([`defaultApplePayConfig`](https://github.com/google-pay/flutter-plugin/tree/main/pay/example/lib/payment_configurations.dart#L29)) and another one for Google Pay ([`defaultGooglePayConfig`](https://github.com/google-pay/flutter-plugin/tree/main/pay/example/lib/payment_configurations.dart#L69)):

```dart
import 'package:pay/pay.dart';
import 'payment_configurations.dart' as payment_configurations;

const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: PaymentItemStatus.final_price,
  )
];

ApplePayButton(
  paymentConfiguration: payment_configurations.defaultApplePayConfig,
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
  paymentConfiguration: payment_configurations.defaultGooglePayConfig,
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

To learn more about the `pay` plugin and alternative integration paths, check out [the readme in the `pay` folder](./pay/README.md).

## Other packages in this plugin

The packages in this repository follow the [federated plugin](https://docs.flutter.dev/packages-and-plugins/developing-packages#federated-plugins) architecture. Each package has a specific responsibility and can be used independently to fulfil less conventional integration needs:

| Package | Description | When to use |
|:---:|:---:|:---:|
| [pay](./pay/) | An app-facing package with support for all the platforms supported by this plugin. | This package offers an agnostic integration for the platforms supported in this plugin and features the easiest path to add payments to your Flutter application. |
| [pay_android](./pay_android/) | The endorsed implementation of this plugin for Android. | This package contains the necessary business logic to support the Android platform. You can integrate this package separately or use it to build your own app-facing package. |
| [pay_ios](./pay_ios/) | The endorsed implementation of this plugin for iOS. | This package contains the necessary business logic to support the iOS platform. You can integrate this package separately or use it to build your own app-facing package. |
| [pay_platform_interface](./pay_platform_interface/) | A common API contract for platform-specific implementations. | Folow the contract in this package to add new platforms to the plugin or create your own Android or iOS implementations. Take a look at the [guide about plugin development](https://flutter.dev/docs/development/packages-and-plugins/developing-packages#federated-plugins) to learn more. |

## Additional resources
Check out the following resources to manage your payment accounts and learn more about the APIs for the supported providers:

|  | Google Pay | Apple Pay |
|:---|:---|:---|
| Platforms | Android | iOS |
| Documentation | [Overview](https://developers.google.com/pay/api/android/overview) | [Overview](https://developer.apple.com/apple-pay/implementation/)
| Console | [Google Pay Business Console](https://pay.google.com/business/console/) |  [Developer portal](https://developer.apple.com/account/)  |
| Reference | [API reference](https://developers.google.com/pay/api/android/reference/client) | [Apple Pay API](https://developer.apple.com/documentation/passkit/apple_pay/)
| Style guidelines | [Brand guidelines](https://developers.google.com/pay/api/android/guides/brand-guidelines) | [Buttons and Marks](https://developer.apple.com/design/human-interface-guidelines/apple-pay/overview/buttons-and-marks/)

<br>
<sup>Note: This is not an officially supported Google product.</sup>

