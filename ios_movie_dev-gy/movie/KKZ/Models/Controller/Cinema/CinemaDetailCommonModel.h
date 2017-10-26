//
//  CinemaDetailCommonModel.h
//  KoMovie
//
//  Created by 艾广华 on 16/4/19.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CinemaDetailCommonModelDelegate <NSObject>

/**
 *  收藏状态
 *
 *  @param isCollect
 */
- (void)cinemaCollectStatusChanged:(BOOL)isCollect;

@end

@interface CinemaDetailCommonModel : NSObject

/**
 *  代理对象
 */
@property (nonatomic, weak)id<CinemaDetailCommonModelDelegate>delegate;

/**
 *  单例对象
 *
 *  @return
 */
+(CinemaDetailCommonModel *)sharedInstance;

/**
 *  收藏影院请求
 *
 *  @param cinemaId 影院Id
 */
- (void)doCollectCinemaWithCinemaId:(NSInteger)cinemaId;

/**
 *  查看收藏影院的请求
 *
 *  @param cinemaId 影院Id
 */
- (void)refreshFavCinemaWithCinemaId:(NSInteger)cinemaId;

/**
 *  是否已经收藏过影院
 */
@property (nonatomic, assign) BOOL isCollected;

@end
