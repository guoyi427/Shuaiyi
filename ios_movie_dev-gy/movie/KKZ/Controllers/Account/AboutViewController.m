//
//  AboutViewController.m
//  KoMovie
//
//  Created by kokozu on 15/11/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.kkzTitleLabel.text = @"关于章鱼";
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"About_icon"]];
    [self.view addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(150);
    }];
    
    //  客服电话
    UILabel *telphoneLabel = [[UILabel alloc] init];
    telphoneLabel.text = @"客服电话 400-030-1053";
    telphoneLabel.textColor = appDelegate.kkzPink;
    telphoneLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:telphoneLabel];
    [telphoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.mas_equalTo(-130);
    }];
    
    //  工作时间
    UILabel *workTimeLabel = [[UILabel alloc] init];
    workTimeLabel.text = @"工作时间：早9:00-晚22:00";
    workTimeLabel.textColor = appDelegate.kkzGray;
    workTimeLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:workTimeLabel];
    [workTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(telphoneLabel.mas_bottom).offset(3);
    }];
    
    //
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.text = @"©2017 All Rights Reserved Asia Innovations Ltd.";
    bottomLabel.font = [UIFont systemFontOfSize:12];
    bottomLabel.textColor = [UIColor grayColor];
    [self.view addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-20);
    }];
}

@end
