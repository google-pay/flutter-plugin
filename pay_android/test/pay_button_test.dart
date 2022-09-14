/// Copyright 2021 Google LLC
/// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_android/pay_android.dart';

void main() {
  setUp(() async {});

  group('Button style:', () {
    testWidgets('defaults to type dark', (WidgetTester tester) async {
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: RawGooglePayButton(onPressed: () => null),
      ));

      expect(
          find.byWidgetPredicate((widget) =>
              widget is RawMaterialButton && widget.fillColor == Colors.black),
          findsOneWidget);

      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('height defaults to 48 as specified in the brand guidelines',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: RawGooglePayButton(onPressed: () => null),
          ),
        ),
      );

      final buttonSize = tester.getSize(find.byType(RawMaterialButton));
      expect(buttonSize.height, 48);
    });
  });
}
