
#import <Cordova/CDV.h>

#import "UIImageView+WebCache.h"
#import "WebViewProxy.h"

#import "CDVSDWebImage.h"


@implementation CDVSDWebImage

- (void) _setupProxy {
  NSOperationQueue* queue = [[NSOperationQueue alloc] init];
  [queue setMaxConcurrentOperationCount:15];

  // intercept all UIWebView requests starting with http://intercept
  [WebViewProxy handleRequestsWithHost:@"intercept" handler:^(NSURLRequest* req, WVPResponse *res) {

    NSURL *requestUrl = [req.URL.absoluteString substringFromIndex:([@"http://intercept" length] + 1)];

    NSLog(@"requestUrl: %@", requestUrl);

    // Set off a download job
    NSOperation *job = [manager downloadImageWithURL:requestUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize)
    {
      // download progress
      NSLog(@"progress %d %d", receivedSize, expectedSize);
    }
    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
    {
      if (image && finished)
      {
        // never expires this image
        [res setHeader:@"Cache-Control" value:[NSString stringWithFormat:@"max-age=%i", 365 * 24 * 60 * 60]];
        // return it
        [res respondWithImage:image];
      } else {
        NSLog(@"error");
      }
    }];
  }];

}

// Setup the index and download manager
- (void)pluginInitialize {
  indexes = [NSMutableDictionary new];
  manager = [SDWebImageManager sharedManager];
  SDWebImageManager.sharedManager.delegate = self;
  [[SDWebImageDownloader sharedDownloader] setMaxConcurrentDownloads:6];
  [self _setupProxy];
}

// return b64 version of cached images
- (void)getImage:(CDVInvokedUrlCommand*)command
{

  options = [command.arguments objectAtIndex:0];

  // Set off a download job
  [self.commandDelegate runInBackground:^{
    NSOperation *job = [manager downloadImageWithURL:[options objectForKey:@"src"] options:[[options objectForKey:@"downloadOptions"] integerValue] progress:^(NSInteger receivedSize, NSInteger expectedSize)
    {
      // TODO: create a callback so we can have a process update in web land
      NSLog(@"progress %ld %ld", (long)receivedSize, (long)expectedSize);
    }
    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
    {
      if (image)
      {
        // If we have an image. Switch it to a base64 image and send it back to web land to be injected
        NSString *base64Image = [UIImageJPEGRepresentation(image, [[options objectForKey:@"quality"] floatValue]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:base64Image];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
      } else {
        [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
      }
    }];
  }];

}

- (void)clearCache:(CDVInvokedUrlCommand*)command
{

  [[NSURLCache sharedURLCache] removeAllCachedResponses];
  [manager.imageCache clearMemory];
  [manager.imageCache clearDisk];
  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"ok"];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)getCacheInfo:(CDVInvokedUrlCommand*)command
{
  NSLog(@"getDiskCount: %d", [manager.imageCache getDiskCount]);
  NSLog(@"getSize: %d", [manager.imageCache getSize]);
  CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"ok"];
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}
@end
