//
//  VipCardListCell.m
//  CIASMovie
//
//  Created by avatar on 2017/2/27.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "VipCardListCell.h"
#import "KKZTextUtility.h"

@implementation VipCardListCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([kIsXinchengCardStyle isEqualToString:@"1"]) {
            //卡图片
            UIImage *cardImage = [UIImage imageNamed:@"membercard_xc_1"];
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
            
            NSString *cardTypeStr = @"白金卡";
            CGSize cardTypeStrSize = [KKZTextUtility measureText:cardTypeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
            cardTypeLabel = [[UILabel alloc] init];
            [cardBackImageView addSubview:cardTypeLabel];
            cardTypeLabel.text = cardTypeStr;
            cardTypeLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardTypeLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
            [cardTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageView.mas_right).offset(-19*Constants.screenWidthRate);
                make.top.equalTo(cardImageView.mas_top).offset(30*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardTypeStrSize.width+5, cardTypeStrSize.height));
            }];
            cardTypeLabel.hidden = YES;
            //
            NSString *cardValueStr = @"123123123123123123";
            CGSize cardValueStrSize = [KKZTextUtility measureText:cardValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
            cardValueLabel = [[UILabel alloc] init];
            [cardBackImageView addSubview:cardValueLabel];
            cardValueLabel.text = @"";
            cardValueLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            cardValueLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardValueLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
            [cardValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(20*Constants.screenWidthRate);
                make.bottom.equalTo(cardImageView.mas_bottom).offset(-15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardValueStrSize.width+10, cardValueStrSize.height));
            }];
            cardValueLabel.hidden = NO;
            
            //卡图片上的卡号
            NSString *cardTitleStr = @"卡号";
            CGSize cardTitleStrSize = [KKZTextUtility measureText:cardTitleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
            cardTitleLabel = [[UILabel alloc] init];
            [cardBackImageView addSubview:cardTitleLabel];
            cardTitleLabel.text = cardTitleStr;
            cardTitleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardTitleLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
            [cardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(20*Constants.screenWidthRate);
                make.bottom.equalTo(cardValueLabel.mas_top).offset(-6*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardTitleStrSize.width+5, cardTitleStrSize.height));
            }];
            cardTitleLabel.hidden = NO;
            
            NSString *cardValidTimeStr = @"2016-12-11至2016-12-12";
            CGSize cardValidTimeStrSize = [KKZTextUtility measureText:cardValidTimeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
            cardValidTimeLabel = [[UILabel alloc] init];
            [cardBackImageView addSubview:cardValidTimeLabel];
            //MARK: 如果没有有效期则隐藏
            cardValidTimeLabel.text = cardValidTimeStr;
            cardValidTimeLabel.textAlignment = NSTextAlignmentRight;
            cardValidTimeLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardValidTimeLabel.font = [UIFont systemFontOfSize:10*Constants.screenWidthRate];
            [cardValidTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageView.mas_right).offset(-15*Constants.screenWidthRate);
                make.bottom.equalTo(cardImageView.mas_bottom).offset(-15*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardValidTimeStrSize.width+5, cardValidTimeStrSize.height));
            }];
            
            NSString *cardBalanceValueStr = @"余额：10050.00元";
            CGSize cardBalanceValueStrSize = [KKZTextUtility measureText:cardBalanceValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
            cardBalanceValueLabel = [[UILabel alloc] init];
            cardBalanceValueLabel.textAlignment = NSTextAlignmentRight;
            [cardBackImageView addSubview:cardBalanceValueLabel];
            /*
             *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
             */
            cardBalanceValueLabel.attributedText = [KKZTextUtility getbalanceStrWithString:cardBalanceValueStr];
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
#else
            cardLogoImageView.hidden = NO;
#endif
            NSString *cardTypeStr = @"白金卡";
            CGSize cardTypeStrSize = [KKZTextUtility measureText:cardTypeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
            cardTypeLabel = [[UILabel alloc] init];
            [cardBackImageView addSubview:cardTypeLabel];
            cardTypeLabel.text = cardTypeStr;
            cardTypeLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardTypeLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
            [cardTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cardImageView.mas_right).offset(-19*Constants.screenWidthRate);
                make.top.equalTo(cardImageView.mas_top).offset(30*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake(cardTypeStrSize.width+5, cardTypeStrSize.height));
            }];
            cardTypeLabel.hidden = NO;
            //
            //卡图片上的卡号
            NSString *cardTitleStr = @"卡号";
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
            cardTitleLabel.hidden = NO;
            
            NSString *cardValueStr = @"123123123123123123";
            CGSize cardValueStrSize = [KKZTextUtility measureText:cardValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
            cardValueLabel = [[UILabel alloc] init];
            [cardBackImageView addSubview:cardValueLabel];
            cardValueLabel.text = @"";
            cardValueLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
            cardValueLabel.font = [UIFont systemFontOfSize:18*Constants.screenWidthRate];
            [cardValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cardImageView.mas_left).offset(35*Constants.screenWidthRate);
                make.top.equalTo(cardTitleLabel.mas_bottom).offset(10*Constants.screenHeightRate);
                make.size.mas_equalTo(CGSizeMake((cardImage.size.width - 35)*Constants.screenWidthRate, cardValueStrSize.height));
            }];
            cardValueLabel.hidden = NO;
            
            NSString *cardBalanceValueStr = @"余额：10050.00元";
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
            cardValidTimeLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
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

