//
//  NewFriendTask.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/16.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "NetworkTask.h"

static NSString *requestDataSource = @"dataSource";
static NSString *requestDataTotal = @"totalData";

@interface NewFriendTask : NetworkTask

/**
 *  初始化手机好友
 *
 *  @param usernames
 *  @param block     请求完成的回调
 *
 *  @return
 */
-(id)initWithPhoneUser:(NSString *)usernames
              finished:(FinishDownLoadBlock)block;

/**
 *  初始化活跃用户
 *
 *  @param pageNum  请求的第几页
 *  @param pageSize 每页请求个数
 *  @param block
 *
 *  @return
 */
-(id)initWithActivityPageNum:(int)pageNum
                withPageSize:(int)pageSize
                    finished:(FinishDownLoadBlock)block;

/**
 *  初始化附近的人
 *
 *  @param latitude  纬度
 *  @param longitude 精度
 *  @param pageSize  显示条数
 *  @param block
 *
 *  @return
 */
-(id)initWithNearByLatitude:(NSString *)latitude
              withLongitude:(NSString *)longitude
               withPageSize:(int)pageSize
                  finished:(FinishDownLoadBlock)block;

@end
