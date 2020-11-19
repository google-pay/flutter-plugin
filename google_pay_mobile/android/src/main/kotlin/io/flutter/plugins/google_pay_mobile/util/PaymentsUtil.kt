/*
 * Copyright 2020 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package io.flutter.plugins.google_pay_mobile.util

import com.google.android.gms.common.api.ApiException
import com.google.android.gms.wallet.WalletConstants
import java.math.BigDecimal
import java.math.RoundingMode
import java.util.*

val CENTS = BigDecimal(100)

/**
 * Contains helper static methods for dealing with the Payments API.
 *
 * Many of the parameters used in the code are optional and are set here merely to call out their
 * existence. Please consult the documentation to learn more and feel free to remove ones not
 * relevant to your implementation.
 */
object PaymentsUtil {

    fun statusCodeForException(exception: Exception): Int = when (exception) {
        is ApiException -> exception.statusCode
        else -> -1
    }

    fun environmentForString(environmentString: String?): Int =
            when (environmentString?.toLowerCase(Locale.ROOT)) {
                "test" -> WalletConstants.ENVIRONMENT_TEST
                "production" -> WalletConstants.ENVIRONMENT_PRODUCTION
                else -> throw IllegalArgumentException(
                        "Environment must be one of TEST or PRODUCTION")
            }
}

/**
 * Converts cents to a string format accepted by [PaymentsUtil.getPaymentDataRequest].
 *
 * @param cents value of the price.
 */
fun Long.centsToString() = BigDecimal(this)
        .divide(CENTS)
        .setScale(2, RoundingMode.HALF_EVEN)
        .toString()
