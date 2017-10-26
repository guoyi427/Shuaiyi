//
//  EvaluationModel.h
//  KoMovie
//
//  Created by 艾广华 on 16/1/21.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cinemaEvalue : NSObject

/**
 *  影院名字
 */
@property (nonatomic, strong) NSString *cinemaName;
 
@end

@interface movieEvalue : NSObject

/**
 *  电影名称
 */
@property (nonatomic, strong) NSString *movieName;

@end

@interface planEvalue : NSObject

/**
 *  影院信息
 */
@property (nonatomic, strong) cinemaEvalue *cinema;

/**
 *  电影详情
 */
@property (nonatomic, strong) movieEvalue *movie;

/**
 *  排期时间 
 */
@property (nonatomic, strong) NSString *featureTime;

/**
 *  电影Id
 */
@property (nonatomic, strong) NSString *movieId;

@end

@interface commentOrderEvalue : NSObject

/**
 *  评论Id
 */
@property (nonatomic, strong) NSString *commentId;

/**
 *  奖励的积分
 */
@property (nonatomic, assign) int integral;

/**
 *  待评价的URL地址
 */
@property (nonatomic, strong) NSString *url;

/**
 *  帖子类型
 */
@property (nonatomic, assign) int type;

@end

@interface EvaluationModel : NSObject

/**
 *  订单ID
 */
@property (nonatomic, strong) NSString *orderId;

/**
 *  排期数据
 */
@property (nonatomic, strong) planEvalue *plan;

/**
 *  评论详情
 */
@property (nonatomic, strong) commentOrderEvalue *commentOrder;

@end
