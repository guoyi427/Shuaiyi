//
//  ProductListDetail.h
//  CIASMovie
//
//  Created by cias on 2017/3/3.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ProductListDetail : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong)NSArray *list;
@property (nonatomic, copy)NSString *goodsType;//1系统方卖品  2自营卖品

@end
