//
//  MPGameShankView.h
//  MobilePrint
//
//  Created by guoyi on 15/7/13.
//  Copyright (c) 2015年 GuoYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPGameShankView;
@protocol MPGameShankViewDelegate <NSObject>

/// 触摸 代理
- (void)gameShankView:(MPGameShankView *)gameShankView touchMove:(CGPoint)point;

@end

@interface MPGameShankView : UIView

@property (nonatomic, weak) id<MPGameShankViewDelegate> delegate;

/// 便利构造器
+ (instancetype)gameShankWithSuperView:(UIView *)superView;

@end
