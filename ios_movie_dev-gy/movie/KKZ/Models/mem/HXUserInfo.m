//
//  HXUserInfo.m
//  KoMovie
//
//  Created by avatar on 15/7/22.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "HXUserInfo.h"
#import "MemContainer.h"

@implementation HXUserInfo


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"hxUserId":@"userId",
             @"headimg":@"headimg",
             @"nickname":@"nickname",
             };
}



+ (HXUserInfo *)getHXUserInfoWithId:(NSString *)userIdChat{

    return [[MemContainer me] getObject:[HXUserInfo class]
                                 filter:[Predicate predictForKey:@"hxUserId" compare:Equal value:userIdChat], nil];
}

@end
