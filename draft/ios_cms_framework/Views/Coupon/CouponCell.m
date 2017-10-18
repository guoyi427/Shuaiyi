//
//  CouponCell.m
//  CIASMovie
//
//  Created by cias on 2017/2/25.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "CouponCell.h"
#import "KKZTextUtility.h"

@implementation CouponCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        tipLabel = [UILabel new];
        tipLabel.textColor = [UIColor colorWithHex:@"#333333"];
        tipLabel.textAlignment = NSTextAlignmentLeft;
        tipLabel.font = [UIFont systemFontOfSize:30];
        [self addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(10));
            make.left.equalTo(@(35));
            make.width.equalTo(@(60));
            make.height.equalTo(@(30));
        }];
        typeLabel = [UILabel new];
        typeLabel.textColor = [UIColor colorWithHex:@"#333333"];
        typeLabel.textAlignment = NSTextAlignmentLeft;
        typeLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:typeLabel];
        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(12));
            make.left.equalTo(tipLabel.mas_right).offset(10);
            make.width.equalTo(@(150));
            make.height.equalTo(@(14));
        }];
        detailLabel = [UILabel new];
        detailLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(typeLabel.mas_bottom).offset(0);
            make.left.equalTo(tipLabel.mas_right).offset(10);
            make.width.equalTo(@(kCommonScreenWidth-70));
            make.height.equalTo(@(15));
        }];
        dateLabel = [UILabel new];
        dateLabel.textColor = [UIColor colorWithHex:@"#ff9900"];
        dateLabel.textAlignment = NSTextAlignmentLeft;
        dateLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:dateLabel];
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tipLabel.mas_bottom).offset(5);
            make.left.equalTo(@(35));
            make.width.equalTo(@(kCommonScreenWidth-70));
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
            make.top.equalTo(@(25));
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
    tipLabel.textColor = [UIColor colorWithHex:@"#333333"];
    typeLabel.textColor = [UIColor colorWithHex:@"#333333"];
    detailLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    dateLabel.textColor = [UIColor colorWithHex:@"#ff9900"];

    if (self.isFromConfirm) {
        tipLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        typeLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        detailLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        dateLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        
    }
    selectedImageView.hidden = YES;
    
    if (self.isShow) {
        selectedImageView.hidden = NO;
    }

    tipLabel.text = [self.myCoupon.couponType integerValue] == 1 ? @"通兑":@"￥24";
    CGSize cardNameSize = [KKZTextUtility measureText:tipLabel.text font:[UIFont systemFontOfSize:30]];
    [tipLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(10));
        make.left.equalTo(@(35));
        make.width.equalTo(@(cardNameSize.width+5));
        make.height.equalTo(@(30));
    }];
    typeLabel.text = self.myCoupon.couponName;
    detailLabel.text = self.myCoupon.remark;
    dateLabel.text = [NSString stringWithFormat:@"有效期%@至%@", self.myCoupon.startTime, self.myCoupon.endTime];
}

- (void)usedCellEcardNo{
    if (self.isSelect) {
        selectedImageView.hidden = NO;
    }else{
        selectedImageView.hidden = YES;
    }
}
@end
