/// Copyright 2023 Google LLC
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

part of '../../pay_android.dart';

/// The types of button supported on Google Pay.
enum GooglePayButtonType {
  add,
  book,
  buy,
  checkout,
  donate,
  order,
  pay,
  plain,
  subscribe
}

/// A button widget that follows the Google Pay button styles and design
/// guidelines.
///
/// This widget is a representation of the Google Pay button in Flutter. The
/// button is drawn on the Flutter end using official assets, featuring all
/// the labels, and styles available, and can be used independently as a
/// standalone component.
///
/// To use this button independently, simply add it to your layout:
/// ```dart
/// RawGooglePayButton(
///   type: GooglePayButtonType.pay,
///   onPressed: () => print('Button pressed'));
/// ```
class RawGooglePayButton extends StatelessWidget {
  /// The default width for the Google Pay Button.
  static const double minimumButtonWidth =
      _GooglePayButtonTypeAsset.defaultAssetWidth;

  /// The default height for the Google Pay Button.
  static const double defaultButtonHeight = 48;


  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// The type of button depending on the activity initiated with the payment
  /// transaction.
  final GooglePayButtonType type;

  /// Creates a Google Pay button widget with the parameters specified.
  const RawGooglePayButton({
    Key? key,
    this.onPressed,
    this.type = GooglePayButtonType.pay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  }


}
