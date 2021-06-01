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

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry.Registrar

/**
 * Entry point handler for the plugin.
 */
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
