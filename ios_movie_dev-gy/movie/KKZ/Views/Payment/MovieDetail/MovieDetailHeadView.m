//
//  电影详情页面的HeaderView
//
//  Created by KKZ on 16/2/19.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "DataEngine.h"
#import "DateEngine.h"
#import "ImageEngineNew.h"
#import "KKZUtility.h"
#import "KKZUtility.h"
#import "Movie.h"
#import "MovieDetailHeadView.h"
#import "MovieTrailer.h"
#import "PublishPostView.h"

#define marginX 15
#define marginY 15

#define postImageViewWidth 100
#define postImageViewHeight 135

#define marginTitleToTop 12
#define marginImgToTitle 15
#define marginTitleToStar 15
#define marginSubTitle 10

#define starHeight 14

#define marginStarToScore 10
#define scoreFont 14

#define subTitleFont 13

#define marginPostImageViewToBtn 15

#define marginBtnWidth (screentWith - marginX * 3) * 0.5
#define marginBtnHeight 35

#define movieTitleFont 16

#define headHeight 215

@interface MovieDetailHeadView()
{
    
}
@property (nonatomic, copy) void (^wantToWatchBlock)();
@end

@implementation MovieDetailHeadView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        [self setBackgroundColor:[UIColor clearColor]];
        self.clipsToBounds = true;
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 150-64, kAppScreenWidth, 100)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];
        
        self.postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, 32, postImageViewWidth, postImageViewHeight)];
        self.postImageView.backgroundColor = [UIColor clearColor];
        self.postImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.postImageView.clipsToBounds = YES;
        self.postImageView.image = nil;
        self.postImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.postImageView.layer.borderWidth = 1;
        [self addSubview:self.postImageView];

        movieTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.postImageView.frame) + marginImgToTitle, CGRectGetMinY(self.postImageView.frame) + marginY, screentWith - (CGRectGetMaxX(self.postImageView.frame) + marginImgToTitle), movieTitleFont)];
        movieTitleLabel.font = [UIFont systemFontOfSize:movieTitleFont];
        movieTitleLabel.textColor = [UIColor blackColor];
        movieTitleLabel.backgroundColor = [UIColor clearColor];
        movieTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:movieTitleLabel];
        
        threeDImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(movieTitleLabel.frame), marginTitleToTop, screentWith - CGRectGetMaxX(movieTitleLabel.frame) - marginX, movieTitleFont)];
        threeDImg.userInteractionEnabled = YES;
        threeDImg.image = [UIImage imageNamed:@"3D_screentype_logo"];
        threeDImg.hidden = YES;
        [self addSubview:threeDImg];

        imaxImg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(movieTitleLabel.frame), marginTitleToTop, screentWith - CGRectGetMaxX(movieTitleLabel.frame) - marginX, movieTitleFont)];
        imaxImg.userInteractionEnabled = YES;
        imaxImg.image = [UIImage imageNamed:@"imax_screenType_logo"];
        imaxImg.hidden = YES;
        [self addSubview:imaxImg];
        
        //评分星星
        /*
        starView = [[RatingView alloc] initWithFrame:CGRectMake(CGRectGetMinX(movieTitleLabel.frame), CGRectGetMaxY(movieTitleLabel.frame) + marginTitleToTop, 83, starHeight)];
        [starView setImagesDeselected:@"fav_star_no_yellow_match"
                       partlySelected:@"fav_star_half_yellow"
                         fullSelected:@"fav_star_full_yellow"
                             iconSize:CGSizeMake(starHeight, starHeight)
                          andDelegate:self];
        starView.userInteractionEnabled = NO;
        [starView displayRating:0];
        [self addSubview:starView];
         */
        /*
        totleScoreLalel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(starView.frame) + marginStarToScore, CGRectGetMinY(starView.frame), 80, scoreFont)];
        totleScoreLalel.font = [UIFont systemFontOfSize:scoreFont];
        totleScoreLalel.textAlignment = NSTextAlignmentLeft;
        totleScoreLalel.backgroundColor = [UIColor clearColor];
        totleScoreLalel.textColor = appDelegate.kkzYellow;
        totleScoreLalel.text = @"0";
        [self addSubview:totleScoreLalel];
         */
        //  类型
        movieType = [[UILabel alloc] init];
        movieType.font = [UIFont systemFontOfSize:subTitleFont];
        movieType.textAlignment = NSTextAlignmentLeft;
        movieType.backgroundColor = [UIColor clearColor];
        movieType.textColor = [UIColor grayColor];
        movieType.text = @"";
        [movieType setBackgroundColor:[UIColor clearColor]];
        [whiteView addSubview:movieType];
        [movieType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(movieTitleLabel);
            make.top.mas_equalTo(12);
        }];
        
        //  语种 和 时长
        movieDetailInfo = [[UILabel alloc] init];
        movieDetailInfo.font = [UIFont systemFontOfSize:subTitleFont];
        movieDetailInfo.textAlignment = NSTextAlignmentLeft;
        movieDetailInfo.backgroundColor = [UIColor clearColor];
        movieDetailInfo.textColor = [UIColor grayColor];
        movieDetailInfo.text = @"";
        [movieDetailInfo setBackgroundColor:[UIColor clearColor]];
        [whiteView addSubview:movieDetailInfo];
        [movieDetailInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(movieType.mas_right).offset(30);
            make.centerY.equalTo(movieType);
        }];

        //  上映时间
        moviePlayerTime = [[UILabel alloc] init];
        moviePlayerTime.font = [UIFont systemFontOfSize:subTitleFont];
        moviePlayerTime.textAlignment = NSTextAlignmentLeft;
        moviePlayerTime.backgroundColor = [UIColor clearColor];
        moviePlayerTime.textColor = [UIColor blackColor];
        moviePlayerTime.text = @"";
        [whiteView addSubview:moviePlayerTime];
        [moviePlayerTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(movieTitleLabel);
            make.top.equalTo(movieDetailInfo.mas_bottom).offset(5);
        }];

        //添加评论想看按钮
