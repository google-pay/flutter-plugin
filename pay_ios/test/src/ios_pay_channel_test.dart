import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_ios/pay_ios.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final IOSPayMethodChannel _payChannel;

  setUpAll(() async {
    _payChannel = IOSPayMethodChannel();
  });

  group('Verify channel I/O for', () {
    final log = <MethodCall>[];
    const testResponses = <String, Object?>{
      'updatePaymentStatus': null,
    };

    setUp(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        _payChannel.channel,
        (MethodCall methodCall) async {
          log.add(methodCall);
          final response = testResponses[methodCall.method];
          if (response is Exception) {
            return Future<Object?>.error(response);
          }
          return Future<Object?>.value(response);
        },
      );
    });

    test('updatePaymentStatus', () async {
      await _payChannel.updatePaymentStatus(true);
      expect(
        log,
        <Matcher>[isMethodCall('updatePaymentStatus', arguments: true)],
      );
    });
  });
}
