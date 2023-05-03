/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Flutter
import PassKit
import UIKit

/// A class that receives and handles calls from Flutter to complete the payment.
public class PayPlugin: NSObject, FlutterPlugin {
  private static let methodChannelName = "plugins.flutter.io/pay_channel"
  private let methodUserCanPay = "userCanPay"
  private let methodShowPaymentSelector = "showPaymentSelector"
  private let methodUpdatePaymentStatus = "updatePaymentStatus"
  
  private let paymentHandler = PaymentHandler()
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let messenger = registrar.messenger()
    let channel = FlutterMethodChannel(name: methodChannelName, binaryMessenger: messenger)
    registrar.addMethodCallDelegate(PayPlugin(), channel: channel)
    
    // Register the PlatformView to show the Apple Pay button.
    let buttonFactory = ApplePayButtonViewFactory(messenger: messenger)
    registrar.register(buttonFactory, withId: ApplePayButtonView.buttonMethodChannelName)
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case methodUserCanPay:
      result(paymentHandler.canMakePayments(call.arguments as! String))
      
    case methodShowPaymentSelector:
      let arguments = call.arguments as! [String: Any]
      paymentHandler.startPayment(
        result: result,
        paymentConfiguration: arguments["payment_profile"] as! String,
        paymentItems: arguments["payment_items"] as! [[String: Any?]])
      
    case methodUpdatePaymentStatus:
      let isSuccess = call.arguments as! Bool
      paymentHandler.updatePaymentStatus(isSuccess: isSuccess)
    
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
