

#import <Cordova/CDV.h>
#import "UIImageView+WebCache.h"

@interface CDVSDWebImage : CDVPlugin<SDWebImageManagerDelegate> {
    NSDictionary *options;
    NSMutableDictionary *indexes;
    SDWebImageManager *manager;
//    SDWebImagePrefetcher *prefetcher;
}

- (void)getImage:(CDVInvokedUrlCommand*)command;
- (void)clearCache:(CDVInvokedUrlCommand*)command;
- (void)getCacheInfo:(CDVInvokedUrlCommand*)command;
- (void)prefetchURLs:(CDVInvokedUrlCommand*)command;

@end
