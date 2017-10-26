//
//  CinemaTableView.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/11.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    tableHeaderNormalState = 1000,
    tableHeaderLoadingState,
} tableHeaderState;

@protocol CinemaTableViewDelegate <NSObject>

@optional

/**
 *  开始进入刷新模式
 */
- (void)beginRquestData;

/**
 *  加载下一页数据
 */
- (void)reloaNextPageData;

/**
 *  停止请求数据
 */
- (void)endRequestData;

/**
 *  滚动条滚动过程中
 *
 *  @param scrollView 
 */
- (void)cinemeScrollViewDidScroll:(UIScrollView *)scrollView;

/**
 *  滚动条刚开始结束滚动
 *
 *  @param scrollView
 *  @param decelerate
 */
- (void)cinemaScrollViewDidEndDragging:(UIScrollView *)scrollView
                        willDecelerate:(BOOL)decelerate;

/**
 *  滚动条已经停止减速
 *
 *  @param scrollView
 */
- (void)cinemaScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

@interface CinemaTableView : UITableView <CinemaTableViewDelegate>

/**
 *  代理对象
 */
@property (nonatomic, assign) id<CinemaTableViewDelegate> cinemaDelegate;

/**
 *  设置下拉刷新状态
 *
 *  @param state
 */
- (void)setTableViewHeaderState:(tableHeaderState)state;

/**
 *  设置上拉加载的状态
 *
 *  @param isLoad
 */
- (void)setTableViewFooterIsLoad:(BOOL)isLoad;

/**
 *  设置上拉加载是否还有更多
 *
 *  @param hasMore
 */
- (void)setTableViewFooterHasMore:(BOOL)hasMore;

/**
 *  设置上拉刷新的视图隐藏还是显示
 *
 *  @param hidden
 */
- (void)setTableViewFooterHidden:(BOOL)hidden;

/**
 *  初始化视图只有下拉刷新的视图
 *
 *  @param frame
 *  @param style
 *
 *  @return
 */
- (id)initWithOnlyRefreshFrame:(CGRect)frame
                         style:(UITableViewStyle)style;

/**
 *  初始化视图只有加载更多的视图
 *
 *  @param frame 视图的尺寸
 *  @param style
 *
 *  @return
 */
- (id)initWithOnlyMoreFrame:(CGRect)frame
                      style:(UITableViewStyle)style;

@end
