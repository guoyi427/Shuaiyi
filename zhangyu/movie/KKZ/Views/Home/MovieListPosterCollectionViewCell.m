//
//  MovieListPosterCollectionViewCell.m
//  CIASMovie
//
//  Created by cias on 2016/12/16.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "MovieListPosterCollectionViewCell.h"
#import <Category_KKZ/UIImage+Resize.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "KKZTextUtility.h"
#import <Category_KKZ/UIColor+Hex.h>
#import "UIConstants.h"
#import "KKZTextUtility.h"

@implementation MovieListPosterCollectionViewCell



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _moviePosterImage = [UIImageView new];
        _moviePosterImage.backgroundColor = [UIColor colorWithHex:@"#f2f5f5"];
        _moviePosterImage.layer.cornerRadius = 3.5;
        _moviePosterImage.clipsToBounds = YES;
        [self addSubview:_moviePosterImage];
        [_moviePosterImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 20, 0));
        }];
        huiLogoImage = [UIImageView new];
        huiLogoImage.backgroundColor = [UIColor clearColor];
//        huiLogoImage.layer.cornerRadius = 4;
        huiLogoImage.image = [UIImage imageNamed:@"hui_tag1"];
        [_moviePosterImage addSubview:huiLogoImage];
        huiLogoImage.clipsToBounds = YES;
        huiLogoImage.hidden = YES;
        huiLogoImage.contentMode = UIViewContentModeScaleAspectFit;
        [huiLogoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(_moviePosterImage);
            make.width.height.equalTo(@(34));
        }];

//        self.movieName = @"神奇动物在哪里";
        movieNameLabel = [UILabel new];
        movieNameLabel.font = [UIFont systemFontOfSize:13];
        movieNameLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        movieNameLabel.backgroundColor = [UIColor clearColor];
        movieNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:movieNameLabel];
        movieNameLabel.text = self.movieName;
//        movieNameLabel.frame = CGRectMake(0, 220, 105, 15);
        [movieNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.top.equalTo(self.mas_bottom).offset(-14);
            make.height.equalTo(@(14));
        }];
        preSellLabel = [self getFlagLabelWithFont:10 withBgColor:@"#00cc99" withTextColor:@"#FFFFFF"];
        preSellLabel.text = @"预售";
        preSellLabel.hidden = YES;
        [self addSubview:preSellLabel];
        [preSellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.width.equalTo(@(26));
            make.top.equalTo(self.mas_bottom).offset(-15);
            make.height.equalTo(@(13));
        }];

        scoreLabel = [self getFlagLabelWithFont:10 withBgColor:@"#FFCC00" withTextColor:@"#000000"];
        [_moviePosterImage addSubview:scoreLabel];
        [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_moviePosterImage.mas_right).offset(-6);
            make.bottom.equalTo(_moviePosterImage.mas_bottom).offset(-6);
            make.width.equalTo(@(25));
            make.height.equalTo(@(15));
        }];
        screenTypeLabel = [self getFlagLabelWithFont:10 withBgColor:@"#000000" withTextColor:@"#FFFFFF"];
        [_moviePosterImage addSubview:screenTypeLabel];
        [screenTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(scoreLabel.mas_left).offset(-3);
            make.bottom.equalTo(_moviePosterImage.mas_bottom).offset(-6);
            make.width.equalTo(@(25));
            make.height.equalTo(@(15));
        }];

    }
    return self;
}

+ (NSURL *)getUrlDeleteChineseWithString:(NSString *)urlStr {
    NSString *urlString = @"";
    if ([urlStr hasPrefix:@"http://"] || [urlStr hasPrefix:@"https://"]) {
        urlString = [NSString stringWithFormat:@"%@", urlStr];
    }
    NSURL *requestUrl = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    return requestUrl;
}

- (void)updateLayout{
//    self.point = @"10.0";
//    self.availableScreenType = @"IMAX 3D";
//    self.movieName = @"神奇动物在哪里";
    
    UIImage *placeHolderImage = [UIImage centerResizeFrom:[UIImage imageNamed:@"movie_nopic"] newSize:CGSizeMake(self.frame.size.width, self.frame.size.height-20) bgColor:[UIColor colorWithHex:self.posterImageBackColor]];
    [self.moviePosterImage sd_setImageWithURL:[MovieListPosterCollectionViewCell getUrlDeleteChineseWithString:self.imageUrl]
                             placeholderImage:placeHolderImage];
    movieNameLabel.text = self.movieName;
    [self setNeedsUpdateConstraints];

//    self.isPreSell = YES;
    if (self.isSale) {
        huiLogoImage.hidden = NO;
    }else{
        huiLogoImage.hidden = YES;
    }
    if (self.isPresell) {
        movieNameLabel.textAlignment = NSTextAlignmentLeft;

        preSellLabel.hidden = NO;
//        CGSize movieNameSize = [KKZTextUtility measureText:self.movieName font:[UIFont systemFontOfSize:13]];
        CGSize movieNameSize = [KKZTextUtility measureText:self.movieName size:CGSizeMake(MAXFLOAT, 15) font:[UIFont systemFontOfSize:13]];

        float movieNameL = movieNameSize.width>=(self.frame.size.width-31)?(self.frame.size.width-31):movieNameSize.width;
//        [movieNameLabel setFrame:CGRectMake(0, 181-20, movieNameSize.width, 15)];

        [movieNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@((self.frame.size.width-movieNameL-31)/2));
            make.top.equalTo(self.mas_bottom).offset(-14);
            make.height.equalTo(@(14));
            make.width.equalTo(@(movieNameL+5));
        }];
        [preSellLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(movieNameLabel.mas_right);
            //            make.right.equalTo(self.mas_right);
            make.width.equalTo(@(26));
            make.top.equalTo(self.mas_bottom).offset(-15);
            make.height.equalTo(@(13));
        }];
    }else{
        movieNameLabel.textAlignment = NSTextAlignmentCenter;

        preSellLabel.hidden = YES;
        [movieNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.top.equalTo(self.mas_bottom).offset(-14);
            make.height.equalTo(@(14));
            make.width.equalTo(self);
            
        }];
        
    }
    
    if (self.point.length) {
        scoreLabel.hidden = NO;
        CGSize scoreSize = [KKZTextUtility measureText:self.point size:CGSizeMake(MAXFLOAT, 13) font:[UIFont systemFontOfSize:10]];
        scoreLabel.text = self.point;
        [scoreLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.moviePosterImage.mas_right).offset(-6);
            make.bottom.equalTo(self.moviePosterImage.mas_bottom).offset(-6);
            make.width.equalTo(@(scoreSize.width+6));
            make.height.equalTo(@(15));
        }];
        
    }else{
        scoreLabel.hidden = YES;
    }
    if (self.availableScreenType.length) {
        screenTypeLabel.hidden = NO;
        CGSize screenTypeSize = [KKZTextUtility measureText:self.availableScreenType size:CGSizeMake(MAXFLOAT, 13) font:[UIFont systemFontOfSize:10]];
        screenTypeLabel.text = self.availableScreenType;
        [screenTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(scoreLabel.mas_left).offset(-3);
            make.bottom.equalTo(self.moviePosterImage.mas_bottom).offset(-6);
            make.width.equalTo(@(screenTypeSize.width+6));
            make.height.equalTo(@(15));
        }];
    }else{
        screenTypeLabel.hidden = YES;
    }

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
    _activityTitle.layer.cornerRadius = 3.5f;
    _activityTitle.layer.masksToBounds = YES;
    return _activityTitle;
}




@end
