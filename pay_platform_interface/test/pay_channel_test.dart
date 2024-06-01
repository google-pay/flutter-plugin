/// Copyright 2021 Google LLC
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

@TestOn('vm')

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_platform_interface/core/payment_configuration.dart';
import 'package:pay_platform_interface/pay_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final PayMethodChannel _mobilePlatform;

  final _defaultBinaryMessenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  const _providerApplePay = PayProvider.apple_pay;
  final _payConfigString =
      '{"provider": "${_providerApplePay.toSimpleString()}", "data": {}}';
  final _dummyConfig = PaymentConfiguration.fromJsonString(_payConfigString);

  setUpAll(() async {
    _mobilePlatform = PayMethodChannel();
  });

  group('Verify channel I/O for', () {
    final log = <MethodCall>[];
    const testResponses = <String, Object>{
      'userCanPay': true,
      'showPaymentSelector': '{}',
    };

    setUp(() {
      _defaultBinaryMessenger.setMockMethodCallHandler(
        _mobilePlatform.channel,
        (MethodCall methodCall) async {
          log.add(methodCall);
          final response = testResponses[methodCall.method];
          if (response is Exception) {
            return Future<Object>.error(response);
          }
          return Future<Object>.value(response);
        },
      );
    });

    test('userCanPay', () async {
      await _mobilePlatform.userCanPay(_dummyConfig);
      expect(
        log,
        <Matcher>[isMethodCall('userCanPay', arguments: '{}')],
      );
    });

    test('showPaymentSelector', () async {
      await _mobilePlatform.showPaymentSelector(_dummyConfig, []);
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
      _defaultBinaryMessenger.setMockMethodCallHandler(
        _mobilePlatform.channel,
        null,
      );
      log.clear();
    });
  });

  tearDown(() async {});
}
