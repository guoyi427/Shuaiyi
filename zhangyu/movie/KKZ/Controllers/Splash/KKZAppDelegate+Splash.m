//
//  KKZAppDelegate+Splash.m
//  
//
//  Created by Albert on 24/02/2017.
//
//

#import "KKZAppDelegate+Splash.h"
#import "AppRequest.h"

@implementation KKZAppDelegate(Splash)
-(BOOL)hasSplashInCache
{
    // 判断磁盘是否有广告图片
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:K_SPLASH_IMAGE_STORE_KEY];
    return image != nil;
}

- (void)requestSplashData {
    AppRequest *request = [[AppRequest alloc] init];
    [request requestSplashSuccess:^(NSArray *_Nullable splashes) {
        
        if (splashes && splashes.count > 0) {
            NSString *splash = splashes[0];
            [self downloadSplashImage:splash];
        }
    }
                          failure:nil];
}

- (void)downloadSplashImage:(NSString *)splashUrl {
    // 比对URL与之前的URl比对，如果一样则不下载图片
    NSString *urlStored = SPLASH_URL;
    if (urlStored != nil && [splashUrl isEqualToString:urlStored] && [self hasSplashInCache] == YES) {
        return;
    }
    
    [[SDWebImageManager sharedManager]
     downloadImageWithURL:[NSURL URLWithString:splashUrl]
     options:SDWebImageContinueInBackground
     progress:nil
     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
         
         SPLASH_URL_WRITE(imageURL.absoluteString);
         [[NSUserDefaults standardUserDefaults] synchronize];
         
         [[SDImageCache sharedImageCache] storeImage:image forKey:K_SPLASH_IMAGE_STORE_KEY toDisk:YES];
         
     }];
}

@end
