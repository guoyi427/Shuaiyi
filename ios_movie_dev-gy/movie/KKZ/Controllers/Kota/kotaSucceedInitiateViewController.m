//
//  发起约电影成功页面
//
//  Created by avatar on 15-1-7.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "kotaSucceedInitiateViewController.h"

#import "applyForViewController.h"

@implementation kotaSucceedInitiateViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.kkzTitleLabel.text = @"发起约电影";

    holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, 320, screentContentHeight - 44)];
    holder.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:holder];

    UIImage *img = [UIImage imageNamed:@"kotaSucceedInitiate"];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    imgV.userInteractionEnabled = YES;
    imgV.image = img;

    RoundCornersButton *doneBtn0 = [[RoundCornersButton alloc] init];
    doneBtn0.frame = CGRectMake(15, CGRectGetMaxY(imgV.frame) - 40, 137.5, 40);
    doneBtn0.cornerNum = 1;
    doneBtn0.rimWidth = 1;
    doneBtn0.titleName = @"查看";
    doneBtn0.rimColor = appDelegate.kkzBlue;
    doneBtn0.titleFont = [UIFont systemFontOfSize:14];
    doneBtn0.titleColor = appDelegate.kkzBlue;
    doneBtn0.backgroundColor = [UIColor whiteColor];
    [doneBtn0 addTarget:self action:@selector(doneBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [imgV addSubview:doneBtn0];

    RoundCornersButton *doneBtn = [[RoundCornersButton alloc] init];
    doneBtn.frame = CGRectMake(167.5, CGRectGetMaxY(imgV.frame) - 40, 137.5, 40);
    doneBtn.cornerNum = 1;
    doneBtn.rimWidth = 1;
    doneBtn.titleName = @"返回";
    doneBtn.rimColor = appDelegate.kkzBlue;
    doneBtn.titleFont = [UIFont systemFontOfSize:14];
    doneBtn.titleColor = appDelegate.kkzBlue;
    doneBtn.backgroundColor = [UIColor whiteColor];
    [doneBtn addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];
    [imgV addSubview:doneBtn];

    [holder addSubview:imgV];

    holder.contentSize = CGSizeMake(320, CGRectGetMaxY(doneBtn.frame) + 20);
}

- (void)doneBtnClicked {
    [self popToViewControllerAnimated:NO];

    [appDelegate setSelectedPage:2 tabBar:YES];
}

@end
