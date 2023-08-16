/// Copyright 2023 Google LLC
/// SPDX-License-Identifier: Apache-2.0

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
