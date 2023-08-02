/// Copyright 2023 Google LLC
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///     https://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pay/pay.dart';

import 'payment_configurations.dart' as payment_configurations;

void main() {
  runApp(PayMaterialApp());
}

const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: PaymentItemStatus.final_price,
  )
];

class PayMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pay for Flutter Demo',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('es', ''),
        const Locale('de', ''),
      ],
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: PaySampleApp(),
    );
  }
}

class PaySampleApp extends StatefulWidget {
  PaySampleApp({Key? key}) : super(key: key);

  @override
  _PaySampleAppState createState() => _PaySampleAppState();
}

class _PaySampleAppState extends State<PaySampleApp> {
  final _applePayConfig = PaymentConfiguration.fromJsonString(
    payment_configurations.defaultApplePay,
  );
  late final Future<PaymentConfiguration> _googlePayConfigFuture;
  late Pay _pay;

  bool shouldPaymentSucceedOnIos = true;

  @override
  void initState() {
    super.initState();
    _googlePayConfigFuture = PaymentConfiguration.fromAsset(
      'default_google_pay_config.json',
    );
    _pay = Pay({
      PayProvider.apple_pay: _applePayConfig,
    });
  }

  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }

  void onApplePayResult(paymentResult) async {
    debugPrint(paymentResult.toString());
    await _pay.updatePaymentStatus(shouldPaymentSucceedOnIos);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('T-shirt Shop'),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20),
            child: const Image(
              image: AssetImage('assets/images/ts_10_11019a.jpg'),
              height: 350,
            ),
          ),
          const Text(
            'Amanda\'s Polo Shirt',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xff333333),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            '\$50.20',
            style: TextStyle(
              color: Color(0xff777777),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xff333333),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'A versatile full-zip that you can wear all day long and even...',
            style: TextStyle(
              color: Color(0xff777777),
              fontSize: 15,
            ),
          ),
          // Example pay button configured using an asset
          FutureBuilder<PaymentConfiguration>(
            future: _googlePayConfigFuture,
            builder: (context, snapshot) => snapshot.hasData
                ? GooglePayButton(
                    paymentConfiguration: snapshot.data!,
                    paymentItems: _paymentItems,
                    type: GooglePayButtonType.buy,
                    margin: const EdgeInsets.only(top: 15.0),
                    onPaymentResult: onGooglePayResult,
                    loadingIndicator: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          // Example pay button configured using a string
          ApplePayButton(
            paymentConfiguration: PaymentConfiguration.fromJsonString(
              payment_configurations.defaultApplePay,
            ),
            paymentItems: _paymentItems,
            style: ApplePayButtonStyle.black,
            type: ApplePayButtonType.buy,
            margin: const EdgeInsets.only(top: 15.0),
            onPaymentResult: onApplePayResult,
            loadingIndicator: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          // This allows you to control whether the payment shall succeed or not.
          // This is only available on iOS.
          // Usually you would want to wait for your backend to return a value,
          // before you update the payment status.
          if (defaultTargetPlatform == TargetPlatform.iOS)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Should the payment succeed?'),
                Switch.adaptive(
                  value: shouldPaymentSucceedOnIos,
                  onChanged: (value) {
                    setState(() {
                      shouldPaymentSucceedOnIos = value;
                    });
                  },
                ),
              ],
            ),
          const SizedBox(height: 15)
        ],
      ),
    );
  }
}
