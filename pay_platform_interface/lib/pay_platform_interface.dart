import 'package:pay_platform_interface/core/payment_item.dart';

abstract class PayPlatform {
  /// Determines whether the caller can make a payment with a given
  /// configuration.
  ///
  /// Returns a [Future] that resolves to a boolean value with the result.
  Future<bool> userCanPay(Map<String, dynamic> paymentProfile);

  /// Triggers the action to show the payment selector to complete a payment
  /// with the configuration and a list of [PaymentItem] to determine the price
  /// elements to show in the payment selector.
  ///
  /// Returns a [Future] with the result of the selection.
  Future<Map<String, dynamic>> showPaymentSelector(
      Map<String, dynamic> paymentProfile, List<PaymentItem> paymentItems);
}
