//
//  UIViewController+NavAnim.h
//  KoMovie
//
//  Created by 艾广华 on 16/1/26.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    CommonSwitchAnimationNone = 0,
    CommonSwitchAnimationBounce, //弹出动画
    CommonSwitchAnimationFlipR,
    CommonSwitchAnimationFlipL,
    
    CommonSwitchAnimationSwipeL2R, //左到右
    CommonSwitchAnimationSwipeR2L, //右到左
    CommonSwitchAnimationSwipeD2U, //下到上
    CommonSwitchAnimationSwipeU2D,  //上到下
    
    CommonSwitchAnimationFade, //渐隐渐显
    
} CommonSwitchAnimation;

@interface UIViewController (NavAnim)

/**
 *  切换动画
 */
@property (nonatomic, assign) CommonSwitchAnimation switchAnimation;

@end
