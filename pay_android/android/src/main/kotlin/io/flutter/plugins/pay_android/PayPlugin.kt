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

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugins.pay_android.view.PayButtonViewFactory

/**
 * Entry point handler for the plugin.
 */
class PayPlugin : FlutterPlugin, ActivityAware {

    private val googlePayButtonViewType = "plugins.flutter.io/pay/google_pay_button"

    private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    private lateinit var methodCallHandler: PayMethodCallHandler

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            googlePayButtonViewType, PayButtonViewFactory(flutterPluginBinding.binaryMessenger)
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) = Unit

    override fun onAttachedToActivity(activityPluginBinding: ActivityPluginBinding) {
        methodCallHandler = PayMethodCallHandler(flutterPluginBinding, activityPluginBinding)
    }

    override fun onDetachedFromActivity() = methodCallHandler.stopListening()

    override fun onReattachedToActivityForConfigChanges(
        activityPluginBinding: ActivityPluginBinding,
    ) = onAttachedToActivity(activityPluginBinding)

    override fun onDetachedFromActivityForConfigChanges() = onDetachedFromActivity()
}
