part of '../../pay_ios.dart';

const double _defaultButtonHeight = 48.0;

enum ApplePayButtonType {
  plain,
  buy,
  setUp,
  inStore,
  donate,
  checkout,
  book,
  subscribe,
  reload,
  addMoney,
  topUp,
  order,
  rent,
  support,
  contribute,
  tip
}

enum ApplePayButtonStyle {
  white,
  whiteOutline,
  black,
  automatic,
}

class RawApplePayButton extends StatelessWidget {
  final BoxConstraints constraints;
  final EdgeInsets margin;
  final VoidCallback onPressed;
  final ApplePayButtonStyle style;
  final ApplePayButtonType type;

  RawApplePayButton({
    Key? key,
    required this.onPressed,
    this.margin = EdgeInsets.zero,
    this.style = ApplePayButtonStyle.black,
    this.type = ApplePayButtonType.plain,
    double? width,
    double? height = _defaultButtonHeight,
  })  : constraints = BoxConstraints.tightFor(width: width, height: height),
        super(key: key) {
    assert(constraints.debugAssertIsValid());
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints,
      child: _platform,
    );
  }

  Widget get _platform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return _UiKitApplePayButton(
          onPressed: onPressed,
          style: style,
          type: type,
        );
      default:
        throw UnsupportedError(
            'This platform $defaultTargetPlatform does not support Apple Pay');
    }
  }

  static bool get supported => defaultTargetPlatform == TargetPlatform.iOS;
}

class _UiKitApplePayButton extends StatefulWidget {
  final VoidCallback onPressed;
  final ApplePayButtonStyle style;
  final ApplePayButtonType type;

  _UiKitApplePayButton({
    Key? key,
    required this.onPressed,
    this.style = ApplePayButtonStyle.black,
    this.type = ApplePayButtonType.plain,
  }) : super(key: key);

  @override
  _UiKitApplePayButtonState createState() => _UiKitApplePayButtonState();
}

class _UiKitApplePayButtonState extends State<_UiKitApplePayButton> {
  static const _buttonId = 'plugins.flutter.io/pay/apple_pay_button';
  MethodChannel? methodChannel;

  @override
  Widget build(BuildContext context) {
    final int style = mapButtonStyle(widget.style);
    final int type = _mapButtonType(widget.type);

    return UiKitView(
      viewType: _buttonId,
      creationParamsCodec: StandardMessageCodec(),
      creationParams: {'style': style, 'type': type},
      onPlatformViewCreated: (viewId) {
        methodChannel = MethodChannel('$_buttonId/$viewId');
        methodChannel?.setMethodCallHandler((call) async {
          if (call.method == 'onPressed') widget.onPressed.call();
          return;
        });
      },
    );
  }

  @override
  void didUpdateWidget(covariant _UiKitApplePayButton oldWidget) {
    if (widget.style != oldWidget.style || widget.type != oldWidget.type) {
      final int style = mapButtonStyle(widget.style);
      final int type = _mapButtonType(widget.type);
      methodChannel?.invokeMethod('updateStyle', {
        'style': style,
        'type': type,
      });
    }
    super.didUpdateWidget(oldWidget);
  }
}

int _mapButtonType(ApplePayButtonType type) {
  switch (type) {
    case ApplePayButtonType.plain:
      return 0;
    case ApplePayButtonType.buy:
      return 1;
    case ApplePayButtonType.setUp:
      return 2;
    case ApplePayButtonType.inStore:
      return 3;
    case ApplePayButtonType.donate:
      return 4;
    case ApplePayButtonType.checkout:
      return 5;
    case ApplePayButtonType.book:
      return 6;
    case ApplePayButtonType.subscribe:
      return 7;
    case ApplePayButtonType.reload:
      return 8;
    case ApplePayButtonType.addMoney:
      return 9;
    case ApplePayButtonType.topUp:
      return 10;
    case ApplePayButtonType.order:
      return 11;
    case ApplePayButtonType.rent:
      return 12;
    case ApplePayButtonType.support:
      return 13;
    case ApplePayButtonType.contribute:
      return 14;
    case ApplePayButtonType.tip:
      return 15;
    default:
      return 0;
  }
}

int mapButtonStyle(ApplePayButtonStyle style) {
  switch (style) {
    case ApplePayButtonStyle.white:
      return 0;
    case ApplePayButtonStyle.whiteOutline:
      return 1;
    case ApplePayButtonStyle.black:
      return 2;
    case ApplePayButtonStyle.automatic:
      return 3;
    default:
      return 2;
  }
}
