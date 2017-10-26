//
//  新的好友 - 活跃用户页面
//
//  Created by 艾广华 on 15/12/7.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"
#import "RecommendView.h"

@interface ActivityUserViewController : CommonViewController <CommenMethodDelegate>

/**
 *  活跃用户视图
 */
@property (nonatomic, strong) RecommendView *recommendView;

/**
 *  初始化视图
 *
 *  @param userId
 *  @param frame
 *
 *  @return
 */
- (id)initWithViewFrame:(CGRect)frame;

@end
