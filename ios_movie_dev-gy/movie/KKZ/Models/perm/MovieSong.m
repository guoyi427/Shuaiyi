//
//  MovieSong.m
//  KoMovie
//
//  Created by XuYang on 13-8-8.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import "MovieSong.h"
#import "MemContainer.h"

@implementation MovieSong

@dynamic songId;
@dynamic songImg;
@dynamic songUrl;
@dynamic songName;
@dynamic hot;
@dynamic movieId;
@dynamic singer;
@dynamic songType;
@dynamic songDesc;
@dynamic movieName;
@dynamic pathHorizonS;
@dynamic isNews;

+ (NSString *)primaryKey {
    return @"songId";
}

+(NSDictionary *)propertyMapping {
    static NSDictionary *map = nil;
    if(!map){
        map = [@{
                 @"songId": @"id",
                 @"songUrl": @"songFile",
                 @"songType": @"songDesc",

                 } retain];
    }
    return map;
}

- (void)updateDataFromDictForMovieInfo:(NSDictionary *)dict{
    if ([[dict kkz_objForKey:@"movie"] kkz_stringForKey:@"pathHorizonS"].length != 0) {
        self.pathHorizonS = [[dict kkz_objForKey:@"movie"] kkz_stringForKey:@"pathHorizonS"];
    }
}

+ (MovieSong *)getSongWithId:(int)songId{
    return [[MemContainer me] getObject:[MovieSong class]
                                 filter:[Predicate predictForKey: @"songId" compare:Equal value:@(songId)], nil];
}
+ (NSArray *)getSongsAllWithisNews:(NSString*)isNews{
    return nil;
}


-(NSString *)description{
    return [NSString stringWithFormat:@"音乐名字<%@>，歌手%@，电影名字%d,url%@",self.songName,self.singer,self.movieId,self.songUrl];
}

@end
