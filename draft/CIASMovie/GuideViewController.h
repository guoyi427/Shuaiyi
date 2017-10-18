//
//  GuideViewController.h
//  CIASMovie
//
//  Created by avatar on 2017/2/21.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WelcomeView.h"

@interface GuideViewController : UIViewController<WelcomeViewDelegate>
{
    UIImageView *cameraImageView, *futureCinemaImageView, *popcornImageView;
    int timeCount;
}
@property (nonatomic,strong) WelcomeView *welcome;
@property (nonatomic, copy) void (^dismissBlock)();
@property (nonatomic, copy) void (^willDismissBlock)();

/**
 *  will dismiss，将开始淡出动画
 *
 *  @param a_block 回调
 */
- (void) willDismiss:(void (^)())a_block;
/**
 *  结束或跳过回调
 *
 *  @param a_block 回调
 */
- (void) dismissCallback:(void (^)())a_block;
@end
