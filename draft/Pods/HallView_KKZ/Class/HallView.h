//
//  HallView.h
//  KKZ
//
//  Created by da zhang on 11-10-24.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeatProtocol.h"

@class HallView;
@protocol HallViewDelegate <NSObject>

@optional

- (void)selectEmptySeat;
- (void)selectNumReachMax;
/**
 座位是否可以被选
 
 @param seats 座位list
 @return yes：可选 no：不可选
 */
- (BOOL) shouldSelectSeats:(NSArray *)seats;

/**
 *  点击座位图
 *
 *  @param point                坐标
 *  @param changeStatus         是否改变了座位状态
 */
- (void) touchAt:(CGPoint)point didChangeSteatStatus:(BOOL)changeStatus;

@required
- (void)selectSeatAtColumn:(NSString *)col
                       row:(NSString *)row
                    withId:(NSString *)seatId;

- (void)deselectSeatAtColumn:(NSString *)col
                         row:(NSString *)row
                      withId:(NSString *)seatId;

@end

@interface HallView : UIView {
    
@private
    uint currentSelectedNum;
    NSMutableDictionary *seatNOs;
    UIImage *selected, *normal, *unavailable, *selectedKota, *loverL, *loverR, *selectLoverL, *selectLoverR, *loverLUnavailable, *loverRUnavailable;
    NSArray *allSeats;
}

@property (nonatomic, weak) id <HallViewDelegate> delegate;
@property (nonatomic, assign) int rowNum;
@property (nonatomic, assign) int columnNum;
@property (nonatomic, assign) int maxSelectedNum;
@property (nonatomic, strong) NSString *cinemaId;
@property (nonatomic, strong) NSString *hallId;
/**
 *  过道 排 <NSNumber>
 */
@property (nonatomic, strong, readonly) NSArray *aisle;

/**
 *  座位间隔 默认1；
 */
@property (nonatomic) CGFloat  space;

/**
 *  座位矩阵
 */
@property (nonatomic, strong, readonly) NSArray *seatMatrix;
/**
 *  可选座位图
 */
@property (nonatomic, strong, readonly) NSArray *availableSeats;

/**
 座位宽度
 */
@property (nonatomic, readonly) CGFloat seatWidth;

/**
 座位高度
 */
@property (nonatomic, readonly) CGFloat seatHeight;

/**
 选中座位的icon列表
 */
@property (nonatomic, strong) NSArray <UIImage *> *seatSeletedIcons;
/**
 *  跟新座位图
 *
 *  @param seatList 座位list（全部座位＋不可选座位）
 */
- (void)updateDataSource:(NSArray *)seatList;
- (void)updateLayout;
- (BOOL)hasEmtpySeats;
- (CGSize)sizeWithColumnNum:(int)col andRowNum:(int)row;
- (void)deselectSeatWithSeatId:(NSString *)seatId;

/**
 *  MARK: 选中座位
 *
 *  @param seat 座位
 */
- (void) selectSeat:(id<SeatProtocol>)seat;

/**
 *  MARK: 选中座位
 *
 *  @param seats 座位
 */
- (void) selectSeats:(NSArray *)seats;

/**
 *  MARK: 更新drawRect回调
 *
 *  @param a_block 回调
 */
- (void) setUpdateDrawCallBack:(void (^)())a_block;
/**
 *  MARK: 根据seatId获取Seat对象block
 *
 *  @param a_block block
 */
- (void) getSeatByIdBlock:(id<SeatProtocol>(^)(NSString *seatId))a_block;

/**
 根据seatID 获取seat 对象
 
 @param seatId seat id
 @return seat 对象
 */
- (id<SeatProtocol>) getSeatBy:(NSString *)seatId;
@end
