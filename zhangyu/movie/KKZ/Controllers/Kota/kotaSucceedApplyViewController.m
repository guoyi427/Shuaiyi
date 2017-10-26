//
//  约电影申请成功页面
//
//  Created by avatar on 15-1-7.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "kotaSucceedApplyViewController.h"

@implementation kotaSucceedApplyViewController

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

    RoundCornersButton *doneBtn = [[RoundCornersButton alloc] init];
    doneBtn.frame = CGRectMake(15, CGRectGetMaxY(imgV.frame) - 40, 290, 40);
    doneBtn.cornerNum = 1;
    doneBtn.rimWidth = 1;
    doneBtn.rimColor = appDelegate.kkzBlue;

    doneBtn.titleName = @"返回";
    doneBtn.titleFont = [UIFont systemFontOfSize:14];
    doneBtn.titleColor = appDelegate.kkzBlue;
    doneBtn.backgroundColor = [UIColor whiteColor];
    [doneBtn addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];
    [imgV addSubview:doneBtn];

    [holder addSubview:imgV];

    holder.contentSize = CGSizeMake(320, CGRectGetMaxY(doneBtn.frame) + 20);
}

@end
