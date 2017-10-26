//
//  排期列表的Cell
//
//  Created by 艾广华 on 16/4/14.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaPlanCellLayout.h"
#import "Ticket.h"

#define K_CINEMA_PLAN_CELL_HEIGHT 70.0f

@interface CinemaPlanCell : UITableViewCell

/**
 *  数据模型
 */
@property (nonatomic, strong) Ticket *model;

/**
 *  数据布局
 */
@property (nonatomic, strong) CinemaPlanCellLayout *layout;



/**
 标记是否为当前场次

 @param isCurrent yes：当前场次 no：不是当前场次
 */
- (void) setIsCurrentPlan:(BOOL)isCurrent;


/**
 点击购票 回调

 @param a_block 回调
 */
- (void) buyTicketCallback:(void(^)(Ticket *plan))a_block;

@end
