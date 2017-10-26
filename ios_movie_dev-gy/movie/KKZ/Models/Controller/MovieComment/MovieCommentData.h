//
//  MovieCommentData.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/19.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieSelectHeader.h"

@interface MovieCommentData : NSObject

/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *imagesArray;

/**
 *  电影Id
 */
@property (nonatomic, strong) NSString *movieId;

/**
 *  订单Id
 */
@property (nonatomic, strong) NSString *orderId;

/**
 *  导航Id
 */
@property (nonatomic, assign) NSInteger navId;

/**
 *  电影名字
 */
@property (nonatomic, strong) NSString *movieName;

/**
 *  影院名字
 */
@property (nonatomic, strong) NSString *cinemaName;

/**
 *  影院Id
 */
@property (nonatomic, strong) NSString *cinemaId;

/**
 *  电影评论的输入文字
 */
@property (nonatomic, strong) NSString *inputString;

/**
 *  是否清空图片数组
 */
@property (nonatomic, assign) BOOL isClearImgArr;

/**
 *  单例方法
 *
 *  @return
 */
+(MovieCommentData *)sharedInstance;

/**
 *  释放蛋里对象
 */
- (void)freeMovieCommentData;

/**
 *  是否设置了影院Id
 *
 *  @return TRUE，代表已经设置了cinemaId,FALSE,代表没有设置cinemaId
 */
- (BOOL)isSetCinemaId;

/**
 *  是否设置了电影Id
 *
 *  @return TRUE，代表已经设置了cinemaId,FALSE,代表没有设置cinemaId
 */
- (BOOL)isSetMovieId;

/**
 *  通过评论类型返回对应的文字
 *
 *  @param type
 *
 *  @return
 */
- (NSString *)getCommentContentWithType:(chooseType)type;

@end
