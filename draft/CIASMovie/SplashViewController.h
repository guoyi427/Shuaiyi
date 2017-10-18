//
//  SplashViewController.h
//  CIASMovie
//
//  Created by cias on 2016/12/6.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConfig.h"

@interface SplashViewController : UIViewController
{
    UIImageView *cameraImageView, *futureCinemaImageView, *popcornImageView;
    int timeCount;
}
@property (nonatomic, strong) NSTimer *timerOfSplash;
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
