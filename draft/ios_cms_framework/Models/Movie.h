//
//  Movie.h
//  CIASMovie
//
//  Created by cias on 2016/12/19.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Movie : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSString *movieId;
@property (nonatomic, copy)NSString *filmName;
@property (nonatomic, copy)NSString *fakeName;
@property (nonatomic, copy)NSString *duration;
@property (nonatomic, copy)NSString *publishDate;
@property (nonatomic, copy)NSString *filmType;
@property (nonatomic, copy)NSString *language;
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

+ (Movie *)getMovieWithId:(NSString *)movieId;

@end
