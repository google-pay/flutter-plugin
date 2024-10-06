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

package io.flutter.plugins.pay_android

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

private const val METHOD_CHANNEL_NAME = "plugins.flutter.io/pay"
private const val PAYMENT_EVENT_CHANNEL_NAME = "plugins.flutter.io/pay/payment_result"

private const val METHOD_USER_CAN_PAY = "userCanPay"
private const val METHOD_SHOW_PAYMENT_SELECTOR = "showPaymentSelector"

/**
 * A simple class that configures and register a method handler for the `pay` plugin.
 */
class PayMethodCallHandler private constructor(
    messenger: BinaryMessenger,
    activity: Activity,
    private val activityBinding: ActivityPluginBinding?,
) : MethodCallHandler, StreamHandler {

    private val methodChannel: MethodChannel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
    private var eventChannelIsActive = false
    private val paymentResultEventChannel: EventChannel =
        EventChannel(messenger, PAYMENT_EVENT_CHANNEL_NAME)

    private val googlePayHandler: GooglePayHandler = GooglePayHandler(activity)

    init {
        methodChannel.setMethodCallHandler(this)
        paymentResultEventChannel.setStreamHandler(this)
    }

    constructor(
        flutterBinding: FlutterPlugin.FlutterPluginBinding,
        activityBinding: ActivityPluginBinding,
    ) : this(flutterBinding.binaryMessenger, activityBinding.activity, activityBinding) {
        activityBinding.addActivityResultListener(googlePayHandler)
    }

    /**
     * Clears the handler in the method channel when not needed anymore.
     */
    fun stopListening() {
        methodChannel.setMethodCallHandler(null)
        paymentResultEventChannel.setStreamHandler(null)
        activityBinding?.removeActivityResultListener(googlePayHandler)
    }

    // MethodCallHandler interface
    @Suppress("UNCHECKED_CAST")
    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            METHOD_USER_CAN_PAY -> googlePayHandler.isReadyToPay(result, call.arguments()!!)
            METHOD_SHOW_PAYMENT_SELECTOR -> {
                if (eventChannelIsActive) {
                    val arguments = call.arguments<Map<String, Any>>()!!
                    googlePayHandler.loadPaymentData(
                        arguments.getValue("payment_profile") as String,
                        arguments.getValue("payment_items") as List<Map<String, Any?>>
                    )
                    result.success("{}")
                } else {
                    result.error(
                        "illegalEventChannelState",
                        "Your event channel stream needs to be initialized and listening before calling the `showPaymentSelector` method. See the integration tutorial to learn more (https://pub.dev/packages/pay#advanced-usage)",
                        null
                    )
                }
            }

            else -> result.notImplemented()
        }
    }

    // StreamHandler interface
    override fun onListen(arguments: Any?, events: EventSink?) {
        googlePayHandler.setPaymentResultEventSink(events)
        eventChannelIsActive = true
    }

    override fun onCancel(arguments: Any?) {
        googlePayHandler.setPaymentResultEventSink(null)
        eventChannelIsActive = false
    }
}
