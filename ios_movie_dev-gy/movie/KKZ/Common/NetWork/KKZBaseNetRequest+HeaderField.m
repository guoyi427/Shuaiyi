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
#import <Category_KKZ/UIDeviceExtra.h>
#import "DataEngine.h"
#import "FMDeviceManager.h"
@implementation KKZBaseNetRequest (HeaderField)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class class = [self class];

    SEL originalSelector = @selector(headerField);
    SEL swizzledSelector = @selector(default_headerField);

    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

    BOOL didAddMethod = class_addMethod(
        class, originalSelector, method_getImplementation(swizzledMethod),
        method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
      class_replaceMethod(class, swizzledSelector,
                          method_getImplementation(originalMethod),
                          method_getTypeEncoding(originalMethod));
    } else {
      method_exchangeImplementations(originalMethod, swizzledMethod);
    }
  });
}

#pragma mark - Method Swizzling

- (NSDictionary *)default_headerField {
  if ([self default_headerField] == nil) {
    NSMutableDictionary *head = [NSMutableDictionary dictionaryWithCapacity:10];
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)) {
      [head setValue:[[[ASIdentifierManager sharedManager]
                         advertisingIdentifier] UUIDString]
              forKey:@"mobile_idfa"];
    }
    [head setValue:[[UIDevice currentDevice] platform] forKey:@"mobile_model"];
    [head setValue:kChannelId forKey:@"channel_id"];
    [head setValue:kChannelName forKey:@"channel_name"];
    [head setValue:[DataEngine sharedDataEngine].sessionId
            forKey:@"session_id"];
    [head setValue:[self appVersion] forKey:@"version"];
    [head setValue:APP_UUID forKey:@"app_uuid"];

    [head setValue:[[UIDevice currentDevice] model]
            forKey:@"deviceType"]; // 设备类型：iPhone/touch
    [head setValue:[[UIDevice currentDevice] systemVersion]
            forKey:@"os"]; // 系统版本号

    // 获取设备管理器实例
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    // 获取设备指纹黑盒数据，请确保在应用开启时已经对SDK进行初始化，切勿在get的时候才初始化
    NSString *blackBox = manager->getDeviceInfo();
    // 将blackBox随业务请求提交到你的服务端，服务端调用同盾风险决策API时需要带上这个参数
    [head setValue:blackBox forKey:@"black_box"]; // 系统版本号

    if ([USER_LATITUDE length]) {
      [head setValue:USER_LATITUDE forKey:@"latitude"];
    }

    if ([USER_LONGITUDE length]) {

      [head setValue:USER_LONGITUDE forKey:@"longitude"];
    }
    [self setHeaderField:[head copy]];
  }

  return [self default_headerField];
}

static char versionKey;

- (NSString *)appVersion {

  NSString *currentVersion = objc_getAssociatedObject(self, &versionKey);

  if (!currentVersion) {
    NSDictionary *softwareInfo = [[NSDictionary alloc]
        initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",
                                                          [[NSBundle mainBundle]
                                                              bundlePath],
                                                          @"Info.plist"]];
    NSString *currentVersion = [softwareInfo objectForKey:@"CFBundleVersion"];
    objc_setAssociatedObject(self, &versionKey, currentVersion,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }

  return currentVersion;
}

@end
