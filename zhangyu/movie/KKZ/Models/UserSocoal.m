//
//  UserSocoal.m
//  KoMovie
//
//  Created by Albert on 27/09/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "UserSocoal.h"

@implementation UserSocoal
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary mtl_identityPropertyMapWithModel:[self class]]];
    [dic setObject:@"BDay" forKey:@"day"];
    [dic setObject:@"BYear" forKey:@"year"];
    [dic setObject:@"BMonth" forKey:@"month"];
    [dic setObject:@"headimg" forKey:@"headImg"];
    [dic setObject:@"uid" forKey:@"userId"];
    [dic setObject:@"nickname" forKey:@"nickName"];
    
    return [dic copy];
}
@end
