//
//  Movie.h
//  KKZ
//
//  Created by alfaromeo on 11-10-3.
//  Copyright (c) 2011年 kokozu. All rights reserved.
//

#import "Model.h"
#import "Trailer.h"
#import <Mantle/Mantle.h>
#import "Banner.h"

@interface Movie : MTLModel <MTLJSONSerializing>

//actor = "\U4f0a\U5fb7\U91cc\U65af\U00b7\U827e\U5c14\U5df4 / \U7406\U67e5\U5fb7\U00b7\U9ea6\U767b / \U51ef\U5229\U00b7\U857e\U8389 / \U590f\U6d1b\U7279\U00b7\U52d2\U00b7\U90a6 / \U963f\U7eb3\U6258\U5c14\U00b7\U4f18\U7d20\U798f / \U4e39";
//appBigPost = "http://img.komovie.cn/activity/14736627789509.jpg";
//cinemaCount = 31;
//del = 0;
//director = "\U8a79\U59c6\U65af\U00b7\U74e6\U7279\U91d1\U65af";
//has2D = 1;
//has3D = 0;
//hasImax = 0;
//hasPromotion = 0;
//hot = 5773;
//"hot_planCount" = 273;
//"hot_priority" = 110;
//lookCount = 4374;
//minPrice = "20.90";
//minVipPrice = "20.90";
//movieId = 485742;
//movieLength = 92;
//movieName = "\U5df4\U9ece\U5371\U673a";
//movieType = "\U5267\U60c5 / \U52a8\U4f5c";
//pathHorizonH = "http://img.komovie.cn/activity/14736627776503.jpg";
//pathVerticalS = "http://img.komovie.cn/poster/big/14738379951100.jpg";
//planCount = 273;
//posterPath = "http://img.komovie.cn/poster/big/14738379951100.jpg";
//publishTime = "2016-09-20";
//score = "7.6";
//title = "\U5c0f\U5077\U548c\U8b66\U5bdf\Uff0c\U5171\U6218\U6076\U52bf\U529b";
//trailer =     {
//    movieId = 485742;
//    trailerCover = "http://img.komovie.cn/poster/big/14742575707572.jpg";
//    trailerId = 16025;
//    type = 1;
//};
//webBigPost = "http://img.komovie.cn/activity/14736627776503.jpg";


@property (nonatomic, copy) NSString *actor;
@property (nonatomic, copy) NSString *appBigPost;//海报路径
@property (nonatomic, copy) NSNumber *cinemaCount;//影院数量
@property (nonatomic) BOOL has3D;
@property (nonatomic) BOOL hasImax;//IMAX
@property (nonatomic) BOOL hasPromotion;
@property (nonatomic) BOOL hasPlan;//是否在预售
@property (nonatomic, copy) NSNumber * hot;
@property (nonatomic, copy) NSNumber * lookCount;
@property (nonatomic, copy) NSNumber * movieId;
@property (nonatomic, copy) NSNumber * movieLength;
@property (nonatomic, copy) NSString * movieName;
@property (nonatomic, copy) NSString * movieType;
@property (nonatomic, copy) NSString * language;
@property (nonatomic, copy) NSString * pathVerticalS;//竖海报
@property (nonatomic, copy) NSNumber * planCount;   //这个城市这个影片排了多少场
@property (nonatomic, copy) NSDate * publishTime;
@property (nonatomic, copy) NSString * score;
@property (nonatomic, copy) NSString * title;

@property (nonatomic, copy) NSString * shortTitle;
@property (nonatomic, copy) NSString * country;

@property (nonatomic, copy) NSString * thumbPath;//posterPath
@property (nonatomic, copy) NSString * thumbPathSmall;//pathSquare方形海报


//miss filmId filmName

@property (nonatomic, copy) NSString * halfPosterPath;
@property (nonatomic, copy) NSString * moviePoint;
@property (nonatomic, copy) NSString * place;
@property (nonatomic, copy) NSString * starringActor;

@property (nonatomic, copy) NSString * movieIntro;
@property (nonatomic, copy) NSString * movieDirector;


@property (nonatomic, copy) NSString * commentOrderId;



/**
 [Banner]
 */
@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, strong) Trailer * trailer;
// TODO: trailer信息移到trailer对象
@property (nonatomic, copy) NSString * movieTrailer;//预告片url



- (NSString *)getMovieLength;

+ (Movie *)getMovieWithId:(NSUInteger)movieId;

@end
