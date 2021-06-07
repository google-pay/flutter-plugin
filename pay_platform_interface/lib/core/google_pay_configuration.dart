/// Copyright 2021 Google LLC
/// SPDX-License-Identifier: Apache-2.0

import 'payment_configuration.dart';

/// An object that holds information about a payment transaction specific for
/// Google Pay.
class GooglePayConfiguration implements PaymentConfiguration {
  @override
  PayProvider provider = PayProvider.google_pay;

  @override
  Future<Map<String, dynamic>> toMap() {
    throw UnimplementedError();
  }
}
