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

@TestOn('vm')

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_platform_interface/core/payment_configuration.dart';

import 'package:pay_platform_interface/pay_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final PayMethodChannel mobilePlatform;
  const channel = MethodChannel('plugins.flutter.io/pay');

  const providerApplePay = PayProvider.apple_pay;
  final payConfigString =
      '{"provider": "${providerApplePay.toSimpleString()}", "data": {}}';
  final dummyConfig = PaymentConfiguration.fromJsonString(payConfigString);

  setUpAll(() async {
    mobilePlatform = PayMethodChannel();
  });

  group('Verify channel I/O for', () {
    final log = <MethodCall>[];
    const testResponses = <String, Object>{
      'userCanPay': true,
      'showPaymentSelector': '{}',
    };

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        final response = testResponses[methodCall.method];
        if (response is Exception) {
          return Future<Object>.error(response);
        }
        return Future<Object>.value(response);
      });
    });

    test('userCanPay', () async {
      await mobilePlatform.userCanPay(dummyConfig);
      expect(
        log,
        <Matcher>[isMethodCall('userCanPay', arguments: '{}')],
      );
    });

    test('showPaymentSelector', () async {
      await mobilePlatform.showPaymentSelector(dummyConfig, []);
      expect(
        log,
        <Matcher>[
          isMethodCall('showPaymentSelector', arguments: <String, Object>{
            'payment_profile': '{}',
            'payment_items': [],
          })
        ],
      );
    });

    tearDown(() async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
      log.clear();
    });
  });

  tearDown(() async {});
}
