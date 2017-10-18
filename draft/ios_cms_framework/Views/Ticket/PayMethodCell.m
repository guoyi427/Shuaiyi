//
//  PayMethodCell.m
//  CIASMovie
//
//  Created by hqlgree2 on 09/01/2017.
//  Copyright © 2017 cias. All rights reserved.
//

#import "PayMethodCell.h"

@implementation PayMethodCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        selectedImageView = [UIImageView new];
        selectedImageView.backgroundColor = [UIColor redColor];
        selectedImageView.clipsToBounds = YES;
        selectedImageView.hidden = YES;
        selectedImageView.image = [UIImage imageNamed:@"list_selected_icon"];
        selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:selectedImageView];
        
        logoImageView = [UIImageView new];
        logoImageView.backgroundColor = [UIColor clearColor];
        logoImageView.clipsToBounds = YES;
        logoImageView.image = [UIImage imageNamed:@"alipay_icon"];
        logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:logoImageView];
        
        payMethodLabel = [UILabel new];
        payMethodLabel.textColor = [UIColor colorWithHex:@"#333333"];
        payMethodLabel.textAlignment = NSTextAlignmentLeft;
        payMethodLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:payMethodLabel];
        
        [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(17));
            make.right.equalTo(self.mas_right).offset(35);
            make.width.equalTo(@(20));
            make.height.equalTo(@(20));
        }];
        [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(16));
            make.left.equalTo(@(15));
            make.width.equalTo(@(28));
            make.height.equalTo(@(22));
        }];

        [payMethodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(logoImageView.mas_right).offset(10);
            make.top.equalTo(@(18));
            make.width.equalTo(@(100));
            make.height.equalTo(@(14));
        }];


        UIView *line = [UIView new];
        line.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.top.equalTo(self.mas_bottom).offset(-0.5);
            make.height.equalTo(@(0.5));
        }];

    }
    return self;
}

- (void)updateLayout{
    if (self.payTypeNum==PayMethodAlipay) {
        logoImageView.image = [UIImage imageNamed:@"alipay_icon"];
        payMethodLabel.text = @"支付宝";
    }else if(self.payTypeNum==PayMethodWeChat){
        logoImageView.image = [UIImage imageNamed:@"weixinpay_icon"];
        payMethodLabel.text = @"微信支付";

    }
  
}

@end
