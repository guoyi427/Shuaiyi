//
//  CouponCell.m
//  KoMovie
//
//  Created by kokozu on 27/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CouponCell.h"

#import "CouponViewController.h"

@interface CouponCell ()
{
    UIImageView *_stateBgView;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_priceLabel;
    UIImageView *_selectedStateView;
}
@end

@implementation CouponCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _stateBgView = [[UIImageView alloc] init];
        [self.contentView addSubview:_stateBgView];
        [_stateBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(5);
            make.height.mas_equalTo(105);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:18];
        [_stateBgView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(35);
            make.left.mas_equalTo(20);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [_stateBgView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel);
            make.top.equalTo(_nameLabel.mas_bottom).offset(10);
        }];
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = [UIColor whiteColor];
        _priceLabel.font = [UIFont systemFontOfSize:28];
        [_stateBgView addSubview:_priceLabel];
        [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_stateBgView);
            make.right.mas_equalTo(-30);
        }];
        
        _selectedStateView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CouponList_normal"]];
        _selectedStateView.hidden = true;
        [_stateBgView addSubview:_selectedStateView];
        [_selectedStateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_stateBgView).offset(-10);
            make.bottom.equalTo(_stateBgView).offset(-10);
        }];
    }
    return self;
}

- (void)updateWithDic:(NSDictionary *)dic comefromPay:(BOOL)pay {
    if ([dic[@"remainCount"] boolValue]) {
        _stateBgView.image = [UIImage imageNamed:@"CouponList_pink"];
    } else {
        _stateBgView.image = [UIImage imageNamed:@"CouponList_gray"];
    }
    
    _nameLabel.text = dic[@"info"][@"name"];
    _timeLabel.text = dic[@"expireDate"];
    _priceLabel.text = dic[@"info"][@"price"];
    
    _selectedStateView.hidden = !pay;
    //  判断是否选中
    if ([dic[CellSelectedKey] boolValue]) {
        _selectedStateView.image = [UIImage imageNamed:@"CouponList_selected"];
    } else {
        _selectedStateView.image = [UIImage imageNamed:@"CouponList_normal"];
    }
}

@end
