//
//  MovieTrailer.m
//  KoMovie
//
//  Created by gree2 on 21/5/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import "MovieTrailer.h"
#import "MemContainer.h"

@implementation MovieTrailer

@dynamic movieId;
@dynamic trailerId;
@dynamic trailerCover;
@dynamic trailerPath;
@dynamic type;

- (void)dealloc{
    
    [super dealloc];
}

+ (NSString *)primaryKey {
    return @"movieId";
}

+ (MovieTrailer *)getMovieTrailerWithId:(int)movieId{
    return [[MemContainer me] getObject:[MovieTrailer class]
                                 filter:[Predicate predictForKey: @"movieId" compare:Equal value:@(movieId)], nil];
}

@end
