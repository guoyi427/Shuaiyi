//
//  ShowMoreButton.h
//  kokozu
//
//  Created by zhang da on 10-10-20.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

typedef enum{
	ShowMoreButtonStateLoading = 0,
	ShowMoreButtonStateNormal
} ShowMoreButtonState;

#import <UIKit/UIKit.h>

@class ShowMoreButton;

@protocol ShowMoreButtonDelegate <NSObject>
@optional
- (void)handleTouchToShowMore:(id)sender;
@end

@interface ShowMoreButton: UIView {
	id <ShowMoreButtonDelegate>  delegate;
	
	UILabel *statusLabel;
	UIActivityIndicatorView *activityView;
	UIButton *startLoadBtn;
	
	ShowMoreButtonState state;
}

@property (nonatomic, assign) id <ShowMoreButtonDelegate> delegate;
@property (nonatomic, assign) ShowMoreButtonState state;

- (void)setBgColor:(UIColor *)bgColor textColor:(UIColor *)tColor;
- (void)setContentFrame:(CGRect)frame;
@end