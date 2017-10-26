//
//  MovieSong.h
//  KoMovie
//
//  Created by XuYang on 13-8-8.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"


@interface MovieSong : Model

@property (nonatomic, assign) int songId;
@property (nonatomic, retain) NSString * songImg;
@property (nonatomic, retain) NSString * songUrl;
@property (nonatomic, retain) NSString * songName;
@property (nonatomic, retain) NSNumber * hot;
@property (nonatomic, assign) int movieId;
@property (nonatomic, retain) NSString * singer;//歌手名字
@property (nonatomic, retain) NSString * songType;//用来显示

//资讯里面用的
@property (nonatomic, retain) NSString * songDesc;
@property (nonatomic, retain) NSString * movieName;
@property (nonatomic, retain) NSString * pathHorizonS;

@property (nonatomic, retain) NSString * isNews;

+ (MovieSong *)getSongWithId:(int)songId;
+ (NSArray *)getSongsAllWithisNews:(NSString*)isNews;
- (void)updateDataFromDictForMovieInfo:(NSDictionary *)dict;
-(NSString *)description;
@end
