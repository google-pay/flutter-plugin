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
        String paymentProfileAsset) async =>
    jsonDecode(_fixtureAsset(paymentProfileAsset));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {});

  test('Load a payment profile for the test environment', () async {
    Pay client = Pay(
        paymentProfileAsset: 'test_payment_profile.json',
        profileLoader: _testProfileLoader);

    expect(await client.environment, 'TEST');
  });

  test('Load a payment profile for the producton environment', () async {
    Pay client = Pay(
        paymentProfileAsset: 'prod_payment_profile.json',
        profileLoader: _testProfileLoader);

    expect(await client.environment, 'PRODUCTION');
  });

  test('Verify that software info is included in the requests', () async {
    Pay client = Pay(
        paymentProfileAsset: 'default_payment_profile.json',
        profileLoader: _testProfileLoader);

    var paymentProfile = await client.paymentProfile;
    expect(paymentProfile.containsKey('merchantInfo'), isTrue);
    expect(paymentProfile['merchantInfo'].containsKey('softwareInfo'), isTrue);

    Map<String, String> softwareInfo =
        paymentProfile['merchantInfo']['softwareInfo'];
    expect(softwareInfo.containsKey('id'), isTrue);
    expect(softwareInfo.containsKey('version'), isTrue);
  });

  tearDown(() async {});
}
