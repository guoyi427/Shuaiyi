//
//  EvalueModel.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/21.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "kkzCommonModel.h"

@interface EvalueModel : kkzCommonModel

/**
 *  是否是待评价
 */
@property (nonatomic, assign) BOOL isEvaluation;

/**
 *  影院名字
 */
@property (nonatomic, strong) NSString *cinemaName;

/**
 *  电影名称
 */
@property (nonatomic, strong) NSString *movieName;

/**
 *  电影的Id
 */
@property (nonatomic, assign) int movieId;

/**
 *  评论Id
 */
@property (nonatomic, strong) NSString *commentId;

/**
 *  订单ID
 */
@property (nonatomic, strong) NSString *orderID;

/**
 *  影院排期时间
 */
@property (nonatomic, strong) NSString *featureTime;

/**
 *  评论获得的积分
 */
@property (nonatomic, assign) int integral;

/**
 *  查看的URL
 */
@property (nonatomic, strong) NSString *url;

/**
 *  帖子类型
 */
@property (nonatomic, assign) int type;

@end
