//
//  WaitIndicatorView.h
//  kokozu
//
//  Created by da zhang on 11-6-7.
//  Copyright 2011 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaitIndicatorView : UIView {
    UIActivityIndicatorView *indicatorView;

    NSString *title;
    NSString *subTitle;
    int originY;
    BOOL animated;
    CGFloat alpa;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, assign) CGFloat alpa;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, assign) BOOL fullScreen;

- (void)updateLayout;

@end
