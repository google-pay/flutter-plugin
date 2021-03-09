@TestOn('vm')

import 'package:pay_mobile/pay_mobile.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final PayMobileChannel _mobilePlatform;
  const MethodChannel channel = MethodChannel('plugins.flutter.io/pay_channel');

  setUpAll(() async {
    _mobilePlatform = PayMobileChannel();
  });

  group('Verify channel I/O for', () {
    final List<MethodCall> log = <MethodCall>[];
    const Map<String, dynamic> testResponses = <String, dynamic>{
      'userCanPay': true,
      'showPaymentSelector': '{}',
    };

    setUp(() {
      channel.setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        final dynamic response = testResponses[methodCall.method];
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
      await _mobilePlatform.showPaymentSelector({}, '0');
      expect(
        log,
        <Matcher>[
          isMethodCall('showPaymentSelector', arguments: <String, dynamic>{
            'payment_profile': '{}',
            'price': '0',
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
