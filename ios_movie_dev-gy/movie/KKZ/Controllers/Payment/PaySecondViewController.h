//
//  PaySecondViewController.h
//  KoMovie
//
//  Created by kokozu on 31/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"

@class Order, PayView;
@interface PaySecondViewController : CommonViewController

@property (nonatomic, strong) Order *myOrder;
@property (nonatomic, assign) BOOL isFromCoupon;
@property (nonatomic, strong)   PayView *payView;

@end
