package io.flutter.plugins.pay_mobile

import android.app.Activity
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import androidx.test.ext.junit.runners.AndroidJUnit4
import com.google.android.gms.tasks.Task
import com.google.android.gms.wallet.*
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
    private val itemPrice = "0"
    private val versionName = "0.0.0"

    private lateinit var googlePayHandler: GooglePayHandler
    private lateinit var loadPaymentDataCall: () -> Boolean

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
        loadPaymentDataCall = {
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
                .buildPaymentProfile(mockedActivity, basicPaymentProfile, itemPrice)

        val transactionInfo = paymentProfile.getJSONObject("transactionInfo")
        assertThat(transactionInfo.optString("totalPriceStatus")).isEqualTo("FINAL")
        assertThat(transactionInfo.optString("totalPrice")).isEqualTo(itemPrice)
    }

    @Test
    fun onlyOnePaymentAttemptAtATime() {
        assertThat(loadPaymentDataCall()).isTrue()
    }

    @Test
    fun theSecondPaymentAttemptFails() {
        assertThat(loadPaymentDataCall()).isTrue()
        assertThat(loadPaymentDataCall()).isFalse()
    }

    @After
    fun cleanUp() {
        mockedResolveHelper.close()
        mockedWallet.close()
    }
}