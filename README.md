# Custom pay plugin

This is a custom pay plugin that was forked from the original version to add some features we need. This is a [federated plugin](https://docs.flutter.dev/development/packages-and-plugins/developing-packages#federated-plugins). Which means that it has three four parts:

- pay: the main package that doesn't have native code
- pay_platform_interface: a package that exposes an interface that any native plugin must implement to work under pay package
- pay_ios: iOS plugin that has native swift code
- pay_android: android plugin that has native kotlin code

## Modifications

- Reject payment if shipping address is outside of Poland

## How to edit

As an example say you want to edit some native iOS code:

1. Clone this repository locally
2. Open `pubspec.yaml` file of [mobile-app](https://gitlab.com/clean-kitchen/mobile-app) repository
3. Change `pay_ios` dependency override to point to your cloned repository. For example:
   ```
   dependency_overrides:
     pay_ios:
       path: ../flutter-pay-plugin/pay_ios
   ```
4. Now you can create a branch and make changes to files under `pay_ios` repository
5. (optional) if you want to make changes through Xcode to make use of its swift linting features then you can follow [these steps](https://docs.flutter.dev/development/packages-and-plugins/developing-packages#step-2c-add-ios-platform-code-swifthm). But note that for whatever reason running `flutter build ios --no-codesign` will make some changes to platform iOS version in Podfile and other places. But there is no need to push those changes
6. After your changes are done and working you can open an PR to merge them. After they are merged make sure to revert changes made in point 3