- (void)layoutSubviews {
    if ([kIsHaveUnbindcard isEqualToString:@"1"]) {
        [super layoutSubviews];
        UIImage *cardImage = [UIImage imageNamed:@"membercard_mask"];
        for (UIView *subView in self.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
                subView.backgroundColor = [UIColor clearColor];
                for (UIButton *btn in subView.subviews) {
                    if ([btn isKindOfClass:[UIButton class]]) {
                        btn.backgroundColor = [UIColor colorWithHex:@"#ff6666"];
                        btn.frame = CGRectMake(0, (cardImage.size.height + 5 - 44)*Constants.screenHeightRate/2, 64*Constants.screenWidthRate, 44*Constants.screenHeightRate);
                        btn.layer.cornerRadius = 44*Constants.screenHeightRate/2;
                        btn.clipsToBounds = YES;
                        btn.titleLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
                        [btn setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
                    }
                }
            }
        }
    }
}


- (void)updateLayout{
    
    cardValueLabel.text = self.myCard.cardNo;
    if ([kIsXinchengCardStyle isEqualToString:@"1"]) {
        
    }
    if([kIsCMSStandardCardStyle isEqualToString:@"1"]) {
        if (self.myCard.useTypeName.length>0) {
            cardTypeLabel.text = self.myCard.useTypeName;
        }else{
            cardTypeLabel.text = @"";
        }
    }
    
    
    NSString *cardBalanceValueStr = @"";
    if (self.myCard.useType.intValue == 1 || self.myCard.useType.intValue == 3) {
        cardBalanceValueStr = [NSString stringWithFormat:@"余额:%.2f元",self.myCard.cardDetail.balance.floatValue];
        /*
         *MARK:  属性字符串，字符串不能为空，否则会导致NSRange区间找不到而崩溃
         */
        cardBalanceValueLabel.attributedText = [KKZTextUtility getbalanceStrWithString:cardBalanceValueStr];
        if ([kIsXinchengCardStyle isEqualToString:@"1"]) {
            cardImageView.image = [UIImage imageNamed:@"membercard_xc_1"];
        }
        
    } else {
        cardBalanceValueLabel.text = @"";
        if ([kIsXinchengCardStyle isEqualToString:@"1"]) {
            cardImageView.image = [UIImage imageNamed:@"membercard_xc_2"];
        }
    }
    
    CGSize cardBalanceValueStrSize = [KKZTextUtility measureText:cardBalanceValueStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
    [cardBalanceValueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(cardBalanceValueStrSize.width+5, cardBalanceValueStrSize.height));
    }];
    
    NSString *cardValidTimeStr = nil;
    if (([self.myCard.expireDate containsString:@"天"] || [self.myCard.expireDate containsString:@"月"] ||[self.myCard.expireDate containsString:@"年"])&&(!([self.myCard.expireDate containsString:@"有效期"]))) {
        cardValidTimeStr = [NSString stringWithFormat:@"%@有效期", self.myCard.expireDate];
    } else {
        cardValidTimeStr = [NSString stringWithFormat:@"%@", self.myCard.expireDate];
    }
    CGSize cardValidTimeStrSize = [KKZTextUtility measureText:cardValidTimeStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10*Constants.screenWidthRate]];
    cardValidTimeLabel.text = cardValidTimeStr;
    [cardValidTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(cardValidTimeStrSize.width+5, cardValidTimeStrSize.height));
    }];
    
}


//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
