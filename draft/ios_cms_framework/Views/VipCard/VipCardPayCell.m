//
//  VipCardPayCell.m
//  CIASMovie
//
//  Created by cias on 2017/2/23.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "VipCardPayCell.h"
#import "KKZTextUtility.h"

@implementation VipCardPayCell

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
            make.top.equalTo(@(16));
            make.left.equalTo(@(35));
            make.width.equalTo(@(60));
            make.height.equalTo(@(16));
        }];
        payCardNoLabel = [UILabel new];
        payCardNoLabel.textColor = [UIColor colorWithHex:@"#333333"];
        payCardNoLabel.textAlignment = NSTextAlignmentLeft;
        payCardNoLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:payCardNoLabel];
        [payCardNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(16));
            make.left.equalTo(tipLabel.mas_right).offset(10);
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
    tipLabel.text = self.myCard.useTypeName;
    CGSize cardNameSize = [KKZTextUtility measureText:self.myCard.useTypeName font:[UIFont systemFontOfSize:13]];
    [tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(16));
        make.left.equalTo(@(35));
        if (kCommonScreenWidth>375) {
            make.width.equalTo(@(cardNameSize.width+5));
        }else{
            make.width.equalTo(@(cardNameSize.width));
        }
        make.height.equalTo(@(16));
    }];
    if (self.myCard.cardNoView.length>0) {
//        payCardNoLabel.text = [NSString stringWithFormat:@"%@****", [self.myCard.cardNo substringToIndex:self.myCard.cardNo.length-4]];
        payCardNoLabel.text = self.myCard.cardNoView;
    }else{
        payCardNoLabel.text = @"";
    }
    [payCardNoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(16));
        make.left.equalTo(tipLabel.mas_right).offset(10);
        make.width.equalTo(@(150));
        make.height.equalTo(@(16));
    }];

}



@end
