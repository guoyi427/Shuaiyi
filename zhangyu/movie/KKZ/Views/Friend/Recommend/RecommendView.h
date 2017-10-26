//
//  RecommendView.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/7.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendCell.h"

@protocol CommenMethodDelegate <NSObject>

@optional

/**
 *  刷新联系人列表的对应索引的已邀请状态
 *
 *  @param index
 */
- (void)updateInventedStatusWithIndex:(NSInteger)index;

/**
 *  刷新联系人列表的对应索引的已关注状态
 *
 *  @param index
 */
- (void)updateAttentionStatusWithIndex:(NSInteger)index;

@end

@interface RecommendView : UIView <CommenMethodDelegate>

/**
 *  需要显示的cell数据源
 */
@property (nonatomic, strong) NSMutableArray *showDataArray;

/**
 *  显示数据的表视图
 */
@property (nonatomic, strong) UITableView *listTable;

/**
 *  代理对象
 */
@property (nonatomic, assign) id<RecommendCellDelegate> cellDelegate;

/**
 *  是否可以下拉刷新
 */
@property (nonatomic, assign) BOOL canPullRefresh;

/**
 *  初始化视图
 *
 *  @param frame         视图的尺寸
 *  @param titleText     失败的标题
 *  @param nextResponder 下一个响应者对象
 *
 *  @return 
 */
- (id)initWithRefrshViewFrame:(CGRect)frame
                withTitleText:(NSString *)titleText
                nextResponder:(id)nextResponder;

/**
 *  初始化视图
 *
 *  @param frame
 *  @param titleText
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
      withTitleText:(NSString *)titleText;

/**
 *  停止下拉刷新(带上拉刷新控件)
 */
- (void)endRefresh;

/**
 *  开始下拉刷新(带下拉刷新控件)
 */
- (void)beginRefresh;

@end
