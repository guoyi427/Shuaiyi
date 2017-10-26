//
//  CinemaHelper.h
//  KoMovie
//
//  Created by Albert on 9/9/16.
//  Copyright © 2016 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CinemaHelper : NSObject

/**
 *  处理影院别表（将去过、收藏的影院后合并到cinemaList，去除重复影院，再按距离排序）
 *
 *  @param cinemaList    影院列表
 *  @param ticketCinemas 去过的影院
 *  @param favorCinemas  收藏的影院
 *
 *  @return 处理好的影院列表
 */
+ (NSArray *)cinemaListFrom:(NSArray *)cinemaList
              ticketCinemas:(NSArray *)ticketCinemas
               favorCinemas:(NSArray *)favorCinemas;

/**
 *  将两个电影列表合并，过滤重复
 *
 *  @param cinemas      影院列表<CineamDetail>
 *  @param a_cinemas    另外一个影院列表<CineamDetail> 在a_cinemas移除重复的影院
 *
 *  @return 合并后全部影院<CineamDetail>
 */
+ (NSArray *)combineAndFileterDuplicateCinemas:(NSArray *)cinemas
                                  atherCinemas:(NSArray *)a_cinemas;

/**
 *  根据城区分组
 *
 *  @param cinemas 影院列表
 *  @param finish  完成回调 districts: <NSString> 朝阳区(32家),
 * dictrictsCinemas: [[Cinema, Cinema], [Cinema, Cinema]]
 */
+ (void)groupDistrict:(NSArray *)cinemas
               finish:(void (^)(NSArray *districts,
                                NSArray *districtsCinemas))finish;

@end
