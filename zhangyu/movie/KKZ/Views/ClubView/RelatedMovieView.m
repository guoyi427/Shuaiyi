//
//  RelatedMovieView.m
//  KoMovie
//
//  Created by KKZ on 16/2/2.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ImageEngineNew.h"
#import "RelatedMovieView.h"
#import "RatingView.h"

#define marginX 15
#define marginY 15
#define posterWidth 85
#define posterHeigth 118
#define marginTitleTop 30
#define marginPosterToTitle 15
#define marginTitleToStars 15
#define marginStarToSubTitle 10
#define movieTitleFont 14
#define subTitleFont 13
#define moviePlanDateFont 13
#define starViewWidth 150
#define starViewHeigth 15
#define arrowWidth 20
#define arrowHeight 14
#define starHeight 13

@implementation RelatedMovieView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //设置背景颜色
        [self setBackgroundColor:[UIColor whiteColor]];
        //海报区域
        [self addMoviePoster];
        //相关电影详情
        [self addMovieDetail];
    }
    return self;
}

/**
 *  添加海报区域
 */
- (void)addMoviePoster {
    moivePosterView = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, marginY, posterWidth, posterHeigth)];
    [moivePosterView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:moivePosterView];
}

/**
 *  电影的标题、得分、简短介绍、上映日期
 */
- (void)addMovieDetail {
    //添加电影标题
    movieTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(moivePosterView.frame) + marginPosterToTitle, marginTitleTop, screentWith - CGRectGetMaxX(moivePosterView.frame) - marginPosterToTitle, movieTitleFont)];
    movieTitleLbl.font = [UIFont systemFontOfSize:movieTitleFont];
    movieTitleLbl.textColor = [UIColor blackColor];
    [self addSubview:movieTitleLbl];

    //添加电影得分区域
    moviePointView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(movieTitleLbl.frame), CGRectGetMaxY(movieTitleLbl.frame) + marginTitleToStars, starViewWidth, starViewHeigth)];
    [moviePointView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:moviePointView];
    
    
    //评分星星
    
    starView = [[RatingView alloc] initWithFrame:CGRectMake(0,0, 83, starHeight)];
    
    [starView setImagesDeselected:@"fav_star_no_yellow_match"
     
                   partlySelected:@"fav_star_half_yellow"
     
                     fullSelected:@"fav_star_full_yellow"
     
                         iconSize:CGSizeMake(starHeight, starHeight)
     
                      andDelegate:nil];
    
    starView.userInteractionEnabled = NO;
    
    [starView displayRating:0];
    
    [moviePointView addSubview:starView];
    
    
    moviePointLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(starView.frame) + 8, 0, 50, starViewHeigth)];
    moviePointLbl.font = [UIFont systemFontOfSize:starViewHeigth];
    moviePointLbl.textColor = appDelegate.kkzYellow;
    
    [moviePointView addSubview:moviePointLbl];
    

    //添加箭头
    UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(screentWith - marginX - arrowWidth, (self.frame.size.height - arrowWidth) * 0.5, arrowWidth, arrowHeight)];
    arrowView.contentMode = UIViewContentModeScaleAspectFit;
    arrowView.image = [UIImage imageNamed:@"arrowGray"];
    [self addSubview:arrowView];

    //添加电影简短介绍
    movieSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(movieTitleLbl.frame), CGRectGetMaxY(moviePointView.frame) + marginStarToSubTitle, CGRectGetMinX(arrowView.frame) - CGRectGetMinX(movieTitleLbl.frame), subTitleFont)];
    movieSubTitle.textColor = [UIColor r:102 g:102 b:102];
    movieSubTitle.font = [UIFont systemFontOfSize:subTitleFont];
    [self addSubview:movieSubTitle];

    //添加电影上映日期
    moviePlanDate = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(movieTitleLbl.frame), self.frame.size.height - moviePlanDateFont - marginTitleTop, screentWith - CGRectGetMinX(movieTitleLbl.frame), moviePlanDateFont)];
    moviePlanDate.textColor = [UIColor r:153 g:153 b:153];
    moviePlanDate.font = [UIFont systemFontOfSize:moviePlanDateFont];
    [self addSubview:moviePlanDate];
}

/**
 *  加载数据
 */
- (void)upLoadData {
    //加载海报
    [moivePosterView loadImageWithURL:self.moviePath andSize:ImageSizeOrign];
    //加载电影标题
    movieTitleLbl.text = self.movieTitle;
    movieSubTitle.text = self.movieSubTitle;
    moviePlanDate.text = self.movieDate;
    
   [starView displayRating:[self.moviePoint floatValue] / 2.0];
    moviePointLbl.text = [NSString stringWithFormat:@"%.1f",self.moviePoint.floatValue];
}
@end
