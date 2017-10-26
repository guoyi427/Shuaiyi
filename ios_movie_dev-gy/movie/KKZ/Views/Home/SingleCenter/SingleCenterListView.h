//
//  SingleCenterListView.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/21.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CinemaTableView.h"

@protocol SingleCenterListViewDelegate <NSObject>

@optional

/**
 *  TableView滚动条开始滚动的时候
 *
 *  @param listScrollView
 */
- (void)listTableDidScroll:(UIScrollView *)listScrollView;

/**
 *  下拉刷新请求网络
 */
- (void)pullRefreshBeginRequest;

/**
 *  TableView滚动条停止滚动的时候
 *
 *  @param listScrollView
 */
- (void)listTableDidEndScroll:(UIScrollView *)listScrollView;

@end

@interface SingleCenterListView : UIView <CinemaTableViewDelegate>

/**
 *  列表显示数据
 */
@property (nonatomic, strong) NSArray *listData;

/**
 *  数据布局数组
 */
@property (nonatomic, strong) NSMutableArray *layoutData;

/**
 *  表视图
 */
@property (nonatomic, strong) CinemaTableView *listTable;

/**
 *  代理对象
 */
@property (nonatomic, assign) id<CinemaTableViewDelegate> cinemaDelegate;

/**
 *  页面的代理对象
 */
@property (nonatomic, assign) id<SingleCenterListViewDelegate> singleDelegate;

/**
 *  初始化视图添加响应者对象
 *
 *  @param frame
 *  @param responder
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
      withResponder:(id)responder;

@end
