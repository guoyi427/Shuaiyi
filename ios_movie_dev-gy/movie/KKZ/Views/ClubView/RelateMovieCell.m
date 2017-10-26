//
//  RelateMovieCell.m
//  KoMovie
//
//  Created by KKZ on 16/2/26.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "DateEngine.h"
#import "KKZUtility.h"
#import "Movie.h"

#import "MovieDetailViewController.h"
#import "MovieTask.h"
#import "RelateMovieCell.h"
#import "RelatedMovieView.h"
#import "TaskQueue.h"

#define relateMovieViewBgColor [UIColor r:245 g:245 b:245]
#define relateMovieViewHeight 170
//相关电影区域和背景之间的距离
#define marginRelatedMovieView 10

@implementation RelateMovieCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //加载相关电影区域
        [self loadRelateMovieView];
    }
    return self;
}

/**
 *  加载相关电影区域
 */
- (void)loadRelateMovieView {
    relateMovieViewBg = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screentWith, relateMovieViewHeight)];
    [relateMovieViewBg setBackgroundColor:relateMovieViewBgColor];
    [relateMovieViewBg addTarget:self action:@selector(getMovieDetail) forControlEvents:UIControlEventTouchUpInside];

    relateMovieV = [[RelatedMovieView alloc] initWithFrame:CGRectMake(0, marginRelatedMovieView, screentWith, relateMovieViewHeight - marginRelatedMovieView * 2)];
    [relateMovieViewBg addSubview:relateMovieV];
    relateMovieV.userInteractionEnabled = NO;

    [self addSubview:relateMovieViewBg];
}

- (void)upLoadData {
    if (self.movieId > 0 && self.movie) {

        relateMovieV.movieTitle = self.movie.movieName;
        relateMovieV.moviePoint = [NSNumber numberWithInteger:[self.movie.score integerValue]];
        relateMovieV.movieSubTitle = self.movie.title;
        if (self.movie.publishTime) {
            relateMovieV.movieDate = [NSString stringWithFormat:@"%@上映", [[DateEngine sharedDateEngine] stringFromDate:self.movie.publishTime withFormat:@"YYYY-MM-dd"]];
        }

        relateMovieV.moviePath = self.movie.thumbPath;
        [relateMovieV upLoadData];
    }
}

- (void)getMovieDetail {
    Movie *movie = self.movie;
    MovieDetailViewController *mvc = [[MovieDetailViewController alloc] initCinemaListForMovie:
                                      movie.movieId];

    CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
    [parentCtr pushViewController:mvc animation:CommonSwitchAnimationBounce];
}
@end
