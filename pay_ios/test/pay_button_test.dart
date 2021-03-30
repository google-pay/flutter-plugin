import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pay_ios/pay_ios.dart';

const _minimumButtonHeight = 30;

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
        _minimumButtonHeight,
      );
      debugDefaultTargetPlatformOverride = null;
    });
  });
}
