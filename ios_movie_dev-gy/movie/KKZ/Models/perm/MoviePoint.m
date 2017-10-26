//
//  Point.m
//  KoMovie
//
//  Created by yaojinhai on 13-4-25.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "MoviePoint.h"
#import "MemContainer.h"

@implementation MoviePoint

@dynamic pointId;
@dynamic movieId;
@dynamic content;
@dynamic score;

+ (NSString *)primaryKey {
    return @"pointId";
}

- (void)updateDataFromDict:(NSDictionary *)dict
{
    self.typeId = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"type"] objectForKey:@"typeId"]];
    self.typeName = [[dict objectForKey:@"type"] kkz_stringForKey:@"typeName"];
}

+ (MoviePoint *)getMoviePointWithId:(unsigned int)pointId {
    
    return [[MemContainer me] getObject:[MoviePoint class]
                                 filter:[Predicate predictForKey: @"pointId" compare:Equal value:@(pointId)], nil];
}

@end
