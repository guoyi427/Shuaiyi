//
//  ZYCinemaCell.m
//  KoMovie
//
//  Created by kokozu on 25/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "ZYCinemaCell.h"

@interface ZYCinemaCell ()
{
    UILabel *_cinemaNameLabel;
    UILabel *_cinemaAddressLabel;
    UILabel *_priceLabel;
    UILabel *_distanceLabel;
}
@end

@implementation ZYCinemaCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self prepareUI];
    }
    return self;
}

- (void)prepareUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _cinemaNameLabel = [[UILabel alloc] init];
    _cinemaNameLabel.font = [UIFont systemFontOfSize:16];
    _cinemaNameLabel.textColor = appDelegate.kkzBlack;
    _cinemaNameLabel.text = @"";
    [self.contentView addSubview:_cinemaNameLabel];
    [_cinemaNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.lessThanOrEqualTo(self.contentView).offset(-20);
        make.top.mas_equalTo(20);
    }];
    
    _cinemaAddressLabel = [[UILabel alloc] init];
    _cinemaAddressLabel.font = [UIFont systemFontOfSize:13];
    _cinemaAddressLabel.textColor = appDelegate.kkzGray;
    _cinemaAddressLabel.text = @"";
    [self.contentView addSubview:_cinemaAddressLabel];
    [_cinemaAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cinemaNameLabel);
        make.right.lessThanOrEqualTo(self.contentView).offset(-80);
        make.top.equalTo(_cinemaNameLabel.mas_bottom).offset(15);
    }];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.font = [UIFont systemFontOfSize:12];
    _priceLabel.textColor = appDelegate.kkzPink;
    _priceLabel.text = @"";
    [self.contentView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(20);
    }];
    
    _distanceLabel = [[UILabel alloc] init];
    _distanceLabel.font = [UIFont systemFontOfSize:10];
    _distanceLabel.textColor = appDelegate.kkzGray;
    _distanceLabel.text = @"";
    [self.contentView addSubview:_distanceLabel];
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_priceLabel);
        make.top.equalTo(_priceLabel.mas_bottom).offset(20);
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = appDelegate.kkzGray;
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)update:(CinemaDetail *)model {
    _cinemaNameLabel.text = model.cinemaName;
    _cinemaAddressLabel.text = model.cinemaAddress;
    _priceLabel.text = [NSString stringWithFormat:@"￥ %@起", model.minPrice];
    _distanceLabel.text = [NSString stringWithFormat:@"%.1fkm", model.distanceMetres.floatValue / 1000.0f];
}

@end
