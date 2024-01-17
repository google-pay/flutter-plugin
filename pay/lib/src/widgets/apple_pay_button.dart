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

/// A widget to show the Apple Pay button according to the rules and constraints
/// specified in [PayButton].
///
/// Example usage:
/// ```dart
/// ApplePayButton(
///   paymentConfiguration: _paymentConfiguration,
///   paymentItems: _paymentItems,
///   style: ApplePayButtonStyle.black,
///   type: ApplePayButtonType.buy,
///   margin: const EdgeInsets.only(top: 15.0),
///   onPaymentResult: onApplePayResult,
///   loadingIndicator: const Center(
///     child: CircularProgressIndicator(),
///   ),
/// )
/// ```
class ApplePayButton extends PayButton {
  late final Widget _applePayButton;

  ApplePayButton({
    super.key,
    super.buttonProvider = PayProvider.apple_pay,
    required super.paymentConfiguration,
    super.onPaymentResult,
    required List<PaymentItem> paymentItems,
    ApplePayButtonStyle style = ApplePayButtonStyle.black,
    ApplePayButtonType type = ApplePayButtonType.plain,
    super.width = RawApplePayButton.minimumButtonWidth,
    super.height = RawApplePayButton.minimumButtonHeight,
    super.margin = EdgeInsets.zero,
    VoidCallback? onPressed,
    super.onError,
    super.childOnError,
    super.loadingIndicator,
  })  : assert(width >= RawApplePayButton.minimumButtonWidth),
        assert(height >= RawApplePayButton.minimumButtonHeight) {
    _applePayButton = RawApplePayButton(
        style: style,
        type: type,
        onPressed: _defaultOnPressed(onPressed, paymentItems));
  }

  @override
  final List<TargetPlatform> _supportedPlatforms = [TargetPlatform.iOS];

  @override
  late final Widget _payButton = _applePayButton;
}
