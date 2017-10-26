//
//  约电影的帮助页面
//
//  Created by avatar on 14-11-19.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "KotaHelpInfoViewController.h"
#import "RoundCornersButton.h"
#import "UIConstants.h"

@interface KotaHelpInfoViewController ()

@end

@implementation KotaHelpInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.kkzTitleLabel.text = @"发起约电影";

    holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)];
    holder.backgroundColor = [UIColor whiteColor];
    holder.alwaysBounceVertical = YES;
    [self.view addSubview:holder];

    CGFloat positionY = 15;

    [self showMessageWithTitle:@"什么是约电影？" andMsg1:@"我们希望大家通过约电影结识更多的朋友，请主动发起约电影吧！" andMsg2:@"" andPositionY:positionY];

    positionY += 92;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(15, positionY - 10, (screentWith - 15 * 2), 1)];
    line.backgroundColor = kUIColorDivider;
    [holder addSubview:line];

    [self showMessageWithTitle:@"如何发起约电影？" andMsg1:@"方法1：点击”发起约电影“按钮直接发起；" andMsg2:@"方法2：您在一个订单内只购买了一张电影票，系统将默认推送至约电影，当然推送的信息不会包含您的购票信息（可在设置中手动开关此功能）；" andPositionY:positionY];

    positionY += 145;
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(15, positionY - 10, (screentWith - 15 * 2), 1)];
    line1.backgroundColor = kUIColorDivider;
    [holder addSubview:line1];

    [self showMessageWithTitle:@"如何申请与TA约电影？" andMsg1:@"进入”约电影“查看进行中的约会，点击”申请与TA观影”的按钮，填写留言请求并发出申请，待对方接受你的申请后，便能查看到对方的场次和座位，选择一个靠近TA的位置，并完成购票，即可完成约电影，接下来请自由发挥吧" andMsg2:@"" andPositionY:positionY];

    positionY += 145;
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(15, positionY - 10, (screentWith - 15 * 2), 1)];
    line2.backgroundColor = kUIColorDivider;
    [holder addSubview:line2];

    [self showMessageWithTitle:@"注意：" andMsg1:@"1.目前仅支持正在放映和即将上映影片发起约电影；" andMsg2:@"2.如果不希望分享约电影，可在设置中关闭该功能；" andPositionY:positionY];

    positionY += 125;

    RoundCornersButton *doneBtn = [[RoundCornersButton alloc] init];
    doneBtn.frame = CGRectMake(15, positionY, screentWith - 15 * 2, 40);
    doneBtn.cornerNum = kDimensCornerNum;
    doneBtn.titleName = @"我知道了";
    doneBtn.titleFont = [UIFont systemFontOfSize:kTextSizeButtonLarge];
    doneBtn.titleColor = [UIColor whiteColor];
    doneBtn.backgroundColor = appDelegate.kkzBlue;
    [doneBtn addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];
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

    UILabel *v1 = [[UILabel alloc] initWithFrame:CGRectMake(marginX, positionT, (screentWith - marginX * 2), s1.height)];
    v1.text = msg1;
    v1.font = [UIFont systemFontOfSize:14];
    v1.textColor = [UIColor grayColor];
    v1.numberOfLines = 0;
    positionT += s1.height;

    CGSize s2 = [msg2 sizeWithFont:[UIFont systemFontOfSize:14]

                 constrainedToSize:CGSizeMake((screentWith - marginX * 2), MAXFLOAT)];

    UILabel *v2 = [[UILabel alloc] initWithFrame:CGRectMake(marginX, positionT, (screentWith - marginX * 2), s2.height)];
    v2.text = msg2;
    v2.font = [UIFont systemFontOfSize:14];
    v2.textColor = [UIColor grayColor];
    v2.numberOfLines = 0;

    [holder addSubview:tV];
    [holder addSubview:v1];
    [holder addSubview:v2];
}

@end
