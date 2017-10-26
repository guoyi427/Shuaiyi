//
//  我的 - 我的红包 页面列表的header view
//
//  Created by gree2 on 17/10/14.
//  Copyright (c) 2014 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "RedCoupon.h"

@interface RedEnvelopeHeaderView : UIView {

    UILabel *redCouponTipLabel;
    UILabel *redCouponMoney;
    UILabel *lastRedInfoLabel;
    UIView *yellowView;
    UIView *bgV;
    UIView *line;

    UIImageView *avatorImgV, *avatorImgVBg;
    UILabel *nickNameLab;
    UILabel *lab2;
    UIView *lastRedInfoV;
}

@property (nonatomic, assign) float redAmount;

@property (nonatomic, strong) RedCoupon *lastRedCoupon;

- (void)updateLayout;

@end
