import Flutter
import PassKit
import UIKit

public class SwiftPayPlugin: NSObject, FlutterPlugin {
  let paymentHandler = PaymentHandler()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "plugins.flutter.io/pay_channel", binaryMessenger: registrar.messenger())
    let instance = SwiftPayPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    let factory = ApplePayButtonViewFactory(messenger: registrar.messenger())
    registrar.register(factory, withId: "plugins.flutter.io/pay/apple_pay")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "userCanPay":
      // TODO: payload validation
      result(PaymentHandler.canMakePayments(call.arguments as! String))
    default: break
    }
  }
}
