//
//  UIButton+Block.m
//  CIASMovie
//
//  Created by avatar on 2017/6/29.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

@implementation UIButton (Block)


- (void)handleWithBlock:(CMSHandlerBlock)block {
    
    objc_setAssociatedObject(self, @selector(cms_buttonTouchAction), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self addTarget:self action:@selector(cms_buttonTouchAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cms_buttonTouchAction {
    
    CMSHandlerBlock block = objc_getAssociatedObject(self, _cmd);
    
    if (block) {
        
        block(self);
        
    }
}




@end
