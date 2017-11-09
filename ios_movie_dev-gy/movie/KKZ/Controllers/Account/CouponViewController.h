//
//  CouponViewController.h
//  KoMovie
//
//  Created by kokozu on 27/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"

static NSString *CellSelectedKey = @"selected";

@class CouponViewController;
@protocol CouponViewControllerDelegate <NSObject>

- (void)couponViewController:(CouponViewController *)viewController didSelectedCouponList:(NSArray *)list type:(CouponType)type;

@end

@interface CouponViewController : CommonViewController

@property (nonatomic, assign) CouponType type;
@property (nonatomic, assign) BOOL comefromPay;
@property (nonatomic, weak) id<CouponViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *selectedList;
@property (nonatomic, strong) NSString *orderId;

@end
