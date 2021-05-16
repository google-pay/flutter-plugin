[![pub package](https://img.shields.io/pub/v/pay_platform_interface.svg)](https://pub.dartlang.org/packages/pay_platform_interface)

A common platform interface for the [`pay`](../pay) plugin.

The contract in this package allows platform-specific implementations of the `pay` plugin, to ensure a common interface across plugins.

Take a look at the [guide about plugin development](https://flutter.dev/docs/development/packages-and-plugins/developing-packages#federated-plugins) if you'd like to learn more about the process of creating federated plugins.

## Usage
To implement a new platform-specific implementation, add `pay_platform_interface` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/):

```yaml
dependencies:
  pay_platform_interface: ^1.0.0
```

Start by extending [`PayPlatform`](lib/pay_platform_interface.dart) with an implementation that performs the platform-specific behavior.

The methods in the interface are:
* `Future<bool> userCanPay(PaymentConfiguration paymentConfiguration)`
<br>This method helps users of the plugin learn about whether a user can pay with a selected provider. The logic in this call is in charge of communicating directly with the payment provider specified in the payment configuration to return a result.
* `Future<Map<String, dynamic>> showPaymentSelector(PaymentConfiguration paymentConfiguration, List<PaymentItem> paymentItems)`
<br>This method takes provider-specific payment configuration and a list of payment items (eg.: articles, taxes, subtotal, etc) and starts the payment process by showing the payment selector to users.

## Payment configuration
The configuration to setup a payment provider is based on a open-ended schema (with provider-specific classes coming soon) with two required properties:
* `provider`: with the target payment provider (eg.: `apple_pay`, `google_pay`).
* `data`: a schemaless object with specific fields for the target payment provider. Take a look at the [test assets folder](test/assets/) to see examples configurations.

## Note on breaking changes

Strongly prefer non-breaking changes (such as adding a method to the interface) over breaking changes for this package.

Take a look at [this discussion](https://flutter.dev/go/platform-interface-breaking-changes) on why a less-clean interface is preferable to a breaking change.

<br>
<sup>Note: This is not an officially supported Google product.</sup>