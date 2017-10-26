//
//  圆角的按钮
//
//  Created by gree2 on 21/11/13.
//  Copyright (c) 2013 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "RoundCornersButton.h"

@implementation RoundCornersButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)dealloc {
    self.backgroundColor = nil;
    self.rimColor = nil;
    self.fillColor = nil;
    self.titleName = nil;
    self.subTitleName = nil;
    self.titleFont = nil;
    self.subTitleFont = nil;
    self.titleColor = nil;
    self.subTitleColor = nil;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (self.rimWidth != 0) {

        // 画圆角矩形边框
        [self.rimColor setStroke]; // 设置线条颜色

        // 设置填充颜色
        if (self.fillColor) {
            [self.fillColor setFill];
        } else {
            [[UIColor whiteColor] setFill];
        }

        CGRect rect1 = CGRectMake(self.rimWidth / 2, self.rimWidth / 2, rect.size.width - self.rimWidth, rect.size.height - self.rimWidth);
        [self drawRectangle:rect1 withRadius:self.cornerNum];

    } else {

        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.backgroundColor set];

        CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
        CGContextSetLineWidth(context, 0);

        [self drawRoundedRectInFrame:rect
                            withRadius:self.cornerNum
                             inContext:context];
    }

    if (self.titleName) {

        CGFloat height = self.titleFont.pointSize + 2;
        [self.titleColor set];
        CGRect titleNameRect = CGRectMake(0, rect.size.height / 2 - height / 2, rect.size.width, height);
        [self drawRectTitleName:self.titleName withTitleFont:self.titleFont andRect:titleNameRect andAlignment:NSTextAlignmentCenter andColor:self.titleColor];

    } else if (self.subTitleName && self.titleName) {

        CGRect mainRect, subRect;
        subRect = CGRectMake(rect.size.width / 8, rect.size.height / 2 - 8, rect.size.width * 3 / 8, 16);
        mainRect = CGRectMake(rect.size.width * 4 / 8, rect.size.height / 2 - 8, rect.size.width * 4 / 8, 16);

        [self.subTitleColor set];
        [self drawRectTitleName:self.subTitleName withTitleFont:self.subTitleFont andRect:subRect andAlignment:NSTextAlignmentLeft andColor:self.subTitleColor];

        [self.titleColor set];
        [self drawRectTitleName:self.titleName withTitleFont:self.titleFont andRect:mainRect andAlignment:NSTextAlignmentLeft andColor:self.titleColor];
    }
}

// 圆角矩形边框
- (void)drawRectangle:(CGRect)rect withRadius:(float)radius {

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.rimWidth);

    CGMutablePathRef pathRef = [self pathwithFrame:rect withRadius:radius];

    CGContextAddPath(context, pathRef);
    CGContextDrawPath(context, kCGPathFillStroke);

    CGPathRelease(pathRef);
}

// 圆角矩形
- (void)drawRoundedRectInFrame:(CGRect)rect
                    withRadius:(float)radius
                     inContext:(CGContextRef)context {

    CGFloat minx = CGRectGetMinX(rect);
    CGFloat midx = CGRectGetMidX(rect);
    CGFloat maxx = CGRectGetMaxX(rect);

    CGFloat miny = CGRectGetMinY(rect);
    CGFloat midy = CGRectGetMidY(rect);
    CGFloat maxy = CGRectGetMaxY(rect);

    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);

    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)drawRectTitleName:(NSString *)titleN withTitleFont:(UIFont *)font andRect:(CGRect)rect andAlignment:(NSTextAlignment)alignment andColor:(UIColor *)color {

    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = alignment;
    paragraph.lineBreakMode = NSLineBreakByTruncatingTail;
    NSDictionary *attribute = @{NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraph, NSForegroundColorAttributeName : color};
    [titleN drawInRect:rect withAttributes:attribute];
}

- (CGMutablePathRef)pathwithFrame:(CGRect)frame withRadius:(float)radius {
    CGPoint x1, x2, x3, x4; // x为4个顶点
    CGPoint y1, y2, y3, y4, y5, y6, y7, y8; // y为4个控制点
    // 从左上角顶点开始，顺时针旋转,x1->y1->y2->x2

    x1 = frame.origin;
    x2 = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y);
    x3 = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height);
    x4 = CGPointMake(frame.origin.x, frame.origin.y + frame.size.height);

    y1 = CGPointMake(frame.origin.x + radius, frame.origin.y);
    y2 = CGPointMake(frame.origin.x + frame.size.width - radius, frame.origin.y);
    y3 = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y + radius);
    y4 = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height - radius);

    y5 = CGPointMake(frame.origin.x + frame.size.width - radius, frame.origin.y + frame.size.height);
    y6 = CGPointMake(frame.origin.x + radius, frame.origin.y + frame.size.height);
    y7 = CGPointMake(frame.origin.x, frame.origin.y + frame.size.height - radius);
    y8 = CGPointMake(frame.origin.x, frame.origin.y + radius);

    CGMutablePathRef pathRef = CGPathCreateMutable();

    if (radius <= 0) {
        CGPathMoveToPoint(pathRef, &CGAffineTransformIdentity, x1.x, x1.y);
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x2.x, x2.y);
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x3.x, x3.y);
        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, x4.x, x4.y);
    } else {
        CGPathMoveToPoint(pathRef, &CGAffineTransformIdentity, y1.x, y1.y);

        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y2.x, y2.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity, x2.x, x2.y, y3.x, y3.y, radius);

        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y4.x, y4.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity, x3.x, x3.y, y5.x, y5.y, radius);

        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y6.x, y6.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity, x4.x, x4.y, y7.x, y7.y, radius);

        CGPathAddLineToPoint(pathRef, &CGAffineTransformIdentity, y8.x, y8.y);
        CGPathAddArcToPoint(pathRef, &CGAffineTransformIdentity, x1.x, x1.y, y1.x, y1.y, radius);
    }
    CGPathCloseSubpath(pathRef);
    return pathRef;
}

- (void)setTitleName:(NSString *)titleName {
    _titleName = titleName;
    [self setNeedsDisplay];
}

@end
