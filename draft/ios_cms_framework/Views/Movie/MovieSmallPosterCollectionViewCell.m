//
//  MovieListPosterCollectionViewCell.m
//  CIASMovie
//
//  Created by cias on 2016/12/16.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "MovieSmallPosterCollectionViewCell.h"
#import <Category_KKZ/UIImage+Resize.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "KKZTextUtility.h"

@implementation MovieSmallPosterCollectionViewCell



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        moviePosterImage = [UIImageView new];
        moviePosterImage.backgroundColor = [UIColor colorWithHex:@"#f2f5f5"];
        moviePosterImage.layer.cornerRadius = 3.5;
        moviePosterImage.clipsToBounds = YES;
        [self addSubview:moviePosterImage];
        [moviePosterImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 23, 0));
        }];
        /*

        huiLogoImage = [UIImageView new];
        huiLogoImage.backgroundColor = [UIColor clearColor];
        huiLogoImage.layer.cornerRadius = 4;
        huiLogoImage.image = [UIImage imageNamed:@"hui_tag1"];
        [moviePosterImage addSubview:huiLogoImage];
        huiLogoImage.clipsToBounds = YES;
        huiLogoImage.contentMode = UIViewContentModeScaleAspectFit;
        [huiLogoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(moviePosterImage);
            make.width.height.equalTo(@(34));
            
        }];
*/
        self.movieName = @"神奇动物在哪里";
        movieNameLabel = [UILabel new];
        movieNameLabel.font = [UIFont systemFontOfSize:13];
        movieNameLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        movieNameLabel.backgroundColor = [UIColor clearColor];
        movieNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:movieNameLabel];
//        movieNameLabel.frame = CGRectMake(0, 220, 105, 15);
        [movieNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.top.equalTo(moviePosterImage.mas_bottom).offset(8);
            make.height.equalTo(@(15));
        }];
        /*
        preSellLabel = [self getFlagLabelWithFont:11 withBgColor:@"#20CB9A" withTextColor:@"#FFFFFF"];
        preSellLabel.text = @"预售";
        preSellLabel.hidden = YES;
        [self addSubview:preSellLabel];
        [preSellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.width.equalTo(@(29));
            make.top.equalTo(self.mas_bottom).offset(-21);
            make.height.equalTo(@(13));
        }];

        scoreLabel = [self getFlagLabelWithFont:11 withBgColor:[UIConstants sharedDataEngine].withColor withTextColor:@"#000000"];
        [moviePosterImage addSubview:scoreLabel];
        [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(moviePosterImage.mas_right).offset(-5);
            make.bottom.equalTo(moviePosterImage.mas_bottom).offset(-5);
            make.width.equalTo(@(25));
            make.height.equalTo(@(20));
        }];
        screenTypeLabel = [self getFlagLabelWithFont:11 withBgColor:@"#000000" withTextColor:@"#FFFFFF"];
        [moviePosterImage addSubview:screenTypeLabel];
        [screenTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(scoreLabel.mas_left).offset(-3);
            make.bottom.equalTo(moviePosterImage.mas_bottom).offset(-5);
            make.width.equalTo(@(28));
            make.height.equalTo(@(18));
        }];
         */

    }
    return self;
}

- (void)updateLayout{
    movieNameLabel.text = self.movieName;
    UIImage *placeHolderImage = [UIImage centerResizeFrom:[UIImage imageNamed:@"movie_nopic_s"] newSize:CGSizeMake(self.frame.size.width, self.frame.size.height-23) bgColor:[UIColor colorWithHex:@"#f2f5f5"]];
    [moviePosterImage sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:self.imageUrl] placeholderImage:placeHolderImage];
    /*
    UIImage *placeHolderImage = [UIImage centerResizeFrom:[UIImage imageNamed:@"logo_holder"] newSize:moviePosterImage.frame.size bgColor:[UIColor colorWithHex:@"0xe3e3e3"]];
    [moviePosterImage sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:placeHolderImage];
    movieNameLabel.text = self.movieName;
    [self setNeedsUpdateConstraints];

    self.isPreSell = YES;
    if (self.isPreSell) {
        movieNameLabel.textAlignment = NSTextAlignmentLeft;

        preSellLabel.hidden = NO;
        CGSize movieNameSize = [KKZTextUtility measureText:self.movieName font:[UIFont systemFontOfSize:13]];
//        CGSize movieNameSize = [KKZTextUtility measureText:self.movieName size:CGSizeMake(MAXFLOAT, 15) font:[UIFont systemFontOfSize:13]];

        float movieNameL = movieNameSize.width>=(self.frame.size.width-34)?(self.frame.size.width-34):movieNameSize.width;
//        [movieNameLabel setFrame:CGRectMake(0, 181-20, movieNameSize.width, 15)];

        [movieNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@((self.frame.size.width-movieNameL-34)/2));
            make.top.equalTo(self.mas_bottom).offset(-22);
            make.height.equalTo(@(15));
            make.width.equalTo(@(movieNameL+5));
        }];
        [preSellLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(movieNameLabel.mas_right);
            //            make.right.equalTo(self.mas_right);
            make.width.equalTo(@(29));
            make.top.equalTo(self.mas_bottom).offset(-21);
            make.height.equalTo(@(13));
        }];
    }else{
        movieNameLabel.textAlignment = NSTextAlignmentCenter;

        preSellLabel.hidden = YES;
        [movieNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.top.equalTo(self.mas_bottom).offset(-22);
            make.height.equalTo(@(15));
            make.width.equalTo(self);
            
        }];
        
    }
    CGSize scoreSize = [KKZTextUtility measureText:self.point font:[UIFont systemFontOfSize:11]];
    scoreLabel.text = self.point;
    [scoreLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(moviePosterImage.mas_right).offset(-4);
        make.bottom.equalTo(moviePosterImage.mas_bottom).offset(-5);
        make.width.equalTo(@(scoreSize.width+4));
        make.height.equalTo(@(15));
    }];
    
    CGSize screenTypeSize = [KKZTextUtility measureText:self.availableScreenType font:[UIFont systemFontOfSize:11]];
    screenTypeLabel.text = self.availableScreenType;
    [screenTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(scoreLabel.mas_left).offset(-2);
        make.bottom.equalTo(moviePosterImage.mas_bottom).offset(-6);
        make.width.equalTo(@(screenTypeSize.width+4));
        make.height.equalTo(@(13));
    }];
    
*/
}

- (void)updateConstraints {
    //according to apple super should be called at end of method
    [super updateConstraints];
}

- (UILabel *)getFlagLabelWithFont:(float)font withBgColor:(NSString *)color withTextColor:(NSString *)textColor{
    UILabel *_activityTitle = [UILabel new];
    _activityTitle.font = [UIFont systemFontOfSize:font];
    _activityTitle.textAlignment = NSTextAlignmentCenter;
    _activityTitle.textColor = [UIColor colorWithHex:textColor];
    _activityTitle.backgroundColor = [UIColor colorWithHex:color];
    _activityTitle.layer.cornerRadius = 4.0f;
    _activityTitle.layer.masksToBounds = YES;
    return _activityTitle;
}




@end
