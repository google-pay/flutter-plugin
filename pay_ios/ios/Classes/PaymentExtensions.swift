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

import PassKit

/// A set of utility methods associated to `PKPayment`.
extension PKPayment {

  /// Creates a `Dictionary` representation of the `PKPayment` object.
  public func toDictionary() -> [String: Any] {
    return [
      "token": String(decoding: token.paymentData, as: UTF8.self) as Any?,
      "transactionIdentifier": token.transactionIdentifier,
      "paymentMethod": token.paymentMethod.toDictionary(),
      "billingContact": billingContact?.toDictionary(),
      "shippingContact": shippingContact?.toDictionary(),
      "shippingMethod": shippingMethod?.toDictionary(),
    ].compactMapValues { $0 }
  }
}

/// A set of utility methods associated to `PKPaymentMethod`.
extension PKPaymentMethod {

  /// Creates a `Dictionary` representation of the `PKPaymentMethod` object.
  public func toDictionary() -> [String: Any] {
    return [
      "displayName": displayName,
      "network": network?.rawValue,
      "type": type.rawValue
    ].compactMapValues { $0 }
  }
}

/// A set of utility methods associated to `PKContact`.
extension PKContact {

  /// Creates a `Dictionary` representation of the `PKContact` object.
  public func toDictionary() -> [String: Any] {
    return [
      "name": name?.toDictionary() as Any?,
      "emailAddress": emailAddress,
      "phoneNumber": phoneNumber?.stringValue,
      "postalAddress": postalAddress?.toDictionary()
    ].compactMapValues { $0 }
  }
}

/// A set of utility methods associated to `PersonNameComponents`.
extension PersonNameComponents {

  /// Creates a `Dictionary` representation of the `PersonNameComponents` object.
  public func toDictionary() -> [String: Any]? {
    let dict = [
      "namePrefix": namePrefix,
      "givenName": givenName,
      "middleName": middleName,
      "familyName": familyName,
      "nameSuffix": nameSuffix,
      "nickname": nickname,
      "phoneticRepresentation": phoneticRepresentation?.toDictionary(),
    ].compactMapValues { $0 }

    return !dict.isEmpty ? dict : nil
  }
}

/// A set of utility methods associated to `CNPostalAddress`.
extension CNPostalAddress {

  /// Creates a `Dictionary` representation of the `CNPostalAddress` object.
  public func toDictionary() -> [String: Any] {
    return [
      "street": street,
      "subLocality": subLocality,
      "city": city,
      "subAdministrativeArea": subAdministrativeArea,
      "state": state,
      "postalCode": postalCode,
      "country": country,
      "isoCountryCode": isoCountryCode
    ].compactMapValues { $0 }
  }
}

/// A set of utility methods associated to `PKShippingMethod`.
extension PKShippingMethod {

  /// Creates a `Dictionary` representation of the `PKShippingMethod` object.
  public func toDictionary() -> [String: Any?] {
    return [
      "id": identifier,
      "details": detail
    ].compactMapValues { $0 }
  }
}

/// A set of utility methods associated to `PKPaymentNetwork`.
extension PKPaymentNetwork {

  /// Creates a `PKPaymentNetwork` object from a network in string format.
  public static func fromString(_ paymentNetworkString: String) -> PKPaymentNetwork? {
    switch paymentNetworkString {
    case "amex":
      return .amex
    case "cartesBancaires":
      guard #available(iOS 12.0, *) else { return nil }
      return .cartesBancaires
    case "chinaUnionPay":
      return .chinaUnionPay
    case "discover":
      return .discover
    case "eftpos":
      guard #available(iOS 12.0, *) else { return nil }
      return .eftpos
    case "electron":
      guard #available(iOS 12.0, *) else { return nil }
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
      guard #available(iOS 12.0, *) else { return nil }
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
      guard #available(iOS 12.0, *) else { return nil }
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

/// A set of utility methods associated to `PKPaymentSummaryItemType`.
extension PKPaymentSummaryItemType {

  /// Creates a `PKPaymentSummaryItemType` object from an item type in string format.
  public static func fromString(_ summaryItemType: String) -> PKPaymentSummaryItemType {
    switch summaryItemType {
    case "pending":
      return .pending
    default:
      return .final // final_price
    }
  }
}

/// A set of utility methods associated to `PKMerchantCapability`.
extension PKMerchantCapability {

  /// Creates a `PKMerchantCapability` object from a capability in string format.
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

/// A set of utility methods associated to `PKContactField`.
extension PKContactField {

  /// Creates a `PKContactField` object from a contact field item in string format.
  public static func fromString(_ contactFieldItem: String) -> PKContactField? {
    switch contactFieldItem {
    case "emailAddress":
      return .emailAddress
    case "name":
      return .name
    case "phoneNumber":
      return .phoneNumber
    case "phoneticName":
      return .phoneticName
    case "postalAddress":
      return .postalAddress
    default:
      return nil
    }
  }
}
