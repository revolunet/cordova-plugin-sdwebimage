
#import <Cordova/CDVPlugin.h>

@interface CDVForceNetwork : CDVPlugin {}

- (void) openNetworkSettings;
- (void) openNetworkSettings:(CDVInvokedUrlCommand*)command;

@end
