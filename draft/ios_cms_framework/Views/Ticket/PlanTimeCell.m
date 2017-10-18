//
//  PlanTimeCell.m
//  CIASMovie
//
//  Created by cias on 2017/3/25.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "PlanTimeCell.h"
#import <DateEngine_KKZ/DateEngine.h>
#import "KKZTextUtility.h"
#import "Movie.h"

@implementation PlanTimeCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        dateLabel = [UILabel new];
        dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        dateLabel.textColor = [UIColor colorWithHex:@"#333333"];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:dateLabel];
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.width.equalTo(@(60));
            make.top.equalTo(@(19));
            make.height.equalTo(@(15));
        }];
        overTimeLabel = [UILabel new];
        overTimeLabel.font = [UIFont systemFontOfSize:10];
        overTimeLabel.textColor = [UIColor colorWithHex:@"#cccccc"];
        overTimeLabel.backgroundColor = [UIColor clearColor];
        overTimeLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:overTimeLabel];
        [overTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.width.equalTo(@(60));
            make.top.equalTo(dateLabel.mas_bottom).offset(1.5);
            make.height.equalTo(@(15));
        }];
        
        screenTypeLabel = [self getFlagLabelWithFont:10 withBgColor:@"#ffcc00" withTextColor:@"#000000"];
        [self addSubview:screenTypeLabel];
        languageLael = [self getFlagLabelWithFont:10 withBgColor:@"#333333" withTextColor:@"#FFFFFF"];
        [self addSubview:languageLael];
        
        CGSize screenTypeSize = [KKZTextUtility measureText:@"3D|IMAX" font:[UIFont systemFontOfSize:10]];
        screenTypeLabel.text = @"3D|IMAX";
        [screenTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dateLabel.mas_right).offset(10);
            make.top.equalTo(@(18));
            make.width.equalTo(@(screenTypeSize.width+8));
            make.height.equalTo(@(15));
        }];
        CGSize languageSize = [KKZTextUtility measureText:@"英语" font:[UIFont systemFontOfSize:10]];
        languageLael.text = @"英语";
        [languageLael mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(screenTypeLabel.mas_right).offset(2);
            make.top.equalTo(@(18));
            make.width.equalTo(@(languageSize.width+8));
            make.height.equalTo(@(15));
        }];

        hallNameLabel = [UILabel new];
        hallNameLabel.font = [UIFont systemFontOfSize:10];
        hallNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
        hallNameLabel.backgroundColor = [UIColor clearColor];
        hallNameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:hallNameLabel];
        [hallNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dateLabel.mas_right).offset(10);
            make.top.equalTo(dateLabel.mas_bottom).offset(1.5);
            make.width.equalTo(@(kCommonScreenWidth-200));
            make.height.equalTo(@(15));
        }];

        priceLabel = [UILabel new];
        priceLabel.font = [UIFont systemFontOfSize:14];
        priceLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].planBtnColor];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-85);
            make.width.equalTo(@(60));
            make.top.equalTo(@(20));
            make.height.equalTo(@(14));
        }];
        
        NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"白金卡",@"¥10",nil];
        priceSegment = [[UISegmentedControl alloc] initWithItems:segmentedArray];
        [self addSubview:priceSegment];
        [priceSegment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-85);
            make.width.equalTo(@(81));
            make.top.equalTo(priceLabel.mas_bottom).offset(0.5);
            make.height.equalTo(@(15));
        }];
        [priceSegment setWidth:40 forSegmentAtIndex:0];
        UIFont *font = [UIFont boldSystemFontOfSize:10.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [priceSegment setTitleTextAttributes:attributes
                                   forState:UIControlStateNormal];
        priceSegment.selectedSegmentIndex = 0;//设置默认选择项索引
        priceSegment.tintColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].planBtnColor];
        priceSegment.hidden = YES;
        priceSegment.userInteractionEnabled = NO;
        
        
        contrastPriceLabel = [UILabel new];
        contrastPriceLabel.font = [UIFont systemFontOfSize:10];
        contrastPriceLabel.textColor = [UIColor colorWithHex:@"#cccccc"];
        contrastPriceLabel.backgroundColor = [UIColor clearColor];
        contrastPriceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:contrastPriceLabel];
        [contrastPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-85);
            make.width.equalTo(@(60));
            make.top.equalTo(priceLabel.mas_bottom).offset(0.5);
            make.height.equalTo(@(14));
        }];
        UIView *hLine = [[UIView alloc] initWithFrame:CGRectMake(35, 7, 25, 1)];
        [contrastPriceLabel addSubview:hLine];
        hLine.backgroundColor = [UIColor colorWithHex:@"#cccccc"];
        
        
        expiredButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:expiredButton];
        expiredButton.hidden = YES;
        expiredButton.backgroundColor = [UIColor colorWithHex:@"#b2b2b2"];
        [expiredButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(@(19));
            make.width.equalTo(@(50));
            make.height.equalTo(@(27));
        }];
        expiredButton.layer.cornerRadius = 2.5;
        expiredButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [expiredButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
        [expiredButton setTitle:@"停售" forState:UIControlStateNormal];
        //[expiredButton addTarget:self action:@selector(buyTicketButtonClick) forControlEvents:UIControlEventTouchUpInside];

        
        huiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:huiButton];
        huiButton.hidden = YES;
        huiButton.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].planBtnColor];
        [huiButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(@(19));
            make.width.equalTo(@(50));
            make.height.equalTo(@(27));
        }];
        huiButton.layer.cornerRadius = 2.5;
        huiButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [huiButton setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
        [huiButton setTitle:@"特惠" forState:UIControlStateNormal];
        [huiButton addTarget:self action:@selector(buyTicketButtonClick) forControlEvents:UIControlEventTouchUpInside];

        ticketButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:ticketButton];
        ticketButton.hidden = YES;
        ticketButton.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
        [ticketButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(@(19));
            make.width.equalTo(@(50));
            make.height.equalTo(@(27));
        }];
        ticketButton.layer.cornerRadius = 2.5;
        ticketButton.layer.borderWidth = 0.5;
        ticketButton.layer.borderColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].planBtnColor].CGColor;
        ticketButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [ticketButton setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].planBtnColor] forState:UIControlStateNormal];
        [ticketButton setTitle:@"购票" forState:UIControlStateNormal];
        [ticketButton addTarget:self action:@selector(buyTicketButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        huiImageView = [UIImageView new];
        huiImageView.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
        huiImageView.image = [UIImage imageNamed:@"hui_tag2"];
        huiImageView.contentMode = UIViewContentModeScaleAspectFit;
        huiImageView.hidden = YES;
        [self addSubview:huiImageView];
        [self bringSubviewToFront:huiImageView];
        [huiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(15));
            make.bottom.equalTo(self.mas_bottom).offset(-15);
            make.width.equalTo(@(16));
            make.height.equalTo(@(16));
        }];
        promotionLabel = [UILabel new];
        promotionLabel.textColor = [UIColor colorWithHex:@"#333333"];
        promotionLabel.textAlignment = NSTextAlignmentLeft;
        promotionLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:promotionLabel];
        promotionLabel.hidden = YES;
        [promotionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(huiImageView.mas_right).offset(5);
            make.centerY.equalTo(huiImageView.mas_centerY);
            make.width.equalTo(@((kCommonScreenWidth-64)/2));
            make.height.equalTo(@(15));
            
        }];
        promotionCountLabel = [UILabel new];
        promotionCountLabel.textColor = [UIColor colorWithHex:@"#333333"];
        promotionCountLabel.textAlignment = NSTextAlignmentRight;
        promotionCountLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:promotionCountLabel];
        promotionCountLabel.hidden = YES;
        [promotionCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(promotionLabel.mas_right).offset(0);
            make.centerY.equalTo(huiImageView.mas_centerY);
            make.width.equalTo(@((kCommonScreenWidth-64)/2));
            make.height.equalTo(@(15));
            
        }];

        arrowImageView = [UIImageView new];
        arrowImageView.backgroundColor = [UIColor clearColor];
        arrowImageView.clipsToBounds = YES;
        arrowImageView.hidden = YES;
        arrowImageView.userInteractionEnabled = YES;
        arrowImageView.image = [UIImage imageNamed:@"home_more"];
        arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-14));
            make.centerY.equalTo(huiImageView.mas_centerY);
            make.width.equalTo(@(8));
            make.height.equalTo(@(12));
            
        }];
    }
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self);
        make.top.equalTo(self.mas_bottom).offset(-0.5);
        make.height.equalTo(@(0.5));
    }];
    return self;

}

