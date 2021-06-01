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

package io.flutter.plugins.pay_android.util

import com.google.android.gms.common.api.ApiException
import com.google.android.gms.wallet.WalletConstants
import java.util.Locale

/**
 * A set of utilities with  static methods for dealing with the Payments API.
 */
object PaymentsUtil {

    /**
     * Extracts the status code of the exception if included.
     *
     * An [ApiException] is returned by the Google Pay library when there is an error in the process
     * of initiating a payment process. This type has a status code that concretely defines the issue.
     * @param exception the exception to extract the status code from.
     * @return the integer that specifies the concrete issue.
     */
    fun statusCodeForException(exception: Exception): Int = when (exception) {
        is ApiException -> exception.statusCode
        else -> -1
    }

    /**
     * Creates an environment constant from a string that the Google Pay library understands.
     *
     * Google Pay can be used in `TEST` or `PRODUCTION` modes. In `TEST` mode, the payment result
     * returns a dummy token to help validate the flow before going to production. When `PRODUCTION`
     * is used, a real encrypted payload is offered instead.
     *
     * @param environmentString the environment in [String] format.
     * @return a constant from [WalletConstants] with the environment.
     * @throws IllegalArgumentException if the value provided is unrecognized.
     */
    fun environmentForString(environmentString: String?): Int =
            when (environmentString?.toLowerCase(Locale.ROOT)) {
                "test" -> WalletConstants.ENVIRONMENT_TEST
                "production" -> WalletConstants.ENVIRONMENT_PRODUCTION
                else -> throw IllegalArgumentException(
                        "Environment must be one of TEST or PRODUCTION")
            }

    fun createSoftwareInfo(context: Context): Map<String, String> {
        val packageInfo = context.packageManager.getPackageInfo(context.packageName, 0)
        return mapOf(
                "id" to "pay-flutter-plug-in",
                "version" to packageInfo.versionName
        )
    }
}

/**
 * Extension to convert cents to a string format.
 */
fun Long.centsToString() = BigDecimal(this)
        .divide(CENTS)
        .setScale(2, RoundingMode.HALF_EVEN)
        .toString()
