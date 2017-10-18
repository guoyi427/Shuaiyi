//
//  BannerRequest.h
//  CIASMovie
//
//  Created by cias on 2016/12/29.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerRequest : NSObject

- (void)requestBannerListParams:(NSDictionary *_Nullable)params
                       success:(nullable void (^)(NSArray *_Nullable movies))success
                       failure:(nullable void (^)(NSError *_Nullable err))failure;


@end
