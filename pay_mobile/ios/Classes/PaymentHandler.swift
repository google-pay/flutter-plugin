/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 A shared class for handling payment across an app and its related extensions
 */

import PassKit
import UIKit

typealias PaymentCompletionHandler = (Bool) -> Void

class PaymentHandler: NSObject {
    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItems = [PKPaymentSummaryItem]()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: PaymentCompletionHandler!

    class func canMakePayments(_ paymentConfiguration: String) -> Bool {
        if let supportedNetworks = supportedNetworks(from: paymentConfiguration) {
            return PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks)
        } else {
            return false
        }
    }

    func startPayment(completion: @escaping PaymentCompletionHandler) {
        completionHandler = completion

        let fare = PKPaymentSummaryItem(label: "Minimum Fare", amount: NSDecimalNumber(string: "9.99"), type: .final)
        let tax = PKPaymentSummaryItem(label: "Tax", amount: NSDecimalNumber(string: "1.00"), type: .final)
        let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: "10.99"), type: .pending)
        paymentSummaryItems = [fare, tax, total]

        // Create our payment request
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.merchantIdentifier = Configuration.Merchant.identifier
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "US"
        paymentRequest.currencyCode = "USD"
        paymentRequest.requiredShippingContactFields = [.postalAddress, .phoneNumber]
        // paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks

        // Display our payment request
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        paymentController?.present(completion: { (presented: Bool) in
            if presented {
                debugPrint("Presented payment controller")
            } else {
                debugPrint("Failed to present payment controller")
                self.completionHandler(false)
            }
        })
    }

    private static func supportedNetworks(from paymentConfigurationString: String) -> [PKPaymentNetwork]? {
        let paymentConfigurationData = paymentConfigurationString.data(using: .utf8)
        guard let paymentConfiguration = try? JSONSerialization.jsonObject(with: paymentConfigurationData!, options: []) as? [String: Any] else {
            return nil
        }

        return (paymentConfiguration["supportedNetworks"] as! [String]).compactMap { PKPaymentNetwork.fromString($0) }
    }
}

/*
    PKPaymentAuthorizationControllerDelegate conformance.
 */
extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {
    func paymentAuthorizationController(_: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        // Perform some very basic validation on the provided contact information
        var errors = [Error]()
        var status = PKPaymentAuthorizationStatus.success
        if !["US", "ES"].contains(payment.shippingContact?.postalAddress?.isoCountryCode) {
            let pickupError = PKPaymentRequest.paymentShippingAddressUnserviceableError(withLocalizedDescription: "Sample App only picks up in the United States")
            let countryError = PKPaymentRequest.paymentShippingAddressInvalidError(withKey: CNPostalAddressCountryKey, localizedDescription: "Invalid country")
            errors.append(pickupError)
            errors.append(countryError)
            status = .failure
        } else {
            // Here you would send the payment token to your server or payment provider to process
            // Once processed, return an appropriate status in the completion handler (success, failure, etc)
        }

        paymentStatus = status
        completion(PKPaymentAuthorizationResult(status: status, errors: errors))
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            // We are responsible for dismissing the payment sheet once it has finished
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    self.completionHandler!(true)
                } else {
                    self.completionHandler!(false)
                }
            }
        }
    }

    func paymentAuthorizationController(_: PKPaymentAuthorizationController, didSelectPaymentMethod paymentMethod: PKPaymentMethod, handler completion: @escaping (PKPaymentRequestPaymentMethodUpdate) -> Void) {
        // The didSelectPaymentMethod delegate method allows you to make changes when the user updates their payment card
        // Here we're applying a $2 discount when a debit card is selected
        guard paymentMethod.type == .debit else {
            completion(PKPaymentRequestPaymentMethodUpdate(paymentSummaryItems: paymentSummaryItems))
            return
        }

        var discountedSummaryItems = paymentSummaryItems
        let discount = PKPaymentSummaryItem(label: "Debit Card Discount", amount: NSDecimalNumber(string: "-2.00"))
        discountedSummaryItems.insert(discount, at: paymentSummaryItems.count - 1)
        if let total = paymentSummaryItems.last {
            total.amount = total.amount.subtracting(NSDecimalNumber(string: "2.00"))
        }
        completion(PKPaymentRequestPaymentMethodUpdate(paymentSummaryItems: discountedSummaryItems))
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
