//
//  SeatTask.m
//  kokozu
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "SeatTask.h"
#import "Constants.h"
#import "Cinema.h"
#import "Ticket.h"
#import "Order.h"
#import "Hall.h"
#import "Seat.h"
#import "PlatformVO.h"
#import "DateEngine.h"
#import "DataEngine.h"
#import "MemContainer.h"

@implementation SeatTask

@synthesize orderNo = _orderNo, phone = _phone;
@synthesize seatNo = _seatNo, seatInfo = _seatInfo;
@synthesize cinemaId = _cinemaId, hallId = _hallId, ticketId = _ticketId;

//影院厅图
- (id)initQueryCinemaSeatForHallid:(NSString *)hallid
                       andCienmaId:(NSString *)cinemaid
                         andTicket:(NSString *)ticketId
                          finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeCinemaSeatList;
    self.hallId = hallid;
    self.cinemaId = cinemaid;
    self.ticketId = ticketId;
    self.finishBlock = block;
  }
  return self;
}

//影院已售座位图
- (id)initQuerySoldSeatForTicket:(NSString *)ticketId
                        finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeSoldSeatList;
    self.ticketId = ticketId;
    self.finishBlock = block;
  }
  return self;
}

- (int)cacheVaildTime {
  if (taskType == TaskTypeCinemaSeatList) {
    return 15;
  }
  return 0;
}

- (void)getReady {
  //        获取厅图通过seat_Query接口 hall_id和cinema_id
  //        获取已售的座位使用seat_Query接口传plan_id，only_unavailable 传false

  if (taskType == TaskTypeCinemaSeatList) {

    [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];
    [self addParametersWithValue:@"seat_Hall" forKey:@"action"];
    [self addParametersWithValue:self.hallId forKey:@"hall_id"];
    [self addParametersWithValue:self.cinemaId forKey:@"cinema_id"];
    [self addParametersWithValue:self.ticketId forKey:@"plan_id"];
    [self setRequestMethod:@"GET"];
  }
  if (taskType == TaskTypeSoldSeatList) {

    [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];
    [self addParametersWithValue:@"seat_Query" forKey:@"action"];
    [self addParametersWithValue:self.ticketId forKey:@"plan_id"];
    [self addParametersWithValue:@"true" forKey:@"only_unavailable"];
    [self setRequestMethod:@"GET"];
  }
}

#pragma mark required method
- (void)requestSucceededWithData:(id)result {

}

- (void)requestFailedWithError:(NSError *)error {
  if (taskType == TaskTypeCinemaSeatList) {
    DLog(@"TaskTypeCinemaSeatList failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  }
  if (taskType == TaskTypeSoldSeatList) {
    DLog(@"TaskTypeSoldSeatList failed: %@", [error description]);
    [self doCallBack:NO info:[error userInfo]];
  }
}

- (void)requestSucceededConnection {
  // if needed do something after connected to net, handle here
}

// upload process
- (void)uploadBytesWritten:(NSInteger)written
         totalBytesWritten:(NSInteger)totalWritten
 totalBytesExpectedToWrite:(NSInteger)totalExpectedToWrite {
  // just for upload task
}

@end
