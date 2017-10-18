//
//  CouponCell.h
//  CIASMovie
//
//  Created by cias on 2017/2/25.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"
@interface CouponCell : UITableViewCell
{
    UILabel *tipLabel,*typeLabel, *detailLabel, *dateLabel;
    UIImageView *selectedImageView;
}

@property (nonatomic, assign) NSInteger indexPathNum;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isFromConfirm;

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong) Coupon * myCoupon;

- (void)updateLayout;
- (void)usedCellEcardNo;

@end
