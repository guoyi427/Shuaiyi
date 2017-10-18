//
//  SeatProtocol.h
//  HallView
//
//  Created by Albert on 14/04/2017.
//  Copyright © 2017 Kokozu. All rights reserved.
//

#ifndef SeatProtocol_h
#define SeatProtocol_h
typedef enum {
    SeatStateNone = -1,
    SeatStateAvailable,
    SeatStateUnavailable,
    SeatStateLoverL,
    SeatStateLoverR,
    SeatStateLoverLUnavailable,
    SeatStateLoverRUnavailable,
    SeatStateLoverLSelected,
    SeatStateLoverRSelected,
    SeatStateSelected,
} SeatState;

@protocol SeatProtocol <NSObject>
@property (nonatomic, copy) NSString * seatId;
@property (nonatomic, copy) NSString * seatRow;
@property (nonatomic, copy) NSString * seatCol;
@property (nonatomic, copy) NSNumber * graphRow;
@property (nonatomic, copy) NSNumber * graphCol;

- (SeatState) seatState;

@optional
/**
 *  MARK: 计算出距中心的距离
 *
 *  @param centerRow 中心row
 *  @param centerCol 中心col
 */
- (void) calculateDistanceToCenterAt:(int) centerRow centerCol:(int)centerCol;
@end

#endif /* SeatProtocol_h */
