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
#import "RatingView.h"
#import "Movie.h"

@interface MovieListPosterCollectionViewCell ()
{
    RatingView *_startView;
}
@end
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
        
        UIView *grayView = [[UIView alloc] init];
        grayView.backgroundColor = appDelegate.kkzLine;
        [self addSubview:grayView];
        [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.mas_equalTo(50);
        }];

//        self.movieName = @"神奇动物在哪里";
        movieNameLabel = [UILabel new];
        movieNameLabel.font = [UIFont systemFontOfSize:13];
        movieNameLabel.textColor = [UIColor blackColor];//[UIColor colorWithHex:@"#b2b2b2"];
        [grayView addSubview:movieNameLabel];
        movieNameLabel.text = self.movieName;
        [movieNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.right.mas_lessThanOrEqualTo(-10);
            make.top.equalTo(grayView).offset(5);
        }];
        
        _startView = [[RatingView alloc] initWithFrame:CGRectMake(10, 25, CGRectGetWidth(self.frame) * 0.6, 20)];
        [_startView setImagesDeselected:@"fav_star_no_yellow_match"
                       partlySelected:@"fav_star_half_yellow"
                         fullSelected:@"fav_star_full_yellow"
                             iconSize:CGSizeMake(10, 10)
                          andDelegate:nil];
        _startView.userInteractionEnabled = NO;
        [_startView displayRating:0];
        [grayView addSubview:_startView];

        scoreLabel = [self getFlagLabelWithFont:10 withBgColor:@"#EEEEEE" withTextColor:@"#999999"];
        [grayView addSubview:scoreLabel];
        [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_startView.mas_right).offset(5);
            make.right.mas_lessThanOrEqualTo(-5);
            make.centerY.equalTo(_startView);
        }];
        
        preSellLabel = [self getFlagLabelWithFont:10 withBgColor:@"#EEEEEE" withTextColor:@"#999999"];
        preSellLabel.hidden = YES;
        [self addSubview:preSellLabel];
        [preSellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-10);
            make.height.equalTo(@(13));
        }];
        
        screenTypeLabel = [self getFlagLabelWithFont:10 withBgColor:@"#000000" withTextColor:@"#FFFFFF"];
        [self addSubview:screenTypeLabel];
        [screenTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(grayView.mas_top);
            make.left.mas_equalTo(2);
            make.height.mas_equalTo(20);
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
    _startView.hidden = !self.isSale;

    if (self.isPresell) {
        movieNameLabel.textAlignment = NSTextAlignmentLeft;

        preSellLabel.hidden = NO;
//        CGSize movieNameSize = [KKZTextUtility measureText:self.movieName font:[UIFont systemFontOfSize:13]];
        CGSize movieNameSize = [KKZTextUtility measureText:self.movieName size:CGSizeMake(MAXFLOAT, 15) font:[UIFont systemFontOfSize:13]];
        preSellLabel.text = [NSString stringWithFormat:@"%@上映", [[DateEngine sharedDateEngine] stringFromDate:self.model.publishTime withFormat:@"YYYY-MM-dd"]];
        
    }else{
        movieNameLabel.textAlignment = NSTextAlignmentCenter;

        preSellLabel.hidden = YES;
    }
    
    if (self.point.length) {
        
        [_startView displayRating:self.point.floatValue / 2.0];

        scoreLabel.hidden = NO;
        CGSize scoreSize = [KKZTextUtility measureText:self.point size:CGSizeMake(MAXFLOAT, 13) font:[UIFont systemFontOfSize:10]];
        scoreLabel.text = self.point;
    }else{
        scoreLabel.hidden = YES;
    }
    if (self.availableScreenType.length) {
        screenTypeLabel.hidden = NO;
        CGSize screenTypeSize = [KKZTextUtility measureText:self.availableScreenType size:CGSizeMake(MAXFLOAT, 13) font:[UIFont systemFontOfSize:10]];
        screenTypeLabel.text = self.availableScreenType;
    }else{
        screenTypeLabel.hidden = YES;
    }
    scoreLabel.hidden = !self.isSale;
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
