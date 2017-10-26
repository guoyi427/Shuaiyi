//
//  新的好友 - 附近的人
//
//  Created by 艾广华 on 15/12/18.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"
#import "RecommendView.h"

@interface NearByViewController : CommonViewController <CommenMethodDelegate>

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
