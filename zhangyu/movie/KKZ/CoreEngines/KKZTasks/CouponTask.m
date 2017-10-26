//
//  CouponTask.m
//  kokozu
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "Activity.h"
#import "Constants.h"
#import "Coupon.h"
#import "CouponTask.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "MemContainer.h"

@implementation CouponTask

@synthesize cardType = _cardType;
@synthesize cinemaId = _cinemaId;
@synthesize activityId = _activityId;

- (id)initVipCardCheck:(NSString *)cardNo finished:(FinishDownLoadBlock)block {
  self = [super init];
  if (self) {
    self.taskType = TaskTypeVipCardCheck;
    self.cardType = cardNo;
    self.finishBlock = block;
  }
  return self;
}

- (void)getReady {
  if (taskType == TaskTypeVipCardCheck) {
    [self setRequestURL:[NSString stringWithFormat:@"%@/%@",kKSSBaseUrl,kKSSPServer]];
    [self addParametersWithValue:@"coupon_check" forKey:@"action"];
    [self addParametersWithValue:self.cardType forKey:@"coupon_id"];
    [self addParametersWithValue:@"c" forKey:@"order_type"];
    [self setRequestMethod:@"GET"];
  }
}

- (int)cacheVaildTime {
  return 0;
}

- (BOOL)cacheForToday {
  return NO;
}

#pragma mark required method
- (void)requestSucceededWithData:(id)result {
  if (taskType == TaskTypeVipCardCheck) {
    DLog(@"TaskTypeVipCardCheck succeded");
    NSDictionary *dict = (NSDictionary *)result;
    NSDictionary *coupon = [dict objectForKey:@"coupon"];
    NSString *couponNo = [coupon objectForKey:@"id"];
    NSString *price =
        [[[dict objectForKey:@"values"] objectAtIndex:0] objectForKey:@"value"];

    if (price.length == 0) {
      price = @"0";
    }

    [self doCallBack:YES info:@{ @"couponNo" : couponNo, @"price" : price }];
  }
}

- (void)requestFailedWithError:(NSError *)error {
  if (taskType == TaskTypeVipCardCheck) {
    DLog(@"TaskTypeVipCardCheck failed: %@", [error description]);
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
