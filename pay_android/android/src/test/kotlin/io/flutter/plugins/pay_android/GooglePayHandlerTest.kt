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
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.google.android.gms.tasks.Task
import com.google.android.gms.wallet.AutoResolvableResult
import com.google.android.gms.wallet.AutoResolveHelper
import com.google.android.gms.wallet.PaymentsClient
import com.google.android.gms.wallet.Wallet
import com.google.common.truth.Truth.assertThat
import io.flutter.plugin.common.MethodChannel
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith
import org.mockito.MockedStatic
import org.mockito.Mockito.*


@RunWith(AndroidJUnit4::class)
class GooglePayHandlerTest {

    abstract class AutoResolvableTask : Task<AutoResolvableResult>()

    private val basicPaymentProfile = "{environment: 'TEST', transactionInfo: {}}"
    private val finalPaymentProfile =
            "{environment: 'TEST', transactionInfo: {totalPriceStatus: 'FINAL'}}"

    private val itemPrice = "0"
    private val versionName = "0.0.0"

    private lateinit var googlePayHandler: GooglePayHandler
    private lateinit var basicLoadPaymentDataCall: () -> Boolean

    private lateinit var mockedActivity: Activity
    private lateinit var mockedPackageManager: PackageManager
    private lateinit var mockedPackageInfo: PackageInfo
    private lateinit var mockedMethodChannel: MethodChannel.Result
    private lateinit var mockedResolveHelper: MockedStatic<AutoResolveHelper>
    private lateinit var mockedWallet: MockedStatic<Wallet>

    @Before
    fun setUp() {
        initializeMocks()

        googlePayHandler = GooglePayHandler(mockedActivity)
        basicLoadPaymentDataCall = {
            googlePayHandler.loadPaymentData(mockedMethodChannel, basicPaymentProfile, itemPrice)
        }
    }

    private fun initializeMocks() {
        mockedPackageInfo = PackageInfo()
        mockedPackageInfo.versionName = versionName

        mockedActivity = mock(Activity::class.java)
        mockedPackageManager = mock(PackageManager::class.java)
        `when`(mockedActivity.packageManager).thenReturn(mockedPackageManager)
        `when`(mockedPackageManager.getPackageInfo(mockedActivity.packageName, 0))
                .thenReturn(mockedPackageInfo)

        mockedMethodChannel = mock(MethodChannel.Result::class.java)

        mockedResolveHelper = mockStatic(AutoResolveHelper::class.java)
        mockedResolveHelper.`when`<Any> {
            AutoResolveHelper.resolveTask(
                    any(AutoResolvableTask::class.java),
                    any(Activity::class.java), anyInt())
        }.then { }

        mockedWallet = mockStatic(Wallet::class.java)
        mockedWallet.`when`<Any> {
            Wallet.getPaymentsClient(
                    any(Activity::class.java),
                    any(Wallet.WalletOptions::class.java))
        }.thenReturn(mock(PaymentsClient::class.java))
    }

    @Test
    fun addsSoftwareInfoToLoadPaymentData() {
        val paymentProfile = GooglePayHandler
                .buildPaymentProfile(mockedActivity, basicPaymentProfile)
        assertThat(paymentProfile.has("merchantInfo")).isTrue()

        val merchantInfo = paymentProfile.getJSONObject("merchantInfo")
        assertThat(merchantInfo.has("softwareInfo")).isTrue()

        val softwareInfo = merchantInfo.getJSONObject("softwareInfo")
        assertThat(softwareInfo.optString("id")).isNotNull()
        assertThat(softwareInfo.optString("version")).isEqualTo(versionName)
    }

    @Test
    fun loadPaymentDataRequestContainsTheRightPrice() {
        val paymentProfile = GooglePayHandler
                .buildPaymentProfile(mockedActivity, finalPaymentProfile, itemPrice)

        val transactionInfo = paymentProfile.getJSONObject("transactionInfo")
        assertThat(transactionInfo.optString("totalPriceStatus")).isEqualTo("FINAL")
        assertThat(transactionInfo.optString("totalPrice")).isEqualTo(itemPrice)
    }

    @Test
    fun onlyOnePaymentAttemptAtATime() {
        assertThat(basicLoadPaymentDataCall()).isTrue()
    }

    @Test
    fun theSecondPaymentAttemptFails() {
        assertThat(basicLoadPaymentDataCall()).isTrue()
        assertThat(basicLoadPaymentDataCall()).isFalse()
    }

    @After
    fun cleanUp() {
        mockedResolveHelper.close()
        mockedWallet.close()
    }
}