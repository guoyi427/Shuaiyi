//
//  MovieInfo.m
//  KoMovie
//
//  Created by gree2 on 19/4/13.
//  Copyright (c) 2013 kokozu. All rights reserved.
//

#import "MovieInfo.h"
#import "MemContainer.h"

@implementation MovieInfo

@dynamic imageString;
@dynamic bigString;
@dynamic textString;
@dynamic movieId;
@dynamic newsId;
@dynamic videoPath;
@dynamic newsUrl;
@dynamic typeTitle;
@dynamic smallIcon;
@dynamic isNews;
@dynamic newsTime;

+ (NSString *)primaryKey {
    return @"newsId";
}

+(NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"bigString": @"imageBig",
                 @"imageString": @"imageSmall",
                 @"textString": @"content",
                 @"newsTime": @"createTime",

                 } retain];
    }
    return map;
}

+ (NSDictionary *)formatMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"newsTime": @"yyyy-MM-dd HH:mm:ss",
                 } retain];
    }
    return map;
}

- (void)updateDataFromDict:(NSDictionary *)dict {
    
    NSString * title = [dict kkz_stringForKey:@"title"] ;
    if (title.length == 0) {
        
    }else{
        NSMutableString * string = [NSMutableString stringWithString:title];

        if ([string rangeOfString:@"\n"].length > 0) {
            [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            self.titleString = string;
        }else{
            self.titleString = string;
        }
    }

}

+ (MovieInfo *)getMovieInfoWithId:(unsigned int)newsId {
    return [[MemContainer me] getObject:[MovieInfo class]
                                 filter:[Predicate predictForKey: @"newsId" compare:Equal value:@(newsId)], nil];
}

@end
