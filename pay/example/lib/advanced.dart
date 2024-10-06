// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pay/pay.dart';

import 'payment_configurations.dart' as payment_configurations;

void main() {
  runApp(const PayAdvancedMaterialApp());
}

const googlePayEventChannelName = 'plugins.flutter.io/pay/payment_result';
const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: PaymentItemStatus.final_price,
  )
];

class PayAdvancedMaterialApp extends StatelessWidget {
  const PayAdvancedMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pay for Flutter Advanced Integration Demo',
      localizationsDelegates: const [
        ...GlobalMaterialLocalizations.delegates,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
        Locale('de', ''),
      ],
      home: PayAdvancedSampleApp(),
    );
  }
}

class PayAdvancedSampleApp extends StatefulWidget {
  final Pay payClient;

  PayAdvancedSampleApp({super.key})
      : payClient = Pay({
          PayProvider.google_pay: payment_configurations.defaultGooglePayConfig,
          PayProvider.apple_pay: payment_configurations.defaultApplePayConfig,
        });

  @override
  State<PayAdvancedSampleApp> createState() => _PayAdvancedSampleAppState();
}

class _PayAdvancedSampleAppState extends State<PayAdvancedSampleApp> {
  static const eventChannel = EventChannel(googlePayEventChannelName);
  StreamSubscription<String>? _googlePayResultSubscription;

  late final Future<bool> _canPayGoogleFuture;
  late final Future<bool> _canPayAppleFuture;

  // A method to listen to events coming from the event channel on Android
  void _startListeningForPaymentResults() {
    _googlePayResultSubscription = eventChannel
        .receiveBroadcastStream()
        .map((result) => result.toString())
        .listen(debugPrint, onError: (error) => debugPrint(error.toString()));
  }

  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.android) {
      _startListeningForPaymentResults();
    }

    // Initialize userCanPay futures
    _canPayGoogleFuture = widget.payClient.userCanPay(PayProvider.google_pay);
    _canPayAppleFuture = widget.payClient.userCanPay(PayProvider.apple_pay);
  }

  void _onGooglePayPressed() =>
      _showPaymentSelectorForProvider(PayProvider.google_pay);

  void _onApplePayPressed() =>
      _showPaymentSelectorForProvider(PayProvider.apple_pay);

  void _showPaymentSelectorForProvider(PayProvider provider) async {
    try {
      final result =
          await widget.payClient.showPaymentSelector(provider, _paymentItems);
      debugPrint(result.toString());
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  void dispose() {
    _googlePayResultSubscription?.cancel();
    _googlePayResultSubscription = null;
    super.dispose();
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

          // Google Pay button
          FutureBuilder<bool>(
            future: _canPayGoogleFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == true) {
                  return RawGooglePayButton(
                      paymentConfiguration:
                          payment_configurations.defaultGooglePayConfig,
                      type: GooglePayButtonType.buy,
                      onPressed: _onGooglePayPressed);
                } else {
                  // userCanPay returned false
                  // Consider showing an alternative payment method
                }
              } else {
                // The operation hasn't finished loading
                // Consider showing a loading indicator
              }
              // This example shows an empty box if userCanPay returns false
              return const SizedBox.shrink();
            },
          ),

          // Apple Pay button
          FutureBuilder<bool>(
            future: _canPayAppleFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == true) {
                  return RawApplePayButton(
                      type: ApplePayButtonType.buy,
                      onPressed: _onApplePayPressed);
                } else {
                  // userCanPay returned false
                  // Consider showing an alternative payment method
                }
              } else {
                // The operation hasn't finished loading
                // Consider showing a loading indicator
              }
              // This example shows an empty box if userCanPay returns false
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 15)
        ],
      ),
    );
  }
}
