package io.flutter.plugins.google_pay_mobile

import android.app.Activity
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
import org.mockito.Mockito.mock
import org.mockito.Mockito.mockStatic
import org.mockito.Mockito.any
import org.mockito.Mockito.anyInt

@RunWith(AndroidJUnit4::class)
class GooglePayHandlerTest {

    abstract class AutoResolvableTask : Task<AutoResolvableResult>()
    private val basicPaymentProfile = "{environment: 'TEST', transactionInfo: {}}"
    private val invalidPrice = "-1"

    private lateinit var googlePayHandler: GooglePayHandler
    private lateinit var mockMethodChannel: MethodChannel.Result
    private lateinit var loadPaymentDataCall: () -> Boolean

    private lateinit var mockedResolveHelper: MockedStatic<AutoResolveHelper>
    private lateinit var mockedWallet: MockedStatic<Wallet>

    @Before
    fun setUp() {
        googlePayHandler = GooglePayHandler(mock(Activity::class.java))
        loadPaymentDataCall = {
            googlePayHandler.loadPaymentData(mockMethodChannel, basicPaymentProfile, invalidPrice)
        }

        initializeMocks()
    }

    private fun initializeMocks() {
        mockMethodChannel = mock(MethodChannel.Result::class.java)

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