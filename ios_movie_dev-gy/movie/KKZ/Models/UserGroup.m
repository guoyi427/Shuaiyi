//
//  UserGroup.m
//  KoMovie
//
//  Created by Albert on 27/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "UserGroup.h"

@implementation UserGroup
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary mtl_identityPropertyMapWithModel:[self class]]];
    [dic setObject:@"id" forKey:@"groupID"];
    return [dic copy];
}
@end
