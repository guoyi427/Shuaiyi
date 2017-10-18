//
//  PromotionCell.m
//  CIASMovie
//
//  Created by cias on 2017/2/25.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "PromotionCell.h"
#import "KKZTextUtility.h"

@implementation PromotionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        tipLabel = [UILabel new];
        tipLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        tipLabel.textAlignment = NSTextAlignmentLeft;
        tipLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(20));
            make.left.equalTo(@(35));
            make.width.equalTo(@(60));
            make.height.equalTo(@(16));
        }];
        payCardNoLabel = [UILabel new];
        payCardNoLabel.textColor = [UIColor colorWithHex:@"#333333"];
        payCardNoLabel.textAlignment = NSTextAlignmentLeft;
        payCardNoLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:payCardNoLabel];
        [payCardNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(20));
            make.left.equalTo(tipLabel.mas_right).offset(5);
            make.width.equalTo(@(150));
            make.height.equalTo(@(16));
        }];
        detailLabel = [UILabel new];
        detailLabel.textColor = [UIColor colorWithHex:@"#ff9900"];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipLabel.mas_bottom).offset(7);
            make.left.equalTo(@(35));
            make.width.equalTo(@(kCommonScreenWidth-70-20-10));
            make.height.equalTo(@(15));
        }];

        selectedImageView = [UIImageView new];
        selectedImageView.backgroundColor = [UIColor clearColor];
        selectedImageView.clipsToBounds = YES;
        selectedImageView.hidden = YES;
        selectedImageView.image = [UIImage imageNamed:@"list_selected_icon"];
        selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:selectedImageView];
        [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(27));
            make.right.equalTo(self.mas_right).offset(-35);
            make.width.equalTo(@(20));
            make.height.equalTo(@(20));
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
    selectedImageView.hidden = YES;

    if (self.isSelectCell) {
        selectedImageView.hidden = NO;
    }
    tipLabel.text = self.leftTitle;
    CGSize cardNameSize = [KKZTextUtility measureText:self.leftTitle font:[UIFont systemFontOfSize:16]];
    [tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(20));
        make.left.equalTo(@(35));
        make.width.equalTo(@(cardNameSize.width+5));
        make.height.equalTo(@(16));
    }];
    [payCardNoLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(20));
        make.left.equalTo(tipLabel.mas_right).offset(5);
        make.width.equalTo(@(kCommonScreenWidth-35-cardNameSize.width-10-35-20-10));
        make.height.equalTo(@(16));
    }];
    payCardNoLabel.text = self.rightTitle;
    detailLabel.text = self.detail;
}

@end
