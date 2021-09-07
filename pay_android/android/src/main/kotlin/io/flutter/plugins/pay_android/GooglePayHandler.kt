/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package io.flutter.plugins.pay_android

import android.app.Activity
import android.content.Intent
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.wallet.*
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.pay_android.util.PaymentsUtil
import org.json.JSONObject

private const val LOAD_PAYMENT_DATA_REQUEST_CODE = 991

/**
 * A simple helper to orchestrate fundamental calls to complete a payment operation.
 *
 * Use this class to manage payment sessions, with the ability to determine whether a user
 * can make a payment with the selected provider, and to start the payment process.
 * Example usage:
 * ```
 * val googlePayHandler: GooglePayHandler = GooglePayHandler(activity)
 * googlePayHandler.isReadyToPay(result, arguments)
 * ```
 * @property activity the activity used by the plugin binding.
 */
class GooglePayHandler(private val activity: Activity) :
        PluginRegistry.ActivityResultListener {

    private var loadPaymentDataResult: Result? = null

    companion object {

        /**
         * Creates a valid payment request for Google Pay with the information included in the
         * payment configuration.
         *
         * @param paymentProfileString a JSON string with the configuration to execute this
         * payment.
         * @param paymentItems a list of payment elements that determine the total amount purchased.
         * @return a [JSONObject] with the payment configuration included.
         */
        @JvmStatic
        fun buildPaymentProfile(
                paymentProfileString: String,
                paymentItems: List<Map<String, Any?>>? = null
        ): JSONObject {
            val paymentProfile = JSONObject(paymentProfileString)

            // Add payment information
            paymentItems?.find { it["type"] == "total" }.let {
                val priceStatus = when (it?.get("status")) {
                    "final_price" -> "FINAL"
                    "pending" -> "ESTIMATED"
                    else -> "NOT_CURRENTLY_KNOWN"
                }

                paymentProfile.getJSONObject("transactionInfo").apply {
                    putOpt("totalPrice", it?.get("amount"))
                    put("totalPriceStatus", priceStatus)
                }
            }

            return paymentProfile
        }
    }

    /**
     * Create a [PaymentsClient] with the configuration specified.
     *
     * This client is used by the Google Pay library to make calls against the API.
     *
     * @param paymentProfile the payment configuration object.
     * @return a [PaymentsClient] object with the configuration above.
     *
     * @see <a href="https://developers.google.com/pay/api/android/reference/client">Client
     * reference</a>.
     * more.
     */
    private fun paymentClientForProfile(paymentProfile: JSONObject): PaymentsClient {
        val environmentConstant = PaymentsUtil
                .environmentForString(paymentProfile["environment"] as String?)

        return Wallet.getPaymentsClient(
                activity,
                Wallet.WalletOptions.Builder()
                        .setEnvironment(environmentConstant)
                        .build())
    }

    /**
     * Checks whether the user transacting can use Google Pay to start a payment process.
     *
     * This call checks whether Google Pay is supported for the pair of user and device starting a
     * payment operation. This call does not check whether the user has cards that conform to the
     * list of supported networks unless `existingPaymentMethodRequired` is included in the
     * configuration. See the docs for the [`isReadyToPay][https://developers.google.com/android/reference/com/google/android/gms/wallet/PaymentsClient#isReadyToPay(com.google.android.gms.wallet.IsReadyToPayRequest)]
     * call to learn more.`
     *
     * @param result callback to communicate back with the Dart end in Flutter.
     * @param paymentProfileString the payment configuration object in [String] format.
     */
    fun isReadyToPay(result: Result, paymentProfileString: String) {

        // Construct profile and client
        val paymentProfile = buildPaymentProfile(paymentProfileString)
        val client = paymentClientForProfile(paymentProfile)

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

    /**
     * Initiates the payment process with the selected payment provider.
     *
     * Calling this method starts the payment process and opens up the payment selector. Once the
     * user makes a selection, the payment method information is returned. Check out the docs for
     * the [`loadPaymentData`][https://developers.google.com/android/reference/com/google/android/gms/wallet/PaymentsClient#isReadyToPay(com.google.android.gms.wallet.IsReadyToPayRequest)]
     * call to learn more.
     *
     * @param result te reference to the result to send the response back to Flutter.
     * @param paymentProfileString a JSON string with the configuration to execute this payment.
     * @param paymentItems a list of payment elements that determine the total amount purchased.
     */
    fun loadPaymentData(
            result: Result,
            paymentProfileString: String,
            paymentItems: List<Map<String, Any?>>
    ) {

        // Update the member to call the result when the operation completes
        loadPaymentDataResult = result

        val paymentProfile = buildPaymentProfile(paymentProfileString, paymentItems)
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
    ): Boolean = when (requestCode) {
        LOAD_PAYMENT_DATA_REQUEST_CODE -> {
            when (resultCode) {

                // The request ran successfully. Process the result.
                Activity.RESULT_OK -> {
                    data?.let { intent ->
                        PaymentData.getFromIntent(intent).let(::handlePaymentSuccess)
                    }
                    true
                }

                Activity.RESULT_CANCELED -> {
                    loadPaymentDataResult!!.error(
                            "paymentCanceled",
                            "User canceled payment authorization",
                            null)
                    true
                }

                AutoResolveHelper.RESULT_ERROR -> {
                    AutoResolveHelper.getStatusFromIntent(data)?.let { status ->
                        handleError(status.statusCode)
                    }
                    true
                }

                else -> false
            }
        }
        else -> false
    }

    /**
     * Takes the result after showing the payment selector and uses it to create a response.
     *
     * @param paymentData a response object returned by Google Pay after a payer approves payment.
     *
     * @see [Payment
     * Data](https://developers.google.com/pay/api/android/reference/object.PaymentData)
     */
    private fun handlePaymentSuccess(paymentData: PaymentData?) {
        if (paymentData != null) {
            loadPaymentDataResult!!.success(paymentData.toJson())
        } else {
            loadPaymentDataResult!!.error(
                    CommonStatusCodes.INTERNAL_ERROR.toString(),
                    "Unexpected empty result data.",
                    null)
        }
    }

    /**
     * Calls the result callback, with the resulting error.
     *
     * At this stage, the user has already seen a popup informing them an error occurred.
     * Normally, only logging is required.
     *
     * @param statusCode the value of any constant from [CommonStatusCodes] or one of the
     * []WalletConstants].ERROR_CODE_* constants.
     *
     * @see [
     * Wallet constants library](https://developers.google.com/android/reference/com/google/android/gms/wallet/WalletConstants.constant-summary)
     */
    private fun handleError(statusCode: Int) =
            loadPaymentDataResult!!.error(statusCode.toString(), "", null)
}
