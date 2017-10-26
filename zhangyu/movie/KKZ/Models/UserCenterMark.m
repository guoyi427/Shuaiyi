//
//  UserCenterMark.m
//  KoMovie
//
//  Created by Albert on 26/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "UserCenterMark.h"

@implementation UserCenterMark
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId":@"user_id",
             @"externToken":@"extern_token",
             @"email":@"email",
             @"mobile":@"mobile",
             @"realName":@"real_name",
             };
}

@end
