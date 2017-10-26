//
//  KKZRotationLoopProgressView.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/16.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "KKZRotationLoopProgressView.h"
#import "UIColor+Hex.h"

// 加载时显示的文字
NSString * const SDRotationLoopProgressViewWaitingText = @"LOADING...";

//#define SDProgressViewItemMargin 10
#define SDProgressViewFontScale (MIN(self.frame.size.width, self.frame.size.height) / 100.0)

@implementation KKZRotationLoopProgressView
{
    //角度变换
    CGFloat _angleInterval;
    
    //定时器
    NSTimer *timer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)beginAnimation {
    timer = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                             target:self
                                           selector:@selector(changeAngle)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)stopAnimation {
    [timer invalidate];
    _angleInterval = 0.0f;
}

- (void)changeAngle
{
    _angleInterval += M_PI * 0.08;
    if (_angleInterval >= M_PI * 2) _angleInterval = 0;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    
    CGContextSetLineWidth(ctx, 2);
    CGFloat radius = rect.size.width / 2.0f - 3;
    
    [[UIColor colorWithHex:@"#666666"] set];
    CGContextAddArc(ctx, xCenter, yCenter, radius, 0, M_PI * 2, 1);
     CGContextStrokePath(ctx);
    
    CGFloat to = M_PI * 0.2 + _angleInterval; // 初始值0.05
    [[UIColor colorWithHex:@"#f9c452"] set];
    CGContextAddArc(ctx, xCenter, yCenter, radius, _angleInterval, to, 0);
    CGContextStrokePath(ctx);
    
    // 加载时显示的文字
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:13 * SDProgressViewFontScale];
    attributes[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    CGSize strSize = [SDRotationLoopProgressViewWaitingText sizeWithAttributes:attributes];
    CGFloat strX = xCenter - strSize.width * 0.5;
    CGFloat strY = yCenter - strSize.height * 0.5;
    [SDRotationLoopProgressViewWaitingText drawAtPoint:CGPointMake(strX, strY)
                                        withAttributes:attributes];
}

@end
