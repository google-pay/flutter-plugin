/// Copyright 2023 Google LLC.
/// SPDX-License-Identifier: Apache-2.0

import 'package:pay_platform_interface/pay_channel.dart';

/// This implements the iOS specific functionality of the Pay plugin.
class IOSPayMethodChannel extends PayMethodChannel {
  /// Update the payment status with the native platform.
  Future<void> updatePaymentStatus(bool isSuccess) async {
    return channel.invokeMethod('updatePaymentStatus', isSuccess);
  }
}
