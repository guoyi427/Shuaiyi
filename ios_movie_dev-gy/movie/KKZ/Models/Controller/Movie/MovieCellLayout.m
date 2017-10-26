//
//  MovieCellLayout.m
//  KoMovie
//
//  Created by KKZ on 16/4/13.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "DateEngine.h"
#import "Movie.h"
#import "MovieCellLayout.h"
#import "UIConstants.h"

/*****************Margin****************/
static const CGFloat cellMarginX = 12.0f;
static const CGFloat marginMovieNameToDescribe = 18.0f;
static const CGFloat marginMovieDescribeToDetailInfo = 6.0f;
static const CGFloat marginFlag = 5.0f;
static const CGFloat marginFlagLast = 25.0f;

/*****************电影海报****************/
static const CGFloat moviePostLeft = 12.0f;
static const CGFloat moviePostTop = 12.0f;
static const CGFloat moviePostWidth = 57.0f;
static const CGFloat moviePostHeight = 84.0f;

/*****************电影播放按钮****************/
static const CGFloat moviePlayWidth = 20.0f;
static const CGFloat moviePlayRight = 5.0f;
static const CGFloat moviePlayBottom = 4.0f;

/*****************电影得分Text****************/
static const CGFloat movieScoreTextFontY = 11.0f;
static const CGFloat movieScoreTextTop = 19.0f;
static const CGFloat movieScoreTextHeight = 13.0f;

/*****************电影得分Num****************/
static const CGFloat movieScoreNumFontY = 16.0f;
static const CGFloat movieScoreNumTop = 16.0f;
static const CGFloat movieScoreNumHeight = 18.0f;

/*****************电影标签***************/
static const CGFloat movieFlagHeight = 15.0f;
static const CGFloat movieFlag3DWidth = 15.0f;
static const CGFloat movieFlagImaxWidth = 30.4f;
static const CGFloat movieFlagFontY = 10.0f;

/*****************人为添加电影标签***************/
static const CGFloat shortTitleFontY = 10.0f;
static const CGFloat shortTitleTop = 18.0f;

/*****************电影标题****************/
static const CGFloat movieNameFontY = 16.0f;
static const CGFloat movieNameLeft = 82.0f;
static const CGFloat movieNameTop = 17.0f;
static const CGFloat movieNameHeight = 18.0f;

/*****************电影描述***************/
static const CGFloat movieDescribeFontY = 13.0f;
static const CGFloat movieDescribeLeft = 82.0f;
static const CGFloat movieDescribeHeight = 15.0f;

/*****************电影详情***************/
static const CGFloat movieDetailInfoFontY = 12.0f;
static const CGFloat movieDetailInfoleft = 82.0f;
static const CGFloat movieDetailInfoHeight = 14.0f;

/*****************电影购票按钮***************/
static const CGFloat buyBtnTop = 55.0f;
static const CGFloat buyBtnWidth = 48.0f;
static const CGFloat buyBtnHeight = 28.0f;

/*****************活动列表的frame***************/
static const CGFloat activityTop = 108.0f;
static const CGFloat activityHeight = 45.0f;

@implementation MovieCellLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.movieFlagImageArrY = [[NSMutableArray alloc] initWithCapacity:0];
        self.movieFlagFrameArrY = [[NSMutableArray alloc] initWithCapacity:0];
        self.movieFlagImageArr = [[NSMutableArray alloc] initWithCapacity:0];
        self.movieFlagFrameArr = [[NSMutableArray alloc] initWithCapacity:0];
        self.movieActivityFrameArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)setMovie:(Movie *)movie {
    if (movie) {
        _movie = movie;
    }
}

/**
 *  更新MovieCellLayout
 */
