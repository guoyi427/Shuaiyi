//
//  支付订单页面支付方式的Cell
//
//  Created by gree2 on 18/9/14.
//  Copyright (c) 2014 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "PayTypeCell.h"

#import "DataEngine.h"
#import "KKZUtility.h"

#define kMarginX 15
#define kIconWith 30

@implementation PayTypeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        memberCard = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginX, (60 - kIconWith) * 0.5, kIconWith, kIconWith)];
        memberCard.image = [UIImage imageNamed:@""];
        [self addSubview:memberCard];

        memberTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(kIconWith + kMarginX * 2, 14, screentWith - (kIconWith + kMarginX * 2 + 60), 15)];
        memberTipLabel.backgroundColor = [UIColor clearColor];
        memberTipLabel.textColor = [UIColor blackColor];
        memberTipLabel.font = [UIFont systemFontOfSize:14];
        memberTipLabel.text = @"";
        [self addSubview:memberTipLabel];

        memberSubTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kIconWith + kMarginX * 2, CGRectGetMaxY(memberTipLabel.frame) + 5, screentWith - (kIconWith + kMarginX * 2 + 60), 15)];
        memberSubTitleLabel.backgroundColor = [UIColor clearColor];
        memberSubTitleLabel.textColor = [UIColor r:153 g:153 b:153];
        memberSubTitleLabel.font = [UIFont systemFontOfSize:12];
        memberSubTitleLabel.text = @"";
        [self addSubview:memberSubTitleLabel];

        self.balanceNotice = [[UILabel alloc] initWithFrame:CGRectMake(150, CGRectGetMaxY(memberTipLabel.frame) + 5, screentWith - (kIconWith + kMarginX * 2 + 60), 15)];
        self.balanceNotice.backgroundColor = [UIColor clearColor];
        self.balanceNotice.textColor = [UIColor r:255 g:105 b:0];
        self.balanceNotice.font = [UIFont systemFontOfSize:13];
        self.balanceNotice.text = @"金额不足";
        self.balanceNotice.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.balanceNotice];

        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(kMarginX, 60 - 1, screentWith - 15, 1)];
        line1.backgroundColor = [UIColor r:229 g:229 b:229 alpha:0.8];
        [self addSubview:line1];
    }
    return self;
}

