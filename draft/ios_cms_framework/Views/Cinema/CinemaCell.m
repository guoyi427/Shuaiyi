//
//  CinemaCell.m
//  CIASMovie
//
//  Created by cias on 2016/12/26.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "CinemaCell.h"
#import "KKZTextUtility.h"
#import "LocationEngine.h"

@implementation CinemaCell

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

        cinemaNameLabel = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:16*Constants.screenWidthRate] textColor:[UIColor colorWithHex:@"#333333"] textAlignment:NSTextAlignmentLeft];
        cinemaNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self addSubview:cinemaNameLabel];
        
        nearLabel = [self getFlagLabelWithFont:10 withBgColor:@"#66CCFF" withTextColor:@"#FFFFFF"];
        nearLabel.text = @"最近";
        nearLabel.hidden = YES;
        [self addSubview:nearLabel];
        
        comeLabel = [self getFlagLabelWithFont:10 withBgColor:@"#3CC192" withTextColor:@"#FFFFFF"];
        comeLabel.text = @"来过";
        comeLabel.hidden = YES;
        [self addSubview:comeLabel];
        
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
        
        cinemaAddressLabel = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:13*Constants.screenWidthRate] textColor:[UIColor colorWithHex:@"#b2b2b2"] textAlignment:NSTextAlignmentLeft];
        [self addSubview:cinemaAddressLabel];

        distanceLabel = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:13*Constants.screenWidthRate] textColor:[UIColor colorWithHex:@"#b2b2b2"] textAlignment:NSTextAlignmentRight];
        
        [self addSubview:distanceLabel];
        
        
        [cinemaNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15*Constants.screenWidthRate));
            make.top.equalTo(@(15*Constants.screenHeightRate));
            make.width.equalTo(@(kCommonScreenWidth-180*Constants.screenWidthRate));
            make.height.equalTo(@(15*Constants.screenHeightRate));
            
        }];
        [nearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cinemaNameLabel.mas_right).offset(5*Constants.screenWidthRate);
            make.width.equalTo(@(29*Constants.screenWidthRate));
            make.top.equalTo(@(15*Constants.screenHeightRate));
            make.height.equalTo(@(15*Constants.screenHeightRate));
        }];
        [comeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cinemaNameLabel.mas_right).offset(5*Constants.screenWidthRate);
            make.width.equalTo(@(29*Constants.screenWidthRate));
            make.top.equalTo(@(15*Constants.screenHeightRate));
            make.height.equalTo(@(15*Constants.screenHeightRate));
        }];
        [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(13*Constants.screenHeightRate));
            make.right.equalTo(self.mas_right).offset(-14*Constants.screenWidthRate);
            make.width.equalTo(@(20*Constants.screenWidthRate));
            make.height.equalTo(@(20*Constants.screenHeightRate));
        }];

        [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15*Constants.screenWidthRate));
            make.top.equalTo(cinemaNameLabel.mas_bottom).offset(15*Constants.screenHeightRate);
            make.width.equalTo(@(12*Constants.screenWidthRate));
            make.height.equalTo(@(14*Constants.screenHeightRate));
        }];
        
        [cinemaAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(locationImageView.mas_right).offset(5*Constants.screenWidthRate);
            make.top.equalTo(cinemaNameLabel.mas_bottom).offset(15*Constants.screenHeightRate);
            make.width.equalTo(@(kCommonScreenWidth-170*Constants.screenWidthRate));
            make.height.equalTo(@(15*Constants.screenHeightRate));
            
        }];
        
        [distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15*Constants.screenWidthRate);
            make.top.equalTo(self.mas_bottom).offset(-30*Constants.screenHeightRate);
            make.width.equalTo(@(80*Constants.screenWidthRate));
            make.height.equalTo(@(15*Constants.screenHeightRate));
            
        }];
        
        cinemaFeatureView = [[UIView alloc] init];
        cinemaFeatureView.backgroundColor = [UIColor clearColor];
        [self addSubview:cinemaFeatureView];
        [cinemaFeatureView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(cinemaAddressLabel.mas_bottom).offset(7);
            make.height.equalTo(@0);
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
    nearLabel.hidden = YES;
    comeLabel.hidden = YES;

    cinemaNameLabel.text = self.cinemaName;
    cinemaAddressLabel.text = self.cinemaAddress;
    //MARK: 加入标签
    if (self.isFromOpenCard) {
        
    } else {
#if kIsHaveTipLabelInCinemaList
        if (self.featureArr.count > 0) {
            for (UIView *view in cinemaFeatureView.subviews) {
                [view removeFromSuperview];
            }
            CGFloat leftGap = 15.0;
            NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithCapacity:0];
            if (self.featureArr.count > 4) {
                for (int i = 0; i < 4; i++) {
                    [tmpArr addObject:[self.featureArr objectAtIndex:i]];
                }
            } else {
                [tmpArr addObjectsFromArray:self.featureArr];
            }
            for (NSDictionary *dic in tmpArr) {
                NSString *featureStr = [dic kkz_stringForKey:@"name"];
                CGSize featureStrSize = [KKZTextUtility measureText:featureStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
                UILabel *featureLabel = [KKZTextUtility getLabelWithText:featureStr font:[UIFont systemFontOfSize:10] textColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor] textAlignment:NSTextAlignmentCenter];
                featureLabel.layer.borderColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor].CGColor;
                featureLabel.layer.borderWidth = 1.0f;
                featureLabel.layer.cornerRadius = 2.0;
                featureLabel.clipsToBounds = YES;
                [cinemaFeatureView addSubview:featureLabel];
                [featureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cinemaFeatureView.mas_left).offset(leftGap);
                    make.centerY.equalTo(cinemaFeatureView.mas_centerY);
                    make.size.mas_equalTo(CGSizeMake(featureStrSize.width+5, featureStrSize.height+5));
                }];
                leftGap += featureStrSize.width+10;
            }
            NSString *cinemaFeatureStr = @"D BOX厅";
            CGSize cinemaFeatureStrSize = [KKZTextUtility measureText:cinemaFeatureStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
            [cinemaFeatureView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(cinemaAddressLabel.mas_bottom).offset(7);
                make.height.equalTo(@(cinemaFeatureStrSize.height+10));
            }];
        }else{
            for (UIView *view in cinemaFeatureView.subviews) {
                [view removeFromSuperview];
            }
            [cinemaFeatureView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self);
                make.top.equalTo(cinemaAddressLabel.mas_bottom).offset(7);
                make.height.equalTo(@(0));
            }];
        }
