//
//  电影详情页面
//
//  Created by KKZ on 16/2/18.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"
#import "MovieCinemaListController.h"

@class Movie;
@class MovieTrailer;
@class MovieDetailHeadView;
@class ClubPlate;
@class MovieHobbyModel;
@class CPMovieComment;

@interface MovieDetailViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate> {

    //背景图片
    UIImageView *homeBackgroundView;
    UIImageView *homeBgCover;
    //返回按钮
    UIButton *backBtn;
    //分享按钮
    UIButton *rightBtn;
    //电影详情的Table
    UITableView *movieDetailTable;
    //tableheader
    MovieDetailHeadView *movieDetailHeadView;

    NSMutableArray *stars; //2判断是否大于0，明星单独查
    //    NSMutableArray *gallerys; //3剧照（可以为0）,单独查，
    NSMutableArray *songs; //5电影音乐,最多一个

    //周边
    NSString *hobbyPicUrl, *hobbyPrice, *hobbyPromotionPrice, *hobbyTitle, *hobbyUrl;
    //电影简介Cell的高度
    float introCellHeight;

    //当前加载的页面
    NSInteger currentPage;

    UILabel *subTitleLbl1;
    UILabel *subTitleLbl2;
}

/**
 *  影片信息
 */
@property (nonatomic, strong) Movie *movie;

@property (nonatomic,strong) NSArray *movieHobbies;



/**
 *  分享的图片的信息
 */
@property (nonatomic, strong) UIImageView *postImage;

/**
 *  简介是否展开
 */
@property (nonatomic, assign) BOOL section1Expand;

/**
 *  电影预告片
 */
@property (nonatomic, strong) MovieTrailer *movieTrailer;

/**
 *  热门吐槽数据源
 */
@property (nonatomic, strong) NSMutableArray<CPMovieComment *> *clubPosts;

/**
 *  帖子精华数据源
 */
@property (nonatomic, strong) NSMutableArray *clubBestPosts;

/**
 *  帖子图片列表缩略图
 */
@property (nonatomic, strong) NSMutableArray *clubPhotos;

/**
 *  是否来自电影列表页面
 */
@property (nonatomic, assign) BOOL isFromMovies;

/**
 *  是否需要加载更多
 */
@property (nonatomic, assign) BOOL hasMore;

/**
 *  总的条数
 */
@property (nonatomic, assign) NSInteger total;

/**
 *  喜欢的数目
 */
@property (nonatomic, strong) NSNumber *likeNum;

/**
 *  不喜欢的数目
 */
@property (nonatomic, strong) NSNumber *unlikeNum;

/**
 *  是否评价过  1 喜欢，2不喜欢 0未添加
 */
@property (nonatomic, assign) NSInteger relation;

/**
 *  电影详情Table
 */
@property (nonatomic, strong) UITableView *movieDetailTableY;

/**
 *  电影详情Table
 */
@property (nonatomic, strong) NSMutableArray *postPlateM;

/**
 *  电影详情Table
 */
@property (nonatomic, copy) NSString *urlStr;


@property (nonatomic,assign) BOOL has3D;
@property (nonatomic, assign) BOOL hasImax;//IMAX


- (id)initCinemaListForMovie:(NSNumber *)movieId;






@end
