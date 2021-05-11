/// Copyright 2021 Google LLC
/// SPDX-License-Identifier: Apache-2.0

import 'core/payment_configuration.dart';
import 'core/payment_item.dart';

abstract class PayPlatform {
  /// Determines whether the caller can make a payment with a given
  /// configuration.
  ///
  /// Returns a [Future] that resolves to a boolean value with the result.
  Future<bool> userCanPay(PaymentConfiguration paymentConfiguration);

  /// Triggers the action to show the payment selector to complete a payment
  /// with the configuration and a list of [PaymentItem] to determine the price
  /// elements to show in the payment selector.
  ///
  /// Returns a [Future] with the result of the selection.
  Future<Map<String, dynamic>> showPaymentSelector(
      PaymentConfiguration paymentConfiguration,
      List<PaymentItem> paymentItems);
}
