//
//  CouponRedeemCell.h
//  KoMovie
//
//  Created by kokozu on 27/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponRedeemCell : UITableViewCell

- (void)updateWithDic:(NSDictionary *)dic comefromPay:(BOOL)pay;

- (void)updateCardWithDic:(NSDictionary *)dic comfromPay:(BOOL)pay;

@end
