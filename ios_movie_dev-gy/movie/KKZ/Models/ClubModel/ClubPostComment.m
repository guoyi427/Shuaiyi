//
//  ClubPostComment.m
//  KoMovie
//
//  Created by KKZ on 16/2/28.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubPostComment.h"

#import "Constants.h"
#import "Cryptor.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "MemContainer.h"

@implementation ClubPostComment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {

    return [NSDictionary mtl_identityPropertyMapWithModel:[self class]];
}

+ (NSValueTransformer *)commentorJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[KKZAuthor class]];
}

+ (NSValueTransformer *)articleJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[ClubPost class]];
}

+ (NSValueTransformer *)isUpJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

@end
