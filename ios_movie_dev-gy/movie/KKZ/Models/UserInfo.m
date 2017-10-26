//
//  UserInfo.m
//  KoMovie
//
//  Created by Albert on 27/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *) groupJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[UserGroup class]];
}

+ (NSValueTransformer *) shareJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Share class]];
}

@end
