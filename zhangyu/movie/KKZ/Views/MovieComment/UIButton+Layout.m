//
//  UIButton+Layout.m
//  KoMovie
//
//  Created by 艾广华 on 16/1/29.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "UIButton+Layout.h"

@implementation UIButton (Layout)

- (void)setOriginY:(CGFloat)originY {
    CGRect frame = self.frame;
    frame.origin.y = originY;
    self.frame = frame;
}

- (void)setOriginX:(CGFloat)originX {
    CGRect frame = self.frame;
    frame.origin.x = originX;
    self.frame = frame;
}

@end
