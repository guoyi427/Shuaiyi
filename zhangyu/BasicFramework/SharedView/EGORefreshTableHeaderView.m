//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"
#import "DateEngine.h"

//#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
//#define BORDER_COLOR [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]


@implementation EGORefreshTableHeaderView

@synthesize state=_state;



- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
//		lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 25.0f, self.frame.size.width, 20.0f)];
//		lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//		lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
//		lastUpdatedLabel.textColor = [UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1.0];
//		lastUpdatedLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//		lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
//		lastUpdatedLabel.backgroundColor = [UIColor clearColor];
//		lastUpdatedLabel.textAlignment = NSTextAlignmentCenter;
//		[self addSubview:lastUpdatedLabel];
//		[lastUpdatedLabel release];
//		
//        [self setCurrentDate];
		
		statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 35, self.frame.size.width, 20)];
		statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		statusLabel.font = [UIFont boldSystemFontOfSize:13.0f];
		statusLabel.textColor = [UIColor colorWithRed:84/255.0 green:84/255.0 blue:84/255.0 alpha:1.0];
//		statusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//		statusLabel.shadowOffset = CGSizeMake(0.0f, -1.0f);
		statusLabel.backgroundColor = [UIColor clearColor];
		statusLabel.textAlignment = NSTextAlignmentCenter;
		[self setState:EGOOPullRefreshNormal];
		[self addSubview:statusLabel];
		[statusLabel release];
		
//		arrowImage = [[CALayer alloc] init];
//		arrowImage.frame = CGRectMake(25, frame.size.height - 47, 24, 44);
//		arrowImage.contentsGravity = kCAGravityResizeAspect;
//		arrowImage.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
//		[[self layer] addSublayer:arrowImage];
//		[arrowImage release];
		
		activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityView.frame = CGRectMake((frame.size.width - 20)/2, frame.size.height - 35, 20, 20);
		activityView.hidesWhenStopped = YES;
		[self addSubview:activityView];
		[activityView release];
        
//        CGColorRef darkColor = [[UIColor blackColor] colorWithAlphaComponent:.3f].CGColor;  
//        CGColorRef lightColor = [UIColor clearColor].CGColor;  
        
        //Footer shadow  
//        UIView *footerShadow = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 15, 320, 15)];  
//        CAGradientLayer *bottomShadow = [[[CAGradientLayer alloc] init] autorelease];  
//        bottomShadow.frame = CGRectMake(0, 0, 320, 15);  
//        bottomShadow.colors = [NSArray arrayWithObjects:(id)lightColor, (id)darkColor, nil]; 
//        footerShadow.alpha = 0.3;  
//        [footerShadow.layer addSublayer:bottomShadow];  
//        [self addSubview:footerShadow];
//        [footerShadow release];
		
    }
    return self;
}

/*
- (void)drawRect:(CGRect)rect{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawPath(context,  kCGPathFillStroke);
	[BORDER_COLOR setStroke];
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, 0.0f, self.bounds.size.height - 1);
	CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height - 1);
	CGContextStrokePath(context);
}
*/

- (void)setBackgroundColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor {
    self.backgroundColor = bgColor;
    statusLabel.textColor = titleColor;
}

- (void)setCurrentDate {
    lastUpdatedLabel.text = [NSString stringWithFormat:@"更新时间 %@", 
                             [[DateEngine sharedDateEngine] refreshHeaderStringFromDate:[NSDate date]] ];
}

- (void)setLastUpdateTime:(NSDate *)time {
    if (!time) {
        [self setCurrentDate];
    } else {
        lastUpdatedLabel.text = [NSString stringWithFormat:@"更新时间 %@", 
                                 [[DateEngine sharedDateEngine] refreshHeaderStringFromDate:time] ];
    }
}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			statusLabel.text = @"松开立即刷新";
//			[CATransaction begin];
//			[CATransaction setAnimationDuration:.18];
//			arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
//			[CATransaction commit];
			
			break;
            
            
            
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
//				[CATransaction begin];
//				[CATransaction setAnimationDuration:.18];
//				arrowImage.transform = CATransform3DIdentity;
//				[CATransaction commit];
			}
			
			statusLabel.text = @"下拉可以刷新";
			[activityView stopAnimating];
//			[CATransaction begin];
//			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
//			arrowImage.hidden = NO;
//			arrowImage.transform = CATransform3DIdentity;
//			[CATransaction commit];
			
			break;
            
		case EGOOPullRefreshLoading:
			
			statusLabel.text = @"";
			[activityView startAnimating];
//			[CATransaction begin];
//			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
//			arrowImage.hidden = YES;
//			[CATransaction commit];
			
			break;
            
            
        case EGOOPullRefreshNone:
			
			statusLabel.text = @"";
            [activityView stopAnimating];

			break;
            
		default:
			break;
	}
	
	_state = aState;
}

- (void)setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style{
    [activityView setActivityIndicatorViewStyle:style];
}

- (void)dealloc {
	activityView = nil;
	statusLabel = nil;
	arrowImage = nil;
	lastUpdatedLabel = nil;
    [super dealloc];
}


@end
