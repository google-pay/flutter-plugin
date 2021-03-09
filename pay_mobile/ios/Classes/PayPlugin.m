#import "PayPlugin.h"
#if __has_include(<pay_mobile/pay_mobile-Swift.h>)
#import <pay_mobile/pay_mobile-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "pay_mobile-Swift.h"
#endif

@implementation PayPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPayPlugin registerWithRegistrar:registrar];
}
@end
