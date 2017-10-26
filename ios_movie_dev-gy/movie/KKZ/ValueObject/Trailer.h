//
//  Trailer.h
//  KoMovie
//
//  Created by 艾广华 on 16/3/1.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Mantle/MTLModel.h>

@interface Trailer : MTLModel <MTLJSONSerializing>

/**
 *  视频封面
 */
@property (nonatomic, copy) NSString *trailerCover;

/**
 *  视频播放地址
 */
@property (nonatomic, copy) NSString *trailerPath;

/**
 *  电影Id
 */
@property (nonatomic, copy) NSNumber *movieId;

@property (nonatomic, copy) NSNumber *trailerId;

/**
 *  初始化视频类
 *
 *  @param dict
 *
 *  @return
 */
- (Trailer *)initWithDict:(NSDictionary *)dict;

@end
