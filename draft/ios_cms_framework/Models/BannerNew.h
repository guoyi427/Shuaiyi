//
//  BannerNew.h
//  CIASMovie
//
//  Created by avatar on 2017/7/5.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef enum {
    MediaTypeMoviePost = 10, //
    MediaTypeMovieTrailer = 11,   //
    MediaTypeCinemaPhotos = 20,   //
    MediaTypeCinemaLogo = 21,   //
} MediaType;

@interface BannerNew : MTLModel<MTLJSONSerializing>




@property (nonatomic, copy)NSString *slideImg;
@property (nonatomic, copy)NSString *slideUrl;
@property (nonatomic, copy)NSString *slideTitle;


//  ---------- kkz

@property (nonatomic, copy) NSNumber * bannerId;
@property (nonatomic, copy) NSString * imagePath;
@property (nonatomic, copy) NSNumber * targetId;//资讯，活动
@property (nonatomic, copy) NSNumber * targetType;//...
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * targetUrl;
@property (nonatomic, copy) NSString * tag;//活动标签，电影列表页面活动列表

+ (BannerNew *)getBannerWithId:(unsigned int)bannerId;


@end
