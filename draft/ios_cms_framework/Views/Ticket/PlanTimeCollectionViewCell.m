//
//  MovieListPosterCollectionViewCell.m
//  CIASMovie
//
//  Created by cias on 2016/12/16.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "PlanTimeCollectionViewCell.h"
#import <Category_KKZ/UIImage+Resize.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "KKZTextUtility.h"
#import <DateEngine_KKZ/DateEngine.h>

@implementation PlanTimeCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 2;
        self.layer.borderColor = [UIColor colorWithHex:@"#cccccc"].CGColor;
        self.layer.borderWidth = 0.5;
    
//        UIView *selfBackView = [UIView new];
//        selfBackView.backgroundColor = [UIColor clearColor];
//        selfBackView.layer.cornerRadius = 2;
//        selfBackView.layer.borderColor = [UIColor colorWithHex:@"#cccccc"].CGColor;
//        selfBackView.layer.borderWidth = 0.5;
//        [self addSubview:selfBackView];
//        [selfBackView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];

        
        selectBg = [UIView new];
        selectBg.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
        selectBg.layer.cornerRadius = 2;
        [self addSubview:selectBg];
        selectBg.hidden = YES;
        [selectBg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        dateLabel = [UILabel new];
        if (Constants.isIphone5) {
            dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
        }else{
            dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        }
        dateLabel.textColor = [UIColor colorWithHex:@"#333333"];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:dateLabel];
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            if (Constants.isIphone5) {
                make.top.equalTo(@(5));
            }else{
                make.top.equalTo(@(7));
            }
            make.height.equalTo(@(13));
        }];
        overTimeLabel = [UILabel new];
        overTimeLabel.font = [UIFont systemFontOfSize:10];
        overTimeLabel.textColor = [UIColor colorWithHex:@"#cccccc"];
        overTimeLabel.backgroundColor = [UIColor clearColor];
        overTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:overTimeLabel];
        [overTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.top.equalTo(dateLabel.mas_bottom).offset(2);
            make.height.equalTo(@(15));
        }];
        priceLabel = [UILabel new];
        priceLabel.font = [UIFont systemFontOfSize:10];
        priceLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].planBtnColor];
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.top.equalTo(overTimeLabel.mas_bottom);
            make.height.equalTo(@(14));
        }];
        huiImageView = [UIImageView new];
//        huiImageView.backgroundColor = [UIColor colorWithRed:253 green:152 blue:39 alpha:1];
        huiImageView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:253 green:152 blue:39 alpha:1];
        huiImageView.image = [UIImage imageNamed:@"hui_tag2"];
//        huiImageView.layer.cornerRadius = 2;
//        huiImageView.layer.borderWidth = 3;
//        huiImageView.layer.borderColor = [UIColor colorWithRed:253 green:152 blue:39 alpha:1].CGColor;
        huiImageView.contentMode = UIViewContentModeScaleAspectFit;
//        huiImageView.clipsToBounds = YES;
        huiImageView.hidden = YES;
        [self addSubview:huiImageView];
        [self bringSubviewToFront:huiImageView];
        [huiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(-5));
            make.top.equalTo(@(-5));
            make.width.equalTo(@(16));
            make.height.equalTo(@(16));
        }];
    }
    return self;
}

- (void)updateLayout{
    if ([self.selectPlan.isSale isEqualToString:@"1"]) {
        priceLabel.text = [NSString stringWithFormat:@"￥%@", self.selectPlan.standardPrice];

    }else{
        selectBg.hidden = YES;
        self.layer.borderWidth = 0.5;
        dateLabel.textColor = [UIColor colorWithHex:@"#cccccc"];
        overTimeLabel.textColor = [UIColor colorWithHex:@"#cccccc"];
        priceLabel.textColor = [UIColor colorWithHex:@"#cccccc"];
        priceLabel.text = @"停售";
    }
    dateLabel.text = [[DateEngine sharedDateEngine] shortTimeStringFromDate:[[DateEngine sharedDateEngine] dateFromString:self.selectPlan.startTime]];
    overTimeLabel.text = [NSString stringWithFormat:@"%@散场", [[DateEngine sharedDateEngine] shortTimeStringFromDate:[[DateEngine sharedDateEngine] dateFromString:self.selectPlan.endTime]]];
    if ([self.selectPlan.isDiscount integerValue] == 1) {
        huiImageView.hidden = NO;
        [self bringSubviewToFront:huiImageView];
    }else{
        huiImageView.hidden = YES;
    }
}

- (void)setIsSelect:(BOOL)isSelect{
    if (isSelect) {
        selectBg.hidden = NO;
        self.layer.borderWidth = 0;
        dateLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor];
        overTimeLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor];
        priceLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor];

        
    } else {
        selectBg.hidden = YES;
        self.layer.borderWidth = 0.5;
        dateLabel.textColor = [UIColor colorWithHex:@"#333333"];
        overTimeLabel.textColor = [UIColor colorWithHex:@"#cccccc"];
        priceLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].planBtnColor];
    }
}

@end