//        [self addCommentAndwantSeeView];
    }
    return self;
}

/**
 *  添加评论想看功能
 */
- (void)addCommentAndwantSeeView {
    CGFloat bottomY = 0;

    if (runningOniOS7) {
        bottomY = 0;
    } else {
        bottomY = 20;
    }

    wantSeeBtn = [[UIButton alloc] initWithFrame:CGRectMake(marginX, CGRectGetMaxY(self.postImageView.frame) + marginPostImageViewToBtn, marginBtnWidth, marginBtnHeight)];
    [wantSeeBtn setTitle:@"想看" forState:UIControlStateNormal];
    wantSeeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [wantSeeBtn setImage:[UIImage imageNamed:@"movie_detail_want"] forState:UIControlStateNormal];
    [wantSeeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
    [wantSeeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    wantSeeBtn.layer.borderWidth = 0.8;
    wantSeeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    wantSeeBtn.layer.cornerRadius = 3;
    wantSeeBtn.clipsToBounds = YES;
    [wantSeeBtn setBackgroundColor:[UIColor clearColor]];
    [wantSeeBtn addTarget:self action:@selector(wantseeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:wantSeeBtn];

    commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(wantSeeBtn.frame) + marginX, CGRectGetMaxY(self.postImageView.frame) + marginPostImageViewToBtn, marginBtnWidth, marginBtnHeight)];
    [commentBtn setImage:[UIImage imageNamed:@"movie_detail_comment"] forState:UIControlStateNormal];
    [commentBtn setImage:[UIImage imageNamed:@"movie_detail_comment"] forState:UIControlStateSelected];
    [commentBtn setImage:[UIImage imageNamed:@"movie_detail_comment"] forState:UIControlStateHighlighted];
    [commentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
    [commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commentBtn setTitle:@"吐槽" forState:UIControlStateNormal];
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    commentBtn.layer.borderWidth = 0.8;
    commentBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    commentBtn.layer.cornerRadius = 3;
    commentBtn.clipsToBounds = YES;
    [commentBtn setBackgroundColor:[UIColor clearColor]];
    [commentBtn addTarget:self action:@selector(commentBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:commentBtn];
}

/**
 *  加载数据
 */
- (void)upLoadData {

    //刷新是否想看
    [self loadIsWantWatch];

    [starView displayRating:[self.movie.score floatValue] * 0.5];

    if (self.movie.thumbPath.length) {
        [self.postImageView loadImageWithURL:self.movie.thumbPath andSize:ImageSizeSmall imgNameDefault:@"post_black_shadow"];
    } else {
        [self.postImageView loadImageWithURL:self.movie.pathVerticalS andSize:ImageSizeSmall imgNameDefault:@"post_black_shadow"];
    }

    totleScoreLalel.text = self.movie.score;

    if (self.movie.country.length) {
        movieDetailInfo.text = [NSString stringWithFormat:@"%@/%@", self.movie.country, [self.movie getMovieLength]];

    } else {
        movieDetailInfo.text = [NSString stringWithFormat:@"%@", [self.movie getMovieLength]];
    }

    movieType.text = self.movie.movieType;

    if (self.movie.publishTime) {
        moviePlayerTime.text = [NSString stringWithFormat:@"%@上映", [[DateEngine sharedDateEngine] stringFromDate:self.movie.publishTime withFormat:@"YYYY年MM月dd日"]];
    } else {
        moviePlayerTime.text = @"";
    }

    BOOL movieIs3D = self.movie.has3D;
    BOOL movieIsIMAX = self.movie.hasImax;

    CGRect f = movieTitleLabel.frame;

    NSMutableDictionary *movieNameAttrM = [NSMutableDictionary dictionaryWithCapacity:0];
    [movieNameAttrM setObject:[UIFont systemFontOfSize:16] forKey:NSFontAttributeName];
    CGFloat xW = [self.movie.movieName sizeWithAttributes:movieNameAttrM].width;

    if (movieIs3D) {
        f.size.width = xW < (screentWith - (CGRectGetMaxX(self.postImageView.frame) + marginImgToTitle) - 40) ? xW : (screentWith - (CGRectGetMaxX(self.postImageView.frame) + marginImgToTitle) - 40);
    } else if (movieIsIMAX) {
        f.size.width = xW < (screentWith - (CGRectGetMaxX(self.postImageView.frame) + marginImgToTitle) - 55) ? xW : (screentWith - (CGRectGetMaxX(self.postImageView.frame) + marginImgToTitle) - 55);
    } else {
        f.size.width = (screentWith - (CGRectGetMaxX(self.postImageView.frame) + marginImgToTitle) - marginX);
    }

    movieTitleLabel.frame = f;

    movieTitleLabel.text = self.movie.movieName;

    CGFloat iconX = CGRectGetMaxX(movieTitleLabel.frame) + 5;

    if (movieIsIMAX) {

        threeDImg.hidden = YES;

        if (movieIsIMAX) {
            imaxImg.hidden = NO;
            imaxImg.frame = CGRectMake(iconX, marginTitleToTop, 30, 15);
        } else {
            imaxImg.hidden = YES;
        }

    } else {
        imaxImg.hidden = YES;

        if (movieIs3D) {
            threeDImg.hidden = NO;
            threeDImg.frame = CGRectMake(iconX, marginTitleToTop, 15, 15);
        } else {
            threeDImg.hidden = YES;
        }
    }
}

/**
 *  想看按钮被点击
 */
- (void)wantseeBtnClicked {

    CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];

    if (self.isOperationing) {
        return;
    }
    if (!appDelegate.isAuthorized) {
        self.isMovieDetial = YES;
        [[DataEngine sharedDataEngine]
                startLoginFinished:^(BOOL succeeded) {

                    if (succeeded) {
                        self.isOperationing = YES;
                        if (self.isMovieWantSee) { //目前是想看的状态
                            [self undoWantSeeMovie];
                        } else { //目前是不想看的状态
                            [self doWantSeeMovie];
                        }
                    }
                }
                    withController:parentCtr];
    } else {
        self.isOperationing = YES;
        if (self.isMovieWantSee) {
            [self undoWantSeeMovie];
        } else {
            [self doWantSeeMovie];
        }
    }
}

#pragma mark -用户增加对电影的关注 网络请求
- (void)doWantSeeMovie {
    WeakSelf
            FavoriteRequest *favoriteRequest = [[FavoriteRequest alloc] init];
    [favoriteRequest requestDoWantSeeMovieWithMovieId:self.movie.movieId.integerValue
            success:^(BOOL isSuccess) {
                [appDelegate hideIndicator];
                weakSelf.isOperationing = NO;

                weakSelf.isMovieWantSee = YES;

                //统计事件：电影详情想看
                StatisEvent(EVENT_MOVIE_WANT_SEE);

                [appDelegate showIndicatorWithTitle:@"操作成功"
                                           animated:NO
                                         fullScreen:NO
                                       overKeyboard:YES
                                        andAutoHide:YES];

                [wantSeeBtn setTitle:@"已关注" forState:UIControlStateNormal];
                [wantSeeBtn setImage:[UIImage imageNamed:@"movie_detail_wanted"] forState:UIControlStateNormal];
                
                if (self.wantToWatchBlock) {
                    self.wantToWatchBlock();
                }
                
            }
            failure:^(NSError *_Nullable err) {
                [appDelegate hideIndicator];
                weakSelf.isOperationing = NO;

                weakSelf.isMovieWantSee = NO;
                [appDelegate showIndicatorWithTitle:@"操作失败请重试"
                                           animated:NO
                                         fullScreen:NO
                                       overKeyboard:YES
                                        andAutoHide:YES];
            }];
}

#pragma mark -用户取消对电影的关注 网络请求
- (void)undoWantSeeMovie {
    WeakSelf
            FavoriteRequest *favoriteRequest = [[FavoriteRequest alloc] init];
    [favoriteRequest requestUndoWantSeeMovieWithMovieId:self.movie.movieId.integerValue
            success:^(BOOL isSuccess) {
                weakSelf.isOperationing = NO;
                self.isMovieWantSee = NO;

                [wantSeeBtn setTitle:@"想看" forState:UIControlStateNormal];
                [wantSeeBtn setImage:[UIImage imageNamed:@"movie_detail_want"] forState:UIControlStateNormal];
                [appDelegate showIndicatorWithTitle:@"取消成功"
                                           animated:NO
                                         fullScreen:NO
                                       overKeyboard:YES
                                        andAutoHide:YES];

            }
            failure:^(NSError *_Nullable err) {
                weakSelf.isOperationing = NO;
                weakSelf.isMovieWantSee = YES;

                [wantSeeBtn setTitle:@"已关注" forState:UIControlStateNormal];
                [wantSeeBtn setImage:[UIImage imageNamed:@"movie_detail_wanted"] forState:UIControlStateNormal];
                [appDelegate showIndicatorWithTitle:@"取消失败"
                                           animated:NO
                                         fullScreen:NO
                                       overKeyboard:YES
                                        andAutoHide:YES];
            }];
}

/**
 *  评论按钮被点击
 */
- (void)commentBtnClicked {
    if (!appDelegate.isAuthorized) {

        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [[DataEngine sharedDataEngine] startLoginFinished:nil withController:parentCtr];

    } else {

        PublishPostView *publishPostV = [[PublishPostView alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentHeight)];
        publishPostV.movieId = self.movie.movieId.unsignedIntValue;
        publishPostV.movieName = self.movie.movieName;
        UIWindow *keywindow = [[[UIApplication sharedApplication] delegate] window];

        [keywindow addSubview:publishPostV];
    }
}

//播放预告片
- (void)playerTrailer {
    if (!isConnected) {
#define kLastShowAlertTime @"lastShowAlertTime"
        NSDate *lastShow = [[NSUserDefaults standardUserDefaults] objectForKey:kLastShowAlertTime];
        if (!lastShow || [lastShow timeIntervalSinceNow] < -2) {
            [UIAlertView showAlertView:@"网络好像有点问题, 稍后再试吧" buttonText:@"确定" buttonTapped:nil];

            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kLastShowAlertTime];
        }
        return;
    }

    //统计事件：电影详情点预告片
    StatisEvent(EVENT_MOVIE_PLAY_TRAILER);

    if (self.movieTrailer.trailerPath.length != 0 && ![self.movieTrailer.trailerPath isEqualToString:@"(null)"]) {
        [self startShowMovieTrailer:self.movieTrailer.trailerPath];
    } else {
        [self showMovieTrailerError];
    }
}

- (void)startShowMovieTrailer:(NSString *)url {
    movieVC = [[MoviePlayerViewController alloc] initNetworkMoviePlayerViewControllerWithURL:[NSURL URLWithString:url] movieTitle:self.movieTitle];
    movieVC.delegate = self;

    [movieVC playerViewDelegateSetStatusBarHiden:NO];

    UIScreen *scr = [UIScreen mainScreen];
    movieVC.view.frame = CGRectMake(0, 0, screentHeight, scr.bounds.size.width);

    CGAffineTransform landscapeTransform;
    landscapeTransform = CGAffineTransformMakeRotation(90 * M_PI / 180);
    CGFloat landscapeTransformX = 0;
    if (screentHeight == 480) {
        landscapeTransformX = 80;
    } else if (screentHeight == 667) {
        landscapeTransformX = 146;
    } else if (screentHeight == 568) {
        landscapeTransformX = 124;
    } else if (screentHeight == 736) {
        landscapeTransformX = 161;
    }
    landscapeTransform = CGAffineTransformTranslate(landscapeTransform, landscapeTransformX, landscapeTransformX);
    [movieVC.view setTransform:landscapeTransform];
    [appDelegate.window addSubview:movieVC.view];
}

- (void)movieFinished:(CGFloat)progress {
    [movieVC.view removeFromSuperview];
}

- (void)showMovieTrailerError {
    [UIAlertView showAlertView:@"小编还没有找到预告片，请过段时间再来~" buttonText:@"确定" buttonTapped:nil];

    //    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"小编还没有找到预告片，请过段时间再来~" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
    //    [alertView show];
}

#pragma mark-- RatingViewDelegate
- (void)ratingChanged:(CGFloat)newRating {
}

//加载用户是否想看数据
- (void)loadIsWantWatch {
    WeakSelf
            FavoriteRequest *favoriteRequest = [[FavoriteRequest alloc] init];
    [favoriteRequest requestQueryWantWatchWithMovieId:self.movie.movieId.integerValue
            success:^(BOOL iswantWatch) {
                [appDelegate hideIndicator];
                if (!iswantWatch) {
                    weakSelf.isMovieWantSee = NO;
                    [wantSeeBtn setTitle:@"想看" forState:UIControlStateNormal];
                    [wantSeeBtn setImage:[UIImage imageNamed:@"movie_detail_want"] forState:UIControlStateNormal];
                } else {
                    weakSelf.isMovieWantSee = YES;
                    [wantSeeBtn setTitle:@"已关注" forState:UIControlStateNormal];
                    [wantSeeBtn setImage:[UIImage imageNamed:@"movie_detail_wanted"] forState:UIControlStateNormal];
                }
            }
            failure:^(NSError *_Nullable err) {
                [appDelegate hideIndicator];
            }];
}

- (void) wantToWatch:(void(^)())a_block
{
    self.wantToWatchBlock = a_block;
}

@end
