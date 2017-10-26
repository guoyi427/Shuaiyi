//
//  弱提示的View
//
//  Created by wuzhen on 16/8/26.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "KKZHintView.h"

static const NSInteger kHintViewTag = -100;

@implementation KKZHintView

+ (MBProgressHUD *)showHint:(NSString *)hint {
    return [self showHint:hint autoHide:YES];
}

+ (MBProgressHUD *)showHint:(NSString *)hint autoHide:(BOOL)autoHide {
    UIView *view = [[UIApplication sharedApplication].delegate window];
    return [self showHint:hint autoHide:YES addedTo:view];
}

+ (MBProgressHUD *)showHint:(NSString *)hint autoHide:(BOOL)autoHide addedTo:(UIView *)view {
    MBProgressHUD *hud = [self showHintView:hint addedTo:view];
    if (autoHide) { // 自动隐藏
        [hud hide:YES afterDelay:2];
    }
    return hud;
}

+ (MBProgressHUD *)showHintView:(NSString *)hint addedTo:(UIView *)view {
    UIView *subView = [view viewWithTag:kHintViewTag];
    if (subView && [subView isKindOfClass:[MBProgressHUD class]]) {
        return (MBProgressHUD *) subView;
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.tag = kHintViewTag;
    hud.userInteractionEnabled = NO;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.cornerRadius = 6.f;
    hud.margin = 10.f;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = hint;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15];
    hud.yOffset = screentHeight / 2.f - 90.f;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

@end
