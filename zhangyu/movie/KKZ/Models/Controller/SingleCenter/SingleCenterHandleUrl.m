//
//  SingleCenterHandleUrl.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/22.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "SingleCenterHandleUrl.h"
#import <objc/runtime.h>
#import "WebViewController.h"
#import "EvaluationViewController.h"
#import "CommonSecondWebViewController.h"
#import "CommonWebViewController.h"
#import "ShoppingCartViewController.h"

/***********自定义请求**********/
static NSString *customProtocol = @"komovie";
static NSString *customHost = @"app";
static NSString *customPath = @"/page";
static NSString *queryKey = @"name";

/***********HTTP请求**********/
static NSString *httprotocol = @"http";

static NSMutableArray *handleArr;

@implementation SingleCenterHandleUrl

+ (NSMutableArray *)getNeedHandleControllerName {
    if (!handleArr) {
        handleArr = [[NSMutableArray alloc] initWithObjects:@"", @"", nil];
    }
    return handleArr;
}

+ (BOOL)isOPenLocalController:(NSURL *)url {
    NSString *scheme = [url scheme];
    NSString *host = [url host];
    NSString *path = [url path];
    if ([scheme isEqualToString:customProtocol]) {
        if ([host isEqualToString:customHost]) {
            if ([path isEqualToString:customPath]) {
                return TRUE;
            }
        }
    }
    return FALSE;
}

+ (BOOL)isHttpRequest:(NSURL *)url {
    NSString *scheme = [url scheme];
    if ([scheme isEqualToString:httprotocol]) {
        return TRUE;
    }
    return FALSE;
}

+ (void)handleWithUrl:(NSURL *)url
             withName:(NSString *)name
        withResponder:(CommonViewController *)controller {

    //设置页面
    NSDictionary *query = [url queryParams];
    if ([self isOPenLocalController:url]) {
        NSString *controllerName = [query valueForKey:queryKey];
        if (controllerName) {
            Class newClass = objc_getClass([controllerName UTF8String]);
            id instance = [[newClass alloc] init];
            if ([controllerName isEqualToString:@"EvaluationViewController"]) {
                [controller pushViewController:instance
                                     animation:CommonSwitchAnimationBounce];
            } else {
                [controller pushViewController:instance
                                     animation:CommonSwitchAnimationBounce];
            }
        }
    } else if ([self isHttpRequest:url]) {
        if ([name isEqualToString:@"购物车"]) {
            ShoppingCartViewController *shop = [[ShoppingCartViewController alloc] init];
            [controller pushViewController:shop
                                 animation:CommonSwitchAnimationBounce];
        } else {
            CommonWebViewController *ctr = [[CommonWebViewController alloc] init];
            ctr.requestURL = url.absoluteString;
            [controller pushViewController:ctr
                                 animation:CommonSwitchAnimationBounce];
        }
    }
}

@end
