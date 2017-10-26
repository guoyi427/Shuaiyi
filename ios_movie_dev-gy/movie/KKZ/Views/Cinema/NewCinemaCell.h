//
//  影院列表的Cell
//
//  Created by KKZ on 16/4/11.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@class CinemaCellLayout;

#define K_CINEMACELL_HEIGHT_PLAN 177     // 排期信息cell高度

@interface NewCinemaCell : UITableViewCell

/**
 *  影院的frame模型
 */
@property (nonatomic, strong) CinemaCellLayout *cinemaCellLayout;

/**
 *  加载影院信息
 */
- (void)updateCinemaCell;


/**
 显示排期信息

 @param planList 排期列表
 @param selectBlock 选中回调
 */
- (void) showMovieTimeList:(NSArray *)planList select:(void (^)(Ticket *plan))selectBlock;

/**
 隐藏排期信息
 */
- (void) hideMovieTimeList;

@end
