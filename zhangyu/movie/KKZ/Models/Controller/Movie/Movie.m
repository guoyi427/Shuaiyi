//
//  Movie.m
//  KKZ
//
//  Created by alfaromeo on 11-10-3.
//  Copyright (c) 2011年 kokozu. All rights reserved.
//

#import "Movie.h"
#import "DateEngine.h"
#import "MemContainer.h"
#import "NSStringExtra.h"
#import "MTLValueTransformerHelper.h"

@implementation Movie

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary mtl_identityPropertyMapWithModel:[self class]]];
    [dic setValuesForKeysWithDictionary:@{
        @"movieDirector" : @"director",
        @"movieIntro" : @"intro",
        @"thumbPathSmall" : @"pathSquare",
        @"thumbPath" : @"posterPath",
    }];

    return dic;
}

+ (NSValueTransformer *)publishTimeJSONTransformer {
    return KKZ_StringToDateTransformer(@"yyyy-MM-dd");
}

+ (NSValueTransformer *)has3DJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)hasImaxJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}
+ (NSValueTransformer *)hasPromotionJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)hasPlanJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)trailerJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[Trailer class]];
}

+ (NSValueTransformer *)bannersJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[Banner class]];
}

- (NSString *)movieTrailer {
    return self.trailer.trailerPath;
}

//-----

+ (NSString *)primaryKey {
    return @"movieId";
}

- (NSString *)getMovieLength {
    if (self.movieLength > 0) {
        return [NSString stringWithFormat:@"%@分钟", self.movieLength];
    }
    return @"未知";
}

+ (Movie *)getMovieWithId:(NSUInteger)movieId {
    return [[MemContainer me] getObject:[Movie class]
                                 filter:[Predicate predictForKey:@"movieId" compare:Equal value:@(movieId)], nil];
}

@end
