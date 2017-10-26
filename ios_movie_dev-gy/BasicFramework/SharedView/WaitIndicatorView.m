//
//  WaitIndicatorView.m
//  kokozu
//
//  Created by da zhang on 11-6-7.
//  Copyright 2011 kokozu. All rights reserved.
//

#import "WaitIndicatorView.h"
#import <QuartzCore/QuartzCore.h>


@implementation WaitIndicatorView

@synthesize title, subTitle, animated, alpa, fullScreen;
//
//- (void)setTitle:(NSString *)value {
//    if (![value isEqualToString:title]) {
//        [title release];
//        title = [value copy];
//    }
//}
//
//- (void)setAnimated:(BOOL)value {
//    if (animated != value) {
//        animated = value;
//    }
//}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];

        originY = frame.origin.y;

        indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(149,
                                                                                  originY + 11,
                                                                                  28,
                                                                                  28)];
        [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        if (runningOniOS5) {
            [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
            indicatorView.frame = CGRectMake(149, originY + 11, 28, 28);
        }
        indicatorView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2);
		indicatorView.backgroundColor = [UIColor clearColor];
        indicatorView.hidesWhenStopped = YES;
		[self addSubview:indicatorView];
    }
    return self;
}

- (void)dealloc {
    [indicatorView release];

    self.title = nil;
    self.subTitle = nil;
    [super dealloc];
}

// addRoundedRectToPath: Source based on Apple Sample Code
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight, UIColor *strokeColor, float stokeAlpha, UIColor *fillColor, float fillAlpha)
{
    CGContextSetStrokeColorWithColor(context, [strokeColor alpha:stokeAlpha].CGColor);
    CGContextSetFillColorWithColor(context, [fillColor alpha:fillAlpha].CGColor);
    CGContextSetLineWidth(context, 0.06);
    
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        return;
    }
    
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context=UIGraphicsGetCurrentContext();
    if (self.alpa) {
        CGContextSetRGBFillColor(context, 0.1, 0.1, 0.1, self.alpa);
        CGContextSetRGBStrokeColor(context, 0.1, 0.1, 0.1, self.alpa);
    }else{
        CGContextSetRGBFillColor(context, 0, 0, 0, .8);
    }
    CGRect rrect;
    if (!self.fullScreen) {
        rrect = CGRectMake(0, 0, 90*1.2, 66*1.2);

    }else {
        originY = (screentContentHeight - 100)/2 - 24;
        rrect = CGRectMake((rect.size.width - 90*1.2)/2, originY, 90*1.2, 66*1.2);

    }
    addRoundedRectToPath(context, rrect, 8, 8, [UIColor blackColor], 0.8, [UIColor blackColor], 0.8);

//    CGContextAddRect(context, rrect);
//    CGFloat radius = 8.0;
//    
//    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect); 
//    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect); 
//    
//    CGContextMoveToPoint(context, minx, midy); 
//    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius); 
//    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius); 
//    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius); 
//    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius); 
//    CGContextClosePath(context); 
    CGContextDrawPath(context, kCGPathFillStroke);
    
    /*
     UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(123, frame.origin.y + 38, 74, 20)];
     label.numberOfLines = 3;
     label.textAlignment = NSTextAlignmentCenter;
     label.backgroundColor = [UIColor clearColor];
     label.text = labelText;
     label.textColor = [UIColor whiteColor];
     label.font = [UIFont boldSystemFontOfSize:11];
     [self addSubview:label];
     [label release];
     [indicatorBackView release];
     */
    [[UIColor whiteColor] set];

    if (!self.fullScreen) {
        if (animated) {
            //add indicator here
            [indicatorView startAnimating];
            
            if (self.subTitle) {
                [title drawInRect:CGRectMake(5, 40, 100, 20)
                         withFont:[UIFont boldSystemFontOfSize:13]
                    lineBreakMode:NSLineBreakByTruncatingTail
                        alignment:NSTextAlignmentCenter];
                [self.subTitle drawInRect:CGRectMake(5, 58, 100, 20)
                                 withFont:[UIFont boldSystemFontOfSize:10]
                            lineBreakMode:NSLineBreakByTruncatingTail
                                alignment:NSTextAlignmentCenter];
            }else {
                [title drawInRect:CGRectMake(5, 48, 100, 20)
                         withFont:[UIFont boldSystemFontOfSize:13]
                    lineBreakMode:NSLineBreakByTruncatingTail
                        alignment:NSTextAlignmentCenter];
            }
            
            indicatorView.frame = CGRectMake((108 - 28)/2,
                                             12,
                                             indicatorView.frame.size.width,
                                             indicatorView.frame.size.width);
        } else {
            [indicatorView stopAnimating];
            CGSize strSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:13]
                               constrainedToSize:CGSizeMake(80, 66*1.2)
                                   lineBreakMode:NSLineBreakByTruncatingTail];
