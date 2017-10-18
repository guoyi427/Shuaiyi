//
//  BestSeatUtil.m
//  CIASMovie
//
//  Created by cias on 2017/3/24.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "BestSeatUtil.h"

#import "Seat.h"

@interface BestSeatUtil ()


@end

struct KSeatCoordinate {
    NSUInteger x;
    NSUInteger y;
};
typedef struct KSeatCoordinate KSeatCoordinate;

@implementation BestSeatUtil

- (id)init {
    self = [super init];
    if (self) {
   
    }
    return self;
}

- (void)setSeats:(NSMutableArray *)seats {
    _seats = seats;
    if (!seats || seats.count == 0) {
        return;
    }
    
    NSUInteger size = seats.count;
    NSUInteger maxCol = 0;
    NSUInteger maxRow = 0;
    for (int i = 0; i < size; i++) {
        Seat* seat = [seats objectAtIndex:i];
        maxCol = maxCol > [seat.graphCol integerValue] ? maxCol : [seat.graphCol integerValue];
        maxRow = maxRow > [seat.graphRow integerValue] ? maxRow : [seat.graphRow integerValue];
    }
    self.mMaxRow = maxRow;
    self.mMaxCol = maxCol;
    
    if (maxRow > 0 && maxCol > 0) {
        self.seatCoordinateArray = [[NSMutableArray alloc]initWithCapacity:maxRow * maxCol];
        self.seatDictionary = [NSMutableDictionary dictionaryWithCapacity:maxRow * maxCol];
        
        for (Seat *seat in seats) {
            // 座位列表的字典，key: row_col，value: seat
            int row = [seat.graphRow intValue], col = [seat.graphCol intValue];
            NSString* key = [NSString stringWithFormat:@"%d_%d", row, col];
            [self.seatDictionary setObject:seat forKey:key];
            
            // 座位的坐标列表，用于根据中心点的距离进行最优座位的排序
            struct KSeatCoordinate coordinate = { col, row };
            NSValue *value = [NSValue valueWithBytes:&coordinate objCType:@encode(struct KSeatCoordinate)];
            [self.seatCoordinateArray addObject:value];
        }
        
        // 最优座位
        NSUInteger centerX = (maxCol / 2) + (maxCol % 2);
        NSUInteger centerY = maxRow * 2 / 3;
        
        // 对座位的坐标按照距离进行排序
        [self.seatCoordinateArray sortUsingComparator:^NSComparisonResult(NSValue*  _Nonnull obj1, NSValue*  _Nonnull obj2) {
            struct KSeatCoordinate point1;
            [obj1 getValue:&point1];
            struct KSeatCoordinate point2;
            [obj2 getValue:&point2];
            
            // 按照距离中心点的距离排序，选取最优座位
            int lx = abs(centerX - point1.x);
            int ly = abs(centerY - point1.y);
            int rx = abs(centerX - point2.x);
            int ry = abs(centerY - point2.y);
            CGFloat dis1 = sqrt(lx * lx + ly * ly);
            CGFloat dis2 = sqrt(rx * rx + ry * ry);
            if (dis1 < dis2) {
                return -1;
            }
            else if (dis1 > dis2) {
                return 1;
            }
            
            int dX = lx - rx;
            int dY = ly - ry;
            if (dX < dY) { // 距离小的排前面
                return -1;
            } else {
#warning 逻辑待测试
                if (dX == 0) {
                    int result = (point2.y - point1.y);
                    if (result != 0) {
                        return result;
                    }
                }
                if (dY == 0) {
                    return (point2.x - point1.x);
                }
            }
            
            return 0;
        }];
    } else {
        self.seats = nil;
    }
}

- (NSMutableArray *)findRecommendSeats:(NSUInteger)recommendCount {
    if (!self.seatCoordinateArray || self.seatCoordinateArray.count == 0) {
        return nil;
    }
    
    NSMutableArray* result = [[NSMutableArray alloc] initWithCapacity:recommendCount];
    for (NSValue* value in self.seatCoordinateArray) {
        struct KSeatCoordinate point;
        [value getValue:&point];
        NSString* key = [NSString stringWithFormat:@"%ld_%ld", point.y, point.x];
        Seat *seat = [self.seatDictionary objectForKey:key];
        if (seat == nil || seat.seatState != SeatStateAvailable) {
            continue;
        }
        
        // 根据推荐座位的数量，先把中心的座位左移，然后向右取recommendCount数量的座位
        NSInteger col = point.x;
        if (recommendCount > 1) {
            col -= recommendCount / 2;
            if (self.mMaxCol % 2 == 0) {
                col += 1;
            }
            if (col < 0) {
                col = 0;
            }
        }
        // 根据坐标移动后的中心座位，向右取recommendCount数量的座位
        for (int i = 0; i < recommendCount; i++) {
            NSString *key = [NSString stringWithFormat:@"%ld_%ld", point.y, col + i];
            Seat *recommendSeat = [self.seatDictionary objectForKey:key];
            if (recommendSeat != nil && recommendSeat.seatState == SeatStateAvailable ) {
                [result addObject:recommendSeat];
            }
        }
        
        if (result.count == recommendCount && [self checkBlankSeats:result]) {
            return result;
        }
        [result removeAllObjects];
    }
    return result;
}


- (BOOL)checkBlankSeats:(NSMutableArray *)selectedSeats {
    for (Seat* seat in selectedSeats) {
        int row = [seat.graphRow integerValue];
        int originL = [seat.graphCol integerValue];
        int originR = originL;
        for (int col = originL; col <= self.mMaxCol; col++) {
            NSString *key = [NSString stringWithFormat:@"%d_%d", row, col];
            Seat *tmpSeat = [self.seatDictionary objectForKey:key];
            if ([selectedSeats containsObject:tmpSeat]) {
                originR = col;
            }
            else {
                break;
            }
        }
        /*
         同一排的座位
         1 左或右挨着已选座位或者边界，ok ！
         左或右不可能挨着自选
         左或右加1如果挨着自选，则中间隔的已选或者没座
         2 左右挨着空座，左右隔一个不挨着自选，已选，边界
         */
        int l1 = [self getSeatStateAtCol:originL - 1 andRow: row];
        int l2 = [self getSeatStateAtCol:originL - 2 andRow: row];
        int r1 = [self getSeatStateAtCol:originR + 1 andRow: row];
        int r2 = [self getSeatStateAtCol:originR + 2 andRow: row];
        
        if (l2 == 1 && l1 == 0) {
            return NO;
        }
        if (r2 == 1 && r1 == 0) {
            return NO;
        }
    }
    return YES;
}

- (int)getSeatStateAtCol:(int)col andRow:(int)row {
    if (col < 1 || row < 1 || col > self.mMaxCol || row > self.mMaxRow) {
        return -1;
    } else {
        NSString *key = [NSString stringWithFormat:@"%d_%d", row, col];
        Seat *seat = [self.seatDictionary objectForKey:key];
        return seat.seatStateOrigin.intValue == SeatStateAvailable ? 0 : 1;
    }
}

@end
