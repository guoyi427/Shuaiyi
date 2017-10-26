//
//  MovieInfo.h
//  KoMovie
//
//  Created by gree2 on 19/4/13.
//  Copyright (c) 2013 kokozu. All rights reserved.
//资讯

#import "Model.h"

@interface MovieInfo : Model

@property (nonatomic, retain) NSString * typeTitle;
@property (nonatomic, retain) NSString * typeId;
@property (nonatomic, retain) NSString * smallIcon; //小图

@property (nonatomic, retain) NSString * imageString; //小图
@property (nonatomic, retain) NSString * bigString;
@property (nonatomic, retain) NSString * titleString;
@property (nonatomic, retain) NSString * textString;
@property (nonatomic, assign) unsigned int movieId;
@property (nonatomic, assign) unsigned int newsId;
@property (nonatomic, retain) NSString * newsUrl;//html5
@property (nonatomic, retain) NSDate * newsTime;//没用
@property (nonatomic, retain) NSString * videoPath;//没用

@property (nonatomic, retain) NSString *isNews;

//+(NSArray *)getMovieInfoAllWithIsNews:(NSString*)isNews inContext:(NSManagedObjectContext *)context;
//+ (MovieInfo *)getMovieInfoWithTypeId:(NSString *)typeId inContext:(NSManagedObjectContext *)context;

+ (MovieInfo *)getMovieInfoWithId:(unsigned int)newsId;
- (void)updateDataFromDict:(NSDictionary *)dict;
@end
