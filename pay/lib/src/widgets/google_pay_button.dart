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

part of '../../pay.dart';

/// A widget to show the Google Pay button according to the rules and
/// constraints specified in [PayButton].
///
/// Example usage:
/// ```dart
/// GooglePayButton(
///   paymentConfiguration: _paymentConfiguration,
///   paymentItems: _paymentItems,
///   theme: GooglePayButtonTheme.dark,
///   type: GooglePayButtonType.pay,
///   margin: const EdgeInsets.only(top: 15.0),
///   onPaymentResult: onGooglePayResult,
///   loadingIndicator: const Center(
///     child: CircularProgressIndicator(),
///   ),
/// )
/// ```
class GooglePayButton extends PayButton {
  late final Widget _googlePayButton;

  GooglePayButton({
    super.key,
    super.buttonProvider = PayProvider.google_pay,
    required final PaymentConfiguration paymentConfiguration,
    super.onPaymentResult,
    required List<PaymentItem> paymentItems,
    int cornerRadius = RawGooglePayButton.defaultButtonHeight ~/ 2,
    GooglePayButtonTheme theme = GooglePayButtonTheme.dark,
    GooglePayButtonType type = GooglePayButtonType.buy,
    super.width = RawGooglePayButton.minimumButtonWidth,
    super.height = RawGooglePayButton.defaultButtonHeight,
    super.margin = EdgeInsets.zero,
    VoidCallback? onPressed,
    super.onError,
    super.childOnError,
    super.loadingIndicator,
  })  : assert(width >= RawGooglePayButton.minimumButtonWidth),
        assert(height >= RawGooglePayButton.defaultButtonHeight),
        super(paymentConfiguration: paymentConfiguration) {
    _googlePayButton = RawGooglePayButton(
        paymentConfiguration: paymentConfiguration,
        cornerRadius: cornerRadius,
        theme: theme,
        type: type,
        onPressed: _defaultOnPressed(onPressed, paymentItems));
  }

  @override
  final List<TargetPlatform> _supportedPlatforms = [TargetPlatform.android];

  @override
  late final Widget _payButton = _googlePayButton;

  @override
  final bool _returnsPaymentDataSynchronously = false;

  @override
  State<PayButton> createState() => _GooglePayButtonState();
}

class _GooglePayButtonState extends _PayButtonState {
  static const eventChannel =
      EventChannel('plugins.flutter.io/pay/payment_result');
  StreamSubscription<Map<String, dynamic>>? _paymentResultSubscription;

  /// A method to listen to events coming from the event channel on Android
  ///
  /// The Android implementation uses an event stream to receive payment results
  /// in order to circumvent the loss of connection with the Flutter engine when
  /// the main activity hosting the plugin gets recycled due to resource
  /// exhaustion.
  void _startListeningForPaymentResults() {
    _paymentResultSubscription = eventChannel
        .receiveBroadcastStream()
        .map((result) => jsonDecode(result as String) as Map<String, dynamic>)
        .listen((result) {
      widget._deliverPaymentResult(result);
    }, onError: (error) {
      widget._deliverError(error);
    });
  }

  @override
  void initState() {
    super.initState();
    _startListeningForPaymentResults();
  }

  @override
  void dispose() {
    _paymentResultSubscription?.cancel();
    _paymentResultSubscription = null;
    super.dispose();
  }
}
