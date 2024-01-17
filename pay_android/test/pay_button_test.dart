// Copyright 2024 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_android/pay_android.dart';

void main() {
  setUp(() async {});

  group('Button style:', () {
    testWidgets('defaults to type dark', (WidgetTester tester) async {
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: RawGooglePayButton(onPressed: () {}),
      ));

      expect(
          find.byWidgetPredicate((widget) =>
              widget is RawMaterialButton && widget.fillColor == Colors.black),
          findsOneWidget);
    });

    testWidgets('height defaults to 48 as specified in the brand guidelines',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: RawGooglePayButton(onPressed: () {}),
          ),
        ),
      );

      final buttonSize = tester.getSize(find.byType(RawMaterialButton));
      expect(buttonSize.height, 48);
    });
  });
}
