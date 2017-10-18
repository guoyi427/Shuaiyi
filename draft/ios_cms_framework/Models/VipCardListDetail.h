//
//  VipCardListDetail.h
//  CIASMovie
//
//  Created by cias on 2017/2/24.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface VipCardListDetail : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSNumber *page;
@property (nonatomic, copy)NSNumber *pageSize;

@property (nonatomic, strong)NSArray *rows;

@end
