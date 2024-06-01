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

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_android/pay_android.dart';
import 'package:pay_platform_interface/core/payment_configuration.dart';

const PayProvider _providerGooglePay = PayProvider.google_pay;
final String _payConfigString =
    '{"provider": "${_providerGooglePay.toSimpleString()}",'
    '"data": { "allowedPaymentMethods": []}}';

void main() {
  setUp(() async {});

  group('Button theme:', () {
    testWidgets('defaults to type buy and dark', (WidgetTester tester) async {
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: RawGooglePayButton(
            paymentConfiguration:
                PaymentConfiguration.fromJsonString(_payConfigString),
            onPressed: () {}),
      ));

      expect(
          find.byWidgetPredicate((widget) =>
              widget is RawGooglePayButton &&
              widget.theme == GooglePayButtonTheme.dark &&
              widget.type == GooglePayButtonType.buy),
          findsOneWidget);
    });

    testWidgets('height defaults to 48 as specified in the brand guidelines',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: RawGooglePayButton(
                paymentConfiguration:
                    PaymentConfiguration.fromJsonString(_payConfigString),
                onPressed: () {}),
          ),
        ),
      );

      final buttonSize = tester.getSize(find.byType(RawGooglePayButton));
      expect(buttonSize.height, RawGooglePayButton.defaultButtonHeight);
    });
  });
}
