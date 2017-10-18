//
//  KKZBaseNetRequest+HeaderField.m
//  KoMovie
//
//  Created by Albert on 7/4/16.
//  Copyright © 2016 kokozu. All rights reserved.
//

#import "KKZBaseNetRequest+HeaderField.h"
#import <objc/runtime.h>
#import <AdSupport/ASIdentifierManager.h>
//#import <Category_KKZ/UIDeviceExtra.h>
#import "UserDefault.h"
#import "Constants.h"
#import "ZDConstants.h"
#import "HCConstants.h"

//#import "CPUserCenter.h"
#import "DataEngine.h"

@implementation KKZBaseNetRequest (HeaderField)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(headerField);
        SEL swizzledSelector = @selector(default_headerField);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (NSDictionary *)default_headerField
{
    if ([self default_headerField] == nil) {
        NSMutableDictionary *head = [NSMutableDictionary dictionaryWithCapacity:10];
        [head setValue:[DataEngine sharedDataEngine].sessionId forKey:@"accessToken"];
        [head setValue:[DataEngine sharedDataEngine].userId forKey:@"userId"];
        
//        [head setValue:[CPUserCenter shareInstance].sessionId forKey:@"session_id"];
//        [head setValue:@"ios" forKey:@"channel"];//固定值
//        [head setValue:kChannelId forKey:@"channel_id"];//渠道ID
//        [head setValue:kChannelName forKey:@"channel_name"];//渠道名
//        [head setValue:APP_UUID forKey:@"app_uuid"];//设备唯一标识
//        [head setValue:[[UIDevice currentDevice] systemVersion] forKey:@"os"]; // 系统版本号
//        [head setValue:[[UIDevice currentDevice] platform] forKey:@"device"];//设备信息
//        [head setValue:[self appVersion] forKey:@"version"];//应用版本号
//        [head setValue:@"1.0.0" forKey:@"serverVersion"];
        
//        // GPS定位
//        if ([USER_LATITUDE length]) {
//            [head setValue:USER_LATITUDE forKey:@"latitude"];
//        }
//        if ([USER_LONGITUDE length]) {
//            [head setValue:USER_LONGITUDE forKey:@"longitude"];
//        }
        [self setHeaderField:[head copy]];
        DLog(@"setHeaderField == %@", head);

    }
    
    return [self default_headerField];
}

static char versionKey;

- (NSString *)appVersion {
    
    NSString *currentVersion =  objc_getAssociatedObject(self, &versionKey);
    
    if (!currentVersion) {
        NSDictionary *softwareInfo = [[NSDictionary alloc] initWithContentsOfFile:
                                      [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], @"Info.plist"]];
        NSString *currentVersion = [softwareInfo objectForKey:@"CFBundleShortVersionString"];
        objc_setAssociatedObject(self, &versionKey,
                                 currentVersion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return currentVersion;
}


@end
