# cordova-plugin-sdwebimage

Use [SDWebImage](https://github.com/rs/SDWebImage) + [WebViewProxy](https://github.com/marcuswestin/WebViewProxy) to cache images in your cordova app.


See benchmarks at https://github.com/revolunet/cordova-plugin-sdwebimage-test

## Installation

Install the plugin :

`cordova plugin add --save https://github.com/revolunet/cordova-plugin-sdwebimage.git`

## Usage

```js
// get image as base64
cordova.plugins.SDWebImage.getImage(url, function(base64) {
  console.log(base64);
});

// prefetch some urls in cached
cordova.plugins.SDWebImage.prefetchURLs(urls, function() {
  // all done
});

// get info about objects in SDImageCache
cordova.plugins.SDWebImage.getCacheInfo(function(data) {
  console.log(data);
});

// Clear SDImageCache
cordova.plugins.SDWebImage.clearCache(function() {
  // all done
});
```

Also adds a proxy that intercepts calls to `http://proxy/http://path/to/image` and return cached version of `http://path/to/image` and force 1 year expiration.


## Todo :



## Licence MIT

Code distributed under MIT licence. Contributions welcome.
