//
//  SeatHelper.h
//  HallView
//
//  Created by Albert on 7/26/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeatProtocol.h"

@interface SeatHelper : NSObject
/**
 *  筛选出可选座位
 *
 *  @param allSeats         全部座位
 *  @param unavailableSeats 不可选座位
 *
 *  @return 可全座位
 */
+ (NSArray *__nullable) availableSeatsWithAllSeats:(NSArray *__nullable)allSeats unavailableSeats:(NSArray *__nullable)unavailableSeats;
/**
 *  获取2个推荐座位
 *
 *  @param availableSeats 可选座位列表
 *  @param maxRow         最大row
 *  @param maxCol         最大col
 *
 *  @return 两个座位
 */
+ (NSArray *__nullable) getTowSeatsFrom:(NSArray *__nullable)availableSeats maxGraphRow:(int)maxRow maxGraphCol:(int)maxCol;
/**
 *  获取一个推荐座位
 *
 *  @param availableSeats 可选座位列表
 *  @param maxRow         最大row
 *  @param maxCol         最大col
 *
 *  @return 一个座位
 */
+ (id<SeatProtocol> __nullable) getOneSeatsFrom:(NSArray *__nullable)availableSeats maxGraphRow:(int)maxRow maxGraphCol:(int)maxCol;
@end
