//
//  SeatHelper.m
//  HallView
//
//  Created by Albert on 7/26/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import "SeatHelper.h"
#import <math.h>

@implementation SeatHelper

+ (NSArray *) availableSeatsWithAllSeats:(NSArray *)allSeats unavailableSeats:(NSArray *)unavailableSeats
{
    if (unavailableSeats.count == 0) {
        return allSeats;
    }
    
    if (unavailableSeats.count == allSeats.count || allSeats.count == 0) {
        return nil;
    }
    
    NSMutableArray *muAllSeats = [NSMutableArray arrayWithArray:allSeats];
    
    //防止unavailableSeats有可用座位
    NSMutableArray *unavailbleSeatsCheack = [NSMutableArray arrayWithArray:unavailableSeats];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"seatState = %@ OR seatState = %@ OR seatState = %@", @(SeatStateUnavailable), @(SeatStateLoverLUnavailable), @(SeatStateLoverRUnavailable)];
    [unavailbleSeatsCheack filterUsingPredicate:predicate];
    
    [unavailbleSeatsCheack enumerateObjectsUsingBlock:^(id<SeatProtocol> seat, NSUInteger idx, BOOL * _Nonnull stop) {
        //条件谓词，选出seatId不在unavailableSeats内的
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K != %@", @"seatId", seat.seatId];
        [muAllSeats filterUsingPredicate:predicate];    //在所有座位里去除不可选座位
    }];
    return [muAllSeats copy];
}

+ (NSArray *) getTowSeatsFrom:(NSArray *)availableSeats maxGraphRow:(int)maxRow maxGraphCol:(int)maxCol
{
    if (availableSeats.count == 0) {
        return nil;
    }
    
    if (availableSeats.count <= 2) {
        return [availableSeats copy];
    }
    
    NSArray *sortedSeats = [self calculateAvalaibleSeats:availableSeats maxGraphRow:maxRow maxGraphCol:maxCol];
    
    NSMutableArray *chooseSeats = [NSMutableArray arrayWithCapacity:2];
    
    for (NSInteger i = 0; i < sortedSeats.count; i++) {
        id<SeatProtocol> seat = sortedSeats[i];
        
        
        id<SeatProtocol> seatL = [[self class] getLeftSeat:seat inList:sortedSeats];
        
        if (seatL && seatL.seatState == seat.seatState && seat.seatState == SeatStateAvailable) {
            [chooseSeats addObject:seat];
            [chooseSeats addObject:seatL];
            break;
        }
        
        id<SeatProtocol> seatR = [[self class] getRightSeat:seat inList:sortedSeats];
        if (seatR && seatR.seatState == seat.seatState && seat.seatState == SeatStateAvailable) {
            [chooseSeats addObject:seat];
            [chooseSeats addObject:seatR];
            break;
        }
        
        if (seat.seatState == SeatStateLoverL) {
            //情侣座 左
            id<SeatProtocol> seatR = [[self class] getRightSeat:seat inList:sortedSeats];
            if (seatR &&seatR.seatState == SeatStateLoverR) {
                [chooseSeats addObject:seat];
                [chooseSeats addObject:seatR];
                break;
            }
        }
        
        if (seat.seatState == SeatStateLoverR) {
            //情侣座 右
            id<SeatProtocol> seatL = [[self class] getLeftSeat:seat inList:sortedSeats];
            if (seatL && seatL.seatState == SeatStateLoverL) {
                [chooseSeats addObject:seatL];
                [chooseSeats addObject:seat];
                break;
            }
        }
        
    }
    
    NSLog(@"seat is %@", chooseSeats);
    
    return [chooseSeats copy];
    
}

/**
 *  将可用座位计算距中心距离并排序
 *
 *  @param availableSeats 可用座位
 *  @param maxRow         最大row
 *  @param maxCol         最大col
 *
 *  @return 按距中心距离排序好的座位列表
 */
+ (NSArray *) calculateAvalaibleSeats:(NSArray *)availableSeats maxGraphRow:(int)maxRow maxGraphCol:(int)maxCol
{
    
    if (availableSeats.count <= 1) {
        return availableSeats;
    }
    
    //找中心座位
    int centerRow = ceil(maxRow/2.0);
    int centerCol = 0;
    //偶数＋1，奇数向上取整
    if (maxCol%2 == 0) {
        centerCol = maxCol/2 + 1;
    }else{
        centerCol = ceil(maxCol/2.0) ;
    }
    
    
    [availableSeats enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id<SeatProtocol> seat = obj;
        [seat calculateDistanceToCenterAt:centerRow centerCol:centerCol];
    }];
    
    
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"distanceToCenter" ascending:YES]];
    NSArray *sortedSeats = [availableSeats sortedArrayUsingDescriptors:sortDescriptors];
    
    return sortedSeats;
}


+ (id<SeatProtocol> __nullable) getOneSeatsFrom:(NSArray *__nullable)availableSeats maxGraphRow:(int)maxRow maxGraphCol:(int)maxCol
{
    if (availableSeats.count == 0) {
        return nil;
    }
    
    if (availableSeats.count == 1) {
        return [availableSeats firstObject];
    }
    
    NSArray *sortedSeats = [self calculateAvalaibleSeats:availableSeats maxGraphRow:maxRow maxGraphCol:maxCol];
    return sortedSeats.firstObject;
    
}

+ (id<SeatProtocol>) getLeftSeat:(id<SeatProtocol>)seat inList:(NSArray *)list
{
    id<SeatProtocol> seatL = [[self class] getSeatWith:seat.graphRow.intValue col:seat.graphCol.intValue - 1 inSeats:list];
    return seatL;
}

+ (id<SeatProtocol>) getRightSeat:(id<SeatProtocol>)seat inList:(NSArray *)list
{
    id<SeatProtocol> seatL = [[self class] getSeatWith:seat.graphRow.intValue col:seat.graphCol.intValue + 1 inSeats:list];
    return seatL;
}

+ (id<SeatProtocol>) getSeatWith:(int)row col:(int)col inSeats:(NSArray *)seats
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"graphRow = %@ && graphCol = %@", @(row), @(col)];
    NSArray *resault = [seats filteredArrayUsingPredicate:predicate];
    if (resault.count > 0) {
        return resault.firstObject;
    }
    
    return nil;
}

@end
