//
//  ArticleTotal.m
//  CIASMovie
//
//  Created by avatar on 2017/4/18.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "ArticleTotal.h"
#import "ArticleList.h"
@implementation ArticleTotal

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *) rowsJSONTransformer
{
    return  [MTLJSONAdapter arrayTransformerWithModelClass:[ArticleList class]];
}


@end
