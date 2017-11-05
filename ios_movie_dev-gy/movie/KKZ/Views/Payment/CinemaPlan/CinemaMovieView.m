//
//  排期列表页面顶部电影列表的View
//
//  Created by 艾广华 on 16/4/12.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaMovieView.h"

#import "KKZUtility.h"
#import "Movie.h"
#import "MovieDetailViewController.h"
#import "SwitchMovieView.h"
#import "UIColor+Hex.h"

/****************影片选择视图*************/
static const CGFloat switchMovieHeight = 150.0f;

/****************影片名字*************/
static const CGFloat movieNameTop = 13.0f;
static const CGFloat movieNameLeft = 10.0f;
static const CGFloat movieNameHeight = 14.0f;
static const CGFloat movieNameFont = 15.0f;

/****************影片分数*************/
static const CGFloat moviePointTop = 14.0f;
static const CGFloat moviePointLeft = 7.0f;
static const CGFloat moviePointRight = 10.0f;
static const CGFloat moviePointMaxWidth = 60.0f;
static const CGFloat moviePointHeight = 12.0f;

/****************影片时长*************/
static const CGFloat movieLengthTop = 10.0f;
static const CGFloat movieLengthLeft = 10.0f;
static const CGFloat movieLengthHeight = 12.0f;
//static const CGFloat movieLengthBottom = 13.0f;
static const CGFloat movieLengthFont = 13.0f;

/****************点击进入影片详情的区域*************/
static const CGFloat movieDetailVHeight = 60.0f;

@interface CinemaMovieView () <SwitchMovieDelegate>

/**
 *  电影切换视图
 */
@property (nonatomic, strong) SwitchMovieView *switchMovieView;

/**
 *  电影海报地址数组
 */
@property (nonatomic, strong) NSMutableArray *movieURLs;

/**
 *  选择影片对应的视图
 */
@property (nonatomic, strong) UIImageView *selectImageView;

/**
 *  点击进入影片详情的区域
 */
@property (nonatomic, strong) UIButton *movieDetailView;

/**
 *  电影名字标签
 */
@property (nonatomic, strong) UILabel *movieNameLabel;

/**
 *  电影分数标签
 */
@property (nonatomic, strong) UILabel *moviePointLabel;

/**
 *  电影时长标签
 */
@property (nonatomic, strong) UILabel *movieLengthLabel;

@end

@implementation CinemaMovieView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMovieDetailViewCanBeclickN) name:@"switchmovieScrollViewDidScroll" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMovieDetailViewCanBeclickY) name:@"switchmovieScrollViewDidEndDecelerating" object:nil];
        self.isMoviedetailCanbeclicked = YES;
    }

    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)changeMovieDetailViewCanBeclickN {
    self.isMoviedetailCanbeclicked = NO;
}

- (void)changeMovieDetailViewCanBeclickY {
    self.isMoviedetailCanbeclicked = YES;
}

- (void)updateLayout {
    [_movieURLs removeAllObjects];
    for (int i = 0; i < _movieList.count; i++) {
        Movie *movie = _movieList[i];
        if (self.movieId != nil) {
            if ([movie.movieId isEqualToNumber:self.movieId]) {
                self.switchMovieView.currentIndex = i;
            }
        }
        if (movie.pathVerticalS) {
            [self.movieURLs addObject:movie.pathVerticalS];
        }
    }
    [self.switchMovieView loadImagesWithUrl:self.movieURLs];
    [self addSubview:self.switchMovieView];
    [self addSubview:self.selectImageView];
    [self addSubview:self.movieDetailView];
    [self addSubview:self.moviePointLabel];
    [self addSubview:self.movieNameLabel];
    [self addSubview:self.movieLengthLabel];
}

- (void)setMovieList:(NSArray *)movieList {
    _movieList = movieList;
}

- (void)switchMovieDidSelectIndex:(NSInteger)index {
    Movie *movie = _movieList[index];
    NSString *pointString = [NSString stringWithFormat:@"%.1f分", [movie.score floatValue]];
    self.moviePointLabel.text = pointString;
    self.movieNameLabel.text = movie.movieName;
    self.detailMovieId = movie.movieId;
    NSInteger movieLength = 90;
    if (movie.movieLength) {
        movieLength = [movie.movieLength intValue];
    }
    self.movieLengthLabel.text = [NSString stringWithFormat:@"片长: %ld分钟", (long) movieLength];

    //计算电影名称和电影分数的标签尺寸
    CGSize pointSize = [KKZUtility customTextSize:self.moviePointLabel.font
                                             text:self.moviePointLabel.text
                                             size:CGSizeMake(moviePointMaxWidth,
                                                             self.moviePointLabel.frame.size.height)];
    CGFloat movieNameMaxWidth = CGRectGetWidth(self.frame) - movieNameLeft - pointSize.width - moviePointLeft - moviePointRight;
    CGSize movieNameSize = [KKZUtility customTextSize:self.movieNameLabel.font
                                                 text:self.movieNameLabel.text
                                                 size:CGSizeMake(CGFLOAT_MAX, self.movieNameLabel.frame.size.height)];

    //如果电影名字长度超过需要显示的最大长度
    if (movieNameSize.width > movieNameMaxWidth) {
        movieNameSize.width = movieNameMaxWidth;
    }

    //设置电影名称和电影分数的标签尺寸
    CGRect movieFrame = self.movieNameLabel.frame;
    movieFrame.size.width = movieNameSize.width;
    movieFrame.origin.x = (CGRectGetWidth(self.frame) - movieNameSize.width - moviePointLeft - pointSize.width) / 2.0f;
    self.movieNameLabel.frame = movieFrame;

    CGRect pointFrame = self.moviePointLabel.frame;
    pointFrame.size.width = pointSize.width;
    pointFrame.origin.x = CGRectGetMaxX(movieFrame) + moviePointLeft;
    self.moviePointLabel.frame = pointFrame;

    DLog(@"self.isMoviedetailCanbeclicked = YES");

    self.isMoviedetailCanbeclicked = YES;

    //执行代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchMovieDidSelectIndex:)]) {
        [self.delegate switchMovieDidSelectIndex:index];
    }
}

