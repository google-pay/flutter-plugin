import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_pay/google_pay.dart';

void main() {
  const MethodChannel channel = MethodChannel('plugins.flutter.io/google_pay');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await GooglePay.platformVersion, '42');
  });
}
