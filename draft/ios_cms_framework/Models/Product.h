//
//  Product.h
//  CIASMovie
//
//  Created by cias on 2017/3/3.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Product : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy)NSString *productId;
@property (nonatomic, copy)NSString *couponName;
@property (nonatomic, copy)NSString *couponBrief;
@property (nonatomic, copy)NSString *couponType;
@property (nonatomic, copy)NSString *showPictureUrl;
@property (nonatomic, copy)NSString *saleLimit;
@property (nonatomic, strong)NSDictionary *saleChannel;

@end
