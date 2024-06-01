// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

part of '../../pay_android.dart';

/// The types of button supported on Google Pay.
enum GooglePayButtonType {
  book,
  buy,
  checkout,
  donate,
  order,
  pay,
  plain,
  subscribe
}

/// The button themes supported on Google Pay.
enum GooglePayButtonTheme {
  dark,
  light,
}

/// A button widget that follows the Google Pay button themes and design
/// guidelines.
///
/// This widget is a representation of the Google Pay button in Flutter. The
/// button is drawn on the Flutter end using official assets, featuring all
/// the labels, and themes available, and can be used independently as a
/// standalone component.
///
/// To use this button independently, simply add it to your layout:
/// ```dart
/// RawGooglePayButton(
///   type: GooglePayButtonType.pay,
///   onPressed: () => print('Button pressed'));
/// ```
class RawGooglePayButton extends StatelessWidget {
  /// The payment configuration for the button to show the last 4 digits of a
  /// pre-selected card
  final PaymentConfiguration _paymentConfiguration;

  /// The default width for the Google Pay Button.
  static const double minimumButtonWidth = 168;

  /// The default height for the Google Pay Button.
  static const double defaultButtonHeight = 48;

  /// The constraints used to limit the size of the button.
  final BoxConstraints constraints;

  // Identifier to register the view on the platform end.
  static const String viewType = 'plugins.flutter.io/pay/google_pay_button';

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// The amount of roundness applied to the corners of the button background.
  final int cornerRadius;

  /// The theme of the Google Pay button, to be adjusted based on the color
  /// scheme of the application.
  final GooglePayButtonTheme theme;

  /// The type of button depending on the activity initiated with the payment
  /// transaction.
  final GooglePayButtonType type;

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  /// Creates a Google Pay button widget with the parameters specified.
  RawGooglePayButton({
    super.key,
    required final PaymentConfiguration paymentConfiguration,
    this.onPressed,
    this.cornerRadius = defaultButtonHeight ~/ 2,
    this.theme = GooglePayButtonTheme.dark,
    this.type = GooglePayButtonType.buy,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
  })  : _paymentConfiguration = paymentConfiguration,
        constraints = const BoxConstraints.tightFor(
          width: minimumButtonWidth,
          height: defaultButtonHeight,
        ) {
    assert(constraints.debugAssertIsValid());
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints,
      child: _platformButton,
    );
  }

  /// Wrapper method to deliver the button
  Widget get _platformButton {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return PlatformViewLink(
            viewType: viewType,
            surfaceFactory: (context, controller) {
              return AndroidViewSurface(
                controller: controller as AndroidViewController,
                gestureRecognizers: gestureRecognizers,
                hitTestBehavior: PlatformViewHitTestBehavior.opaque,
              );
            },
            onCreatePlatformView: (params) =>
                PlatformViewsService.initAndroidView(
                  id: params.id,
                  viewType: viewType,
                  layoutDirection: TextDirection.ltr,
                  creationParams: {
                    'theme': theme.enumString,
                    'type': type.enumString,
                    'cornerRadius': cornerRadius,
                    'paymentConfiguration':
                        _paymentConfiguration.rawConfigurationData(),
                  },
                  creationParamsCodec: const StandardMessageCodec(),
                  onFocus: () {
                    params.onFocusChanged(true);
                  },
                )
                  ..addOnPlatformViewCreatedListener(_onPlatformViewCreated)
                  ..addOnPlatformViewCreatedListener(
                      params.onPlatformViewCreated)
                  ..create());
      default:
        throw UnsupportedError(
            'This platform $defaultTargetPlatform does not support Google Pay');
    }
  }

  _onPlatformViewCreated(int viewId) {
    MethodChannel methodChannel = MethodChannel('$viewType/$viewId');
    methodChannel.setMethodCallHandler((call) async {
      if (call.method == 'onPressed') onPressed?.call();
    });
  }

  static bool get supported => defaultTargetPlatform == TargetPlatform.android;
}

/// A set of utility methods associated to the [GooglePayButtonType] enumeration.
extension on GooglePayButtonType {
  /// Creates a string representation of the [GooglePayButtonType] enumeration.
  String get enumString => {
        GooglePayButtonType.plain: 'plain',
        GooglePayButtonType.buy: 'buy',
        GooglePayButtonType.donate: 'donate',
        GooglePayButtonType.checkout: 'checkout',
        GooglePayButtonType.book: 'book',
        GooglePayButtonType.subscribe: 'subscribe',
        GooglePayButtonType.pay: 'pay',
        GooglePayButtonType.order: 'order',
      }[this]!;
}

/// A set of utility methods associated to the [GooglePayButtonTheme] enumeration.
extension on GooglePayButtonTheme {
  /// Creates a string representation of the [GooglePayButtonTheme] enumeration.
  String get enumString => {
        GooglePayButtonTheme.dark: 'dark',
        GooglePayButtonTheme.light: 'light',
      }[this]!;
}
