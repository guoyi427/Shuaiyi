//
//  电影详情页面的HeaderView
//
//  Created by KKZ on 16/2/19.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MoviePlayerViewController.h"
#import "RatingView.h"

@class MovieTrailer;
@class Movie;

@interface MovieDetailHeadView : UIView <RatingViewDelegate, MoviePlayerViewControllerDataSource, MoviePlayerViewControllerDelegate> {

    //电影名称
    UILabel *movieTitleLabel;
    //是否为3D等类型
    UIImageView *threeDImg;
    UIImageView *imaxImg;
    //评分星星
    RatingView *starView;
    //评分
    UILabel *totleScoreLalel;
    //语种、时长
    UILabel *movieDetailInfo;
    //影片类型
    UILabel *movieType;
    //电影上映的时间
    UILabel *moviePlayerTime;
    MoviePlayerViewController *movieVC;
    //评论
    UIButton *commentBtn;
    //想看
    UIButton *wantSeeBtn;
}

/**
 *  影片海报
 */
@property (nonatomic, copy) NSString *postImagePath;

/**
 *  电影名称
 */
@property (nonatomic, copy) NSString *movieTitle;

/**
 *  是否是3D
 */
@property (nonatomic, assign) BOOL isThreeD;

/**
 *  是否是imax
 */
@property (nonatomic, assign) BOOL isImax;

/**
 *  是否是电影详情
 */
@property (nonatomic, assign) BOOL isMovieDetial;

/**
 *  是否正在请求数据
 */
@property (nonatomic, assign) BOOL isOperationing;

/**
 *  目前是否处于想看状态
 */
@property (nonatomic, assign) BOOL isMovieWantSee;

/**
 *  电影得分
 */
@property (nonatomic, strong) NSNumber *movieScore;

/**
 *  电影语种
 */
@property (nonatomic, copy) NSString *movieLanguage;

/**
 *  电影时长
 */
@property (nonatomic, copy) NSString *movieLength;

/**
 *  电影上映时间
 */
@property (nonatomic, copy) NSString *moviePublishTime;

/**
 *  预告片
 */
@property (nonatomic, strong) MovieTrailer *movieTrailer;

/**
 *  影片
 */
@property (nonatomic, strong) Movie *movie;

@property (nonatomic, strong) UIImageView *postImageView;

/**
 *  加载数据
 */
- (void)upLoadData;

@end
