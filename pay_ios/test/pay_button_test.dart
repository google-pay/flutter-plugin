import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_ios/pay_ios.dart';

const _defaultButtonHeight = 43;

void main() {
  setUp(() async {});

  group('Button style:', () {
    testWidgets('defaults to type black and long', (WidgetTester tester) async {
      await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: RawApplePayButton(onPressed: () => null),
      ));

      expect(
          find.byWidgetPredicate((widget) =>
              widget is RawMaterialButton && widget.fillColor == Colors.black),
          findsOneWidget);

      expect(find.byType(RawMaterialButton), findsOneWidget);
    });

    testWidgets('height defaults to 43 as specified in the brand guidelines',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
            child: RawApplePayButton(onPressed: () => null),
          ),
        ),
      );

      final Size buttonSize = tester.getSize(find.byType(RawMaterialButton));
      expect(
        buttonSize.height,
        _defaultButtonHeight,
      );
    });
  });
}