- (void)updateLayout {
    if (self.payTypeNum == PayMethodVip) {
        memberCard.frame = CGRectMake(kMarginX, (60 - kIconWith) * 0.5, kIconWith, kIconWith);
        memberCard.image = [UIImage imageNamed:@"balance_method_icon"];
        memberTipLabel.text = @"账户余额";
        memberSubTitleLabel.text = [NSString stringWithFormat:@"余额：%.2f元", [DataEngine sharedDataEngine].vipBalance];
        self.balanceNotice.hidden = YES;
        memberSubTitleLabel.textColor = [UIColor r:153 g:153 b:153];
    }
    if (self.payTypeNum == PayMethodAliMoblie) {
        memberCard.frame = CGRectMake(kMarginX, (60 - kIconWith) * 0.5, kIconWith, kIconWith);
        memberCard.image = [UIImage imageNamed:@"alipay_method_icon"];
        memberTipLabel.text = @"支付宝移动快捷支付";

        if ([KKZUtility stringIsEmpty:self.memberSubTitle]) {
            memberSubTitleLabel.text = @"支持支付宝余额，各种网银支付";
            memberSubTitleLabel.textColor = [UIColor r:153 g:153 b:153];
        } else {
            memberSubTitleLabel.text = [self lastStrWithMemberSubTitle:self.memberSubTitle];
        }

        self.balanceNotice.hidden = YES;
    } else if (self.payTypeNum == PayMethodUnionpay) {
        memberCard.frame = CGRectMake(kMarginX, (60 - kIconWith) * 0.5, kIconWith, kIconWith);
        memberCard.image = [UIImage imageNamed:@"union_method_icon"];
        memberTipLabel.text = @"银联在线支付";

        if ([KKZUtility stringIsEmpty:self.memberSubTitle]) {
            memberSubTitleLabel.text = @"支持各大银行的信用卡和借记卡";
            memberSubTitleLabel.textColor = [UIColor r:153 g:153 b:153];
        } else {
            memberSubTitleLabel.text = [self lastStrWithMemberSubTitle:self.memberSubTitle];
        }

        self.balanceNotice.hidden = YES;
    } else if (self.payTypeNum == PayMethodWeiXin) {
        memberCard.frame = CGRectMake(kMarginX, (60 - kIconWith) * 0.5, kIconWith, kIconWith);
        memberCard.image = [UIImage imageNamed:@"wechat_method_icon"];
        memberTipLabel.text = @"微信客户端支付";

        if ([KKZUtility stringIsEmpty:self.memberSubTitle]) {
            memberSubTitleLabel.text = @"手机支付简单快捷，推荐使用";
            memberSubTitleLabel.textColor = [UIColor r:153 g:153 b:153];
        } else {
            memberSubTitleLabel.text = [self lastStrWithMemberSubTitle:self.memberSubTitle];
        }

        self.balanceNotice.hidden = YES;
    }
    if (self.payTypeNum == PayMethodYiZhiFu) {
        memberCard.frame = CGRectMake(kMarginX, (60 - kIconWith) * 0.5, kIconWith, kIconWith);
        memberCard.image = [UIImage imageNamed:@"yipay_method_icon"];
        memberTipLabel.text = @"翼支付";

        if ([KKZUtility stringIsEmpty:self.memberSubTitle]) {
            memberSubTitleLabel.text = @"中国电信移动支付产品";
            memberSubTitleLabel.textColor = [UIColor r:153 g:153 b:153];
        } else {
            memberSubTitleLabel.text = [self lastStrWithMemberSubTitle:self.memberSubTitle];
        }

        self.balanceNotice.hidden = YES;
    }
    if (self.payTypeNum == PayMethodJingDong) {
        memberCard.frame = CGRectMake(kMarginX, (60 - kIconWith) * 0.5, kIconWith, kIconWith);
        memberCard.image = [UIImage imageNamed:@"jingdong_method_icon"];
        memberTipLabel.text = @"京东支付";
        if ([KKZUtility stringIsEmpty:self.memberSubTitle]) {

            memberSubTitleLabel.text = @"京东旗下支付产品，支付安全快捷";
            memberSubTitleLabel.textColor = [UIColor r:153 g:153 b:153];
        } else {
            memberSubTitleLabel.text = [self lastStrWithMemberSubTitle:self.memberSubTitle];
        }
        self.balanceNotice.hidden = YES;

    } else if (self.payTypeNum == PayMethodPuFa) {
        memberCard.frame = CGRectMake(kMarginX, (60 - kIconWith) * 0.5, kIconWith, kIconWith);
        memberCard.image = [UIImage imageNamed:@"pufa_method_icon"];
        memberTipLabel.text = @"小浦支付";

        if ([KKZUtility stringIsEmpty:self.memberSubTitle]) {
            memberSubTitleLabel.text = @"浦发银行旗下支付产品，支付安全快捷";
            memberSubTitleLabel.textColor = [UIColor r:153 g:153 b:153];
        } else {
            memberSubTitleLabel.text = [self lastStrWithMemberSubTitle:self.memberSubTitle];
        }

        self.balanceNotice.hidden = YES;
    }
}

- (NSString *)lastStrWithMemberSubTitle:(NSString *)subTitle {
    NSArray *strArray = [self.memberSubTitle componentsSeparatedByString:@">"];
    if (strArray.count <= 1) {
        memberSubTitleLabel.textColor = [UIColor r:153 g:153 b:153];
        return self.memberSubTitle;
    } else {
        memberSubTitleLabel.textColor = [UIColor redColor];
        NSString *subStr = strArray[1];
        NSArray *subStrArray = [subStr componentsSeparatedByString:@"<"];
        NSString *lastStr = subStrArray[0];
        return lastStr;
    }
}

- (void)setIsbalanotHid:(BOOL)isbalanotHid {
    if (self.payTypeNum == PayMethodVip) {
        memberSubTitleLabel.text = [NSString stringWithFormat:@"余额：%.2f元", [DataEngine sharedDataEngine].vipBalance];
    }
    _isbalanotHid = isbalanotHid;
    self.balanceNotice.hidden = isbalanotHid;
}

@end
