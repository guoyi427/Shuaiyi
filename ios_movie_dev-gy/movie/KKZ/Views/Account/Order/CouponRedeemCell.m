//
//  CouponRedeemCell.m
//  KoMovie
//
//  Created by kokozu on 27/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CouponRedeemCell.h"

@interface CouponRedeemCell ()
{
    UIImageView *_stateBgView;
    UILabel *_nameLabel;
    UILabel *_detailLabel;
    UILabel *_timeLabel;
    UILabel *_stateLabel;
    UILabel *_subStateLabel;
    
    UIImageView *_selectedStateView;
    
    //  储蓄卡
    UILabel *_cardValueLabel;
    UILabel *_remainValueLabel;
}
@end

@implementation CouponRedeemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
            make.top.mas_equalTo(25);
            make.left.mas_equalTo(20);
        }];
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.font = [UIFont systemFontOfSize:13];
        [_stateBgView addSubview:_detailLabel];
        [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel);
            make.top.equalTo(_nameLabel.mas_bottom).offset(4);
        }];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [_stateBgView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel);
            make.top.equalTo(_detailLabel.mas_bottom).offset(8);
        }];
        
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.font = [UIFont systemFontOfSize:22];
        [_stateBgView addSubview:_stateLabel];
        [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_stateBgView);//.offset(-20);
            make.right.mas_equalTo(-30);
        }];
        
        _subStateLabel = [[UILabel alloc] init];
        _subStateLabel.textColor = [UIColor whiteColor];
        _subStateLabel.font = [UIFont systemFontOfSize:13];
        [_stateBgView addSubview:_subStateLabel];
        [_subStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_stateBgView).offset(25);
            make.centerX.equalTo(_stateLabel);
        }];
        
        _selectedStateView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CouponList_normal"]];
        _selectedStateView.hidden = true;
        [_stateBgView addSubview:_selectedStateView];
        [_selectedStateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_stateBgView).offset(-20);
            make.bottom.equalTo(_stateBgView).offset(-20);
        }];
    }
    return self;
}

- (void)updateWithDic:(NSDictionary *)dic {
    BOOL canUse = [dic[@"remainCount"] boolValue];
    if (canUse) {
        _stateBgView.image = [UIImage imageNamed:@"CouponList_pink"];
    } else {
        _stateBgView.image = [UIImage imageNamed:@"CouponList_gray"];
    }
    
    _nameLabel.text = dic[@"info"][@"name"];
    _detailLabel.text = dic[@"info"][@"description"];
    _timeLabel.text = dic[@"expireDate"];
    _stateLabel.text = dic[@"info"][@"name"];
    
    //  判断是否选中
    if (1) {
        _selectedStateView.image = [UIImage imageNamed:@"CouponList_selected"];
    } else {
        _selectedStateView.image = [UIImage imageNamed:@"CouponList_normal"];
    }
}

- (void)updateCardWithDic:(NSDictionary *)dic {
    
    BOOL canUse = [dic[@"remainCount"] boolValue];
    if (canUse) {
        _stateBgView.image = [UIImage imageNamed:@"CouponList_pink"];
    } else {
        _stateBgView.image = [UIImage imageNamed:@"CouponList_gray"];
    }
    
//    _nameLabel.text = dic[@"info"][@"name"];
    _detailLabel.text = dic[@"info"][@"description"];
    _timeLabel.text = dic[@"expireDate"];
    _stateLabel.text = dic[@"info"][@"name"];
    
    _nameLabel.text = [NSString stringWithFormat:@"%@元 剩余：%@元", dic[@"cardValue"], dic[@"remainValue"]];
    
}

@end
