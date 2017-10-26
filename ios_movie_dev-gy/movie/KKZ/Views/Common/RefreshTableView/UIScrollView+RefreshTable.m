//
//  UIScrollView+RefreshTable.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/29.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "UIScrollView+RefreshTable.h"

@interface UIScrollView ()

/**
 *  下拉刷新视图
 */
@property (strong, nonatomic) RefreshTableView *header;

@end

@implementation UIScrollView (RefreshTable)

- (void)addRfreshHeaderWithTarget:(id)target
                           action:(SEL)action {
    if (!self.header) {
        RefreshTableView *header = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, 0, 64)];
        self.header = header;
        [self addSubview:header];
    }

    //2.设置目标和回调方法
    self.header.tableBeginRefreshingTaget = target;
    self.header.tableBeginRefreshingAction = action;
}

- (void)setTableHeaderPullToRefreshText:(NSString *)tableHeaderPullToRefreshText {
    self.header.tablePullToRefreshText = tableHeaderPullToRefreshText;
}

- (void)setTableHeaderReleaseToRefreshText:(NSString *)tableHeaderReleaseToRefreshText {
    self.header.tableReleaseToRefreshText = tableHeaderReleaseToRefreshText;
}

- (void)setTableHeaderRefreshingText:(NSString *)tableHeaderRefreshingText {
    self.header.tableRefreshingText = tableHeaderRefreshingText;
}

- (void)setState:(TableRefreshState)state {
    self.header.state = state;
}

@end
