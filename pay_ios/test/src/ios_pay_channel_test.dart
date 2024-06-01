/// Copyright 2023 Google LLC
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
library;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_ios/pay_ios.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late final IosPayMethodChannel payChannel;

  final defaultBinaryMessenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  setUpAll(() async {
    payChannel = IosPayMethodChannel();
  });

  group('Verify channel I/O for', () {
    final log = <MethodCall>[];
    const testResponses = <String, Object?>{
      'updatePaymentResult': null,
    };

    setUp(() {
      defaultBinaryMessenger.setMockMethodCallHandler(
        payChannel.channel,
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

    test('updatePaymentResult', () async {
      await payChannel.updatePaymentResult(true);
      expect(
        log,
        <Matcher>[isMethodCall('updatePaymentResult', arguments: true)],
      );
    });

    tearDown(() async {
      defaultBinaryMessenger.setMockMethodCallHandler(
        payChannel.channel,
        null,
      );
      log.clear();
    });
  });
}
