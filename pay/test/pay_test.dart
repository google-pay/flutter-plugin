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

@TestOn('vm')

import 'dart:io';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pay/pay.dart';

String _fixtureAsset(String name) {
  var currentPath = Directory.current.path;
  var dir = currentPath.endsWith('/test')
      ? Directory.current.parent.path
      : currentPath;

  return File('$dir/test/assets/$name').readAsStringSync();
}

Future<Map<String, dynamic>> _testProfileLoader(
        String paymentConfigurationAsset) async =>
    jsonDecode(_fixtureAsset(paymentConfigurationAsset))
        as Map<String, dynamic>;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {});

  test('A Pay client can load configuration from an asset', () async {
    final configuration = await PaymentConfiguration.fromAsset(
        'google_pay_default_payment_profile.json',
        profileLoader: _testProfileLoader);

    final client = Pay({
      PayProvider.google_pay: configuration,
    });
    expect(client, isNotNull);
  });

  test('A Pay client can load configuration from multiple providers', () async {
    final multiplePaymentConfig = <PayProvider, PaymentConfiguration>{
      PayProvider.apple_pay: PaymentConfiguration.fromJsonString(
          '{"provider": "apple_pay", "data": {}}'),
      PayProvider.google_pay: PaymentConfiguration.fromJsonString(
          '{"provider": "google_pay", "data": {}}'),
    };

    final client = Pay(multiplePaymentConfig);
    expect(client, isNotNull);
  });

  test('Throw exception when a missing configuration is used', () async {
    final client = Pay({});
    expect(client.userCanPay(PayProvider.google_pay),
        throwsA(isA<ProviderNotConfiguredException>()));
  });

  tearDown(() async {});
}
