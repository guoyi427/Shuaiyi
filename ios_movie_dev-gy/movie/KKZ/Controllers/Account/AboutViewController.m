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
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.textColor = [UIColor grayColor];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.text = @"关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼关于章鱼";
    textLabel.numberOfLines = 0;
    [self.view addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(64 + 20);
    }];
}

@end
