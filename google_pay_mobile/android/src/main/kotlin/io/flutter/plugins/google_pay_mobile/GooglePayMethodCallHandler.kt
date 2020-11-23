package io.flutter.plugins.google_pay_mobile

import android.app.Activity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class GooglePayMethodCallHandler private constructor(
        messenger: BinaryMessenger,
        activity: Activity,
) : MethodCallHandler {

    private val METHOD_CHANNEL_NAME = "plugins.flutter.io/google_pay_channel"

    private val METHOD_USER_CAN_PAY = "userCanPay"
    private val METHOD_SHOW_PAYMENT_SELECTOR = "showPaymentSelector"

    private val channel: MethodChannel
    private val googlePayHandler: GooglePayHandler = GooglePayHandler(activity)

    init {
        channel = MethodChannel(messenger, METHOD_CHANNEL_NAME)
        channel.setMethodCallHandler(this)
    }

    constructor(registrar: Registrar) : this(registrar.messenger(), registrar.activity()) {
        registrar.addActivityResultListener(googlePayHandler)
    }

    constructor(
            flutterBinding: FlutterPlugin.FlutterPluginBinding,
            activityBinding: ActivityPluginBinding,
    ) : this(flutterBinding.binaryMessenger, activityBinding.activity) {
        activityBinding.addActivityResultListener(googlePayHandler)
    }

    fun stopListening() = channel.setMethodCallHandler(null)

    @Suppress("UNCHECKED_CAST")
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

        when (call.method) {
            METHOD_USER_CAN_PAY -> googlePayHandler.isReadyToPay(result, call.arguments())
            METHOD_SHOW_PAYMENT_SELECTOR -> {
                val arguments = call.arguments<Map<String, String>>()
                googlePayHandler.loadPaymentData(result,
                        arguments.getValue("payment_profile"),
                        arguments.getValue("price"))
            }

            else -> result.notImplemented()
        }
    }
}
