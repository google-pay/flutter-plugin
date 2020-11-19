abstract class GooglePayPlatform {
  /**
   * TBA
   */
  Future<bool> userCanPay(Map<String, dynamic> paymentProfile);

  /**
   * TBA
   */
  Future<Map<String, dynamic>> showPaymentSelector(
      Map<String, dynamic> paymentProfile, String price);
}
