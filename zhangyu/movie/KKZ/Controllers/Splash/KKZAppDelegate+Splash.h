//
//  KKZAppDelegate+Splash.h
//  
//
//  Created by Albert on 24/02/2017.
//
//

#import "KKZAppDelegate.h"

#define K_SPLASH_IMAGE_STORE_KEY @"SPLASH_IMAGE_STORE_KEY"  // splash 存key

@interface KKZAppDelegate(Splash)

/**
 是否有缓存

 @return yes: 有splash no：没有splash
 */
- (BOOL) hasSplashInCache;

/**
 请求splash
 */
- (void)requestSplashData;

@end
