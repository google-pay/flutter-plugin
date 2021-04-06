package io.flutter.plugins.pay_android

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry.Registrar

class PayPlugin : FlutterPlugin, ActivityAware {

    private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    private lateinit var methodCallHandler: PayMethodCallHandler

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            PayMethodCallHandler(registrar)
        }
    }

    override fun onAttachedToEngine(
            @NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding,
    ) {
        this.flutterPluginBinding = flutterPluginBinding
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) = Unit

    override fun onAttachedToActivity(@NonNull activityPluginBinding: ActivityPluginBinding) {
        methodCallHandler = PayMethodCallHandler(flutterPluginBinding, activityPluginBinding)
    }

    override fun onDetachedFromActivity() = methodCallHandler.stopListening()

    override fun onReattachedToActivityForConfigChanges(
            @NonNull activityPluginBinding: ActivityPluginBinding,
    ) = onAttachedToActivity(activityPluginBinding)

    override fun onDetachedFromActivityForConfigChanges() = onDetachedFromActivity()
}
