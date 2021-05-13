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

part of '../../pay.dart';

abstract class PayButton extends StatefulWidget {
  late final Pay _payClient;

  final double width;
  final double height;
  final EdgeInsets margin;

  final void Function(Map<String, dynamic> result) onPaymentResult;
  final void Function(Object? error)? onError;
  final Widget? childOnError;
  final Widget? loadingIndicator;

  PayButton(
    Key? key,
    String paymentConfigurationAsset,
    this.onPaymentResult,
    this.width,
    this.height,
    this.margin,
    this.onError,
    this.childOnError,
    this.loadingIndicator,
  )   : _payClient = Pay.fromAssets([paymentConfigurationAsset]),
        super(key: key);

  VoidCallback _defaultOnPressed(
      VoidCallback? onPressed, List<PaymentItem> paymentItems) {
    return () async {
      onPressed?.call();
      try {
        final result =
            await _payClient.showPaymentSelector(paymentItems: paymentItems);
        onPaymentResult(result);
      } catch (error) {
        onError?.call(error);
      }
    };
  }

  List<TargetPlatform> get _supportedPlatforms;
  Widget get _payButton;

  bool get _isPlatformSupported =>
      _supportedPlatforms.contains(defaultTargetPlatform);

  @override
  _PayButtonState createState() => _PayButtonState();
}

class _PayButtonState extends State<PayButton> {
  late final Future<bool> userCanPayFuture;

  Future<bool> userCanPay() async {
    try {
      return await widget._payClient.userCanPay();
    } catch (error) {
      widget.onError?.call(error);
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    userCanPayFuture = userCanPay();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget._isPlatformSupported) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<bool>(
      future: userCanPayFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == true) {
            return Container(
              margin: widget.margin,
              width: widget.width,
              height: widget.height,
              child: widget._payButton,
            );
          } else {
            return ButtonPlaceholder(
              margin: widget.margin,
              child: widget.childOnError,
            );
          }
        }

        return ButtonPlaceholder(
          margin: widget.margin,
          child: widget.loadingIndicator,
        );
      },
    );
  }
}

class ButtonPlaceholder extends StatelessWidget {
  final Widget? child;
  final EdgeInsets margin;

  ButtonPlaceholder({
    Key? key,
    this.child,
    required this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child == null
        ? const SizedBox.shrink()
        : Container(margin: margin, child: child);
  }
}
