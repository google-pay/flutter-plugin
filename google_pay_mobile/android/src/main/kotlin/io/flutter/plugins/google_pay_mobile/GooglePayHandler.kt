package io.flutter.plugins.google_pay_mobile

import android.app.Activity
import android.content.Intent
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.wallet.*
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.google_pay_mobile.util.PaymentsUtil
import org.json.JSONObject

class GooglePayHandler(val activity: Activity) :
        PluginRegistry.ActivityResultListener {

    // Arbitrary constant to track a request in the activity result
    private val LOAD_PAYMENT_DATA_REQUEST_CODE = 991
    private var loadPaymentDataResult: Result? = null

    private fun paymentClientForProfile(paymentProfile: JSONObject): PaymentsClient {
        val environmentConstant = PaymentsUtil
                .environmentForString(paymentProfile["environment"] as String?)
        return Wallet.getPaymentsClient(
                activity,
                Wallet.WalletOptions.Builder()
                        .setEnvironment(environmentConstant)
                        .build())
    }

    fun isReadyToPay(result: Result, paymentProfileString: String) {

        val client = paymentClientForProfile(JSONObject(paymentProfileString))

        val rtpRequest = IsReadyToPayRequest.fromJson(paymentProfileString)
        val task = client.isReadyToPay(rtpRequest)
        task.addOnCompleteListener { completedTask ->
            try {
                result.success(completedTask.getResult(ApiException::class.java))
            } catch (exception: Exception) {
                result.error(
                        PaymentsUtil.statusCodeForException(exception).toString(),
                        exception.message,
                        null)
            }
        }
    }

    fun loadPaymentData(result: Result, paymentProfileString: String, price: String) {

        // Only proceed if there is no other request is active
        if (loadPaymentDataResult != null) return
        loadPaymentDataResult = result

        // Add payment information
        val paymentProfile = JSONObject(paymentProfileString)
        paymentProfile.getJSONObject("transactionInfo").apply {
            put("totalPrice", price)
            put("totalPriceStatus", "FINAL")
        }

        val client = paymentClientForProfile(paymentProfile)
        val ldpRequest = PaymentDataRequest.fromJson(paymentProfile.toString())
        AutoResolveHelper.resolveTask(
                client.loadPaymentData(ldpRequest),
                activity,
                LOAD_PAYMENT_DATA_REQUEST_CODE)
    }

    override fun onActivityResult(
            requestCode: Int,
            resultCode: Int,
            data: Intent?,
    ): Boolean {
        when (requestCode) {
            LOAD_PAYMENT_DATA_REQUEST_CODE -> {
                when (resultCode) {
                    Activity.RESULT_OK -> {
                        data?.let { intent ->
                            PaymentData.getFromIntent(intent).let(::handlePaymentSuccess)
                        }
                        loadPaymentDataResult = null
                        return true
                    }

                    Activity.RESULT_CANCELED -> {
                        // The user cancelled the payment attempt
                        loadPaymentDataResult = null
                        return true
                    }

                    AutoResolveHelper.RESULT_ERROR -> {
                        AutoResolveHelper.getStatusFromIntent(data)?.let { status ->
                            handleError(status.statusCode)
                        }
                        loadPaymentDataResult = null
                        return true
                    }

                    else -> {
                        loadPaymentDataResult = null
                        return false
                    }
                }
            }
            else -> false
        }

        return false
    }

    /**
     * PaymentData response object contains the payment information, as well as any additional
     * requested information, such as billing and shipping address.
     *
     * @param paymentData A response object returned by Google after a payer approves payment.
     * @see [Payment
     * Data](https://developers.google.com/pay/api/android/reference/object.PaymentData)
     */
    private fun handlePaymentSuccess(paymentData: PaymentData?) {
        if (paymentData != null) {
            loadPaymentDataResult!!.success(paymentData.toJson())
        } else {
            loadPaymentDataResult!!.error("", "", null)
        }
    }

    /**
     * At this stage, the user has already seen a popup informing them an error
     * occurred. Normally, only logging is required.
     *
     * @param statusCode will hold the value of any constant from
     * CommonStatusCode or one of the WalletConstants.ERROR_CODE_* constants.
     * @see [
     * Wallet Constants Library](https://developers.google.com/android/reference/com/google/android/gms/wallet/WalletConstants.constant-summary)
     */
    private fun handleError(statusCode: Int) =
            loadPaymentDataResult!!.error(statusCode.toString(), "", null)
}
