import Flutter
import PassKit
import UIKit

public class PayPlugin: NSObject, FlutterPlugin {
  private static let methodChannelName = "plugins.flutter.io/pay_channel"
  private let methodUserCanPay = "userCanPay"
  private let methodShowPaymentSelector = "showPaymentSelector"
  
  private let paymentHandler = PaymentHandler()
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: methodChannelName, binaryMessenger: registrar.messenger)
    registrar.addMethodCallDelegate(PayPlugin(), channel: channel)

    let buttonFactory = ApplePayButtonViewFactory(messenger: registrar.messenger)
    registrar.register(buttonFactory, withId: "plugins.flutter.io/pay/apple_pay_button")
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
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
