//
//  ConstantHeader.h
//  CIASMovie
//
//  Created by avatar on 2017/4/17.
//  Copyright © 2017年 cias. All rights reserved.
//

#ifndef ConstantHeader_h
#define ConstantHeader_h



typedef enum {
    PayMethodBalance = 0,
    PayMethodAlipay = 1,
    PayMethodUnionpay = 3,
    PayMethodWeChat = 5,
    PayMethodCode,
    PayMethodCard = 28,
    PayMethodApplePay = 31,
} PayMethod;


#endif /* ConstantHeader_h */
