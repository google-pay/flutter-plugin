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

import 'core/payment_configuration.dart';
import 'core/payment_item.dart';

/// A contract that defines the required actions for payment libraries that
/// implement it.
abstract class PayPlatform {
  /// Determines whether the caller can make a payment with a given
  /// configuration.
  ///
  /// Returns a [Future] that resolves to a boolean value with the result based
  /// on a given [paymentConfiguration].
  Future<bool> userCanPay(PaymentConfiguration paymentConfiguration);

  /// Triggers the action to show the payment selector to complete a payment
  /// with the configuration and a list of [PaymentItem] that help determine
  /// the price elements to show in the payment selector.
  ///
  /// Returns a [Future] with the result of the selection for the
  /// [paymentConfiguration] and [paymentItems] specified.
  Future<Map<String, dynamic>> showPaymentSelector(
      PaymentConfiguration paymentConfiguration,
      List<PaymentItem> paymentItems);
}
