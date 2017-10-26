//
//  KotaRequest.m
//  KoMovie
//
//  Created by renzc on 16/9/21.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "KotaRequest.h"

@implementation KotaRequest

/**
 *  查询某明星的相信信息
 *
 *  @param starId  明星id
 *  @param success 成功回调 starDetail: [Actor class]
 *  @param failure 失败回调
 *  other 暂时舍弃
 */
- (void)requestStarDetailWithStarId:(NSInteger)starId
                  success:(nullable void (^)(id _Nullable starDetail))success
                  failure:(nullable void (^)(NSError * _Nullable err))failure
{
    KKZBaseNetRequest *request = [KKZBaseNetRequest requestWithBaseURL:kKSSBaseUrl baseParams:nil];
    
    NSMutableDictionary *dicParams = [NSMutableDictionary dictionaryWithCapacity:0];
    [dicParams setObject:[NSString stringWithFormat:@"%tu",starId]  forKey:@"user_id"];
    NSDictionary *newParams = [KKZBaseRequestParams getDecryptParams:dicParams];
    
    [request GET:[NSString stringWithFormat:@"%@/%@",KKSSPKota,@"query_user_detail.chtml"] parameters:newParams success:^(id  _Nullable data, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSError * _Nullable err) {
        if (failure) {
            failure(err);
        }
    }];
    
}
@end
