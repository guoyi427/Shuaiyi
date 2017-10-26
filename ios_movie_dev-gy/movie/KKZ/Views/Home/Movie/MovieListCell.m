//
//  首页 - 电影列表的Cell
//
//  Created by KKZ on 16/4/13.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MovieListCell.h"

#import "AlertViewY.h"
#import "Banner.h"
#import "KKZUtility.h"
#import "Movie.h"
#import "MovieCellLayout.h"
#import "MovieDetailViewController.h"
#import "MovieListActivityView.h"
#import "UIColorExtra.h"
#import "UIConstants.h"
#import "UrlOpenUtility.h"
#import "WebViewController.h"

#define kBlueColor HEX(@"#008CFF") // 蓝色按钮的颜色
#define kTextColor HEX(@"#666666") // 文字的颜色

static const CGFloat kMarginX = 12;

@interface MovieListCell ()

/**
 *  电影海报
 */
@property (nonatomic, strong) UIImageView *moviePostImgV;

/**
 *  播放预告片的按钮
 */
@property (nonatomic, strong) UIImageView *moviePlayImgV;

/**
 *  电影名称
 */
@property (nonatomic, strong) UILabel *movieNameLbl;

/**
 *  电影描述
 */
@property (nonatomic, strong) UILabel *movieDescribeLbl;

/**
 *  电影详情
 */
@property (nonatomic, strong) UILabel *movieDetailInfoLbl;

/**
 *  购票、预售、简介 按钮
 */
@property (nonatomic, strong) UIButton *buyTicketBtn;

/**
 *  得分、多少人想看num
 */
@property (nonatomic, strong) UILabel *movieScoreNumLbl;

/**
 *  分、人想看lbl
 */
@property (nonatomic, strong) UILabel *movieScoreTextLbl;

/**
 *  cell分割线
 */
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, copy) void (^btnClickBlock)();

@end

@implementation MovieListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        //加载海报信息
        [self addSubview:self.moviePostImgV];

        //加载电影名称
        [self addSubview:self.movieNameLbl];

        //加载电影描述
        [self addSubview:self.movieDescribeLbl];

        //加载电影详细信息
        [self addSubview:self.movieDetailInfoLbl];

        //加载购票按钮
        [self addSubview:self.buyTicketBtn];

        //加载评分信息
        [self addSubview:self.movieScoreNumLbl];
        [self addSubview:self.movieScoreTextLbl];

        //加载底部分割线
        [self addSubview:self.bottomLine];

        //添加手势
        [self addGestureRecognizer];
    }
    return self;
}

/**
 *  加载影片信息
 */
