//
//  CouponRedeemCell.m
//  KoMovie
//
//  Created by kokozu on 27/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CouponRedeemCell.h"

#import "CouponViewController.h"
#import "MovieRequest.h"

@interface CouponRedeemCell ()
{
    UIImageView *_stateBgView;
    UILabel *_nameLabel;
    UILabel *_detailLabel;
    UILabel *_timeLabel;
    UILabel *_stateLabel;
    UILabel *_subStateLabel;
    NSDictionary *_model;
    
    UIImageView *_selectedStateView;
    
    //  储蓄卡
    UILabel *_cardValueLabel;
    UILabel *_remainValueLabel;
    UIButton *_deleteCouponButton;
}
@end

@implementation CouponRedeemCell

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
            make.right.equalTo(_stateBgView).offset(-10);
            make.bottom.equalTo(_stateBgView).offset(-10);
        }];
        
        _deleteCouponButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteCouponButton setTitle:@"我要解绑>"
                            forState:UIControlStateNormal];
        [_deleteCouponButton setTitleColor:appDelegate.kkzPink forState:UIControlStateNormal];
        _deleteCouponButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_deleteCouponButton addTarget:self action:@selector(deleteCouponButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_stateBgView addSubview:_deleteCouponButton];
        [_deleteCouponButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_stateLabel);
            make.bottom.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(150, 50));
        }];
    }
    return self;
}

- (void)updateWithDic:(NSDictionary *)dic comefromPay:(BOOL)pay {
    BOOL canUse = [dic[@"remainCount"] boolValue];
    _model = dic;
    NSDate *couponDate = [NSDate dateWithTimeIntervalSince1970:[[[DateEngine sharedDateEngine] dateFromString:dic[@"expireDate"]] timeIntervalSince1970] + 86400];
    BOOL expire = [couponDate compare:[NSDate date]] == NSOrderedDescending;
    
    if (canUse && expire) {
        _stateBgView.image = [UIImage imageNamed:@"CouponList_pink"];
    } else {
        _stateBgView.image = [UIImage imageNamed:@"CouponList_gray"];
    }
    
    _nameLabel.text = [NSString stringWithFormat:@"%@", dic[@"info"][@"description"]];
    _detailLabel.text = [NSString stringWithFormat:@"章鱼码：%@", dic[@"couponId"]];
    _timeLabel.text = [[DateEngine sharedDateEngine] stringFromDateYYYYMMDD: [[DateEngine sharedDateEngine] dateFromString:dic[@"expireDate"]]];
    _stateLabel.text = dic[@"info"][@"name"];
    
    _deleteCouponButton.hidden = pay;
    _selectedStateView.hidden = !pay;
    //  判断是否选中
    if ([dic[CellSelectedKey] boolValue]) {
        _selectedStateView.image = [UIImage imageNamed:@"CouponList_selected"];
    } else {
        _selectedStateView.image = [UIImage imageNamed:@"CouponList_normal"];
    }
}

- (void)updateCardWithDic:(NSDictionary *)dic comfromPay:(BOOL)pay {
    _model = dic;
    NSDate *couponDate = [NSDate dateWithTimeIntervalSince1970:[[[DateEngine sharedDateEngine] dateFromString:dic[@"expireDate"]] timeIntervalSince1970] + 86400];
    BOOL expire = [couponDate compare:[NSDate date]] == NSOrderedDescending;
    
    BOOL canUse = [dic[@"remainCount"] boolValue];
    if (canUse && expire) {
        _stateBgView.image = [UIImage imageNamed:@"CouponList_pink"];
    } else {
        _stateBgView.image = [UIImage imageNamed:@"CouponList_gray"];
    }
    
    _nameLabel.text = [NSString stringWithFormat:@"%@元 剩余：%@元", dic[@"cardValue"], dic[@"remainValue"]];
    _detailLabel.text = [NSString stringWithFormat:@"章鱼卡：%@", dic[@"couponId"]];
    _timeLabel.text = [[DateEngine sharedDateEngine] stringFromDateYYYYMMDD: [[DateEngine sharedDateEngine] dateFromString:dic[@"expireDate"]]];;
    _stateLabel.text = dic[@"info"][@"name"];
    
    
    _deleteCouponButton.hidden = pay;
    _selectedStateView.hidden = !pay;
    //  判断是否选中
    if ([dic[CellSelectedKey] boolValue]) {
        _selectedStateView.image = [UIImage imageNamed:@"CouponList_selected"];
    } else {
        _selectedStateView.image = [UIImage imageNamed:@"CouponList_normal"];
    }
}

#pragma mark - UIButton - Action

- (void)deleteCouponButtonAction {
    [UIAlertView showAlertView:@"确认解绑卡券？" cancelText:@"取消" cancelTapped:^{
        
    } okText:@"确定" okTapped:^{
        MovieRequest *req = [[MovieRequest alloc] init];
        [req deleteCoupon:_model[@"couponId"] success:^{
            [UIAlertView showAlertView:@"解绑成功" buttonText:@"确定"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateCouponList" object:nil];
        } failure:^(NSError * _Nullable err) {
            [appDelegate showAlertViewForRequestInfo:err.userInfo];
        }];
    }];
}
@end
