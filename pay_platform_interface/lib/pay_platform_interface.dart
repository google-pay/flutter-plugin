import 'package:pay_platform_interface/core/payment_item.dart';

abstract class PayPlatform {
  /**
   * TBA
   */
  Future<bool> userCanPay(Map<String, dynamic> paymentProfile);

  /**
   * TBA
   */
  Future<Map<String, dynamic>> showPaymentSelector(
      Map<String, dynamic> paymentProfile, List<PaymentItem> paymentItems);
}
