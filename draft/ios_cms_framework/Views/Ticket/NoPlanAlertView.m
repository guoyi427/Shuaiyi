//
//  NoPlanAlertView.m
//  CIASMovie
//
//  Created by cias on 2017/3/8.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "NoPlanAlertView.h"

@implementation NoPlanAlertView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *noImageView = [UIImageView new];
        [self addSubview:noImageView];
        noImageView.contentMode = UIViewContentModeScaleAspectFit;
        [noImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@((kCommonScreenWidth-180)/2));
            if (kCommonScreenWidth>320) {
                make.top.equalTo(@(130));
            }else{
                make.top.equalTo(@(100));
            }
            make.width.equalTo(@(180));
            make.height.equalTo(@(162));
        }];
        noImageView.image = [UIImage imageNamed:@"0film"];
        

        UILabel *alertLabel = [UILabel new];
        alertLabel.textColor = [UIColor colorWithHex:@"#333333"];
        alertLabel.textAlignment = NSTextAlignmentCenter;
        alertLabel.text = @"影院今日没有排片";
        alertLabel.font = [UIFont systemFontOfSize:24];
        [self addSubview:alertLabel];
        [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(noImageView.mas_bottom).offset(15);
            make.left.equalTo(@(0));
            make.width.equalTo(@(kCommonScreenWidth));
            make.height.equalTo(@(25));
        }];

        UILabel *tipLabel = [UILabel new];
        tipLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:13];
        tipLabel.text = @"想看马上告诉影院吧";
        [self addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertLabel.mas_bottom).offset(5);
            make.left.equalTo(@(0));
            make.width.equalTo(@(kCommonScreenWidth));
            make.height.equalTo(@(15));
        }];
        
    }
    return self;
}


@end
