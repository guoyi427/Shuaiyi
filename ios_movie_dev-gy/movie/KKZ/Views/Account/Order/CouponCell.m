//
//  CouponCell.m
//  KoMovie
//
//  Created by kokozu on 27/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CouponCell.h"

@interface CouponCell ()
{
    UIImageView *_stateBgView;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_priceLabel;
}
@end

@implementation CouponCell

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
    }
    return self;
}

- (void)updateName:(NSString *)name
              time:(NSString *)time
             price:(NSString *)price
            canBuy:(NSNumber *)canBuy {
    
    if (canBuy.boolValue) {
        _stateBgView.image = [UIImage imageNamed:@"CouponList_pink"];
    } else {
        _stateBgView.image = [UIImage imageNamed:@"CouponList_gray"];
    }
    
    _nameLabel.text = name;
    _timeLabel.text = time;
    _priceLabel.text = price;
}

@end
