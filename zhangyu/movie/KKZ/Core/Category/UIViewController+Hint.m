//
//  扩展UIWebController添加弱提示的功能
//
//  Created by wuzhen on 16/8/18.
//  Copyright (c) 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "UIViewController+Hint.h"

#import "KKZHintView.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (Hint)

- (MBProgressHUD *)HUD {
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD {
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHint:(NSString *)hint {
    [self showHint:hint autoHide:YES];
}

- (void)showHint:(NSString *)hint autoHide:(BOOL)autoHide {
    MBProgressHUD *hud = [KKZHintView showHint:hint autoHide:autoHide];
    if (!autoHide) {
        [self setHUD:hud];
    }
}

- (void)hideHint {
    [[self HUD] hide:YES];
}

@end
