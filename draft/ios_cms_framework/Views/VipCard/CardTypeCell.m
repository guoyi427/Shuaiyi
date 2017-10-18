//
//  CardTypeCell.m
//  CIASMovie
//
//  Created by avatar on 2017/3/13.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "CardTypeCell.h"
#import "KKZTextUtility.h"

@implementation CardTypeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([kIsXinchengCardStyle isEqualToString:@"1"]) {
            //卡图片
            UIImage *cardImage = nil;
            if (self.myCardType.cardType.intValue == 1 || self.myCardType.cardType.intValue == 3) {
                cardImage = [UIImage imageNamed:@"membercard_xc_1"];
            } else {
                cardImage = [UIImage imageNamed:@"membercard_xc_2"];
            }
            cardImageView = [[UIImageView alloc] init];
            cardImageView.image = cardImage;
            cardImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:cardImageView];
            [cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset((kCommonScreenWidth-cardImage.size.width*Constants.screenWidthRate)/2);
                make.right.equalTo(self.mas_right).offset(-(kCommonScreenWidth-cardImage.size.width*Constants.screenWidthRate)/2);
                make.height.equalTo(@(cardImage.size.height*Constants.screenHeightRate));
                make.top.equalTo(self.mas_top).offset(25*Constants.screenHeightRate);
            }];
            
            //卡背景图
            UIImage *cardBackImage = [UIImage imageNamed:@"membercard_mask"];
            cardBackImageView = [[UIImageView alloc] init];
            cardBackImageView.image = cardBackImage;
            cardBackImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:cardBackImageView];
            [cardBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset((kCommonScreenWidth-cardBackImage.size.width*Constants.screenWidthRate)/2);
                make.right.equalTo(self.mas_right).offset(-(kCommonScreenWidth-cardBackImage.size.width*Constants.screenWidthRate)/2);
                make.height.equalTo(@(cardBackImage.size.height*Constants.screenHeightRate));
                make.top.equalTo(self.mas_top).offset(10*Constants.screenHeightRate);
            }];
            
            //卡图片上的logo
            UIImage *cardLogoImage = [UIImage imageNamed:@"cinema_logo"];
            cardLogoImageView = [[UIImageView alloc] init];
            [cardBackImageView addSubview:cardLogoImageView];
            [cardLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardImageView.mas_top).offset(25*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardLogoImage.size.width*Constants.screenWidthRate, cardLogoImage.size.height*Constants.screenHeightRate));
            }];
            cardLogoImageView.image = cardLogoImage;
            cardLogoImageView.hidden = YES;
            
            NSString *cardTypeStr = self.myCardType.cardLevelName;
            CGSize cardTypeStrSize = [KKZTextUtility measureText:cardTypeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
            cardTypeLabel = [[UILabel alloc] init];
            [cardBackImageView addSubview:cardTypeLabel];
            cardTypeLabel.text = cardTypeStr;
            cardTypeLabel.textColor = [UIColor colorWithHex:@"#333333"];
            cardTypeLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
            [cardTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageView.mas_right).offset(-12*Constants.screenWidthRate);
                make.top.equalTo(cardImageView.mas_top).offset(30*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardTypeStrSize.width+5, cardTypeStrSize.height));
            }];
            cardTypeLabel.hidden = YES;
            //
            
            NSString *cardValueStr = self.myCardType.discountDesc;
            CGSize cardValueStrSize = [KKZTextUtility measureText:cardValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
            cardValueLabel = [KKZTextUtility getLabelWithText:cardValueStr font:[UIFont systemFontOfSize:14*Constants.screenWidthRate] textColor:[UIColor colorWithHex:@"#ffffff"] textAlignment:NSTextAlignmentLeft];
            [cardBackImageView addSubview:cardValueLabel];
            [cardValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(20*Constants.screenWidthRate);
                make.bottom.equalTo(cardImageView.mas_bottom).offset(-15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardValueStrSize.width+5, cardValueStrSize.height));
            }];
            
            //卡图片上的影院名称
            NSString *cardTitleStr = self.myCardType.cinemaName;
            CGSize cardTitleStrSize = [KKZTextUtility measureText:cardTitleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
            cardTitleLabel = [KKZTextUtility getLabelWithText:cardTitleStr font:[UIFont systemFontOfSize:10*Constants.screenWidthRate] textColor:[UIColor colorWithHex:@"#ffffff"] textAlignment:NSTextAlignmentLeft];
            [cardBackImageView addSubview:cardTitleLabel];
            [cardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(20*Constants.screenWidthRate);
                make.bottom.equalTo(cardValueLabel.mas_top).offset(-6*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardTitleStrSize.width+5, cardTitleStrSize.height));
            }];
            
            NSString *cardValidTimeStr = @"2016-12-11至2016-12-12";
            CGSize cardValidTimeStrSize = [KKZTextUtility measureText:cardValidTimeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
            cardValidTimeLabel = [KKZTextUtility getLabelWithText:cardValidTimeStr font:[UIFont systemFontOfSize:10*Constants.screenWidthRate] textColor:[UIColor colorWithHex:@"#cccccc"] textAlignment:NSTextAlignmentRight];
            [cardBackImageView addSubview:cardValidTimeLabel];
            //MARK: 如果没有有效期则隐藏
            [cardValidTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageView.mas_right).offset(-15*Constants.screenWidthRate);
                make.bottom.equalTo(cardImageView.mas_bottom).offset(-15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardValidTimeStrSize.width+5, cardValidTimeStrSize.height));
            }];
            
            NSString *cardBalanceValueStr = @"充值：10050.00元";
            CGSize cardBalanceValueStrSize = [KKZTextUtility measureText:cardBalanceValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
            cardBalanceValueLabel = [KKZTextUtility getLabelWithAttributedText:[KKZTextUtility getbalanceStrWithString:cardBalanceValueStr] font:nil textColor:nil textAlignment:NSTextAlignmentRight];
            [cardBackImageView addSubview:cardBalanceValueLabel];
            /*
             *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
             */
            [cardBalanceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageView.mas_right).offset(-15*Constants.screenWidthRate);
                make.bottom.equalTo(cardValidTimeLabel.mas_top).offset(-6*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardBalanceValueStrSize.width+5, cardBalanceValueStrSize.height));
            }];
            

        }
        if([kIsCMSStandardCardStyle isEqualToString:@"1"]) {
            //卡图片
            UIImage *cardImage = [UIImage imageNamed:@"membercard1"];
            cardImageView = [[UIImageView alloc] init];
            cardImageView.image = cardImage;
            cardImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:cardImageView];
            [cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset((kCommonScreenWidth-cardImage.size.width*Constants.screenWidthRate)/2);
                make.right.equalTo(self.mas_right).offset(-(kCommonScreenWidth-cardImage.size.width*Constants.screenWidthRate)/2);
                make.height.equalTo(@(cardImage.size.height*Constants.screenHeightRate));
                make.top.equalTo(self.mas_top).offset(25*Constants.screenHeightRate);
            }];
            
            //卡背景图
            UIImage *cardBackImage = [UIImage imageNamed:@"membercard_mask"];
            cardBackImageView = [[UIImageView alloc] init];
            cardBackImageView.image = cardBackImage;
            cardBackImageView.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:cardBackImageView];
            [cardBackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset((kCommonScreenWidth-cardBackImage.size.width*Constants.screenWidthRate)/2);
                make.right.equalTo(self.mas_right).offset(-(kCommonScreenWidth-cardBackImage.size.width*Constants.screenWidthRate)/2);
                make.height.equalTo(@(cardBackImage.size.height*Constants.screenHeightRate));
                make.top.equalTo(self.mas_top).offset(10*Constants.screenHeightRate);
            }];
            
            //卡图片上的logo
            UIImage *cardLogoImage = [UIImage imageNamed:@"cinema_logo"];
            cardLogoImageView = [[UIImageView alloc] init];
            [cardBackImageView addSubview:cardLogoImageView];
            [cardLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardImageView.mas_top).offset(25*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardLogoImage.size.width*Constants.screenWidthRate, cardLogoImage.size.height*Constants.screenHeightRate));
            }];
            cardLogoImageView.image = cardLogoImage;
            
