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

/// A factory class that creates the `FlutterPlatformView` that needs to render
/// and displayed on the Flutter end.
///
/// The constructor takes a messenger to communicate both ends and respond to
/// user interaction.
/// Example usage:
/// ```
/// let messenger = registrar.messenger()
/// let buttonFactory = ApplePayButtonViewFactory(messenger: messenger)
/// ```
class ApplePayButtonViewFactory: NSObject, FlutterPlatformViewFactory {
  
  /// Holds the object needed to connect both the Flutter and native ends.
  private var messenger: FlutterBinaryMessenger
  
  /// Instantiates the class with the associated messenger.
  ///
  /// - parameter messenger: An object to help the Flutter and native ends communicate.
  init(messenger: FlutterBinaryMessenger) {
    self.messenger = messenger
    super.init()
  }
  
  /// Create a `FlutterPlatformView`.
  ///
  /// Implemented by iOS code that expose a `UIView` for embedding in a Flutter app.
  /// The implementation of this method should create a new `UIView` and return it.
  ///
  /// - parameter frame: The rectangle for the newly created `UIView` measured in points.
  /// - parameter viewId: A unique identifier for this `UIView`.
  /// - parameter args: Parameters for creating the `UIView` sent from the Dart side of the Flutter app.
  /// If `createArgsCodec` is not implemented, or if no creation arguments were sent from the Dart
  /// code, this will be null. Otherwise this will be the value sent from the Dart code as decoded by
  /// `createArgsCodec`.
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
  
  /// Returns the `FlutterMessageCodec` for decoding the args parameter of `createWithFrame`.
  ///
  /// Only needs to be implemented if `createWithFrame` needs an arguments parameter.
  func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

/// A class to draw Apple Pay's `PKPaymentButton` natively.
///
/// This class constructs and draws a `PKPaymentButton` to send that back to the
/// Flutter end. At the moment, the assets are not available to use by Flutter, and hence,
/// it needs to be drawn natively.
class ApplePayButtonView: NSObject, FlutterPlatformView {
  
  /// The name of the channel to use by the button to connect the native and Flutter ends
  static let buttonMethodChannelName = "plugins.flutter.io/pay/apple_pay_button"
  
  /// Holds the actual view with the contents to be send back to Flutter.
  private var _view: UIView
  
  /// The channel used to communicate with Flutter's end to exchange user interaction information.
  private let channel: FlutterMethodChannel
  
  /// Function to  inform the Flutter channel about the tap event
  @objc func handleApplePayButtonTapped() {
    channel.invokeMethod("onPressed", arguments: nil)
  }
  
  /// Creates a `PKPaymentButton` based on the parameters received.
  ///
  /// This constructor also initializes the objects necessary to communicate to and from the Flutter end.
  ///
  /// - parameter frame: The bounds of the view.
  /// - parameter viewIdentifier: The identifier for this view.
  /// - parameter args: Additional arguments.
  /// - parameter binaryMessenger: The messenger received from the platform view factory.
  init(
    frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger
  ) {
    _view = UIView()
    
    let arguments = args as! Dictionary<String, AnyObject>
    let buttonType = arguments["type"] as! String
    let buttonStyle = arguments["style"] as! String
    
    // Instantiate the channel to talk to the Flutter end.
    channel = FlutterMethodChannel(name: "\(ApplePayButtonView.buttonMethodChannelName)/\(viewId)",
                                   binaryMessenger: messenger)
    
    super.init()
    channel.setMethodCallHandler(handleFlutterCall)
    createApplePayView(type: buttonType, style: buttonStyle)
  }
  
  /// No-op handler that resonds to calls received from Flutter.
  ///
  /// - parameter call: The call received from Flutter.
  /// - parameter result: The callback to respond back.
  public func handleFlutterCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  func view() -> UIView {
    return _view
  }
  
  /// Creates the actual `PKPaymentButton` with the defined styles and constraints.
  func createApplePayView(type buttonTypeString: String, style buttonStyleString: String){
    
    // Create the PK objects
    let paymentButtonType = PKPaymentButtonType.fromString(buttonTypeString) ?? .plain
    let paymentButtonStyle = PKPaymentButtonStyle.fromString(buttonStyleString) ?? .black
    let applePayButton = PKPaymentButton(paymentButtonType: paymentButtonType, paymentButtonStyle: paymentButtonStyle)
    
    // Configure the button
    applePayButton.translatesAutoresizingMaskIntoConstraints = false
    applePayButton.addTarget(self, action: #selector(handleApplePayButtonTapped), for: .touchUpInside)
    _view.addSubview(applePayButton)
    
    // Enable constraints
    applePayButton.topAnchor.constraint(equalTo: _view.topAnchor).isActive = true
    applePayButton.bottomAnchor.constraint(equalTo: _view.bottomAnchor).isActive = true
    applePayButton.leftAnchor.constraint(equalTo: _view.leftAnchor).isActive = true
    applePayButton.rightAnchor.constraint(equalTo: _view.rightAnchor).isActive = true
  }
}

// github: vmatiukh - added new #available checker
/// A set of utility methods associated to `PKPaymentButtonType`.
extension PKPaymentButtonType {
  
  /// Creates a `PKPaymentButtonType` object from a network in string format.
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
        guard #available(iOS 14.0, *) else { return .plain }
      return .checkout
    case "book":
        guard #available(iOS 14.0, *) else { return .plain }
      return .book
    case "subscribe":
        guard #available(iOS 14.0, *) else { return .plain }
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

/// A set of utility methods associated to `PKPaymentButtonStyle`.
extension PKPaymentButtonStyle {
  
  /// Creates a `PKPaymentButtonStyle` object from a network in string format.
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
