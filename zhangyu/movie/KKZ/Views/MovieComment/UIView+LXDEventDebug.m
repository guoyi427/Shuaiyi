//
//  UIView+LXDEventDebug.m
//  LXDEventChain
//
//  Created by 滕雪 on 15/12/26.
//  Copyright © 2015年 滕雪. All rights reserved.
//

#import "UIView+LXDEventDebug.h"
#import <objc/runtime.h>

@implementation UIView (LXDEventDebug)

+ (void)load
{
//    Method origin = class_getInstanceMethod([self class], @selector(pointInside:withEvent:));
//    Method custom = class_getInstanceMethod([self class], @selector(lxd_pointInside:withEvent:));
//    method_exchangeImplementations(origin, custom);
//    
//    origin = class_getInstanceMethod([self class], @selector(hitTest:withEvent:));
//    custom = class_getInstanceMethod([self class], @selector(lxd_hitTest:withEvent:));
//    method_exchangeImplementations(origin, custom);
}

- (BOOL)lxd_pointInside: (CGPoint)point withEvent: (UIEvent *)event
{
    BOOL canAnswer = [self lxd_pointInside: point withEvent: event];
    NSLog(@"%@ can answer %d", self.class, canAnswer);
    return canAnswer;
}

- (UIView *)lxd_hitTest: (CGPoint)point withEvent: (UIEvent *)event
{
    UIView * answerView = [self lxd_hitTest: point withEvent: event];
    NSLog(@"class===%@   hit view: %@", self.class,answerView);
    return answerView;
}




@end


@implementation UIViewController (LXDEventDebug)

@end
