/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A shared class for handling payment across an app and its related extensions
 */

import Flutter
import PassKit
import UIKit

typealias PaymentCompletionHandler = (Bool) -> Void

class PaymentHandler: NSObject {
  var paymentStatus = PKPaymentAuthorizationStatus.failure
  var paymentResult: FlutterResult!
  
  func canMakePayments(_ paymentConfiguration: String) -> Bool {
    if let supportedNetworks = PaymentHandler.supportedNetworks(from: paymentConfiguration) {
      return PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks)
    } else {
      return false
    }
  }
  
  func startPayment(result: @escaping FlutterResult, paymentConfiguration: String, paymentItems: [[String: Any?]]) {
    
    // Set active payment result
    paymentResult = paymentResult ?? result
    
    // Deserialize payment configuration
    guard let paymentRequest = PaymentHandler.createPaymentRequest(from: paymentConfiguration, paymentItems: paymentItems) else {
      result(FlutterError(code: "invalidPaymentConfiguration", message: "It was not possible to create a payment request from the provided configuration. Review your payment configuration and run again", details: nil))
      return
    }
    
    // Display our payment request
    let paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
    paymentController.delegate = self
    paymentController.present(completion: { (presented: Bool) in
      if !presented {
        result(FlutterError(code: "paymentError", message: "Failed to present payment controller", details: nil))
      }
    })
  }
  
  private static func extractPaymentConfiguration(from paymentConfigurationString: String) -> [String: Any]? {
    let paymentConfigurationData = paymentConfigurationString.data(using: .utf8)
    return try? JSONSerialization.jsonObject(with: paymentConfigurationData!) as? [String: Any]
  }
  
  private static func supportedNetworks(from paymentConfigurationString: String) -> [PKPaymentNetwork]? {
    guard let paymentConfiguration = extractPaymentConfiguration(from: paymentConfigurationString) else {
      return nil
    }
    
    return (paymentConfiguration["supportedNetworks"] as! [String]).compactMap { networkString in PKPaymentNetwork.fromString(networkString) }
  }
  
  private static func createPaymentRequest(from paymentConfigurationString: String, paymentItems: [[String: Any?]]) -> PKPaymentRequest? {
    guard let paymentConfiguration = extractPaymentConfiguration(from: paymentConfigurationString) else {
      return nil
    }
    
    // Create payment request and include summary items
    let paymentRequest = PKPaymentRequest()
    paymentRequest.paymentSummaryItems = paymentItems.map { item in
      if let statusString = item["status"] {
        return PKPaymentSummaryItem(
          label: item["label"] as! String ,
          amount: NSDecimalNumber(string: (item["amount"] as! String)),
          type: PKPaymentSummaryItemType.fromString(statusString as! String))
      }
      
      return PKPaymentSummaryItem(
        label: item["label"] as! String,
        amount: NSDecimalNumber(string: (item["amount"] as! String)))
    }
    
    // Configure the payment
    paymentRequest.merchantIdentifier = paymentConfiguration["merchantIdentifier"] as! String
    if let merchantCapabilities = paymentConfiguration["merchantCapabilities"] as? Array<String> {
      paymentRequest.merchantCapabilities = PKMerchantCapability(merchantCapabilities.compactMap { capabilityString in PKMerchantCapability.fromString(capabilityString) })
    }
    paymentRequest.countryCode = paymentConfiguration["countryCode"] as! String
    paymentRequest.currencyCode = paymentConfiguration["currencyCode"] as! String
    paymentRequest.requiredShippingContactFields = [.postalAddress, .phoneNumber]
    
    if let supportedNetworks = supportedNetworks(from: paymentConfigurationString) {
      paymentRequest.supportedNetworks = supportedNetworks
    }
    
    return paymentRequest
  }
}

/*
 PKPaymentAuthorizationControllerDelegate conformance.
 */
extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {
  func paymentAuthorizationController(_: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
    
    guard let paymentResultData = try? JSONSerialization.data(withJSONObject: payment.toDictionary()) else {
      self.paymentResult(FlutterError(code: "paymentResultDeserializationFailed", message: nil, details: nil))
      return
    }
    self.paymentResult(String(decoding: paymentResultData, as: UTF8.self))
    
    paymentStatus = .success
    completion(PKPaymentAuthorizationResult(status: paymentStatus, errors: nil))
  }
  
  func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
    controller.dismiss {
      DispatchQueue.main.async {
        if self.paymentStatus != .success {
          self.paymentResult(FlutterError(code: "paymentFailed", message: "Failed to complete the payment", details: nil))
        }
      }
    }
  }
}

extension PKPayment {
  public func toDictionary() -> [String: Any?] {
    return [
      "token": String(decoding: token.paymentData, as: UTF8.self),
      "paymentMethod": token.paymentMethod.toDictionary(),
      "billingContact": billingContact?.toDictionary(),
      "shippingContact": shippingContact?.toDictionary(),
      "shippingMethod": shippingMethod?.toDictionary(),
    ]
  }
}

extension PKPaymentMethod {
  public func toDictionary() -> [String: Any?] {
    return [
      "displayName": displayName,
      "network": network?.rawValue,
      "type": type.rawValue
    ]
  }
}

extension PKContact {
  public func toDictionary() -> [String: Any?] {
    return [
      "name": "\(name?.givenName ?? "") \(name?.familyName ?? "")",
      "emailAddress": emailAddress,
      "phoneNumber": phoneNumber?.stringValue
    ]
  }
}

extension PKShippingMethod {
  public func toDictionary() -> [String: Any?] {
    return [
      "id": identifier,
      "details": detail
    ]
  }
}

extension PKPaymentNetwork {
  public static func fromString(_ paymentNetworkString: String) -> PKPaymentNetwork? {
    switch paymentNetworkString {
    case "amex":
      return .amex
    case "cartesBancaires":
      return .cartesBancaires
    case "chinaUnionPay":
      return .chinaUnionPay
    case "discover":
      return .discover
    case "eftpos":
      return .eftpos
    case "electron":
      return .electron
    case "elo":
      guard #available(iOS 12.1.1, *) else { return nil }
      return .elo
    case "idCredit":
      return .idCredit
    case "interac":
      return .interac
    case "JCB":
      return .JCB
    case "mada":
      guard #available(iOS 12.1.1, *) else { return nil }
      return .mada
    case "maestro":
      return .maestro
    case "masterCard":
      return .masterCard
    case "privateLabel":
      return .privateLabel
    case "quicPay":
      return .quicPay
    case "suica":
      return .suica
    case "visa":
      return .visa
    case "vPay":
      return .vPay
    case "barcode":
      guard #available(iOS 14.0, *) else { return nil }
      return .barcode
    case "girocard":
      guard #available(iOS 14.0, *) else { return nil }
      return .girocard
    default:
      return nil
    }
  }
}

extension PKPaymentSummaryItemType {
  public static func fromString(_ summaryItemType: String) -> PKPaymentSummaryItemType {
    switch summaryItemType {
    case "final_price":
      return .final
    default:
      return .pending
    }
  }
}

extension PKMerchantCapability {
  public static func fromString(_ merchantCapability: String) -> PKMerchantCapability? {
    switch merchantCapability {
    case "3DS":
      return .capability3DS
    case "EMV":
      return .capabilityEMV
    case "credit":
      return .capabilityCredit
    case "debit":
      return .capabilityDebit
    default:
      return nil
    }
  }
}
