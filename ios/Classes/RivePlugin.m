#import "RivePlugin.h"
#if __has_include(<rive/rive-Swift.h>)
#import <rive/rive-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "rive-Swift.h"
#endif

@implementation RivePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftRivePlugin registerWithRegistrar:registrar];
}
@end