- (void)updateMovieCell {

    Movie *movie = self.movieCellLayout.movie;

    //加载海报信息
    self.moviePostImgV.frame = self.movieCellLayout.moviePostFrame;

    //加载影片播放按钮的信息
    self.moviePlayImgV.frame = self.movieCellLayout.moviePlayFrame;

    if (self.movieCellLayout.movie.movieTrailer.length) {
        [self.moviePostImgV addSubview:self.moviePlayImgV];
        self.moviePlayImgV.hidden = NO;
        self.moviePostImgV.userInteractionEnabled = YES;

        DLog(@"self.movieCellLayout.movie.movieTrailer !!!!!!!!!!!!!! %@", self.movieCellLayout.movie.movieTrailer);
    } else {
        self.moviePostImgV.userInteractionEnabled = NO;
        self.moviePlayImgV.hidden = YES;
        [self.moviePlayImgV removeFromSuperview];
    }

    NSString *postPath;
    if (movie.thumbPath.length) {
        postPath = movie.thumbPath;
    } else {
        postPath = movie.pathVerticalS;
    }
    [self.moviePostImgV loadImageWithURL:postPath andSize:ImageSizeOrign imgNameDefault:@"post_black_shadow"];

    //加载电影标签
    [self loadFlagsY];

    //加载影片标题
    self.movieNameLbl.frame = self.movieCellLayout.movieNameFrame;
    self.movieNameLbl.font = [UIFont systemFontOfSize:self.movieCellLayout.movieNameFont];
    self.movieNameLbl.text = movie.movieName;

    //加载人为添加的标签
    [self loadFlags];

    //加载影片描述信息
    self.movieDescribeLbl.frame = self.movieCellLayout.movieDescribeFrame;
    self.movieDescribeLbl.font = [UIFont systemFontOfSize:self.movieCellLayout.movieDescribeFont];
    self.movieDescribeLbl.text = movie.title;

    //加载影片详细信息
    self.movieDetailInfoLbl.frame = self.movieCellLayout.movieDetailInfoFrame;
    self.movieDetailInfoLbl.font = [UIFont systemFontOfSize:self.movieCellLayout.movieDetailInfoFont];
    self.movieDetailInfoLbl.text = self.movieCellLayout.movieDetailInfo;

    //加载购票按钮
    self.buyTicketBtn.frame = self.movieCellLayout.buyBtnFrame;
    if ([self.movieCellLayout.buyBtnTitle isEqualToString:@"购票"]) {
        [self.buyTicketBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
        self.buyTicketBtn.layer.borderColor = kBlueColor.CGColor;
    } else if ([self.movieCellLayout.buyBtnTitle isEqualToString:@"预售"]) {
        [self.buyTicketBtn setTitleColor:kOrangeColor forState:UIControlStateNormal];
        self.buyTicketBtn.layer.borderColor = kOrangeColor.CGColor;
    } else if ([self.movieCellLayout.buyBtnTitle isEqualToString:@"介绍"]) {
        [self.buyTicketBtn setTitleColor:kBlueColor forState:UIControlStateNormal];
        self.buyTicketBtn.layer.borderColor = kBlueColor.CGColor;
    }
    [self.buyTicketBtn setTitle:self.movieCellLayout.buyBtnTitle forState:UIControlStateNormal];

    //加载评分信息
    self.movieScoreNumLbl.frame = self.movieCellLayout.movieScoreNumFrame;
    self.movieScoreNumLbl.text = self.movieCellLayout.movieScoreNum;
    self.movieScoreNumLbl.font = [UIFont systemFontOfSize:self.movieCellLayout.movieScoreNumFont];

    self.movieScoreTextLbl.frame = self.movieCellLayout.movieScoreTextFrame;
    self.movieScoreTextLbl.text = self.movieCellLayout.movieScoreText;
    self.movieScoreTextLbl.font = [UIFont systemFontOfSize:self.movieCellLayout.movieScoreTextFont];

    //加载活动信息
    [self addActivityViews];

    //加载底部分割线
    self.bottomLine.frame = CGRectMake(kMarginX, self.movieCellLayout.height - 0.5, screentWith, 0.5);
}

/**
 *  加载活动信息
 */
- (void)addActivityViews {
    //先移除view
    [self removeActivityViews];

    //再加载view
    for (int i = 0; i < self.movieCellLayout.movieActivityFrameArr.count; i++) {

        CGRect r = CGRectFromString(self.movieCellLayout.movieActivityFrameArr[i]);
        MovieListActivityView *btn = [[MovieListActivityView alloc] initWithFrame:r];
        btn.banner = self.movieCellLayout.movie.banners[i];
        btn.tag = 3000 + i;
        [btn addTarget:self action:@selector(movieListActivityViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}

/**
 *  点击活动标签跳转到活动详情
 */
- (void)movieListActivityViewClicked:(MovieListActivityView *)btn {
    if (![[NetworkUtil me] reachable]) {
        return;
    }

    Banner *managedObject = self.movieCellLayout.movie.banners[btn.tag - 3000];

    NSString *urlStr = [managedObject.targetUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    if (![UrlOpenUtility handleOpenAppUrl:[NSURL URLWithString:urlStr]]) {
        WebViewController *ctr = [[WebViewController alloc] initWithTitle:managedObject.title];
        [ctr loadURL:managedObject.targetUrl];
        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
    }
}

/**
 *  移除活动的View
 */
- (void)removeActivityViews {
    if (([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)) {
        for (UIView *view in [self subviews]) {
            for (UIView *viewSub in [view subviews]) {
                if ([viewSub isKindOfClass:[MovieListActivityView class]]) {
                    [viewSub removeFromSuperview];
                }
            }
        }
    } else {
        for (UIView *viewSub in [self subviews]) {
            if ([viewSub isKindOfClass:[MovieListActivityView class]]) {
                [viewSub removeFromSuperview];
            }
        }
    }
}

/**
 *  加载人为添加的标签
 */
- (void)loadFlags {
    //先移除标签
    [self removeFlags];

    //再添加新的标签
    for (int i = 0; i < self.movieCellLayout.movieFlagFrameArr.count; i++) {
        CGRect r = CGRectFromString(self.movieCellLayout.movieFlagFrameArr[i]);
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:r];
        imgV.tag = MovieListFlagType;
        NSString *imgStr = self.movieCellLayout.movieFlagImageArr[i];
        if ([imgStr isEqualToString:@"shortTitle"]) {
            UILabel *shortTitleLbl = [[UILabel alloc] initWithFrame:r];
            shortTitleLbl.tag = MovieListShortTitleType;
            shortTitleLbl.font = [UIFont systemFontOfSize:self.movieCellLayout.shortTitleFont];
            shortTitleLbl.text = self.movieCellLayout.movie.shortTitle;
            shortTitleLbl.textColor = [UIColor whiteColor];
            shortTitleLbl.layer.borderColor = [UIColor r:255 g:81 b:81].CGColor;
            shortTitleLbl.layer.backgroundColor = [UIColor r:255 g:81 b:81].CGColor;
            shortTitleLbl.layer.borderWidth = 1;
            shortTitleLbl.layer.cornerRadius = 5.0f / 3.0f;
            shortTitleLbl.textAlignment = NSTextAlignmentCenter;
            shortTitleLbl.clipsToBounds = YES;
            shortTitleLbl.userInteractionEnabled = NO;
            [self addSubview:shortTitleLbl];
        } else {
            imgV.image = [UIImage imageNamed:imgStr];
            [self addSubview:imgV];
        }
    }
}

/**
 *  移除人为添加的标签
 */
- (void)removeFlags {
    if (([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)) {
        for (UIView *view in [self subviews]) {
            for (UIView *viewSub in [view subviews]) {
                if (viewSub.tag == MovieListFlagType || viewSub.tag == MovieListShortTitleType) {
                    //                if ([viewSub isKindOfClass:[MovieListFlagView class]] || [viewSub isKindOfClass:[MovieListShortTitleView class]]) {
                    [viewSub removeFromSuperview];

                    DLog(@"[imgV removeFromSuperview];");
                }
            }
        }
    } else {
        for (UIView *viewSub in [self subviews]) {
            if (viewSub.tag == MovieListFlagType || viewSub.tag == MovieListShortTitleType) {
                //            if ([viewSub isKindOfClass:[MovieListFlagView class]] || [viewSub isKindOfClass:[MovieListShortTitleView class]]) {
                [viewSub removeFromSuperview];
            }
        }
    }
}

/**
 *  加载标签
 */
- (void)loadFlagsY {
    //先移除标签
    [self removeFlagsY];

    //再添加新的标签
    for (int i = 0; i < self.movieCellLayout.movieFlagFrameArrY.count; i++) {
        CGRect r = CGRectFromString(self.movieCellLayout.movieFlagFrameArrY[i]);
        UILabel *shortTitleLbl = [[UILabel alloc] initWithFrame:r];
        shortTitleLbl.tag = MoviePosterFlagType;
        shortTitleLbl.font = [UIFont systemFontOfSize:self.movieCellLayout.movieFlagFontY];
        shortTitleLbl.text = self.movieCellLayout.movieFlagImageArrY[i];
        shortTitleLbl.textColor = [UIColor whiteColor];
        shortTitleLbl.layer.backgroundColor = appDelegate.kkzBlue.CGColor;
        shortTitleLbl.textAlignment = NSTextAlignmentCenter;
        [self.moviePostImgV addSubview:shortTitleLbl];
    }
}

/**
 *  移除标签
 */
- (void)removeFlagsY {
    if (([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)) {
        for (UIView *view in [self.moviePostImgV subviews]) {
            if (view.tag == MoviePosterFlagType) {
                //            if ([view isKindOfClass:[MovieListFlagViewY class]]) {
                [view removeFromSuperview];

                DLog(@"[imgV removeFromSuperview];");
            } else {
                for (UIView *viewSub in [view subviews]) {
                    if (viewSub.tag == MoviePosterFlagType) {
                        //                    if ([viewSub isKindOfClass:[MovieListFlagViewY class]]) {
                        [viewSub removeFromSuperview];
                        DLog(@"[imgV removeFromSuperview];");
                    }
                }
            }
        }
    } else {
        for (UIView *viewSub in [self.moviePostImgV subviews]) {
            if (viewSub.tag == MoviePosterFlagType) {
                //            if ([viewSub isKindOfClass:[MovieListFlagViewY class]]) {
                [viewSub removeFromSuperview];
            }
        }
    }
}

/**
 *  电影海报
 */
- (UIImageView *)moviePostImgV {
    if (!_moviePostImgV) {
        _moviePostImgV = [[UIImageView alloc] init];
        _moviePostImgV.contentMode = UIViewContentModeScaleAspectFill;
        _moviePostImgV.clipsToBounds = YES;
        _moviePostImgV.userInteractionEnabled = YES;
        //加载电影播放按钮
        [self.moviePostImgV addSubview:self.moviePlayImgV];
    }
    return _moviePostImgV;
}

/**
 *  电影名称
 */
- (UILabel *)movieNameLbl {
    if (!_movieNameLbl) {
        _movieNameLbl = [[UILabel alloc] init];
        _movieNameLbl.textColor = [UIColor blackColor];
    }
    return _movieNameLbl;
}

/**
 *  电影描述信息
 */
- (UILabel *)movieDescribeLbl {
    if (!_movieDescribeLbl) {
        _movieDescribeLbl = [[UILabel alloc] init];
        _movieDescribeLbl.textColor = kTextColor;
    }
    return _movieDescribeLbl;
}

/**
 *  电影详情
 */
- (UILabel *)movieDetailInfoLbl {
    if (!_movieDetailInfoLbl) {
        _movieDetailInfoLbl = [[UILabel alloc] init];
        _movieDetailInfoLbl.textColor = kTextColor;
    }
    return _movieDetailInfoLbl;
}

/**
 *  购片按钮
 */
- (UIButton *)buyTicketBtn {
    if (!_buyTicketBtn) {
        _buyTicketBtn = [[UIButton alloc] init];
        [_buyTicketBtn setBackgroundColor:[UIColor clearColor]];
        _buyTicketBtn.layer.borderWidth = 2.0f / appDelegate.kkzScale;
        _buyTicketBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _buyTicketBtn.layer.cornerRadius = 8.0f / 3.0f;
        [_buyTicketBtn addTarget:self action:@selector(buyTicketBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyTicketBtn;
}

- (void)buyTicketBtnClicked {
    
    if (!isConnected) {
#define kLastShowAlertTime @"lastShowAlertTime"
        NSDate *lastShow = [[NSUserDefaults standardUserDefaults] objectForKey:kLastShowAlertTime];
        if (!lastShow || [lastShow timeIntervalSinceNow] < -2) {
            [UIAlertView showAlertView:@"网络好像有点问题, 稍后再试吧" buttonText:@"确定" buttonTapped:nil];

            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastShowAlertTime];
        }
        return;
    }

    if (self.movieCellLayout.isIncoming) {
        //统计事件：查看即将上映影片详情
        StatisEvent(EVENT_MOVIE_INCOMING_DETAIL);
    } else {
        //统计事件：【购票】电影入口-进入影片页
        StatisEvent(EVENT_BUY_MOVIE_DETAIL_SHOWING_SOURCE_MOVIE);
    }
    
    if (self.btnClickBlock) {
        self.btnClickBlock();
    }
    
}

/**
 *  加载评分
 */
- (UILabel *)movieScoreNumLbl {
    if (!_movieScoreNumLbl) {
        _movieScoreNumLbl = [[UILabel alloc] init];
        _movieScoreNumLbl.textColor = kOrangeColor;
    }
    return _movieScoreNumLbl;
}

/**
 *  加载分、人想看
 */
- (UILabel *)movieScoreTextLbl {
    if (!_movieScoreTextLbl) {
        _movieScoreTextLbl = [[UILabel alloc] init];
        _movieScoreTextLbl.textColor = kOrangeColor;
    }
    return _movieScoreTextLbl;
}

/**
 *  加载底部分割线
 */
- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        [_bottomLine setBackgroundColor:kUIColorDivider];
    }
    return _bottomLine;
}

/**
 *  播放预告片的Icon
 */
- (UIImageView *)moviePlayImgV {
    if (!_moviePlayImgV) {
        _moviePlayImgV = [[UIImageView alloc] init];
        _moviePlayImgV.image = [UIImage imageNamed:@"moviePlayIcon"];
        _moviePlayImgV.userInteractionEnabled = NO;
        _moviePlayImgV.hidden = YES;
    }
    return _moviePlayImgV;
}

- (void)addGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.moviePostImgV addGestureRecognizer:tap];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    [self touchAtPoint:point];
}

#pragma mark touch view delegate
- (void)touchAtPoint:(CGPoint)point {
    DLog(@"跳转到预告片");

    if (self.movieCellLayout.movie.thumbPath.length) {
        if ([self.delegate respondsToSelector:@selector(startShowMovieTrailer:andMovieName:)]) {
            [self.delegate startShowMovieTrailer:self.movieCellLayout.movie.trailer.trailerPath andMovieName:self.movieCellLayout.movie.movieName];
        }

        DLog(@"movie.movieTrailer ========== %@", self.movieCellLayout.movie.thumbPath);
    }
}

- (void) rightButtonClickCallback:( void (^)())a_block
{
    self.btnClickBlock = [a_block copy];
}

@end
