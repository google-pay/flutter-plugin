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

import 'dart:io';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pay_platform_interface/core/payment_configuration.dart';
import 'package:pay_platform_interface/util/configurations.dart';

String _fixtureAsset(String name) {
  var currentPath = Directory.current.path;
  var dir = currentPath.endsWith('/test')
      ? Directory.current.parent.path
      : currentPath;

  return File('$dir/test/assets/$name').readAsStringSync();
}

Future<Map<String, dynamic>> _testProfileLoader(
        String paymentConfigurationAsset) async =>
    jsonDecode(_fixtureAsset(paymentConfigurationAsset));

const PayProvider _providerGooglePay = PayProvider.google_pay;
final String _payConfigString =
    '{"provider": "${_providerGooglePay.toSimpleString()}",'
    '"data": { "environment": "TEST", "apiVersion": 2, "apiVersionMinor": 0}}';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {});

  test('Load payment configuration from a string', () async {
    final configuration = PaymentConfiguration.fromJsonString(_payConfigString);
    expect(configuration.provider, _providerGooglePay);
    expect(await configuration.toMap(), isNotEmpty);
  });

  test('Load payment configuration from an asset', () async {
    final configuration = await PaymentConfiguration.fromAsset(
        'google_pay_prod_payment_profile.json',
        profileLoader: _testProfileLoader);

    expect(configuration.provider, _providerGooglePay);
    expect(await configuration.toMap(), isNotEmpty);
  });

  test('Check that software info is included in Google Pay requests', () async {
    final config = await PaymentConfiguration.fromAsset(
        'google_pay_prod_payment_profile.json',
        profileLoader: _testProfileLoader);

    final builtConfig = await Configurations.build(config);
    expect(builtConfig.containsKey('merchantInfo'), isTrue);
    expect(builtConfig['merchantInfo'].containsKey('softwareInfo'), isTrue);

    Map<String, dynamic> softwareInfo =
        builtConfig['merchantInfo']['softwareInfo'];
    expect(softwareInfo.containsKey('id'), isTrue);
    expect(softwareInfo.containsKey('version'), isTrue);
  });

  tearDown(() async {});
}
