//
//  首页电影列表Cell中活动信息的View
//
//  Created by KKZ on 16/4/13.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@class Banner;

@interface MovieListActivityView : UIButton

/**
 *  电影列表的活动信息
 */
@property (nonatomic, strong) Banner *banner;

/**
 *  是否是最后一个活动
 */
@property (nonatomic, assign) BOOL isLast;

@end