//            if (strSize.height > 44) strSize.height = 44;
            if (self.subTitle) {
                [title drawInRect:CGRectMake(5, 30, 100, 20)
                         withFont:[UIFont boldSystemFontOfSize:13]
                    lineBreakMode:NSLineBreakByTruncatingTail
                        alignment:NSTextAlignmentCenter];
                [self.subTitle drawInRect:CGRectMake(5, 48, 100, 20)
                                 withFont:[UIFont boldSystemFontOfSize:10]
                            lineBreakMode:NSLineBreakByTruncatingTail
                                alignment:NSTextAlignmentCenter];
            }else {
                [title drawInRect:CGRectMake(5, (66*1.2-strSize.height)/2, 100, 66*1.2)
                         withFont:[UIFont boldSystemFontOfSize:13]
                    lineBreakMode:NSLineBreakByTruncatingTail
                        alignment:NSTextAlignmentCenter];
            }
        }
        
    }else {
        if (animated) {
            //add indicator here
            [indicatorView startAnimating];
            [title drawInRect:CGRectMake(CGRectGetMidX(rrect) - 80.0f/2.0f, originY + 43, 80, 20)
                     withFont:[UIFont boldSystemFontOfSize:13]
                lineBreakMode:NSLineBreakByTruncatingTail
                    alignment:NSTextAlignmentCenter];
            if (self.subTitle) {
                [self.subTitle drawInRect:CGRectMake(CGRectGetMidX(rrect) - 80.0f/2.0f, originY + 62, 80, 20)
                                 withFont:[UIFont boldSystemFontOfSize:9]
                            lineBreakMode:NSLineBreakByTruncatingTail
                                alignment:NSTextAlignmentCenter];
            }
            indicatorView.frame = CGRectMake(CGRectGetMidX(rrect) - indicatorView.frame.size.width/2.0f,
                                             originY + 15,
                                             indicatorView.frame.size.width,
                                             indicatorView.frame.size.width);
        } else {
            [indicatorView stopAnimating];
            
            if (self.subTitle) {
                [title drawInRect:CGRectMake(CGRectGetMidX(rrect) - 100.0f/2.0f, CGRectGetMinY(rrect) + 20.0f, 100, 20)
                         withFont:[UIFont boldSystemFontOfSize:13]
                    lineBreakMode:NSLineBreakByTruncatingTail
                        alignment:NSTextAlignmentCenter];
                [self.subTitle drawInRect:CGRectMake(CGRectGetMidX(rrect) - 100.0f/2.0f, CGRectGetMinY(rrect) + 45.0f, 100, 20)
                                 withFont:[UIFont boldSystemFontOfSize:10]
                            lineBreakMode:NSLineBreakByTruncatingTail
                                alignment:NSTextAlignmentCenter];
            }else {
                [title drawInRect:CGRectMake(CGRectGetMidX(rrect) - 100.0f/2.0f,CGRectGetMidY(rrect)-5.0f,100, 66*1.2)
                         withFont:[UIFont boldSystemFontOfSize:13]
                    lineBreakMode:NSLineBreakByTruncatingTail
                        alignment:NSTextAlignmentCenter];
            }
        }
        
    }
}

- (void)updateLayout {
    if (!self.fullScreen) {
        indicatorView.frame = CGRectMake((108 - 28)/2, 0, 28, 28);
    }
	[self setNeedsDisplay];
}

@end
