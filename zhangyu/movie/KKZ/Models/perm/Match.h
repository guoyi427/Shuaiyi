//
//  Match.h
//  KoMovie
//
//  Created by XuYang on 13-8-12.
//  Copyright (c) 2013年 kokozu. All rights reserved.
//和电影里的相关，服装搭配

#import <Foundation/Foundation.h>
#import "Model.h"


@interface Match : Model


@property (nonatomic, assign) unsigned int matchId;
@property (nonatomic, assign) unsigned int movieId;
@property (nonatomic, strong) NSNumber * hot;
@property (nonatomic, strong) NSString *matchName;
@property (nonatomic,strong) NSString *imageBig;
@property (nonatomic,strong) NSString *imageOrigin;
@property (nonatomic,strong) NSString *imageSmall;
@property (nonatomic,strong) NSString *matchDesc;
@property (nonatomic,assign) unsigned int userId;
@property (nonatomic,strong) NSNumber *fansCnt;
@property (nonatomic,strong) NSDate *createTime;


@property (nonatomic, strong) NSString * leftImgUrl;
@property (nonatomic, strong) NSString * rightUpImgUrl;
@property (nonatomic, strong) NSString * rightDownImgUrl;
@property (nonatomic, strong) NSString * rightUpName;
@property (nonatomic, strong) NSString * rightDownName;
@property (nonatomic, strong) NSNumber * rightUpPrice;
@property (nonatomic, strong) NSNumber * rightDownPrice;
@property (nonatomic, strong) NSString * rightUpLink;
@property (nonatomic, strong) NSString * rightDownLink;

+ (Match *)getMatchWithId:(unsigned int)matchId;

@end
