/// Copyright 2023 Google LLC.
/// SPDX-License-Identifier: Apache-2.0
library;

import 'package:pay_platform_interface/pay_channel.dart';

/// This implements the iOS specific functionality of the Pay plugin.
class IosPayMethodChannel extends PayMethodChannel {
  /// Update the payment result with the native platform.
  Future<void> updatePaymentResult(bool isSuccess) async {
    return channel.invokeMethod('updatePaymentResult', isSuccess);
  }
}
