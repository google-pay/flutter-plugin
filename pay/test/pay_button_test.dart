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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay/pay.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('plugins.flutter.io/pay');
  const providerGooglePay = PayProvider.google_pay;
  const payConfigString =
      '{"provider": "google_pay", "data": {}}';
  final paymentConfiguration =
      PaymentConfiguration.fromJsonString(payConfigString);

  testWidgets('PayButton re-evaluates readiness when app is resumed',
      (WidgetTester tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    final log = <MethodCall>[];
    var canPayResponse = true;

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      log.add(methodCall);
      if (methodCall.method == 'userCanPay') {
        return canPayResponse;
      }
      return null;
    });

    // Pump the GooglePayButton widget.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GooglePayButton(
            paymentConfiguration: paymentConfiguration,
            paymentItems: const [],
            onPaymentResult: (_) {},
          ),
        ),
      ),
    );

    // Initial build/initState should call userCanPay.
    await tester.pumpAndSettle();
    expect(log.length, 1);
    expect(log.first.method, 'userCanPay');

    // Simulate resuming the app.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    // Verify that userCanPay was called a second time.
    expect(log.length, 2);
    expect(log[1].method, 'userCanPay');

    // Clean up.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    debugDefaultTargetPlatformOverride = null;
  });
}
