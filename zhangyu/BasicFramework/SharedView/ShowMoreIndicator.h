//
//  ShowMoreIndicator.h
//  Aimeili
//
//  Created by zhang da on 12-8-29.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMoreIndicator : UIView {
    
    UIActivityIndicatorView *indicator;
    
}

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL hasNoMore;
@property (nonatomic, assign) BOOL isPulling;
@property (nonatomic, assign) BOOL isReleasing;
@property (nonatomic, retain) UILabel *statusLabel;
@property(nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle; // default is UIActivityIndicatorViewStyleWhite


- (void)setPullingStatus;
- (void)setReleaseStatus;



@end
