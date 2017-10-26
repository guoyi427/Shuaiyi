//
//  Match.m
//  KoMovie
//
//  Created by XuYang on 13-8-12.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "Match.h"
#import "MemContainer.h"

@implementation Match

@dynamic matchId;
@dynamic movieId;
@dynamic hot;
@dynamic matchName;
@dynamic imageBig;
@dynamic imageOrigin;
@dynamic imageSmall;
@dynamic matchDesc;
@dynamic userId;
@dynamic fansCnt;
@dynamic  createTime;


@dynamic leftImgUrl;
@dynamic rightUpImgUrl;
@dynamic rightDownImgUrl;
@dynamic rightUpName;
@dynamic rightDownName;
@dynamic rightUpPrice;
@dynamic rightDownPrice;
@dynamic rightUpLink;
@dynamic rightDownLink;

+ (NSString *)primaryKey {
    return @"matchId";
}

+ (Match *)getMatchWithId:(unsigned int)matchId{
    return [[MemContainer me] getObject:[Match class]
                                 filter:[Predicate predictForKey: @"matchId" compare:Equal value:@(matchId)], nil];
}

@end
