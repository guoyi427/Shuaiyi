//
//  EcardHelpInfoViewController.m
//  KoMovie
//
//  Created by KKZ on 15/8/13.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "EcardHelpInfoViewController.h"
#import "RoundCornersButton.h"
#import "UIConstants.h"

@interface EcardHelpInfoViewController ()

@end

@implementation EcardHelpInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.kkzTitleLabel.text = @"优惠券/兑换券规则";

    holder = [[UIScrollView alloc]
            initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)];
    holder.backgroundColor = [UIColor whiteColor];
    holder.alwaysBounceVertical = YES;
    [self.view addSubview:holder];

    CGFloat positionY = 15;

    [self showMessageWithTitle:@"什么是优惠券/抵扣券？"
                         andMsg1:@"优惠券/"
                                 @"抵扣券是抠电影发行和认可的购物券，可以在抠电影消费付款时抵扣相应面值的金额。抠电影"
                                 @"的优惠券/抵扣券发放方式一般分为：公司团购；参与抠电影线上活动；市场合作类等。"
                         andMsg2:@""
                    andPositionY:positionY];

    positionY += 140;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, positionY - 10, (screentWith - 15 * 2), 1)];
    line.backgroundColor = kUIColorDivider;
    [holder addSubview:line];

    [self showMessageWithTitle:@"如何获取优惠券/抵扣券"
                         andMsg1:@"抠电影客户端和网站会不定期推出优惠券/"
                                 @"抵扣券相关活动，您可以经常打开抠电影，关注活动通知，及时参与优惠券/抵扣券活动。"
                         andMsg2:@""
                    andPositionY:positionY];

    positionY += 110;
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, positionY - 10, (screentWith - 15 * 2), 1)];
    line1.backgroundColor = kUIColorDivider;
    [holder addSubview:line1];

    [self showMessageWithTitle:@"如何使用优惠券/抵扣券"
                         andMsg1:@"在"
                                 @"网站或手机客户端付款页面中，都可以选择使用满足条件的券码，验证通过后，抵扣相应金额"
                                 @"；"
                         andMsg2:@""
                    andPositionY:positionY];

    positionY += 110;
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, positionY - 10, (screentWith - 15 * 2), 1)];
    line2.backgroundColor = kUIColorDivider;
    [holder addSubview:line2];

    [self showMessageWithTitle:@"优惠券/抵扣券找零兑现吗？"
                         andMsg1:@"优惠券/抵扣券不找零、不兑现。"
                         andMsg2:@""
                    andPositionY:positionY];

    positionY += 75;

    UITextField *tel = [[UITextField alloc] initWithFrame:CGRectMake(0, positionY - 10, screentWith, 20)];
    tel.userInteractionEnabled = NO;
    tel.text = @"客服电话: 400-030-1053";
    tel.font = [UIFont systemFontOfSize:14];
    tel.textColor = [UIColor grayColor];
    tel.textAlignment = NSTextAlignmentCenter;
    [holder addSubview:tel];

    //    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(15, positionY - 10, (320 - 15 * 2), 1)];
    //    line3.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    //    [holder addSubview:line3];

    positionY += 40;

    RoundCornersButton *doneBtn = [[RoundCornersButton alloc] init];
    doneBtn.frame = CGRectMake(15, positionY, screentWith - 15 * 2, 40);
    doneBtn.cornerNum = kDimensCornerNum;
    doneBtn.titleName = @"我知道了";
    doneBtn.titleFont = [UIFont systemFontOfSize:kTextSizeButtonLarge];
    doneBtn.titleColor = [UIColor whiteColor];
    doneBtn.backgroundColor = appDelegate.kkzBlue;
    [doneBtn addTarget:self action:@selector(doneBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [holder addSubview:doneBtn];

    holder.contentSize = CGSizeMake(screentWith, CGRectGetMaxY(doneBtn.frame) + 20);
}

- (void)showMessageWithTitle:(NSString *)t andMsg1:(NSString *)msg1 andMsg2:(NSString *)msg2 andPositionY:(CGFloat)y {
    CGFloat marginX = 15;

    CGFloat marginY = 8;

    CGFloat positionT = y + marginY;

    CGSize s = [t sizeWithFont:[UIFont systemFontOfSize:14]

             constrainedToSize:CGSizeMake((screentWith - marginX * 2), MAXFLOAT)];

    UILabel *tV = [[UILabel alloc] initWithFrame:CGRectMake(marginX, positionT, (screentWith - marginX * 2), s.height)];
    tV.text = t;
    tV.font = [UIFont systemFontOfSize:16];
    tV.textColor = [UIColor colorWithRed:0 / 255.0 green:141 / 255.0 blue:255 / 255.0 alpha:1];
    tV.numberOfLines = 0;
    positionT += s.height + marginY;

    CGSize s1 = [msg1 sizeWithFont:[UIFont systemFontOfSize:14]

                 constrainedToSize:CGSizeMake((screentWith - marginX * 2), MAXFLOAT)];

    UILabel *v1 =
            [[UILabel alloc] initWithFrame:CGRectMake(marginX, positionT, (screentWith - marginX * 2), s1.height)];
    v1.text = msg1;
    v1.font = [UIFont systemFontOfSize:14];
    v1.textColor = [UIColor grayColor];
    v1.numberOfLines = 0;
    positionT += s1.height;

    CGSize s2 = [msg2 sizeWithFont:[UIFont systemFontOfSize:14]

                 constrainedToSize:CGSizeMake((screentWith - marginX * 2), MAXFLOAT)];

    UILabel *v2 =
            [[UILabel alloc] initWithFrame:CGRectMake(marginX, positionT, (screentWith - marginX * 2), s2.height)];
    v2.text = msg2;
    v2.font = [UIFont systemFontOfSize:14];
    v2.textColor = [UIColor grayColor];
    v2.numberOfLines = 0;

    [holder addSubview:tV];
    [holder addSubview:v1];
    [holder addSubview:v2];
}

- (void)doneBtnClicked {
    [self popViewControllerAnimated:YES];
}

#pragma mark override from CommonViewController

- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return TRUE;
}

- (BOOL)showTitleBar {
    return TRUE;
}
@end
