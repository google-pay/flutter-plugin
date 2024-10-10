[![pub package](https://img.shields.io/pub/v/pay_ios.svg)](https://pub.dartlang.org/packages/pay_ios)

This is an implementation of the [`pay_platform_interface`](https://github.com/google-pay/flutter-plugin/tree/main/pay_platform_interface) package for iOS.

## Usage

### With the `pay` plugin

This package is the endorsed implementation of the [`pay` plugin](https://pub.dev/packages/pay), so it gets automatically added to your [dependencies](https://flutter.dev/platform-plugins/) by adding the `pay` package to your `pubspec.yaml`.

### Using this package directly

If you prefer to integrate or extend this package separately, add it as a dependency in your `pubspec.yaml` file as follows:

```yaml
dependencies:
  pay_ios: ^1.0.12
```

Now, you can use the buttons available for the supported payment providers and the methods exposed in [the interface that this package uses](https://github.com/google-pay/flutter-plugin/tree/main/pay_platform_interface) to communicate with the native end.

```dart
RawApplePayButton(
  style: ApplePayButtonStyle.black,
  type: ApplePayButtonType.buy);
```

<br>
<sup>Note: This is not an officially supported Google product.</sup>