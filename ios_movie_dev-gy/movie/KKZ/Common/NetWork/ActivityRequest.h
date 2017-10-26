//
//  ActivityRequest.h
//  KoMovie
//
//  Created by Albert on 9/20/16.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Activity;

@interface ActivityRequest : NSObject
/**
 *  查询活动详情
 *
 *  @param activityId  参数：必填：cinema_id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)requestDetail:(NSNumber *_Nonnull)activityId
              success:(nullable void (^)(Activity *_Nullable activity))success
              failure:(nullable void (^)(NSError *_Nullable err))failure;
@end
