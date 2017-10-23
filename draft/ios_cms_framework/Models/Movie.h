//
//  Movie.h
//  CIASMovie
//
//  Created by cias on 2016/12/19.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Movie : MTLModel<MTLJSONSerializing>

//@property (nonatomic, copy)NSString *movieId;
@property (nonatomic, copy)NSString *filmName;
@property (nonatomic, copy)NSString *fakeName;
@property (nonatomic, copy)NSString *duration;
@property (nonatomic, copy)NSString *publishDate;
@property (nonatomic, copy)NSString *filmType;
//@property (nonatomic, copy)NSString *language;
@property (nonatomic, copy)NSString *publishPlace;
@property (nonatomic, copy)NSString *filmPoster;
@property (nonatomic, copy)NSString *filmPosterHorizon;
@property (nonatomic, copy)NSString *introduction;
@property (nonatomic, copy)NSString *availableScreenType;
@property (nonatomic, copy)NSString *point;
@property (nonatomic, copy)NSString *isSale;//无用
@property (nonatomic, copy)NSString *isDiscount;//优惠1是0否

@property (nonatomic, copy)NSString *isPresell;//预售

@property (nonatomic, copy)NSString *discountTag;//优惠活动描述
@property (nonatomic, copy)NSString *note;//一句话点评

@property (nonatomic, strong)NSArray *filmPeoples;

@property (nonatomic, copy)NSString *actors;
@property (nonatomic, copy)NSString *director;
@property (nonatomic, copy)NSString *filmCode;
//@property (nonatomic, copy)NSString *filmId;

//--------------
@property(nonatomic) BOOL isInTheater;


//  -------------kkz
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
//@property (nonatomic, strong) Trailer * trailer;
// TODO: trailer信息移到trailer对象
@property (nonatomic, copy) NSString * movieTrailer;//预告片url


+ (Movie *)getMovieWithId:(NSUInteger)movieId;


//  -----------------   kkz
- (NSString *)getMovieLength;
@end
