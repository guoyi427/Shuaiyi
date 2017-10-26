//
//  ShowMoreButton.m
//  kokozu
//
//  Created by zhang da on 10-10-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ShowMoreButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation ShowMoreButton

@synthesize state, delegate;

- (void)setState:(ShowMoreButtonState)value {
	if (state != value) {
		state = value;
		if (value == ShowMoreButtonStateNormal) {
			[activityView stopAnimating];
			statusLabel.text = @"点击加载更多"; 
		} else {
			[activityView startAnimating];
			statusLabel.text = @"加载中";
		}
	}
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor =  [UIColor whiteColor];
        //self. backgroundColor = [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];

        startLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		startLoadBtn.frame = CGRectMake(0, 0, 320, frame.size.height);
		[startLoadBtn addTarget:self action:@selector(btnTouched) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:startLoadBtn];
		[startLoadBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		statusLabel = [[UILabel alloc] initWithFrame:CGRectMake((frame.size.width - 160)/2, 0, 160, frame.size.height)];
		statusLabel.font = [UIFont systemFontOfSize:16.0];
		statusLabel.backgroundColor = self.backgroundColor;
//        statusLabel.shadowColor = [UIColor whiteColor];
//        statusLabel.shadowOffset = CGSizeMake(0, -.5);
//		  statusLabel.opaque = YES;
        [statusLabel setTextColor:[UIColor darkGrayColor]];
		statusLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:statusLabel];
		
		activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		activityView.frame = CGRectMake((frame.size.width - 160)/2 - 10, (frame.size.height - 20.0)/2.0, 20.0f, 20.0f);
		activityView.hidesWhenStopped = YES;
		[self addSubview:activityView];
        
//        CGColorRef darkColor = [[UIColor blackColor] colorWithAlphaComponent:.2f].CGColor;  
//        CGColorRef lightColor = [UIColor clearColor].CGColor;  
        
        //Footer shadow  
//        UIView *headerShadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];  
//        CAGradientLayer *headShadow = [[[CAGradientLayer alloc] init] autorelease];  
//        headShadow.frame = CGRectMake(0, 0, 320, 10);  
//        headShadow.colors = [NSArray arrayWithObjects:(id)darkColor, (id)lightColor, nil]; 
//        headerShadow.alpha = 0.5;  
//        [headerShadow.layer addSublayer:headShadow];  
//        [self addSubview:headerShadow];
//        [headerShadow release];
//        
//        UIView *footerShadow = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 10, 320, 10)];  
//        CAGradientLayer *bottomShadow = [[[CAGradientLayer alloc] init] autorelease];  
//        bottomShadow.frame = CGRectMake(0, 0, 320, 10);  
//        bottomShadow.colors = [NSArray arrayWithObjects:(id)lightColor, (id)darkColor, nil]; 
//        footerShadow.alpha = 0.5;  
//        [footerShadow.layer addSublayer:bottomShadow];  
//        [self addSubview:footerShadow];
//        [footerShadow release];
    }
    return self;
}

- (void)setBgColor:(UIColor *)bgColor textColor:(UIColor *)tColor{
    self.backgroundColor = bgColor;
    statusLabel.backgroundColor = bgColor;
    statusLabel.textColor = tColor;
    activityView.color = tColor;
}

- (void)setContentFrame:(CGRect)frame{
    statusLabel.frame = CGRectMake((frame.size.width - 160)/2, 0, 160, frame.size.height);
    activityView.frame = CGRectMake((frame.size.width - 160)/2 - 10, (frame.size.height - 20.0)/2.0, 20.0f, 20.0f);

}

- (void)btnTouched {
	if ([delegate respondsToSelector:@selector(handleTouchToShowMore:)]) {
        [delegate handleTouchToShowMore:self];
    }	
}

- (void)dealloc {
	[activityView release];
	[statusLabel release];
    [super dealloc];
}

@end