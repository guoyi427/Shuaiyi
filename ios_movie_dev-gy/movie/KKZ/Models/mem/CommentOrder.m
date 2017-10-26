//
//  CommentOrder.m
//  KoMovie
//
//  Created by Albert on 01/11/2016.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommentOrder.h"


@implementation CommentOrder
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *) planJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Ticket class]];
}

+ (NSValueTransformer *) commentOrderJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[OrderCommentInfo class]];
}

@end
