//
//  CinemaTableView.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/11.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "CinemaTableView.h"
#import "EGORefreshTableHeaderView.h"
#import "ShowMoreIndicator.h"
#import "UIScrollView+RefreshTable.h"

@interface CinemaTableView () {
    //上拉刷新视图
    EGORefreshTableHeaderView *refreshHeaderView;

    //加载更多
    ShowMoreIndicator *showMoreFooterView;
}

/**
 *  下拉刷新是否正在加载
 */
@property (nonatomic, assign) BOOL pullLoading;

/**
 *  需要执行下拉刷新
 */
@property (nonatomic, assign) BOOL needPullRefresh;

/**
 *  需要刷新数据
 */
@property (nonatomic, assign) BOOL needReloadData;

/**
 *  滚动条是否正在滚动
 */
@property (nonatomic, assign) BOOL isScrolling;

@end

@implementation CinemaTableView

- (id)initWithFrame:(CGRect)frame
              style:(UITableViewStyle)style {
    self = [super initWithFrame:frame
                          style:style];
    if (self) {
        //上拉刷新
        [self addRfreshHeaderWithTarget:self
                                   action:@selector(headRefresh)];

        //加载更多
        CGRect showMoreFrame = CGRectMake(0, 0, self.bounds.size.width, 40);
        showMoreFooterView = [[ShowMoreIndicator alloc] initWithFrame:showMoreFrame];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:237 / 255.0
                                               green:237 / 255.0
                                                blue:237 / 255.0
                                               alpha:1.0];
        [showMoreFooterView addSubview:line];
    }
    return self;
}

- (id)initWithOnlyRefreshFrame:(CGRect)frame
                         style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {

        //下拉刷新
        [self addRfreshHeaderWithTarget:self
                                   action:@selector(headRefresh)];
    }
    return self;
}

- (id)initWithOnlyMoreFrame:(CGRect)frame
                      style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {

        //加载更多
        CGRect showMoreFrame = CGRectMake(0, 0, self.bounds.size.width, 40);
        showMoreFooterView = [[ShowMoreIndicator alloc] initWithFrame:showMoreFrame];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:237 / 255.0
                                               green:237 / 255.0
                                                blue:237 / 255.0
                                               alpha:1.0];
        [showMoreFooterView addSubview:line];
    }
    return self;
}

#pragma CinemaTableViewDelegate

- (void)cinemeScrollViewDidScroll:(UIScrollView *)scrollView {
    //进入下方区域+45像素
    if (showMoreFooterView) {
        if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45) {
            if (!showMoreFooterView.isLoading && !showMoreFooterView.hasNoMore && refreshHeaderView.state != EGOOPullRefreshLoading && self.tableFooterView) {
                showMoreFooterView.isLoading = YES;
                if (self.cinemaDelegate && [self.cinemaDelegate respondsToSelector:@selector(reloaNextPageData)]) {
                    [self.cinemaDelegate reloaNextPageData];
                }
            }
        }
    }
    self.isScrolling = TRUE;
}

- (void)cinemaScrollViewDidEndDragging:(UIScrollView *)scrollView
                        willDecelerate:(BOOL)decelerate {
    //    if (!decelerate) {
    //        [self _performPullRefresh];
    //    }
}

- (void)cinemaScrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //    [self _performPullRefresh];
}

#pragma 下拉刷新回调

- (void)_performPullRefresh {
    //    if (self.needPullRefresh) {
    //        [self.cinemaDelegate beginRquestData];
    //        self.needPullRefresh = FALSE;
    //        NSLog(@"开始请求");
    //    }
    //    self.isScrolling = FALSE;
}

- (void)headRefresh {
    if (self.cinemaDelegate && [self.cinemaDelegate respondsToSelector:@selector(beginRquestData)]) {

        [self.cinemaDelegate beginRquestData];

        //        //如果下拉刷新正在执行网络请求就直接返回
        //        if (self.pullLoading) {
        //            return;
        //        }
        //
        //        //执行下拉刷新方法
        //        self.pullLoading = TRUE;
        //        self.needPullRefresh = TRUE;
    }
}

- (void)setTableViewHeaderState:(tableHeaderState)state {
    if (state == tableHeaderNormalState) {
        [self setState:TableRefreshStateNormal];
        self.pullLoading = FALSE;
    }
}

- (void)setTableViewFooterHasMore:(BOOL)hasMore {
    showMoreFooterView.hasNoMore = hasMore;
    self.tableFooterView = showMoreFooterView;
}

- (void)setTableViewFooterIsLoad:(BOOL)isLoad {
    showMoreFooterView.isLoading = isLoad;
    self.tableFooterView = showMoreFooterView;
}

- (void)setTableViewFooterHidden:(BOOL)hidden {
    showMoreFooterView.hidden = hidden;
    self.tableFooterView = showMoreFooterView;
}

@end