#if K_ZHONGDU
            cardLogoImageView.hidden = YES;
#endif
            
            NSString *cardTypeStr = self.myCardType.cardLevelName;
            CGSize cardTypeStrSize = [KKZTextUtility measureText:cardTypeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
            cardTypeLabel = [[UILabel alloc] init];
            [cardBackImageView addSubview:cardTypeLabel];
            cardTypeLabel.text = cardTypeStr;
            cardTypeLabel.textColor = [UIColor colorWithHex:@"#333333"];
            cardTypeLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
            [cardTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageView.mas_right).offset(-12*Constants.screenWidthRate);
                make.top.equalTo(cardImageView.mas_top).offset(30*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardTypeStrSize.width+5, cardTypeStrSize.height));
            }];
            //
            //卡图片上的影院名称
            NSString *cardTitleStr = self.myCardType.cinemaName;
            CGSize cardTitleStrSize = [KKZTextUtility measureText:cardTitleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
            cardTitleLabel = [[UILabel alloc] init];
            [cardBackImageView addSubview:cardTitleLabel];
            cardTitleLabel.text = cardTitleStr;
            cardTitleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardTitleLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
            [cardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardLogoImageView.mas_bottom).offset(32*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardTitleStrSize.width+5, cardTitleStrSize.height));
            }];
            
            NSString *cardValueStr = self.myCardType.discountDesc;
            CGSize cardValueStrSize = [KKZTextUtility measureText:cardValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
            cardValueLabel = [[UILabel alloc] init];
            [cardBackImageView addSubview:cardValueLabel];
            cardValueLabel.text = cardValueStr;
            cardValueLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardValueLabel.font = [UIFont systemFontOfSize:18*Constants.screenWidthRate];
            [cardValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardTitleLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardValueStrSize.width+5, cardValueStrSize.height));
            }];
            
            NSString *cardBalanceValueStr = @"充值：10050.00元";
            CGSize cardBalanceValueStrSize = [KKZTextUtility measureText:cardBalanceValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
            cardBalanceValueLabel = [[UILabel alloc] init];
            [cardBackImageView addSubview:cardBalanceValueLabel];
            /*
             *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
             */
            cardBalanceValueLabel.attributedText = [KKZTextUtility getbalanceStrWithString:cardBalanceValueStr];
            [cardBalanceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardValueLabel.mas_bottom).offset(28*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardBalanceValueStrSize.width+5, cardBalanceValueStrSize.height));
            }];
            
            NSString *cardValidTimeStr = @"2016-12-11至2016-12-12";
            CGSize cardValidTimeStrSize = [KKZTextUtility measureText:cardValidTimeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
            cardValidTimeLabel = [[UILabel alloc] init];
            [cardBackImageView addSubview:cardValidTimeLabel];
            //MARK: 如果没有有效期则隐藏
            cardValidTimeLabel.text = cardValidTimeStr;
            cardValidTimeLabel.textAlignment = NSTextAlignmentRight;
            cardValidTimeLabel.textColor = [UIColor colorWithHex:@"#cccccc"];
            cardValidTimeLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
            [cardValidTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageView.mas_right).offset(-25*Constants.screenWidthRate);
                make.bottom.equalTo(cardImageView.mas_bottom).offset(-23*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardValidTimeStrSize.width+5, cardValidTimeStrSize.height));
            }];
        }
        
    }
    return self;
    
}

