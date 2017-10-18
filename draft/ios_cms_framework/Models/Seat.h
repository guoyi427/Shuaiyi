//
//  Seat.h
//  CIASMovie
//
//  Created by cias on 2016/12/24.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <HallView_KKZ/SeatProtocol.h>


@interface Seat :MTLModel<MTLJSONSerializing, SeatProtocol>

@property (nonatomic, copy) NSString * cinemaId;
@property (nonatomic, copy) NSString * hallId;
@property (nonatomic, copy) NSString * seatId;//seatNO
@property (nonatomic, strong) NSNumber * sectionId;

@property (nonatomic, copy) NSString * seatRow;
@property (nonatomic, copy) NSString * seatCol;
@property (nonatomic, copy) NSNumber * graphRow;
@property (nonatomic, copy) NSNumber * graphCol;

/**
 *  座位状态 原始值 0: 可用 1: 不可用
 */
@property (nonatomic, copy) NSNumber * seatStateOrigin;
/**
 *  座位类型 0: 普通座位 1: 情侣座
 */
@property (nonatomic, copy) NSNumber * seatType;
/**
 *  情侣座 yes：左 no：右
 */
@property (nonatomic) BOOL isLoverL;


@property (nonatomic, readonly) float distanceToCenter;
/**
 *  MARK: 计算出距中心的距离
 *
 *  @param centerRow 中心row
 *  @param centerCol 中心col
 */
- (void) calculateDistanceToCenterAt:(int) centerRow centerCol:(int)centerCol;

@end