#endif
    }

    
    
    if (self.distance.length>0 && ![self.distance isEqualToString:@"(null)"] && [LocationEngine sharedLocationEngine].isHasLocation) {
        distanceLabel.text = [NSString stringWithFormat:@"%@KM", self.distance];
    }else{
        distanceLabel.text = @"";
    }
    if (self.isSelected) {
        selectedImageView.hidden = NO;
    }else{
        selectedImageView.hidden = YES;
    }
    
    if ([self.isnear integerValue]) {
        CGSize cinemaNameSize = [KKZTextUtility measureText:self.cinemaName font:[UIFont systemFontOfSize:16*Constants.screenWidthRate]];
        NSInteger cinemaNameLabelLength = cinemaNameSize.width>(kCommonScreenWidth-180*Constants.screenWidthRate)?(kCommonScreenWidth-180*Constants.screenWidthRate):cinemaNameSize.width;
        [nearLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(cinemaNameLabelLength+15*Constants.screenWidthRate+5*Constants.screenWidthRate));
            make.width.equalTo(@(29*Constants.screenWidthRate));
            make.top.equalTo(@(15*Constants.screenHeightRate));
            make.height.equalTo(@(15*Constants.screenHeightRate));
        }];

        nearLabel.hidden = NO;
        
        if ([self.isCome integerValue]) {
            comeLabel.hidden = NO;
            
            [comeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(nearLabel.mas_right).offset(5);
                make.width.equalTo(@(29*Constants.screenWidthRate));
                make.top.equalTo(@(15*Constants.screenHeightRate));
                make.height.equalTo(@(15*Constants.screenHeightRate));
            }];
        }

    }else{
        if ([self.isCome integerValue]) {
            comeLabel.hidden = NO;
            CGSize cinemaNameSize = [KKZTextUtility measureText:self.cinemaName font:[UIFont systemFontOfSize:16*Constants.screenWidthRate]];
            NSInteger cinemaNameLabelLength = cinemaNameSize.width>(kCommonScreenWidth-180*Constants.screenWidthRate)?(kCommonScreenWidth-180*Constants.screenWidthRate):cinemaNameSize.width;
            [comeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@(cinemaNameLabelLength+15*Constants.screenWidthRate+5*Constants.screenWidthRate));
                make.width.equalTo(@(29*Constants.screenWidthRate));
                make.top.equalTo(@(15*Constants.screenHeightRate));
                make.height.equalTo(@(15*Constants.screenHeightRate));
            }];
        }

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
