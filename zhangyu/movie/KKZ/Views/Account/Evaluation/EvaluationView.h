//
//  我的 - 待评价列表页面
//
//  Created by 艾广华 on 15/12/21.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "EvalueTableViewCell.h"

@interface EvaluationView : UIView <EvalueTableViewDelegate>

/**
 *  列表显示数据
 */
@property (nonatomic, strong) NSMutableArray *listData;

/**
 *  代理对象
 */
@property (nonatomic, assign) id<EvalueTableViewDelegate> cellDelegate;

/**
 *  是否还有更多数据
 */
@property (nonatomic, assign) BOOL hasMoreDta;

@end
