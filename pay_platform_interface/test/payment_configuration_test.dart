@TestOn('vm')

import 'dart:io';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pay_platform_interface/core/payment_configuration.dart';

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
    final configurationMap = jsonDecode(_paymentConfigurationString);
    final configuration = PaymentConfiguration.fromMap(configurationMap);
    expect(configuration.provider, isNotNull);
    expect(await configuration.parameters, isNotEmpty);
  });

  tearDown(() async {});
}
