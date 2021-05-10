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
import UIKit
import PassKit

class ApplePayButtonViewFactory: NSObject, FlutterPlatformViewFactory {
  private var messenger: FlutterBinaryMessenger
  
  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }
  
  func create(
    withFrame frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?
  ) -> FlutterPlatformView {
    return ApplePayButtonView(
      frame: frame,
      viewIdentifier: viewId,
      arguments: args,
      binaryMessenger: messenger)
  }
  
  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

class ApplePayButtonView: NSObject, FlutterPlatformView {
  private var _view: UIView
  var type: String
  var style: String
  
  private var applePayButton: PKPaymentButton?
  
  private let channel: FlutterMethodChannel
  
  @objc func handleApplePayButtonTapped() {
    channel.invokeMethod("onPressed", arguments: nil)
  }
  
  init(
    frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger
  ) {
    channel = FlutterMethodChannel(name: "plugins.flutter.io/pay/apple_pay_button/\(viewId)",
                                   binaryMessenger: messenger)
    _view = UIView()

    let arguments = args as! Dictionary<String, AnyObject>
    type = arguments["type"] as! String
    style = arguments["style"] as! String

    super.init()
    channel.setMethodCallHandler(handle)
    createApplePayView()
  }
  
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  func view() -> UIView {
    return _view
  }
  
  func createApplePayView(){
    if let applePayButton = self.applePayButton {
      applePayButton.removeFromSuperview()
    }
    
    let paymentButtonType = PKPaymentButtonType.fromString(type) ?? .plain
    let paymentButtonStyle = PKPaymentButtonStyle.fromString(style) ?? .black
    self.applePayButton = PKPaymentButton(paymentButtonType: paymentButtonType, paymentButtonStyle: paymentButtonStyle)
    
    if let applePayButton = self.applePayButton {
      applePayButton.translatesAutoresizingMaskIntoConstraints = false
      applePayButton.addTarget(self, action: #selector(handleApplePayButtonTapped), for: .touchUpInside)
      _view.addSubview(applePayButton)
      
      applePayButton.topAnchor.constraint(equalTo: _view.topAnchor).isActive = true
      applePayButton.bottomAnchor.constraint(equalTo: _view.bottomAnchor).isActive = true
      applePayButton.leftAnchor.constraint(equalTo: _view.leftAnchor).isActive = true
      applePayButton.rightAnchor.constraint(equalTo: _view.rightAnchor).isActive = true
    }
  }
}

extension PKPaymentButtonType {
  public static func fromString(_ buttonType: String) -> PKPaymentButtonType? {
    switch buttonType {
    case "buy":
      return .buy
    case "setUp":
      return .setUp
    case "inStore":
      return .inStore
    case "donate":
      return .donate
    case "checkout":
      return .checkout
    case "book":
      return .book
    case "subscribe":
      return .subscribe
    default:
      guard #available(iOS 14.0, *) else { return .plain }
      switch buttonType {
      case "reload":
        return .reload
      case "addMoney":
        return .addMoney
      case "topUp":
        return .topUp
      case "order":
        return .order
      case "rent":
        return .rent
      case "support":
        return .support
      case "contribute":
        return .contribute
      case "tip":
        return .tip
      default:
        return nil
      }
    }
  }
}

extension PKPaymentButtonStyle {
  public static func fromString(_ buttonStyle: String) -> PKPaymentButtonStyle? {
    switch buttonStyle {
    case "white":
      return .white
    case "whiteOutline":
      return .whiteOutline
    case "black":
      return .black
    case "automatic":
      guard #available(iOS 14.0, *) else { return nil }
      return .automatic
    default:
      return nil
    }
  }
}
