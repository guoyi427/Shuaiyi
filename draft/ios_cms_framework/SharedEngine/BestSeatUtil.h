//
//  BestSeatUtil.h
//  CIASMovie
//
//  Created by cias on 2017/3/24.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BestSeatUtil : NSObject

@property(nonatomic, assign) NSUInteger mMaxRow;
@property(nonatomic, assign) NSUInteger mMaxCol;

@property(nonatomic, strong) NSMutableArray *seats; // 座位列表
@property(nonatomic, strong) NSMutableDictionary *seatDictionary; // 按照座位的排、列生成的二维数组
@property(nonatomic, strong) NSMutableArray<NSValue *> *seatCoordinateArray; // 用于定位

/**
 * 查找推荐的座位。
 *
 * @param recommendCount 推荐座位的数量
 */
- (NSMutableArray *)findRecommendSeats:(NSUInteger)recommendCount;

@end
