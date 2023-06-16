/// Copyright 2021 Google LLC
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///     https://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.

part of '../../pay_ios.dart';

/// The types of button supported on Apple Pay.
///
/// See the [PKPaymentButtonType](https://developer.apple.com/documentation/passkit/pkpaymentbuttontype)
/// class in the Apple Pay documentation to learn more.
enum ApplePayButtonType {
  plain,
  buy,
  setUp,
  inStore,
  donate,
  checkout,
  book,
  subscribe,
  reload,
  addMoney,
  topUp,
  order,
  rent,
  support,
  contribute,
  tip
}

/// The button styles supported on Apple Pay.
///
/// See the [PKPaymentButtonStyle](https://developer.apple.com/documentation/passkit/pkpaymentbuttonstyle)
/// class in the Apple Pay documentation to learn more.
enum ApplePayButtonStyle {
  white,
  whiteOutline,
  black,
  automatic,
}

/// A set of utility methods associated to the [ApplePayButtonType] enumeration.
extension on ApplePayButtonType {
  /// The minimum width for this button type according to
  /// [Apple Pay's Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/apple-pay/overview/buttons-and-marks/)
  /// for the button.
  double get minimumAssetWidth => this == ApplePayButtonType.plain ? 100 : 140;
}

/// A button widget that follows the Apple Pay button styles and design
/// guidelines.
///
/// This widget is a representation of the Apple Pay button in Flutter. The
/// button is drawn natively through a [PlatformView] and sent back to the UI
/// element tree in Flutter. The button features all the labels, and styles
/// available, and can be used independently as a standalone component.
///
/// To use this button independently, simply add it to your layout:
/// ```dart
/// RawApplePayButton(
///   style: ApplePayButtonStyle.black,
///   type: ApplePayButtonType.buy,
///   onPressed: () => print('Button pressed'));
/// ```
class RawApplePayButton extends StatelessWidget {
  /// The default width for the Apple Pay Button.
  static const double minimumButtonWidth = 100;

  /// The default height for the Apple Pay Button.
  static const double minimumButtonHeight = 30;

  /// The constraints used to limit the size of the button.
  final BoxConstraints constraints;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// The style of the Apple Pay button, to be adjusted based on the color
  /// scheme of the application.
  final ApplePayButtonStyle style;

  /// The type of button depending on the activity initiated with the payment
  /// transaction.
  final ApplePayButtonType type;

  /// Creates an Apple Pay button widget with the parameters specified.
  RawApplePayButton({
    Key? key,
    this.onPressed,
    this.style = ApplePayButtonStyle.black,
    this.type = ApplePayButtonType.plain,
  })  : constraints = BoxConstraints.tightFor(
          width: type.minimumAssetWidth,
          height: minimumButtonHeight,
        ),
        super(key: key) {
    assert(constraints.debugAssertIsValid());
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints,
      child: _platformButton,
    );
  }

  /// Wrapper method to deliver the button only to applitcations running on iOS.
  Widget get _platformButton {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return _UiKitApplePayButton(
          onPressed: onPressed,
          style: style,
          type: type,
        );
      default:
        throw UnsupportedError(
            'This platform $defaultTargetPlatform does not support Apple Pay');
    }
  }

  static bool get supported => defaultTargetPlatform == TargetPlatform.iOS;
}

/// A widget to draw the Apple Pay button through a [PlatforView].
class _UiKitApplePayButton extends StatelessWidget {
  static const buttonId = 'plugins.flutter.io/pay/apple_pay_button';
  late final MethodChannel? methodChannel;

  final VoidCallback? onPressed;
  final ApplePayButtonStyle style;
  final ApplePayButtonType type;

  _UiKitApplePayButton({
    Key? key,
    this.onPressed,
    this.style = ApplePayButtonStyle.black,
    this.type = ApplePayButtonType.plain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UiKitView(
      viewType: buttonId,
      creationParamsCodec: const StandardMessageCodec(),
      creationParams: {'style': style.enumString, 'type': type.enumString},
      onPlatformViewCreated: (viewId) {
        methodChannel = MethodChannel('$buttonId/$viewId');
        methodChannel?.setMethodCallHandler((call) async {
          if (call.method == 'onPressed') onPressed?.call();
          return;
        });
      },
    );
  }
}

/// A set of utility methods associated to the [ApplePayButtonType] enumeration.
extension on ApplePayButtonType {
  /// Creates a string representation of the [ApplePayButtonType] enumeration.
  String get enumString => {
        ApplePayButtonType.plain: 'plain',
        ApplePayButtonType.buy: 'buy',
        ApplePayButtonType.setUp: 'setUp',
        ApplePayButtonType.inStore: 'inStore',
        ApplePayButtonType.donate: 'donate',
        ApplePayButtonType.checkout: 'checkout',
        ApplePayButtonType.book: 'book',
        ApplePayButtonType.subscribe: 'subscribe',
        ApplePayButtonType.reload: 'reload',
        ApplePayButtonType.addMoney: 'addMoney',
        ApplePayButtonType.topUp: 'topUp',
        ApplePayButtonType.order: 'order',
        ApplePayButtonType.rent: 'rent',
        ApplePayButtonType.support: 'support',
        ApplePayButtonType.contribute: 'contribute',
        ApplePayButtonType.tip: 'tip',
      }[this]!;
}

/// A set of utility methods associated to the [ApplePayButtonStyle] enumeration.
extension on ApplePayButtonStyle {
  /// Creates a string representation of the [ApplePayButtonStyle] enumeration.
  String get enumString => {
        ApplePayButtonStyle.white: 'white',
        ApplePayButtonStyle.whiteOutline: 'whiteOutline',
        ApplePayButtonStyle.black: 'black',
        ApplePayButtonStyle.automatic: 'automatic',
      }[this]!;
}