- (void)updateLayout{
    if ([kIsXinchengCardStyle isEqualToString:@"1"]) {
        
        
        UIImage *cardImage = nil;
        if (self.myCardType.cardType.intValue == 1 || self.myCardType.cardType.intValue == 3) {
            cardImage = [UIImage imageNamed:@"membercard_xc_1"];
        } else {
            cardImage = [UIImage imageNamed:@"membercard_xc_2"];
        }
        cardImageView.image = cardImage;
        
        NSString *cardTitleStr = self.myCardType.cinemaName;
        CGSize cardTitleStrSize = [KKZTextUtility measureText:cardTitleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
        cardTitleLabel.text = cardTitleStr;
        [cardTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(cardTitleStrSize.width+5, cardTitleStrSize.height));
        }];
        
        NSString *cardValueStr = self.myCardType.discountDesc;
        CGSize cardValueStrSize = [KKZTextUtility measureText:cardValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
        cardValueLabel.text = cardValueStr;
        [cardValueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(cardValueStrSize.width+5, cardValueStrSize.height));
        }];
    }
    if([kIsCMSStandardCardStyle isEqualToString:@"1"]) {
        NSString *cardTypeStr = self.myCardType.cardTypeName;
        cardTypeLabel.text = cardTypeStr;
        CGSize cardTypeStrSize = [KKZTextUtility measureText:cardTypeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
        [cardTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(cardTypeStrSize.width+5, cardTypeStrSize.height));
        }];
        
        NSString *cardTitleStr = self.myCardType.cinemaName;
        CGSize cardTitleStrSize = [KKZTextUtility measureText:cardTitleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
        cardTitleLabel.text = cardTitleStr;
        [cardTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(cardTitleStrSize.width+5, cardTitleStrSize.height));
        }];
        
        NSString *cardValueStr = self.myCardType.discountDesc;
        CGSize cardValueStrSize = [KKZTextUtility measureText:cardValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
        cardValueLabel.text = cardValueStr;
        [cardValueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(cardValueStrSize.width+5, cardValueStrSize.height));
        }];
        
    }
    
    
    
    
    
    NSString *cardBalanceValueStr = @"";

    cardBalanceValueStr = [NSString stringWithFormat:@"售价:%.2f元",self.myCardType.saleMoney.floatValue];
    /*
     *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
     */
    cardBalanceValueLabel.attributedText = [KKZTextUtility getbalanceStrWithString:cardBalanceValueStr];
    CGSize cardBalanceValueStrSize = [KKZTextUtility measureText:cardBalanceValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
    [cardBalanceValueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(cardBalanceValueStrSize.width+5, cardBalanceValueStrSize.height));
    }];
    
    NSString *cardValidTimeStr = nil;
    if (([self.myCardType.expireDate containsString:@"天"] || [self.myCardType.expireDate containsString:@"月"] ||[self.myCardType.expireDate containsString:@"年"])&&(!([self.myCardType.expireDate containsString:@"有效期"]))) {
        cardValidTimeStr = [NSString stringWithFormat:@"%@有效期", self.myCardType.expireDate];
    } else {
        cardValidTimeStr = [NSString stringWithFormat:@"%@", self.myCardType.expireDate];
    }
    CGSize cardValidTimeStrSize = [KKZTextUtility measureText:cardValidTimeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
    cardValidTimeLabel.text = cardValidTimeStr;
    [cardValidTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(cardValidTimeStrSize.width+5, cardValidTimeStrSize.height));
    }];
    
    
}



@end


