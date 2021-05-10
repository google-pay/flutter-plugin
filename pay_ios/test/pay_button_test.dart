/// Copyright 2021 Google LLC
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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_ios/pay_ios.dart';

void main() {
  setUp(() async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  });

  group('Button style:', () {
    testWidgets('defaults to type plan and black', (WidgetTester tester) async {
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: RawApplePayButton(onPressed: () => null),
      ));

      expect(
          find.byWidgetPredicate((widget) =>
              widget is UiKitView &&
              widget.creationParams['style'] == 'black' &&
              widget.creationParams['type'] == 'plain'),
          findsOneWidget);

      expect(find.byType(UiKitView), findsOneWidget);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets('height defaults to 30 as specified in the brand guidelines',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: RawApplePayButton(onPressed: () => null),
          ),
        ),
      );

      final buttonSize = tester.getSize(find.byType(UiKitView));
      expect(
        buttonSize.height,
        RawApplePayButton.minimumButtonHeight,
      );
      debugDefaultTargetPlatformOverride = null;
    });
  });
}