- (void)updateMovieCellLayout {
    
    [self.movieFlagImageArrY removeAllObjects];
    [self.movieFlagFrameArrY removeAllObjects];
    
    [self.movieFlagImageArr removeAllObjects];
    [self.movieFlagFrameArr removeAllObjects];
    
    [self.movieActivityFrameArr removeAllObjects];
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    
    //电影海报的frame
    self.moviePostFrame = CGRectMake(moviePostLeft, moviePostTop, moviePostWidth, moviePostHeight);
    
    //电影播放按钮的frame
    self.moviePlayFrame = CGRectMake(moviePostWidth - moviePlayWidth - moviePlayRight, moviePostHeight - moviePlayWidth - moviePlayBottom, moviePlayWidth, moviePlayWidth);
    
    //电影评分的frame
    //text
    
    if (self.isIncoming) {
        self.movieScoreNum = @"";//[NSString stringWithFormat:@"%@", self.movie.lookCount];
        self.movieScoreText = @"";//@"人想看";
        
    } else {
        if ([self.movie.publishTime timeIntervalSinceNow] > 0) {
            self.movieScoreNum = @"";//[NSString stringWithFormat:@"%@", self.movie.lookCount];
            self.movieScoreText = @"";//@"人想看";
        } else {
            self.movieScoreNum = [NSString stringWithFormat:@"%.1f", [self.movie.score floatValue]];
            self.movieScoreText = @"分";
        }
    }
    
    CGFloat movieScoreTextLeft = 0;
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:movieScoreTextFontY];
    attributes[NSForegroundColorAttributeName] = kUIColorOrange;
    CGSize movieScoreTextS = [self.movieScoreText sizeWithAttributes:attributes];
    movieScoreTextLeft = screentWith - cellMarginX - movieScoreTextS.width;
    self.movieScoreTextFrame = CGRectMake(movieScoreTextLeft, movieScoreTextTop, movieScoreTextS.width, movieScoreTextHeight);
    self.movieScoreTextFont = movieScoreTextFontY;
    
    //num
    
    CGFloat movieScoreNumLeft = 0;
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:movieScoreNumFontY];
    attributes[NSForegroundColorAttributeName] = kUIColorOrange;
    CGSize movieScoreNumS = [self.movieScoreNum sizeWithAttributes:attributes];
    movieScoreNumLeft = CGRectGetMinX(self.movieScoreTextFrame) - movieScoreNumS.width;
    self.movieScoreNumFont = movieScoreNumFontY;
    self.movieScoreNumFrame = CGRectMake(movieScoreNumLeft, movieScoreNumTop, movieScoreNumS.width, movieScoreNumHeight);
    
    //电影标题的frame
    CGFloat movieNameWidth = 0;
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:movieNameFontY];
    attributes[NSForegroundColorAttributeName] = [UIColor blackColor];
    CGSize movieNameTextS = [self.movie.movieName sizeWithAttributes:attributes];
    movieNameWidth = movieNameTextS.width;
    
    if (movieNameLeft + marginFlag * 2 + movieNameWidth <= CGRectGetMinX(self.movieScoreNumFrame)) {
        
    }else{
        movieNameWidth = CGRectGetMinX(self.movieScoreNumFrame) - (movieNameLeft + marginFlag * 2);
    }
    self.movieNameFrame = CGRectMake(movieNameLeft, movieNameTop, movieNameWidth, movieNameHeight);
    self.movieNameFont = movieNameFontY;
    
    //电影标签
    //先移除所有标签
    
    NSMutableArray *flagLengthArrY = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (self.movie.hasImax) {
        [self.movieFlagImageArrY addObject:@"IMAX"];
        [flagLengthArrY addObject:[NSString stringWithFormat:@"%f", movieFlagImaxWidth]];
        self.movieFlagFontY = movieFlagFontY;
    } else if (self.movie.has3D) {
        [self.movieFlagImageArrY addObject:@"3D"];
        [flagLengthArrY addObject:[NSString stringWithFormat:@"%f", movieFlag3DWidth]];
        self.movieFlagFontY = movieFlagFontY;
    }
    
    CGFloat flagLeftReallyY = 0;
    for (int i = 0; i < flagLengthArrY.count; i++) {
        CGRect r = CGRectMake(flagLeftReallyY, 0, [flagLengthArrY[i] floatValue], movieFlagHeight);
        [self.movieFlagFrameArrY addObject:NSStringFromCGRect(r)];
    }
    
    //购票按钮的frame
    self.buyBtnFrame = CGRectMake(screentWith - cellMarginX - buyBtnWidth, buyBtnTop, buyBtnWidth, buyBtnHeight);
    
    if (self.isIncoming) {
        if (self.movie.hasPlan) {
            self.buyBtnTitle = @"预售";
        } else {
            self.buyBtnTitle = @"介绍";
        }
    } else {
        if ([self.movie.publishTime timeIntervalSinceNow] > 0) {
            self.buyBtnTitle = @"预售";
        } else {
            self.buyBtnTitle = @"购票";
        }
    }
    
    
    //先移除所有人为添加的标签
    CGFloat flagLeft = CGRectGetMaxX(self.movieNameFrame) + marginFlag;
    
    if (self.movie.shortTitle.length && self.movie.shortTitle && !self.isIncoming) {
        CGFloat shortTitleWidth;
        attributes[NSFontAttributeName] = [UIFont systemFontOfSize:shortTitleFontY];
        attributes[NSForegroundColorAttributeName] = kUIColorOrange;
        CGSize shortTitleS = [self.movie.shortTitle sizeWithAttributes:attributes];
        shortTitleWidth = shortTitleS.width + 10;
        self.shortTitleFont = shortTitleFontY;
        
        [self.movieFlagImageArr addObject:@"shortTitle"];
        
        
        
        CGFloat lastRightPointX = CGRectGetMinX(self.movieScoreNumFrame) < CGRectGetMinX(self.buyBtnFrame)?CGRectGetMinX(self.movieScoreNumFrame):CGRectGetMinX(self.buyBtnFrame);
        
        
        
        if (flagLeft + shortTitleWidth + marginFlag * (self.movieFlagImageArr.count - 1) + marginFlagLast <= lastRightPointX) {
            CGRect r = CGRectMake(flagLeft, shortTitleTop, shortTitleWidth, movieFlagHeight);
            [self.movieFlagFrameArr addObject:NSStringFromCGRect(r)];
            
            self.movieNameFrame = CGRectMake(movieNameLeft, movieNameTop,movieNameWidth, movieNameHeight);
            
        } else {
            CGFloat flagLeftReally = lastRightPointX - marginFlagLast - shortTitleWidth;
            
            CGRect r = CGRectMake(flagLeftReally, shortTitleTop, shortTitleWidth, movieFlagHeight);
            
            [self.movieFlagFrameArr addObject:NSStringFromCGRect(r)];
            
            self.movieNameFrame = CGRectMake(movieNameLeft, movieNameTop,flagLeftReally - movieNameLeft, movieNameHeight);
        }
    }
    
    //电影描述的frame
    CGFloat movieDescribeWidth = 0;
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:movieDescribeFontY];
    attributes[NSForegroundColorAttributeName] = [UIColor grayColor];
    CGSize movieDescribeS = [self.movie.title sizeWithAttributes:attributes];
    movieDescribeWidth = movieDescribeS.width;
    CGFloat movieDescribeTop = CGRectGetMaxY(self.movieNameFrame) + marginMovieNameToDescribe;
    self.movieDescribeFrame = CGRectMake(movieDescribeLeft, movieDescribeTop, movieDescribeWidth, movieDescribeHeight);
    self.movieDescribeFont = movieDescribeFontY;
    
    //电影详情的frame
    if (self.movie.cinemaCount&& self.movie.planCount) {
        self.movieDetailInfo = [NSString stringWithFormat:@"共%@家影院%@场", self.movie.cinemaCount.stringValue, self.movie.planCount.stringValue];
        
    } else {
        if ([self.movie.publishTime timeIntervalSinceNow] > 0) {
            self.movieDetailInfo = [NSString stringWithFormat:@"%@上映", [[DateEngine sharedDateEngine] stringFromDate:self.movie.publishTime withFormat:@"YYYY-MM-dd"]];
        }
    }
    CGFloat movieDetailInfoWidth = 0;
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:movieDetailInfoFontY];
    attributes[NSForegroundColorAttributeName] = [UIColor grayColor];
    CGSize movieDetailInfoS = [self.movieDetailInfo sizeWithAttributes:attributes];
    movieDetailInfoWidth = movieDetailInfoS.width;
    CGFloat movieDetailInfoTop = CGRectGetMaxY(self.movieDescribeFrame) + marginMovieDescribeToDetailInfo;
    self.movieDetailInfoFrame = CGRectMake(movieDetailInfoleft, movieDetailInfoTop, movieDetailInfoWidth, movieDetailInfoHeight);
    self.movieDetailInfoFont = movieDetailInfoFontY;
    
    
    
    //活动列表
    CGFloat positionY = activityTop;
    
    [self.movieActivityFrameArr removeAllObjects];
    for (int i = 0; i < self.movie.banners.count; i++) {
        CGRect r = CGRectMake(0, positionY, screentWith, activityHeight);
        [self.movieActivityFrameArr addObject:NSStringFromCGRect(r)];
        positionY += activityHeight;
    }
    
    self.height = positionY;
}
@end
