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
    show RawGooglePayButton, GooglePayButtonTheme, GooglePayButtonType;

export 'package:pay_ios/pay_ios.dart'
    show RawApplePayButton, ApplePayButtonStyle, ApplePayButtonType;

part 'src/pay.dart';
part 'src/widgets/pay_button.dart';
part 'src/widgets/apple_pay_button.dart';
part 'src/widgets/google_pay_button.dart';
