//
//  friendRecommendModel.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/7.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "Model.h"

static NSString *modelTypeActivityUser = @"modelTypeActivityUser";
static NSString *modelTypePhoneUser = @"modelTypePhoneUser";
static NSString *modelTypeNearByUser = @"modelTypeNearByUser";

@interface friendRecommendModel : NSObject

/**
 *  用户头像地址
 */
@property (nonatomic, strong) NSString *avatarUrl;

/**
 *  用户姓名拼音
 */
@property (nonatomic, strong) NSString *namePY;

/**
 *  用户ID
 */
@property (nonatomic, strong) NSString *uid;

/**
 *  用户手机号
 */
@property (nonatomic, strong) NSString *phone;

/**
 *  用户昵称
 */
@property (nonatomic, strong) NSString *nickname;

/**
 *  用户备注
 */
@property (nonatomic, strong) NSString *userDetail;

/**
 *  距离
 */
@property (nonatomic, assign) CGFloat distance;

/**
 *  计算好的距离
 */
@property (nonatomic, strong) NSString *estimateDistance;

/**
 *  标注一下model的类型
 */
@property (nonatomic, strong) NSString *modelType;

/**
 *  用户状态
 */
@property (nonatomic, assign) int status;

/**
 *  是否是好友
 */
@property (nonatomic, assign) BOOL isFriend;

/**
 *  最大页数
 */
@property (nonatomic, assign) int maxPageCount;

@end
