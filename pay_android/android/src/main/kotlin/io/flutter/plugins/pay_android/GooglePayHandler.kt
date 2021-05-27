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

class GooglePayHandler(private val activity: Activity) :
        PluginRegistry.ActivityResultListener {

    private var loadPaymentDataResult: Result? = null

    companion object {
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

                paymentProfile.optJSONObject("transactionInfo").apply {
                    putOpt("totalPrice", it?.get("amount"))
                    put("totalPriceStatus", priceStatus)
                }
            }

            return paymentProfile
        }
    }

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

    fun loadPaymentData(result: Result, paymentProfileString: String, paymentItems: List<Map<String, Any?>>): Boolean {

        loadPaymentDataResult = result

        val paymentProfile = buildPaymentProfile(paymentProfileString, paymentItems)
        val client = paymentClientForProfile(paymentProfile)
        val ldpRequest = PaymentDataRequest.fromJson(paymentProfile.toString())
        AutoResolveHelper.resolveTask(
                client.loadPaymentData(ldpRequest),
                activity,
                LOAD_PAYMENT_DATA_REQUEST_CODE)

        return true
    }

    override fun onActivityResult(
            requestCode: Int,
            resultCode: Int,
            data: Intent?,
    ): Boolean = when (requestCode) {
            LOAD_PAYMENT_DATA_REQUEST_CODE -> {
                when (resultCode) {
                    Activity.RESULT_OK -> {
                        data?.let { intent ->
                            PaymentData.getFromIntent(intent).let(::handlePaymentSuccess)
                        }
                        true
                    }

                    Activity.RESULT_CANCELED -> {
                        // The user cancelled the payment attempt
                        true
                    }

                    AutoResolveHelper.RESULT_ERROR -> {
                        AutoResolveHelper.getStatusFromIntent(data)?.let { status ->
                            handleError(status.statusCode)
                        }
                        true
                    }

                    else -> {
                        false
                    }
                }
            }
        else -> false
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
            loadPaymentDataResult!!.error(
                    CommonStatusCodes.INTERNAL_ERROR.toString(),
                    "Unexpected empty result data.",
                    null)
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
