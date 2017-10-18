//
//  OrderListData.h
//  CIASMovie
//
//  Created by avatar on 2017/1/22.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface OrderListData : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *totalpage; //
@property (nonatomic, assign) long maxresult; //
@property (nonatomic, assign) long currentpage; //
@property (nonatomic, copy) NSString *totalrecord; //
@property (nonatomic, assign) long pagecode; //
@property (nonatomic, assign) long firstResult; //
@property (nonatomic, strong) NSArray *records;
//

@end
