//
//  我的 - 我的红包 页面列表
//
//  Created by gree2 on 17/10/14.
//  Copyright (c) 2014 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "RedCoupon.h"

@interface RedEnvelopeCell : UITableViewCell {

    UILabel *titleLabel, *validateLabel, *statusLabel, *aboutLabel, *titleLabelText;
}

@property (nonatomic, strong) RedCoupon *myRedCoupon;

- (void)updateLayout;

@end