- (NSMutableArray *)movieURLs {
    if (!_movieURLs) {
        _movieURLs = [[NSMutableArray alloc] init];
    }
    return _movieURLs;
}

- (UIImageView *)selectImageView {
    if (!_selectImageView) {
        UIImage *selectImg = [UIImage imageNamed:@"cinema_Movie_select"];
        _selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - selectImg.size.width) * 0.5, switchMovieHeight - selectImg.size.height, selectImg.size.width, selectImg.size.height)];
        _selectImageView.image = selectImg;
    }
    return _selectImageView;
}

- (SwitchMovieView *)switchMovieView {
    if (!_switchMovieView) {
        _switchMovieView = [[SwitchMovieView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, switchMovieHeight)];
        _switchMovieView.currentMovieSize = CGSizeMake(77, 108);
        _switchMovieView.normalMovieSize = CGSizeMake(64, 88);
        _switchMovieView.backgroundColor = [UIColor clearColor];
        _switchMovieView.delegate = self;
        _switchMovieView.currentIndex = 0;
    }
    return _switchMovieView;
}

- (UILabel *)movieNameLabel {
    if (!_movieNameLabel) {
        _movieNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, movieNameTop + CGRectGetMaxY(self.switchMovieView.frame), 0, movieNameHeight)];
        _movieNameLabel.font = [UIFont systemFontOfSize:movieNameFont];
        _movieNameLabel.textColor = [UIColor blackColor];
        _movieNameLabel.backgroundColor = [UIColor clearColor];
        _movieNameLabel.userInteractionEnabled = NO;
    }
    return _movieNameLabel;
}

- (UILabel *)moviePointLabel {
    if (!_moviePointLabel) {
        _moviePointLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, moviePointTop + CGRectGetMaxY(self.switchMovieView.frame), 0, moviePointHeight)];
        _moviePointLabel.font = [UIFont systemFontOfSize:moviePointTop];
        _moviePointLabel.textColor = appDelegate.kkzPink;//[UIColor colorWithHex:@"#ff6900"];
        _moviePointLabel.userInteractionEnabled = NO;
    }
    return _moviePointLabel;
}

- (UILabel *)movieLengthLabel {
    if (!_movieLengthLabel) {
        _movieLengthLabel = [[UILabel alloc] initWithFrame:CGRectMake(movieLengthLeft, CGRectGetMaxY(self.movieNameLabel.frame) + movieLengthTop, CGRectGetWidth(self.frame) - movieLengthLeft * 2, movieLengthHeight)];
        _movieLengthLabel.font = [UIFont systemFontOfSize:movieLengthFont];
        _movieLengthLabel.textColor = [UIColor colorWithHex:@"#666666"];
        _movieLengthLabel.textAlignment = NSTextAlignmentCenter;
        _movieLengthLabel.userInteractionEnabled = NO;
    }
    return _movieLengthLabel;
}

- (UIButton *)movieDetailView {
    if (!_movieDetailView) {
        _movieDetailView = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.switchMovieView.frame), screentWith, movieDetailVHeight)];
        [_movieDetailView setBackgroundColor:[UIColor clearColor]];
        [_movieDetailView addTarget:self action:@selector(movieDetailBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _movieDetailView;
}

- (void)movieDetailBtnClicked {
    if (self.isMoviedetailCanbeclicked) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isMoviedetailCanbeclickedPush" object:nil];
        DLog(@"movieDetailBtnClickedY");

        MovieDetailViewController *mvc = [[MovieDetailViewController alloc] initCinemaListForMovie:self.detailMovieId];
        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:mvc animation:CommonSwitchAnimationBounce];
    } else {
        DLog(@"movieDetailBtnClickedN");
    }
}

- (BOOL) shouldShowOfferIconAtIndex:(NSInteger)index
{
    if (index >= self.movieList.count) {
        return NO;
    }
    
    Movie *mo = self.movieList[index];
    return  mo.hasPromotion;
}

@end
