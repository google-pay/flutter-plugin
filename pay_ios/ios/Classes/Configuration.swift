/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Handles configuration logic for the Apple Pay merchant identifier
 */

import Foundation

public class Configuration {
  /*
   The value of the `OFFERING_APPLE_PAY_BUNDLE_PREFIX` user-defined build
   setting is written to the Info.plist file of every target in Swift
   version of the sample project. Specifically, the value of
   `OFFERING_APPLE_PAY_BUNDLE_PREFIX` is used as the string value for a
   key of `AAPLOfferingApplePayBundlePrefix`. This value is loaded from the
   target's bundle by the lazily evaluated static variable "prefix" from
   the nested "Bundle" struct below the first time that "Bundle.prefix"
   is accessed. This avoids the need for developers to edit both
   `OFFERING_APPLE_PAY_BUNDLE_PREFIX` and the code below. The value of
   `Bundle.prefix` is then used as part of an interpolated string to insert
   the user-defined value of `OFFERING_APPLE_PAY_BUNDLE_PREFIX` into several
   static string constants below.
   */
  
  private struct MainBundle {
    static var prefix: String = {
      guard let prefix = Bundle.main.object(forInfoDictionaryKey: "AAPLOfferingApplePayBundlePrefix") as? String else {
        return ""
      }
      return prefix
    }()
  }
  
  struct Merchant {
    static let identifier = "merchant.\(MainBundle.prefix).demo"
  }
}