-(void)buyTicketButtonClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selctCellWithIndex:)]) {
        [self.delegate selctCellWithIndex:self.selectIndexRow];
    }
}

- (void)updateLayout{
    huiImageView.hidden = YES;
    promotionLabel.hidden = YES;
    promotionCountLabel.hidden = YES;
    arrowImageView.hidden = YES;

    huiButton.hidden = YES;
    ticketButton.hidden = YES;
    expiredButton.hidden = YES;
    
    if ([self.selectPlan.isSale isEqualToString:@"1"]) {
        
    }else{
        
    }

    priceLabel.text = [NSString stringWithFormat:@"￥%@", self.selectPlan.standardPrice];
    
    if (![self.selectPlan.vipName isKindOfClass:[NSNull class]] &&
        self.selectPlan.vipPrice.floatValue >= 0.01) {
        priceSegment.hidden = NO;
        contrastPriceLabel.hidden = YES;
        [priceSegment setTitle:self.selectPlan.vipName forSegmentAtIndex:0];
        [priceSegment setTitle:[NSString stringWithFormat:@"￥%@", self.selectPlan.vipPrice] forSegmentAtIndex:1];
    } else {
        contrastPriceLabel.text = [NSString stringWithFormat:@"￥%@", self.selectPlan.marketPrice];
        priceSegment.hidden = YES;
        contrastPriceLabel.hidden = NO;
    }
    

    dateLabel.text = [[DateEngine sharedDateEngine] shortTimeStringFromDate:[[DateEngine sharedDateEngine] dateFromString:self.selectPlan.startTime]];
    overTimeLabel.text = [NSString stringWithFormat:@"%@散场", [[DateEngine sharedDateEngine] shortTimeStringFromDate:[[DateEngine sharedDateEngine] dateFromString:self.selectPlan.endTime]]];
    
    if (self.selectPlan.filmInfo.count>0) {
        Movie *amovie = [self.selectPlan.filmInfo objectAtIndex:0];
        CGSize screenTypeSize = [KKZTextUtility measureText:amovie.filmType font:[UIFont systemFontOfSize:10]];
        screenTypeLabel.text = amovie.filmType;
        [screenTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dateLabel.mas_right).offset(10);
            make.top.equalTo(@(18));
            make.width.equalTo(@(screenTypeSize.width+8));
            make.height.equalTo(@(15));
        }];

        CGSize languageSize = [KKZTextUtility measureText:amovie.language font:[UIFont systemFontOfSize:10]];
        languageLael.text = amovie.language;
        [languageLael mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(screenTypeLabel.mas_right).offset(2);
            make.top.equalTo(@(18));
            make.width.equalTo(@(languageSize.width+8));
            make.height.equalTo(@(15));
        }];
        

    }
    
    hallNameLabel.text = self.selectPlan.screenName;
    if ([self.selectPlan.isDiscount integerValue] == 1) {
        huiImageView.hidden = NO;
        huiButton.hidden = NO;
        ticketButton.hidden = YES;
        huiImageView.hidden = NO;
        promotionLabel.hidden = NO;
        promotionCountLabel.hidden = NO;
        arrowImageView.hidden = NO;
        NSArray *arr = [self.selectPlan.discount componentsSeparatedByString:@"|"];
        promotionLabel.text = [NSString stringWithFormat:@"%@", arr[0]];
        promotionCountLabel.text = [NSString stringWithFormat:@"共有%ld个活动", arr.count];

        
    }else{
        huiImageView.hidden = YES;
        huiButton.hidden = YES;
        ticketButton.hidden = NO;
    }
    NSComparisonResult result; //是否过期
    int lockTime = [klockTime intValue];
    
    NSDate *lateDate = [[NSDate date] dateByAddingTimeInterval:lockTime*60];
    NSDate *startTimeDate = [[DateEngine sharedDateEngine] dateFromString:self.selectPlan.startTime];
    result= [startTimeDate compare:lateDate];
    if (result == NSOrderedDescending) {


    }else{
        huiButton.hidden = YES;
        ticketButton.hidden = YES;
        expiredButton.hidden = NO;
        //[CIASPublicUtility showAlertViewForTitle:@"" message:[NSString stringWithFormat:@"请在开场前%d分钟购票", lockTime] cancelButton:@"确定"];
    }

}

- (UILabel *)getFlagLabelWithFont:(float)font withBgColor:(NSString *)color withTextColor:(NSString *)textColor{
    UILabel *_activityTitle = [UILabel new];
    _activityTitle.font = [UIFont systemFontOfSize:font];
    _activityTitle.textAlignment = NSTextAlignmentCenter;
    _activityTitle.textColor = [UIColor colorWithHex:textColor];
    _activityTitle.backgroundColor = [UIColor colorWithHex:color];
    _activityTitle.layer.cornerRadius = 3.5f;
    _activityTitle.layer.masksToBounds = YES;
    return _activityTitle;
}


@end
