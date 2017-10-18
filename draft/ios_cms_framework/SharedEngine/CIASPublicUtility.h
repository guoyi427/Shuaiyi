//
//  CIASPublicUtility.h
//  CIASMovie
//
//  Created by cias on 2017/1/13.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIASPublicUtility : NSObject

@property (nonatomic, retain) NSString *kShowLog;

+ (CIASPublicUtility *)sharedEngine;

//show  AlertView
+ (void)showAlertViewForTitle:(NSString *)title
                      message:(NSString *)message
                 cancelButton:(NSString *)cancelButtonTitle;
//网络请求回来对返回的userInfo处理
+ (void)showAlertViewForTaskInfo:(NSError *)errorInfo;


+ (void)showMyAlertViewForTaskInfo:(NSError *)errorInfo;

+(NSURL *) getUrlDeleteChineseWithString:(NSString *)urlStr;

- (void)applyThirdPartySDK;
//自动更新
- (void)checkAppUpdate;

@end
