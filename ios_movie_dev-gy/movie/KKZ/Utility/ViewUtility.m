//
//  ViewUtility.m
//  KoMovie
//
//  Created by wuzhen on 15/7/15.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "ViewUtility.h"


@implementation ViewUtility



/**
 * draw 一条直线。
 */
+ (void)drawLine:(UIColor *)color startX:(CGFloat)startX startY:(CGFloat)startY endX:(CGFloat)endX endY:(CGFloat)endY {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color set];
    CGContextSetLineWidth(context, 0.6);
    CGContextMoveToPoint(context, startX, startY);
    CGContextAddLineToPoint(context, endX, endY);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}



@end

