//
//  RedCoupon.h
//  KoMovie
//
//  Created by gree2 on 18/10/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import "Model.h"

@interface RedCoupon : Model

@property (nonatomic, retain) NSNumber * redRemainAmount;//
@property (nonatomic, retain) NSString * status;//状态
@property (nonatomic, retain) NSString * sourceTypeStr;
@property (nonatomic, retain) NSString * redUtimeStart;
@property (nonatomic, retain) NSString * redUtimeEnd;
@property (nonatomic, retain) NSString * note;
//没用
//+ (RedCoupon *)getRedCouponWithId:(unsigned int)rId;
- (BOOL)RedCouponIsValid;

@end
