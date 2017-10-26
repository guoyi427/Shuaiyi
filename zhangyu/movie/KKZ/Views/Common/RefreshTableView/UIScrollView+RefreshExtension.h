//
//  UIScrollView+RefreshExtension.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/29.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (RefreshExtension)

/**
 *  滚动条的x轴偏移量
 */
@property (assign, nonatomic) CGFloat table_contentOffsetX;

/**
 *  滚动条的Y轴偏移量
 */
@property (assign, nonatomic) CGFloat table_contentOffsetY;

/**
 *  滚动条inset的顶部偏移量
 */
@property (assign, nonatomic) CGFloat table_contentInsetTop;

@end
