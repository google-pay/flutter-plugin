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
    jsonDecode(_fixtureAsset(paymentConfigurationAsset));

const String _paymentConfigurationString = '{"provider": "google_pay",'
    '"data": { "environment": "TEST", "apiVersion": 2, "apiVersionMinor": 0}}';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {});

  test('Load payment configuration from a string', () async {
    Pay client = Pay.fromJson(_paymentConfigurationString);
    expect(await client.environment, 'TEST');
  });

  test('Load Google Pay configuration for the test environment', () async {
    Pay client = Pay.fromAsset('google_pay_test_payment_profile.json',
        profileLoader: _testProfileLoader);

    expect(await client.environment, 'TEST');
  });

  test('Load Google Pay configuration for the producton environment', () async {
    Pay client = Pay.fromAsset('google_pay_prod_payment_profile.json',
        profileLoader: _testProfileLoader);

    expect(await client.environment, 'PRODUCTION');
  });

  test('Check that software info is included in Google Pay requests', () async {
    Pay client = Pay.fromAsset('google_pay_default_payment_profile.json',
        profileLoader: _testProfileLoader);

    var paymentData = await client.paymentData;
    expect(paymentData.containsKey('merchantInfo'), isTrue);
    expect(paymentData['merchantInfo'].containsKey('softwareInfo'), isTrue);

    Map<String, String> softwareInfo =
        paymentData['merchantInfo']['softwareInfo'];
    expect(softwareInfo.containsKey('id'), isTrue);
    expect(softwareInfo.containsKey('version'), isTrue);
  });

  tearDown(() async {});
}
