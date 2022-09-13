/// Copyright 2021 Google LLC.
/// SPDX-License-Identifier: Apache-2.0

library pay;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pay_ios/pay_ios.dart';
import 'package:pay_android/pay_android.dart';
import 'package:pay_platform_interface/core/payment_configuration.dart';
import 'package:pay_platform_interface/core/payment_item.dart';
import 'package:pay_platform_interface/pay_channel.dart';
import 'package:pay_platform_interface/pay_platform_interface.dart';

export 'package:pay_platform_interface/core/payment_configuration.dart'
    show PayProvider, PaymentConfiguration;

export 'package:pay_platform_interface/core/payment_item.dart'
    show PaymentItem, PaymentItemType, PaymentItemStatus;

export 'package:pay_android/pay_android.dart'
    show RawGooglePayButton, GooglePayButtonType;

export 'package:pay_ios/pay_ios.dart'
    show RawApplePayButton, ApplePayButtonStyle, ApplePayButtonType;

part 'src/pay.dart';
part 'src/widgets/pay_button.dart';
part 'src/widgets/apple_pay_button.dart';
part 'src/widgets/google_pay_button.dart';
