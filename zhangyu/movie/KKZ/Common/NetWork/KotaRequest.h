//
//  KotaRequest.h
//  KoMovie
//
//  Created by renzc on 16/9/21.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KotaRequest : NSObject

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
                   failure:(nullable void (^)(NSError * _Nullable err))failure;
@end
