//
//  CIASActivityIndicatorView.h
//  CIASMovie
//
//  Created by avatar on 2017/1/7.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CIASActivityIndicatorViewDelegate;

@interface CIASActivityIndicatorView : UIView
/**
 设置矩形个数
 */
@property (readwrite, nonatomic) NSUInteger numbers;
/**
 设置间隔距离
 */
@property (readwrite, nonatomic) CGFloat internalSpacing;
/**
 设置矩形尺寸
 */
@property (readwrite, nonatomic) CGSize size;
/**
 设置动画延迟
 */
@property (readwrite, nonatomic) CGFloat delay;
/**
 设置动画持续时间
 */
@property (readwrite, nonatomic) CGFloat duration;


@property (strong, nonatomic) id<CIASActivityIndicatorViewDelegate> delegate;


- (void)startAnimating;

- (void)stopAnimating;

@end

@protocol CIASActivityIndicatorViewDelegate <NSObject>
@optional
/**
 设置每个矩形的颜色
 */
- (UIColor *)activityIndicatorView:(CIASActivityIndicatorView *)activityIndicatorView rectangleBackgroundColorAtIndex:(NSUInteger)index;

@end
