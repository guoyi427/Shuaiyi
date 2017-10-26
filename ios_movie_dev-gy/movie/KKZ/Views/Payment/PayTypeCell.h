//
//  支付订单页面支付方式的Cell
//
//  Created by gree2 on 18/9/14.
//  Copyright (c) 2014 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@interface PayTypeCell : UITableViewCell {

    UIImageView *memberCard;
    UILabel *memberTipLabel, *tipLabel, *memberSubTitleLabel;
}

@property (nonatomic, assign) NSInteger payTypeNum;
@property (nonatomic, strong) UILabel *balanceNotice;
@property (nonatomic, assign) BOOL isbalanotHid;
@property (nonatomic, strong) NSString *memberSubTitle;

- (void)updateLayout;

@end
