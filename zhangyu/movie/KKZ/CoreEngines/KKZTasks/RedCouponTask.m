//
//  RedCouponTask.m
//  KoMovie
//
//  Created by gree2 on 17/10/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import "RedCouponTask.h"
#import "Constants.h"
#import "DataEngine.h"
#import "RedCoupon.h"
#import "MemContainer.h"

@implementation RedCouponTask


//TaskTypeRedAccounts


- (id)initUserRedAccountsUserfinished:(FinishDownLoadBlock)block{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeRedAccounts;
        self.finishBlock = block;
    }
    return self;
}

- (id)initUserRedCouponFee:(float)orderBalance andOrderNo:(NSString *)orderNo finished:(FinishDownLoadBlock)block{
    
    self = [super init];
    if (self) {
        self.taskType = TaskTypeRedCouponFee;
        self.orderBalance = orderBalance;
        self.orderNo = orderNo;
        self.finishBlock = block;
    }
    return self;
}

- (id)initUserRedCouponFeeListWithPage:(NSInteger)page finished:(FinishDownLoadBlock)block{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeRedCouponFeeList;
        self.pageNum = page;
        self.pageSize = 10;
        self.finishBlock = block;
    }
    return self;
}

- (void)getReady {
    if (taskType == TaskTypeRedCouponFee) {
        [self setRequestURL:[NSString stringWithFormat:@"%@%@",KKSSPRED,@"useRedEnvelop"]];
        [self addParametersWithValue:[NSString stringWithFormat:@"%.2f", self.orderBalance] forKey:@"orderAmount"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%@", self.orderNo] forKey:@"orderNo"];
        [self setRequestMethod:@"GET"];
        
    }else if (taskType == TaskTypeRedAccounts) {
        [self setRequestURL:[NSString stringWithFormat:@"%@%@",KKSSPRED,@"redEnvelopAccounts"]];
        [self addParametersWithValue:[DataEngine sharedDataEngine].userId forKey:@"userId"];
        [self setRequestMethod:@"GET"];
        
    }
    else if (taskType == TaskTypeRedCouponFeeList) {
        [self setRequestURL:[NSString stringWithFormat:@"%@%@",KKSSPRED,@"redEnvelopAccount"]];
        [self addParametersWithValue:[NSString stringWithFormat:@"%ld", (long)self.pageNum] forKey:@"pageNumber"];
        [self addParametersWithValue:[NSString stringWithFormat:@"%d", self.pageSize] forKey:@"pageSize"];
        [self setRequestMethod:@"GET"];
        
    }

}



#pragma mark required method
- (void)requestSucceededWithData:(id)result {
    if (taskType == TaskTypeRedCouponFee) {
        NSDictionary *dict = (NSDictionary *)result;
        DLog(@"TaskTypeRedCouponFee ...%@", dict);//availableAmount

        float redCouponValue = 0;
        NSDictionary*data = [dict objectForKey:@"data"];
        DLog(@"%@", [data kkz_objForKey:@"availableAmount"]);
        if ([data kkz_objForKey:@"availableAmount"]) {
            redCouponValue = [[data objectForKey:@"availableAmount"] floatValue];
        }
        [self doCallBack:YES info:@{@"availableAmount": @(redCouponValue)}];
    }else if (taskType == TaskTypeRedAccounts) {
         NSDictionary *dict = (NSDictionary *)result;
         NSDictionary*data = [dict objectForKey:@"data"];
        float redAccounts = 0;
        if ([data kkz_objForKey:@"totalAmount"]) {
            redAccounts = [[data objectForKey:@"totalAmount"] floatValue];
        }
        [self doCallBack:YES info:@{@"redAccounts": @(redAccounts)}];
    }
    else if (taskType == TaskTypeRedCouponFeeList) {
        NSDictionary *dict = (NSDictionary *)result;
        DLog(@"TaskTypeRedCouponFeeList ...%@", dict);
        
        NSDictionary *data = [dict objectForKey:@"data"];
        NSArray *redCouponList = [data objectForKey:@"list"];
        NSMutableArray *redCouponDBList = [[NSMutableArray alloc] init];
        NSDictionary *lastRedCoupon = [data kkz_objForKey:@"lastExpire"];
        NSNumber *totalAmount = [data kkz_floatNumberForKey:@"totalAmount"];
        
        RedCoupon *lastredCoupon = nil;
        
        NSNumber *existed1 = nil;
        lastredCoupon = (RedCoupon *)[[MemContainer me] instanceFromDict:lastRedCoupon
                                                                                  clazz:[RedCoupon class]
                                                                                  exist:&existed1];
        if ([redCouponList count]) {
            for (NSDictionary *redJson in redCouponList) {
                NSNumber *existed = nil;
                RedCoupon *redCoupon = (RedCoupon *)[[MemContainer me] instanceFromDict:redJson
                                                                           clazz:[RedCoupon class]
                                                                           exist:&existed];
                
                [redCouponDBList addObject:redCoupon];
            }
        } else {
            [self deleteCache];
        }
        
        if (lastredCoupon) {
            [self doCallBack:YES info: @{@"redCoupons":redCouponDBList,
                                         @"lastredCoupon":lastredCoupon,
                                         @"totalAmount":totalAmount,
                                         @"hasMore":[NSNumber numberWithBool:([redCouponDBList count] >= self.pageSize)],
                                         }];

        }else{
            [self doCallBack:YES info: @{@"redCoupons":redCouponDBList,
                                         @"totalAmount":totalAmount,
                                         @"hasMore":[NSNumber numberWithBool:([redCouponDBList count] >= self.pageSize)],
                                         }];

        }
        
    }

}

- (void)requestFailedWithError:(NSError *)error {
    if (taskType == TaskTypeRedCouponFee)
    {
        DLog(@"TaskTypeRedCouponFee task failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }else if (taskType == TaskTypeRedAccounts) {
        DLog(@"TaskTypeRedAccounts task failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }
    else if (taskType == TaskTypeRedCouponFeeList)
    {
        DLog(@"TaskTypeRedCouponFeeList task failed: %@", [error description]);
        [self doCallBack:NO info:[error userInfo]];
    }

}

@end
