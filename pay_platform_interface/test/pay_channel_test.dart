@TestOn('vm')

import 'package:pay_platform_interface/pay_channel.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final PayMethodChannel _mobilePlatform;
  const channel = MethodChannel('plugins.flutter.io/pay_channel');

  setUpAll(() async {
    _mobilePlatform = PayMethodChannel();
  });

  group('Verify channel I/O for', () {
    final log = <MethodCall>[];
    const testResponses = <String, dynamic>{
      'userCanPay': true,
      'showPaymentSelector': '{}',
    };

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        final response = testResponses[methodCall.method];
        if (response is Exception) {
          return Future<dynamic>.error(response);
        }
        return Future<dynamic>.value(response);
      });
    });

    test('userCanPay', () async {
      await _mobilePlatform.userCanPay({});
      expect(
        log,
        <Matcher>[isMethodCall('userCanPay', arguments: '{}')],
      );
    });

    test('showPaymentSelector', () async {
      await _mobilePlatform.showPaymentSelector({}, []);
      expect(
        log,
        <Matcher>[
          isMethodCall('showPaymentSelector', arguments: <String, dynamic>{
            'payment_profile': '{}',
            'payment_items': [],
          })
        ],
      );
    });

    tearDown(() async {
      channel.setMockMethodCallHandler(null);
      log.clear();
    });
  });

  tearDown(() async {});
}
