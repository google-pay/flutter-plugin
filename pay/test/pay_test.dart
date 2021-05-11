@TestOn('vm')

import 'dart:io';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pay_platform_interface/core/payment_configuration.dart';
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {});

  test('A Pay client can load configuration from multiple providers', () async {
    final configuration = await PaymentConfiguration.fromAsset(
        'google_pay_default_payment_profile.json',
        profileLoader: _testProfileLoader);
    final client = Pay([configuration]);
    expect(client, isNotNull);
  });

  tearDown(() async {});
}
