//
//  红包规则页面
//
//  Created by KKZ on 15/8/13.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "RedCouponHelpInfoViewController.h"
#import "RoundCornersButton.h"
#import "UIConstants.h"

static const CGFloat kPageMargin = 15.f;

@interface RedCouponHelpInfoViewController ()

@property (nonatomic, strong) UIScrollView *holder;

@end

@implementation RedCouponHelpInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.kkzTitleLabel.text = @"红包规则";
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.holder];

    NSArray *infos = @[
        @{ @"title" : @"1、红包的作用？",
           @"message" : @"您支付订单的时候，可用红包抵付现金。" },
        @{ @"title" : @"2、红包如何获得？",
           @"message" : @"用户通过微信等平台，获得抠电影送红包活动的红包金额奖励。\n获得红包后，抠电影新用户（首次使用手机注册的用户），注册完成后，便可使用现金红包。\n无论用户手机号码是否已被注册或手机曾用其他号码注册过抠电影账户，获得的红包将同步到参与红包活动的手机号上。" },
        @{ @"title" : @"3、红包如何使用？",
           @"message" : @"在订单支付页中，如果您的订单允许使用红包，抠电影会根据您的可用红包余额自动帮您计算出该订单最大的红包抵用金额，支付时所需现金相应扣减。暂不支持手动修改红包支付金额。\n若您的红包金额不足以支付订单金额，则不足部分仍需您继续使用其他方式予以支付。" },
        @{ @"title" : @"4、红包发放、使用的限制说明？",
           @"message" : @"4.1 券码类购买订单不支持使用红包支付。\n4.2 红包有效期限制，您领取的红包超过有效期，则到期红包自动失效，您的红包金额相应减少。红包金额不可提现。" },
        @{ @"title" : @"5、使用红包的订单退款",
           @"message" : @"如果订单申请退款成功，订单中红包支付的金额暂不支持返还到您的红包中；如果订单同时使用红包及余额支付，部分退款时优先退余额，红包部分请联系客服协商解决。" }
    ];

    CGFloat top = [self addMessageViews:infos];

    UITextField *telephone = [[UITextField alloc] initWithFrame:CGRectMake(0, top, screentWith, 20)];
    telephone.userInteractionEnabled = NO;
    telephone.text = @"客服电话: 400-000-9666";
    telephone.font = [UIFont systemFontOfSize:14];
    telephone.textColor = [UIColor grayColor];
    telephone.textAlignment = NSTextAlignmentCenter;
    [self.holder addSubview:telephone];

    top += 45;

    RoundCornersButton *doneBtn = [[RoundCornersButton alloc] init];
    doneBtn.frame = CGRectMake(kPageMargin, top, screentWith - kPageMargin * 2, 44);
    doneBtn.cornerNum = 4;
    doneBtn.titleName = @"我知道了";
    doneBtn.titleFont = [UIFont systemFontOfSize:kTextSizeButtonLarge];
    doneBtn.titleColor = [UIColor whiteColor];
    doneBtn.backgroundColor = appDelegate.kkzBlue;
    [doneBtn addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.holder addSubview:doneBtn];

    self.holder.contentSize = CGSizeMake(screentWith, CGRectGetMaxY(doneBtn.frame) + 20);
}

#pragma mark Init views
- (UIScrollView *)holder {
    if (!_holder) {
        _holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)];
    }
    return _holder;
}

- (CGFloat)addMessageViews:(NSArray *)infos {
    CGFloat y = 0;
    CGFloat labelWidth = screentWith - kPageMargin * 2;
    NSUInteger count = infos.count;

    for (int i = 0; i < count; i++) {
        NSString *title = infos[i][@"title"];
        NSString *message = infos[i][@"message"];

        y += 12;

        CGRect titleRect = [title boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{
                                                NSFontAttributeName : [UIFont systemFontOfSize:16]
                                            }
                                               context:nil];
        CGSize titleSize = titleRect.size;

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPageMargin, y, labelWidth, titleSize.height)];
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = HEX(@"#008DFF");
        titleLabel.numberOfLines = 0;
        [self.holder addSubview:titleLabel];

        y += titleSize.height + 8;

        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4;

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:message];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [message length])];

        CGRect messageRect = [message boundingRectWithSize:CGSizeMake(labelWidth, MAXFLOAT)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{
                                                    NSFontAttributeName : [UIFont systemFontOfSize:14],
                                                    NSParagraphStyleAttributeName : paragraphStyle
                                                }
                                                   context:nil];

        CGSize messageSize = messageRect.size;
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPageMargin, y, labelWidth, messageSize.height)];
        messageLabel.attributedText = attributedString;
        messageLabel.font = [UIFont systemFontOfSize:14];
        messageLabel.textColor = [UIColor grayColor];
        messageLabel.numberOfLines = 0;
        [self.holder addSubview:messageLabel];

        y += messageSize.height + 20;

        if (i < count - 1) {
            UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(kPageMargin, y, labelWidth, 1)];
            divider.backgroundColor = kUIColorDivider;
            [self.holder addSubview:divider];
        }
    }
    return y;
}

#pragma mark Button tapped
- (void)doneButtonClicked {
    [self cancelViewController];
}

@end
