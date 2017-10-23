//
//  Movie.m
//  CIASMovie
//
//  Created by cias on 2016/12/19.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "Movie.h"

#import "MemContainer.h"

NSValueTransformer * KKZ_StringToDateTransformer(NSString *formatter)
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        
        if ([value isKindOfClass:[NSString class]]) {
            NSString *str = value;
            NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
            dateformatter.dateFormat = formatter;
            return [dateformatter dateFromString:str];
        }
        return nil;
    }];
}

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


//  kkz

- (NSString *)publishDate {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = @"yyyy-MM-dd";
    
    return [dateformatter stringFromDate:self.publishTime];
}

- (NSString *)filmName {
    return self.movieName;
}

- (NSString *)introduction {
    return self.movieIntro;
}

- (NSString *)fakeName {
    return self.movieName;
}

- (NSString *)point {
    return self.score;
}

- (NSString *)filmType {
    return self.movieType;
}

- (NSString *)duration {
    return @"";
}

- (NSString *)filmPosterHorizon {
    return self.thumbPath;
}

- (NSString *)filmPoster {
    return self.pathVerticalS;
}

@end
