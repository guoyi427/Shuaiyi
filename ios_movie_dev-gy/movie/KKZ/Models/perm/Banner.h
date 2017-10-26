//
//  Banner.h
//  KoMovie
//
//  Created by gree2 on 19/4/13.
//  Copyright (c) 2013 kokozu. All rights reserved.
//

#import <Mantle/Mantle.h>
typedef enum {
    MediaTypeMoviePost = 10, //
    MediaTypeMovieTrailer = 11,   //
    MediaTypeCinemaPhotos = 20,   //
    MediaTypeCinemaLogo = 21,   //
} MediaType;


@interface Banner : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSNumber * bannerId;
@property (nonatomic, copy) NSString * imagePath;
@property (nonatomic, copy) NSNumber * targetId;//资讯，活动
@property (nonatomic, copy) NSNumber * targetType;//...
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * targetUrl;
@property (nonatomic, copy) NSString * tag;//活动标签，电影列表页面活动列表

+ (Banner *)getBannerWithId:(unsigned int)bannerId;

@end
