//
//  跑马灯的控件
//
//  Created by KKZ on 15/11/10.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "XMLampText.h"

@implementation XMLampText

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setMotionWidth:(float)motionWidth {
    _motionWidth = motionWidth;
    self.text = self.lampText;
    self.font = self.lampFont;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    float width = self.frame.size.width;
    if (self.motionWidth >= width) {
        [self.layer removeAllAnimations];
        return;
    }

    CGRect frame = self.frame;

    frame.origin.x = 0;
    frame.size.width = width;
    self.frame = frame;

    [UIView beginAnimations:@"LampAnimation" context:NULL];
    [UIView setAnimationDuration:5.0f * width / self.motionWidth];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationRepeatCount:9999];

    frame = self.frame;
    frame.origin.x = -width;
    self.frame = frame;
    [UIView commitAnimations];
}

@end
