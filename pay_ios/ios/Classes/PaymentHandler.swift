/**
 * Copyright 2024 Google LLC
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

/// An alias to determine the result types of a payment operation.
typealias PaymentCompletionHandler = (Bool) -> Void

/// Enum to track payment handler status and result
enum PaymentHandlerStatus {
  case started, presented, authorizationStarted, authorized
}

/// A simple helper to orchestrate fundamental calls to complete a payment operation.
///
/// Use this class to manage payment sessions, with the ability to determine whether a user
/// can make a payment with the selected provider, and to start the payment process.
/// Example usage:
/// ```
/// let paymentHandler = PaymentHandler()
/// paymentHandler.canMakePayments(stringArguments)
/// ```
class PaymentHandler: NSObject {
  
  /// Holds the current status of the payment process.
  var paymentHandlerStatus: PaymentHandlerStatus!
  
  /// Stores a reference to the Flutter result while the operation completes.
  var paymentResult: FlutterResult!
  
  /// Determines whether a user can make a payment with the selected provider.
  ///
  /// - parameter paymentConfiguration: A JSON string with the configuration to execute
  ///   this payment.
  /// - returns: A boolean with the result: whether the use can make payments.
  func canMakePayments(_ paymentConfiguration: String) -> Bool {
    if let supportedNetworks = PaymentHandler.supportedNetworks(from: paymentConfiguration) {
      return PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks)
    } else {
      return false
    }
  }
  
  /// Initiates the payment process with the selected payment provider.
  ///
  /// Calling this method starts the payment process and opens up the payment selector. Once the user
  /// makes a selection, the payment method information is returned.
  ///
  /// - parameter result: The reference to the result to send the response back to Flutter.
  /// - parameter paymentConfiguration: A JSON string with the configuration to execute
  ///   this payment.
  /// - parameter paymentItems: A list of payment elements that determine the total amount purchased.
  /// - returns: The payment method information selected by the user.
  func startPayment(result: @escaping FlutterResult, paymentConfiguration: String, paymentItems: [[String: Any?]]) {

    // Set active payment result.
    paymentResult = result

    // Reset payment handler status
    paymentHandlerStatus = .started
    
    // Deserialize payment configuration.
    guard let paymentRequest = PaymentHandler.createPaymentRequest(from: paymentConfiguration, paymentItems: paymentItems) else {
      result(FlutterError(code: "invalidPaymentConfiguration", message: "It was not possible to create a payment request from the provided configuration. Review your payment configuration and run again", details: nil))
      return
    }
    
    // Display the payment selector with the request created.
    let paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
    paymentController.delegate = self
    paymentController.present(completion: { (presented: Bool) in
      if presented {
        self.paymentHandlerStatus = .presented
      } else {
        result(FlutterError(code: "paymentError", message: "Failed to present payment controller", details: nil))
      }
    })
  }
  
  /// Utility function to turn the payment configuration received through the method channel into a `Dictionary`.
  ///
  /// - parameter paymentConfigurationString: A JSON string with the configuration to execute
  ///   this payment.
  /// - returns: A `Dictionary` with the payment configuration parsed.
  private static func extractPaymentConfiguration(from paymentConfigurationString: String) -> [String: Any]? {
    let paymentConfigurationData = paymentConfigurationString.data(using: .utf8)
    return try? JSONSerialization.jsonObject(with: paymentConfigurationData!) as? [String: Any]
  }
  
  /// Extracts and parses the list of supported networks in the payment configuration.
  ///
  /// - parameter paymentConfigurationString: A JSON string with the configuration to execute
  ///   this payment.
  /// - returns: A  list of recognized networks supported for this operation.
  private static func supportedNetworks(from paymentConfigurationString: String) -> [PKPaymentNetwork]? {
    guard let paymentConfiguration = extractPaymentConfiguration(from: paymentConfigurationString) else {
      return nil
    }
    
    return (paymentConfiguration["supportedNetworks"] as! [String]).compactMap { networkString in PKPaymentNetwork.fromString(networkString) }
  }
  
  /// Creates a valid payment request for Apple Pay with the information included in the payment configuration.
  ///
  /// - parameter paymentConfigurationString: A JSON string with the configuration to execute
  ///   this payment.
  /// - parameter paymentItems: A list of payment elements that determine the total amount purchased.
  /// - returns: A `PKPaymentRequest` object with the payment configuration included.
  private static func createPaymentRequest(from paymentConfigurationString: String, paymentItems: [[String: Any?]]) -> PKPaymentRequest? {
    guard let paymentConfiguration = extractPaymentConfiguration(from: paymentConfigurationString) else {
      return nil
    }
    
    // Create payment request and include summary items
    let paymentRequest = PKPaymentRequest()
    paymentRequest.paymentSummaryItems = paymentItems.map { item in
      return PKPaymentSummaryItem(
        label: item["label"] as! String,
        amount: NSDecimalNumber(string: (item["amount"] as! String), locale:["NSLocaleDecimalSeparator": "."]),
        type: (PKPaymentSummaryItemType.fromString(item["status"] as? String ?? "final_price"))
      )
    }
    
    // Configure the payment.
    paymentRequest.merchantIdentifier = paymentConfiguration["merchantIdentifier"] as! String
    paymentRequest.countryCode = paymentConfiguration["countryCode"] as! String
    paymentRequest.currencyCode = paymentConfiguration["currencyCode"] as! String
    
    // Add merchant capabilities.
    if let merchantCapabilities = paymentConfiguration["merchantCapabilities"] as? Array<String> {
      paymentRequest.merchantCapabilities = PKMerchantCapability(merchantCapabilities.compactMap { capabilityString in
        PKMerchantCapability.fromString(capabilityString)
      })
    }
    
    // Include the shipping fields required.
    if let requiredShippingFields = paymentConfiguration["requiredShippingContactFields"] as? Array<String> {
      paymentRequest.requiredShippingContactFields = Set(requiredShippingFields.compactMap { shippingField in
        PKContactField.fromString(shippingField)
      })
    }
    
    // Include the billing fields required.
    if let requiredBillingFields = paymentConfiguration["requiredBillingContactFields"] as? Array<String> {
      paymentRequest.requiredBillingContactFields = Set(requiredBillingFields.compactMap { billingField in
        PKContactField.fromString(billingField)
      })
    }
    
    // Add supported networks if available.
    if let supportedNetworks = supportedNetworks(from: paymentConfigurationString) {
      paymentRequest.supportedNetworks = supportedNetworks
    }
    
    return paymentRequest
  }
}

/// Extension that implements the completion methods in the delegate to respond to user selection.
extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {

  func paymentAuthorizationControllerWillAuthorizePayment(_ controller: PKPaymentAuthorizationController) {
      paymentHandlerStatus = .authorizationStarted
  }
    
  func paymentAuthorizationController(_: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
    
    // Collect payment result or error and return if no payment was selected
    guard let paymentResultData = try? JSONSerialization.data(withJSONObject: payment.toDictionary()) else {
      self.paymentResult(FlutterError(code: "paymentResultDeserializationFailed", message: nil, details: nil))
      return
    }
    
    // Return the result back to the channel
    self.paymentResult(String(decoding: paymentResultData, as: UTF8.self))
    
    paymentHandlerStatus = .authorized
    completion(PKPaymentAuthorizationResult(status: PKPaymentAuthorizationStatus.success, errors: nil))
  }
  
  func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
    controller.dismiss {
      DispatchQueue.main.async {
        // There was no attempt to authorize.
        if self.paymentHandlerStatus == .presented {
          self.paymentResult(FlutterError(code: "paymentCanceled", message: "User canceled payment authorization", details: nil))
        }
        // Authorization started, but it did not succeed
        if self.paymentHandlerStatus == .authorizationStarted {
          self.paymentResult(FlutterError(code: "paymentFailed", message: "Failed to complete the payment", details: nil))
        }
      }
    }
  }
}
