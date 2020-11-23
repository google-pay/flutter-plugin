@TestOn('vm')

import 'dart:io';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_pay/google_pay.dart';

String _fixtureAsset(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }

  return File('$dir/test/assets/$name').readAsStringSync();
}

Future<Map<String, dynamic>> _testProfileLoader(
        String paymentProfileAsset) async =>
    jsonDecode(_fixtureAsset(paymentProfileAsset));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {});

  test('Load a payment profile for the test environment', () async {
    GooglePay client = GooglePay(
        paymentProfileAsset: 'test_payment_profile.json',
        profileLoader: _testProfileLoader);

    expect(await client.environment, 'TEST');
  });

  test('Load a payment profile for the producton environment', () async {
    GooglePay client = GooglePay(
        paymentProfileAsset: 'prod_payment_profile.json',
        profileLoader: _testProfileLoader);

    expect(await client.environment, 'PRODUCTION');
  });

  tearDown(() async {});
}
