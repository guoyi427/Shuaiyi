//
//  MovieCommentViewCell.m
//  CIASMovie
//
//  Created by avatar on 2016/12/31.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "MovieCommentViewCell.h"

@implementation MovieCommentViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.bgView = [UIView new];
        [self addSubview:self.bgView];
        self.bgView.backgroundColor = [UIColor yellowColor];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        cinemaNameLabel = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHex:@"#333333"] textAlignment:NSTextAlignmentLeft];
        cinemaNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self addSubview:cinemaNameLabel];
        
        flagLabel = [self getFlagLabelWithFont:10 withBgColor:@"#66CCFF" withTextColor:@"#FFFFFF"];
        flagLabel.text = @"最近";
        flagLabel.hidden = YES;
        [self addSubview:flagLabel];
        
        selectedImageView = [UIImageView new];
        selectedImageView.backgroundColor = [UIColor clearColor];
        selectedImageView.clipsToBounds = YES;
        selectedImageView.hidden = YES;
        selectedImageView.image = [UIImage imageNamed:@"list_selected_icon"];
        selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:selectedImageView];
        
        locationImageView = [UIImageView new];
        locationImageView.backgroundColor = [UIColor clearColor];
        locationImageView.clipsToBounds = YES;
        locationImageView.image = [UIImage imageNamed:@"list_location_icon"];
        locationImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:locationImageView];
        
        cinemaAddressLabel = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithHex:@"#b2b2b2"] textAlignment:NSTextAlignmentLeft];
        [self addSubview:cinemaAddressLabel];
        
        distanceLabel = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithHex:@"#b2b2b2"] textAlignment:NSTextAlignmentRight];
        [self addSubview:distanceLabel];
        
        [cinemaNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.top.equalTo(@(15));
            make.width.equalTo(@(kCommonScreenWidth-180));
            make.height.equalTo(@(15));
            
        }];
        [flagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cinemaNameLabel.mas_right).offset(5);
            make.width.equalTo(@(29));
            make.top.equalTo(@(15));
            make.height.equalTo(@(15));
        }];
        [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(13));
            make.right.equalTo(self.mas_right).offset(-14);
            make.width.equalTo(@(20));
            make.height.equalTo(@(20));
        }];
        
        [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.top.equalTo(self.mas_bottom).offset(-30);
            make.width.equalTo(@(12));
            make.height.equalTo(@(14));
        }];
        
        [cinemaAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(locationImageView.mas_right).offset(5);
            make.top.equalTo(self.mas_bottom).offset(-30);
            make.width.equalTo(@(kCommonScreenWidth-170));
            make.height.equalTo(@(15));
        }];
        
        [distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(self.mas_bottom).offset(-30);
            make.width.equalTo(@(80));
            make.height.equalTo(@(15));
        }];
        
        line = [UIView new];
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
    
    cinemaNameLabel.text = self.cinemaName;
    cinemaAddressLabel.text = self.cinemaAddress;
    distanceLabel.text = @"3000.2KM";
    if (self.isSelected) {
        selectedImageView.hidden = NO;
    }else{
        selectedImageView.hidden = YES;
    }
    if ([self.isnear integerValue]) {
        flagLabel.hidden = NO;
    }else{
        flagLabel.hidden = YES;
    }
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        
        self.bgView.backgroundColor = [UIColor colorWithHex:@"#f0f0f0"];
        
    }else{
        self.bgView.backgroundColor = [UIColor whiteColor];
    }
}

- (UILabel *)getFlagLabelWithFont:(float)font withBgColor:(NSString *)color withTextColor:(NSString *)textColor{
    UILabel *_activityTitle = [UILabel new];
    _activityTitle.font = [UIFont systemFontOfSize:font];
    _activityTitle.textAlignment = NSTextAlignmentCenter;
    _activityTitle.textColor = [UIColor colorWithHex:textColor];
    _activityTitle.backgroundColor = [UIColor colorWithHex:color];
    _activityTitle.layer.cornerRadius = 3.0f;
    _activityTitle.layer.masksToBounds = YES;
    return _activityTitle;
}

@end
