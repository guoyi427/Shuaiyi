//
//  PayTypeCell.m
//  CIASMovie
//
//  Created by cias on 2017/2/8.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "PayTypeCell.h"

@implementation PayTypeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        tipLabel = [UILabel new];
        tipLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        tipLabel.textAlignment = NSTextAlignmentLeft;
        tipLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(15));
            make.left.equalTo(@(35));
            make.width.equalTo(@(60));
            make.height.equalTo(@(16));
        }];
        payTypeLabel = [UILabel new];
        payTypeLabel.textColor = [UIColor colorWithHex:@"#333333"];
        payTypeLabel.textAlignment = NSTextAlignmentLeft;
        payTypeLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:payTypeLabel];
        [payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(15));
            make.left.equalTo(tipLabel.mas_right).offset(3);
            make.width.equalTo(@(150));
            make.height.equalTo(@(16));
        }];
//        selectedImageView = [UIImageView new];
//        selectedImageView.backgroundColor = [UIColor redColor];
//        selectedImageView.clipsToBounds = YES;
//        selectedImageView.hidden = YES;
//        selectedImageView.image = [UIImage imageNamed:@"list_selected_icon"];
//        selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
//        [self addSubview:selectedImageView];
//        [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@(13));
//            make.right.equalTo(self.mas_right).offset(35);
//            make.width.equalTo(@(20));
//            make.height.equalTo(@(20));
//        }];

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
    if (self.payTypeNum==1) {
        tipLabel.text = @"其他支付";
        payTypeLabel.text = @"在线支付";
    }
}


@end
