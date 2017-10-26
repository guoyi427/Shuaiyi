//
//  PullToRefreshView.m
//  simpleread
//
//  Created by zhang da on 10-10-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PullToRefreshView.h"


@interface PullToRefreshView ()
- (NSString *)getStatesStr:(RefreshState)states;
@end


@implementation PullToRefreshView

@synthesize state, lastUpdatedDate;
@synthesize titleColor;

- (void)setState:(RefreshState)value {
    if (state != value) {
        state = value;
        [self setNeedsDisplay];
        switch (value) {
            case RefreshNormal:
                [activityView stopAnimating];
                break;
            case RefreshLoading:
                [activityView startAnimating];
                break;
            case RefreshPulling:
                [activityView stopAnimating];
                break;
        }
    }
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
        
        self.titleColor = [UIColor blackColor];
        
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityView.frame = CGRectMake(12.5f, frame.size.height/2 - 10.0f, 20.0f, 20.0f);
		activityView.hidesWhenStopped = YES;
        [self addSubview:activityView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self.titleColor set];
    
    [[self getStatesStr:state] drawInRect:CGRectMake(5, rect.size.height/2 -35, 35, 60)
                                         withFont:[UIFont boldSystemFontOfSize:12]
                                    lineBreakMode:NSLineBreakByTruncatingTail
                                        alignment:NSTextAlignmentCenter];
    
//    [appDelegate.bingoBlue set];
//    [@"2" drawInRect:CGRectMake(5, self.frame.size.height/2+ 10, 35, 20) 
//            withFont:[UIFont boldSystemFontOfSize:18] 
//       lineBreakMode:NSLineBreakByTruncatingTail
//           alignment:NSTextAlignmentCenter];
//    
//    [@"min" drawInRect:CGRectMake(5, self.frame.size.height/2+ 30, 35, 15) 
//            withFont:[UIFont boldSystemFontOfSize:10] 
//       lineBreakMode:NSLineBreakByTruncatingTail
//           alignment:NSTextAlignmentCenter];
    
    if (self.frame.origin.x < 0) {
//        CGContextRef ctx = UIGraphicsGetCurrentContext();
//        
//        CGContextMoveToPoint(ctx, 39, self.frame.size.height/2);
//        CGContextAddLineToPoint(ctx, 45, self.frame.size.height/2 + 8);
//        CGContextAddLineToPoint(ctx, 45, self.frame.size.height/2 - 8);
//        CGContextClosePath(ctx);
//        CGContextDrawPath(ctx, kCGPathFillStroke);
    } else {
//        CGContextRef ctx = UIGraphicsGetCurrentContext();
//        
//        CGContextMoveToPoint(ctx, 6, 60);
//        CGContextAddLineToPoint(ctx, 0, 68);
//        CGContextAddLineToPoint(ctx, 0, 52);
//        CGContextClosePath(ctx);
//        CGContextDrawPath(ctx, kCGPathFillStroke);
    }
}

- (NSString *)getStatesStr:(RefreshState)states {
    switch (states) {
        case RefreshNormal:
            return @"左\n拉\n加\n载";
        case RefreshLoading:
            return nil;//@"加载";
        case RefreshPulling:
            return @"松\n开\n刷\n新";
    }
    return nil;
}

- (void)flipImageAnimated:(BOOL)animated {
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:animated ? .22 : 0.0];
//	[arrowImage layer].transform = isFlipped ?
//	CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f) :CATransform3DMakeRotation(M_PI * 2, 0.0f, 0.0f, 1.0f);
//	//CATransform3DMakeTranslation(0, 0, 0):CATransform3DMakeTranslation(0, - 51.0f, 0);
//	
//	[UIView commitAnimations];
}

- (void)setLastUpdatedDate:(NSDate *)newDate {
	/*if (newDate)
	{
		if (lastUpdatedDate != newDate)
		{
			[lastUpdatedDate release];
		}
		
		lastUpdatedDate = [newDate retain];
		
		NSDateFormatter* formatter = [[NSDateFormatter alloc] init]; 
		[formatter setDateStyle:NSDateFormatterShortStyle];
		[formatter setTimeStyle:NSDateFormatterShortStyle];
		lastUpdatedLabel.text = [NSString stringWithFormat:
								 @"Last Updated: %@", [formatter stringFromDate:lastUpdatedDate]];
		[formatter release];
	}
	else
	{
		lastUpdatedDate = nil;
		lastUpdatedLabel.text = @"Last Updated: Never";
	}*/
}

- (void)dealloc {
    [activityView release];
	self.lastUpdatedDate = nil;
    self.titleColor = nil;
    
    [super dealloc];
}

@end