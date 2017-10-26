//
//  PaymentModel.h
//  KoMovie
//
//  Created by 艾广华 on 16/3/9.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentModel : NSObject

/**
 *  标题详细
 */
@property (nonatomic, copy) NSString *intro;

/**
 *  支付方式
 */
@property (nonatomic, assign) PayMethod payMethod;

/**
 *  支付方式title
 */
@property (nonatomic, copy) NSString *desc;

/**
 *  支付方式
 */
@property (nonatomic, assign) BOOL selected;

@end
