//
//  UIViewController+NavAnim.m
//  KoMovie
//
//  Created by 艾广华 on 16/1/26.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "UIViewController+NavAnim.h"
#import <objc/runtime.h>

static NSString *BLOCK_ASS_KEY = @"com.random-ideas.BUTTONS";

@implementation UIViewController (NavAnim)
@dynamic switchAnimation;

- (CommonSwitchAnimation)switchAnimation {
    NSNumber *animationNumber =  objc_getAssociatedObject(self, (__bridge const void *)(BLOCK_ASS_KEY));
    return [animationNumber intValue];
}

- (void)setSwitchAnimation:(CommonSwitchAnimation)switchAnimation {
    objc_setAssociatedObject(self, (__bridge const void *)(BLOCK_ASS_KEY),@(switchAnimation), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
