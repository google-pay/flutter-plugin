/**
 * Copyright 2024 Google LLC
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

package io.flutter.plugins.pay_android.view

import android.content.Context
import com.google.android.gms.wallet.button.ButtonOptions
import com.google.android.gms.wallet.button.ButtonConstants.ButtonTheme
import com.google.android.gms.wallet.button.ButtonConstants.ButtonType
import com.google.android.gms.wallet.button.PayButton
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.platform.PlatformView
import org.json.JSONArray
import org.json.JSONObject

private const val VIEW_TYPE = "plugins.flutter.io/pay/google_pay_button"

private const val METHOD_ON_PRESSED = "onPressed"

internal class PayButtonView(private val context: Context, binaryMessenger: BinaryMessenger, viewId: Int, creationParams: Map<String, Any>) : PlatformView {

    private val payButton: PayButton
    private val methodChannel: MethodChannel

    init {
        // Instantiate method channel
        methodChannel = MethodChannel(binaryMessenger, "$VIEW_TYPE/$viewId");

        // Build pay button
        payButton = PayButton(context)
        buildPayButton(creationParams)
    }

    private fun buildPayButton(buttonParams: Map<String, Any>) {
        val buttonTheme = ButtonThemeFactory.fromString(buttonParams["style"] as String)
        val buttonType = ButtonTypeFactory.fromString(buttonParams["type"] as String)
        val cornerRadiusDp = buttonParams["cornerRadius"] as Int
        val cornerRadius = (cornerRadiusDp * context.resources.displayMetrics.density).toInt()

        val allowedPaymentMethods: JSONArray = JSONArray().put(cardPaymentMethod())
        payButton.initialize(ButtonOptions.newBuilder()
            .setButtonTheme(buttonTheme)
            .setButtonType(buttonType)
            .setCornerRadius(cornerRadius)
            .setAllowedPaymentMethods(allowedPaymentMethods.toString())
            .build())

        payButton.setOnClickListener {
            methodChannel.invokeMethod(METHOD_ON_PRESSED, null)
        }
    }

    override fun getView() = payButton

    override fun dispose() = Unit

    private fun baseCardPaymentMethod(): JSONObject {

        val allowedCardNetworks = JSONArray(listOf(
            "AMEX",
            "DISCOVER",
            "JCB",
            "MASTERCARD",
            "VISA"))

        val allowedCardAuthMethods = JSONArray(listOf(
            "PAN_ONLY",
            "CRYPTOGRAM_3DS"))

        return JSONObject().apply {

            val parameters = JSONObject().apply {
                put("allowedAuthMethods", allowedCardAuthMethods)
                put("allowedCardNetworks", allowedCardNetworks)
                put("billingAddressRequired", true)
                put("billingAddressParameters", JSONObject().apply {
                    put("format", "FULL")
                })
            }

            put("type", "CARD")
            put("parameters", parameters)
        }
    }

    private fun gatewayTokenizationSpecification(): JSONObject {
        return JSONObject().apply {
            put("type", "PAYMENT_GATEWAY")
            put("parameters", JSONObject(mapOf(
                "gateway" to "example",
                "gatewayMerchantId" to "exampleGatewayMerchantId"
            )))
        }
    }

    private fun cardPaymentMethod(): JSONObject {
        val cardPaymentMethod = baseCardPaymentMethod()
        cardPaymentMethod.put("tokenizationSpecification", gatewayTokenizationSpecification())

        return cardPaymentMethod
    }
}

class ButtonThemeFactory {
    companion object {
        fun fromString(buttonThemeString: String) = when(buttonThemeString) {
            "dark" -> ButtonTheme.DARK
            "light" -> ButtonTheme.LIGHT
            else -> ButtonTheme.DARK
        }
    }
}

class ButtonTypeFactory {
    companion object {
        fun fromString(buttonTypeString: String) = when(buttonTypeString) {
            "pay" -> ButtonType.PAY
            "buy" -> ButtonType.BUY
            "book" -> ButtonType.BOOK
            "donate" -> ButtonType.DONATE
            "checkout" -> ButtonType.CHECKOUT
            "order" -> ButtonType.ORDER
            "plain" -> ButtonType.PLAIN
            "subscribe" -> ButtonType.SUBSCRIBE
            else -> ButtonType.BUY
        }
    }
}