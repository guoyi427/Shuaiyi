//
//  SeatTask.h
//  kokozu
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "NetworkTask.h"
#import <Foundation/Foundation.h>

@interface SeatTask : NetworkTask {

  float ticketPrice;
  BOOL notRefreshAll;
  BOOL showAvailable;
}

@property(nonatomic, strong) NSString *seatNo;
@property(nonatomic, strong) NSString *kotaSeatNo;
@property(nonatomic, strong) NSString *seatInfo;
@property(nonatomic, strong) NSString *orderNo;
@property(nonatomic, strong) NSString *phone;

@property(nonatomic, strong) NSString *ticketId;
@property(nonatomic, strong) NSString *cinemaId;
@property(nonatomic, strong) NSString *hallId;

/**
 * 查询影厅的座位图。
 *
 * @param hallid   <#hallid description#>
 * @param cinemaid <#cinemaid description#>
 * @param ticketId <#ticketId description#>
 * @param block    <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initQueryCinemaSeatForHallid:(NSString *)hallid
                       andCienmaId:(NSString *)cinemaid
                         andTicket:(NSString *)ticketId
                          finished:(FinishDownLoadBlock)block;

/**
 * 查询场次卖出的座位图
 *
 * @param ticketId <#ticketId description#>
 * @param block    <#block description#>
 *
 * @return <#return value description#>
 */
- (id)initQuerySoldSeatForTicket:(NSString *)ticketId
                        finished:(FinishDownLoadBlock)block;
@end
