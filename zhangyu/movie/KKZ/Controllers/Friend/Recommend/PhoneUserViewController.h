//
//  新的好友 - 好友推荐
//
//  Created by 艾广华 on 15/12/16.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"
#import "RecommendView.h"

@interface PhoneUserViewController : CommonViewController <CommenMethodDelegate>

/**
 *  活跃用户视图
 */
@property (nonatomic, strong) RecommendView *recommendView;

/**
 *  初始化视图
 *
 *  @param frame <#frame description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithViewFrame:(CGRect)frame;

@end
