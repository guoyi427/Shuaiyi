//
//  ActivityRequest.m
//  KoMovie
//
//  Created by Albert on 9/20/16.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "ActivityRequest.h"
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <NetCore_KKZ_Cache/KKZBaseNetRequest+Cache.h>
#import "Constants.h"

#import "Activity.h"

@implementation ActivityRequest
/**
 *  查询活动详情
 *
 *  @param activityId  参数：必填：cinema_id
 *  @param success 成功回调
 *  @param failure 失败回调
 */
- (void)requestDetail:(NSNumber *_Nonnull)activityId
              success:(nullable void (^)(Activity *_Nullable activity))success
              failure:(nullable void (^)(NSError *_Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithCapacity:3];
    [para setValue:activityId forKey:@"activity_id"];
    [para setObject:@"activity_Query" forKey:@"action"];
    
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:para];
    
    request.parseKey = @"activity";
    
    [request GET:kKSSPServer
      parameters:newParams
     resultClass:[Activity class]
         success:^(id _Nullable data, id _Nullable respomsObject) {
             
             if (success) {
                 success(data);
             }
             
         }
         failure:failure];
}
@end
