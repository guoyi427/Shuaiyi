//
//  UIScrollView+RefreshTable.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/29.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableView.h"

@interface UIScrollView (RefreshTable)

/**
 *  下拉文字
 */
@property (strong, nonatomic) NSString *tableHeaderPullToRefreshText;

/**
 *  松开手文字
 */
@property (strong, nonatomic) NSString *tableHeaderReleaseToRefreshText;

/**
 *  开始刷新的文字
 */
@property (strong, nonatomic) NSString *tableHeaderRefreshingText;

/**
 *  表格刷新
 */
@property (assign, nonatomic) TableRefreshState state;

/**
 *  添加顶部下拉视图
 *
 *  @param target
 *  @param action
 */
- (void)addRfreshHeaderWithTarget:(id)target
                           action:(SEL)action;

@end
