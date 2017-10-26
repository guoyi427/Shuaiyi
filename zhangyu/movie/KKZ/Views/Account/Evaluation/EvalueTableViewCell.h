//
//  我的 - 待评价 列表Cell
//
//  Created by 艾广华 on 15/12/21.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "EvalueModel.h"

#import "CommentOrder.h"

@protocol EvalueTableViewDelegate <NSObject>

@optional

/**
 *  评论成功刷新评论请求
 */
- (void)commentFinishedReloadRequest;

/**
 *  开始请求数据 
 */
- (void)beginRequestData;

/**
 *  停止请求数据
 */
- (void)endRequestData;

/**
 *  加载更多数据
 */
- (void)reloadMoreData;

/**
 *  下拉刷新数据
 */
- (void)pullDownRefreshData;

@end

@interface EvalueTableViewCell : UITableViewCell

/**
 *  数据源
 */
@property (nonatomic, strong) CommentOrder *dataSource;

/**
 *  代理对象
 */
@property (nonatomic, assign) id<EvalueTableViewDelegate> cellDelegate;

@end
