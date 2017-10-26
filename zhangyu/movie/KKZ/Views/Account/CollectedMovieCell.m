//
//  MatchCell.m
//  Aimeili
//
//  Created by zhang da on 12-8-15.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "CollectedMovieCell.h"

#import "AudioBarView.h"
#import "AudioPlayerManager.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "FavoriteTask.h"
#import "KKZUtility.h"
#import "MovieDetailViewController.h"
#import "MovieFavView.h"
#import "MovieTask.h"
#import "RIButtonItem.h"
#import "RatingView.h"
#import "RoundCornersButton.h"
#import "TaskQueue.h"
#import "TaskTypeUtils.h"
#import "UIAlertView+Blocks.h"
#import "UIColorExtra.h"
#import "UIView+FlipTransition.h"

#define kMargin 8

@interface MyFavUnit : UIView <RatingViewDelegate> {
    UIImageView *firstView;
    UIImageView *secondView;

    UIImageView *imageView;

    RoundCornersButton *removeBtn;
    RoundCornersButton *lookBtn;
    RoundCornersButton *secondBtn;
}

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) Favorite *favorite;

@property (nonatomic, copy) NSNumber *movieId;
@property (nonatomic, assign) int index;

@property (nonatomic, strong) NSString *movieName;
@property (nonatomic, strong) NSString *imgUrl;

@property (nonatomic, strong) UIImageView *firstView;
@property (nonatomic, strong) UIImageView *secondView;

@property (nonatomic, assign) float score;
@property (nonatomic, strong) NSString *commentType;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, assign) BOOL hasFliped;
@property (nonatomic, assign) BOOL isCollect; //是否看过（收藏），还是想看

@end

@implementation MyFavUnit

@synthesize firstView = _firstView;
@synthesize secondView = _secondView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.opaque = YES;
        self.backgroundColor = [UIColor clearColor];

        _firstView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   frame.size.width,
                                                                   frame.size.height)];

        [self addSubview:_firstView];

        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  frame.size.width,
                                                                  frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [_firstView addSubview:imageView];

        //second View
        _secondView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                    0,
                                                                    frame.size.width,
                                                                    frame.size.height)];
        _secondView.image = [UIImage imageNamed:@"fav_post_bg"];
        _secondView.userInteractionEnabled = YES;
        [self addSubview:_secondView];

        removeBtn = [[RoundCornersButton alloc] initWithFrame:CGRectMake((frame.size.width - 80) * 0.5, 35, 80, 32)];
        removeBtn.titleColor = [UIColor r:230 g:86 b:78];
        removeBtn.titleName = @"移除影片";
        removeBtn.cornerNum = 4;
        removeBtn.backgroundColor = [UIColor clearColor];
        removeBtn.rimColor = [UIColor r:230 g:86 b:78];
        removeBtn.rimWidth = 1;
        removeBtn.titleFont = [UIFont systemFontOfSize:12];
        [removeBtn addTarget:self action:@selector(removeMovie) forControlEvents:UIControlEventTouchUpInside];
        [_secondView addSubview:removeBtn];

        lookBtn = [[RoundCornersButton alloc] initWithFrame:CGRectMake((frame.size.width - 80) * 0.5, 35, 80, 32)];
        lookBtn.titleColor = [UIColor r:0 g:0 b:255];
        lookBtn.titleName = @"我也看过";
        lookBtn.cornerNum = 4;
        lookBtn.backgroundColor = [UIColor clearColor];
        lookBtn.rimColor = [UIColor r:0 g:0 b:255];
        lookBtn.rimWidth = 1;
        lookBtn.titleFont = [UIFont systemFontOfSize:12];
        [lookBtn addTarget:self action:@selector(wantLookOrCollect:) forControlEvents:UIControlEventTouchUpInside];
        [_secondView addSubview:lookBtn];

        secondBtn = [[RoundCornersButton alloc] initWithFrame:CGRectMake((frame.size.width - 80) * 0.5, 75, 80, 32)];
        secondBtn.titleColor = [UIColor r:112 g:112 b:112];
        secondBtn.titleName = @"查看详情";
        secondBtn.cornerNum = 4;
        secondBtn.backgroundColor = [UIColor clearColor];
        secondBtn.rimColor = [UIColor r:155 g:155 b:155];
        secondBtn.rimWidth = 1;
        secondBtn.titleFont = [UIFont systemFontOfSize:12];
        [secondBtn addTarget:self action:@selector(movieDetail) forControlEvents:UIControlEventTouchUpInside];

        //        if ([[DataEngine sharedDataEngine].userId isEqualToString:self.userId]) {
        [_secondView addSubview:secondBtn];
        //        }
        _secondView.hidden = YES;
    }
    return self;
}

- (void)updateLayout {

    if (self.isFirst) {
        //点击添加自己看过的影片
        if (self.isCollect) {
            lookBtn.titleName = @"我也看过";
            firstView.image = [UIImage imageNamed:@"fav_addnew_bg"];
            imageView.image = [UIImage imageNamed:@"fav_addnew_bg"];
        } else {
            lookBtn.titleName = @"我也想看";
            firstView.image = [UIImage imageNamed:@"want_addnew_bg"];
            imageView.image = [UIImage imageNamed:@"want_addnew_bg"];
        }

    } else {

        if (self.hasFliped) {
            self.hasFliped = NO;
            [UIView flipTransitionFromView:_firstView
                                    toView:_secondView
                                  duration:0.6f
                                completion:^(BOOL finished){
                                }];
        }

        if (self.isCollect) {
            lookBtn.titleName = @"我也看过";
        } else {
            lookBtn.titleName = @"我也想看";
        }

        if ([[DataEngine sharedDataEngine].userId isEqualToString:self.userId]) {
            removeBtn.hidden = NO;
            secondBtn.hidden = NO;
            lookBtn.hidden = YES;
        } else {

            removeBtn.hidden = YES;

            if (self.isCollect) {

                lookBtn.hidden = YES;
                secondBtn.hidden = YES;
            }

            if ([self.favorite.isMyFav intValue] == 1) {

                lookBtn.enabled = NO;
                lookBtn.titleColor = appDelegate.kkzGray;
                lookBtn.rimColor = appDelegate.kkzGray;

            } else {
                lookBtn.enabled = YES;
                lookBtn.titleColor = [UIColor r:0 g:0 b:255];
                lookBtn.rimColor = [UIColor r:0 g:0 b:255];
            }
        }

        [imageView loadImageWithURL:self.imgUrl andSize:ImageSizeSmall];

        DLog(@"self.imgUrl%@", self.imgUrl);
    }
}

- (void)ratingChanged:(CGFloat)newRating {
}

- (void)showScoreTextView {
}

- (void)removeMovie {
    RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
    cancel.action = ^{

    };

    RIButtonItem *done = [RIButtonItem itemWithLabel:@"确定"];
    done.action = ^{
        FavoriteTask *task;
        if (self.isCollect) {
            task = [[FavoriteTask alloc] initDelFavMovie:self.movieId.intValue
                                                finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                    [self removeMovieFavFinished:userInfo status:succeeded];
                                                }];
        } else {
            task = [[FavoriteTask alloc] initDelWantLookWithMovieId:self.movieId.intValue
                                                           finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                               [self removeMovieFavFinished:userInfo status:succeeded];
                                                           }];
        }

        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {

            [appDelegate showIndicatorWithTitle:@"正在操作..."
                                       animated:NO
                                     fullScreen:NO
                                   overKeyboard:YES
                                    andAutoHide:YES];
        }
    };

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"确定要移除该影片吗？"
                                           cancelButtonItem:cancel
                                           otherButtonItems:done, nil];
    [alert show];

    DLog(@"removieMovie");
}

- (void)removeMovieFavFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    DLog(@"removeMovieFav finished");

    if (succeeded) {

        [appDelegate showIndicatorWithTitle:@"您已成功移除该影片"
                                   animated:NO
                                 fullScreen:NO
                               overKeyboard:YES
                                andAutoHide:YES];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"Notification_remove_movie" object:self.movieId];
    }
}

- (void)wantLookOrCollect:(id)sender {
    if (self.isCollect) {
        [self markAndCollect:sender];
    } else {
        [self wantWatch:sender];
    }
}

- (void)markAndCollect:(id)sender {
    DLog(@"点击我已看过"); //评分
    BOOL isIphone5 = (fabs((double) [UIScreen mainScreen].bounds.size.height - 568.0) < DBL_EPSILON);
    CGFloat yOffset = 70;
    if (isIphone5) {
        yOffset = 120;
    }
    CGFloat xWidth = 270;
    CGFloat yHeight = 230;

    MovieFavView *poplistview = [[MovieFavView alloc] initWithFrame:CGRectMake((screentWith - xWidth) / 2.0, yOffset, xWidth, yHeight)];
    poplistview.movieId = self.movieId;
    poplistview.popViewAnimation = PopViewAnimationBounce;
    [poplistview showAndcompletion:^(BOOL finished, NSDictionary *dict) {
        if (finished) {

            self.favorite.isMyFav = @1;
            lookBtn.enabled = NO;
            lookBtn.titleColor = appDelegate.kkzGray;
            lookBtn.rimColor = appDelegate.kkzGray;
            //不再刷新列表了
        }
    }];
}

//点击想看
- (void)wantWatch:(id)sender {
    FavoriteTask *task = [[FavoriteTask alloc] initClickWantWatchWithMovieId:self.movieId.intValue
                                                                    finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                        if (succeeded) {
                                                                            //[appDelegate hideIndicator];
                                                                            [appDelegate showIndicatorWithTitle:@"收藏影片成功！"
                                                                                                       animated:NO
                                                                                                     fullScreen:NO
                                                                                                   overKeyboard:YES
                                                                                                    andAutoHide:YES];

                                                                            self.favorite.isMyFav = @1;
                                                                            lookBtn.enabled = NO;
                                                                            lookBtn.titleColor = appDelegate.kkzGray;
                                                                            lookBtn.rimColor = appDelegate.kkzGray;

                                                                        } else {

                                                                            NSDictionary *LogicErrorDict = userInfo[@"LogicError"];

                                                                            NSString *LogicErrorMess = LogicErrorDict[@"error"];

                                                                            if (LogicErrorMess && LogicErrorMess.length) {
                                                                                [appDelegate showIndicatorWithTitle:LogicErrorMess
                                                                                                           animated:NO
                                                                                                         fullScreen:NO
                                                                                                       overKeyboard:YES
                                                                                                        andAutoHide:YES];
                                                                            }
                                                                        }
                                                                    }];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
}

- (void)movieDetail {
    DLog(@"movieDetail");

    MovieDetailViewController *mdv = [[MovieDetailViewController alloc] initCinemaListForMovie:self.movieId];
    
    CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
    [parentCtr pushViewController:mdv animation:CommonSwitchAnimationBounce];
}

@end

/////////////////////////////////////////////

@implementation CollectedMovieCell

@synthesize delegate;

@synthesize row;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.opaque = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];

        CGFloat marginTop = 7;
        CGFloat marginX = (screentWith - 320) / 3;

        lUnit = [[MyFavUnit alloc] initWithFrame:CGRectMake(7, marginTop, 98 + marginX, 145 + 152 * (screentWith / 320 - 1))];
        [self addSubview:lUnit];

        mUnit = [[MyFavUnit alloc] initWithFrame:CGRectMake(111 + marginX, marginTop, 98 + marginX, 145 + 152 * (screentWith / 320 - 1))];
        [self addSubview:mUnit];

        rUnit = [[MyFavUnit alloc] initWithFrame:CGRectMake(215 + marginX * 2, marginTop, 98 + marginX, 145 + 152 * (screentWith / 320 - 1))];
        [self addSubview:rUnit];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)updateLayout {
    lUnit.isCollect = self.isCollect;
    mUnit.isCollect = self.isCollect;
    rUnit.isCollect = self.isCollect;
    lUnit.movieName = self.lMovieName;
    mUnit.movieName = self.mMovieName;
    rUnit.movieName = self.rMovieName;

    if (!self.lMovieId) {
        lUnit.hidden = NO;
        lUnit.isFirst = YES;

        [lUnit updateLayout];
    } else {
        lUnit.userId = self.userId;
        lUnit.favorite = self.lFavorite;
        lUnit.hidden = NO;
        lUnit.movieId = self.lMovieId;
        lUnit.imgUrl = self.lImgUrl;

        lUnit.isFirst = NO;

        [lUnit updateLayout];
    }

    if (self.mMovieId) {
        mUnit.userId = self.userId;
        mUnit.favorite = self.mFavorite;
        mUnit.hidden = NO;
        mUnit.movieId = self.mMovieId;
        mUnit.imgUrl = self.mImgUrl;

        [mUnit updateLayout];

    } else {
        mUnit.hidden = YES;
    }

    if (self.rMovieId) {
        rUnit.userId = self.userId;
        rUnit.favorite = self.rFavorite;
        rUnit.hidden = NO;
        rUnit.movieId = self.rMovieId;
        rUnit.imgUrl = self.rImgUrl;

        [rUnit updateLayout];

    } else {
        rUnit.hidden = YES;
    }
}

- (void)addNewMovie {
    DLog(@"addNewMovie");
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {

    CGPoint point = [recognizer locationInView:self];

    if (CGRectContainsPoint(CGRectMake(CGRectGetMinX(lUnit.frame), CGRectGetMinY(lUnit.frame), CGRectGetWidth(lUnit.frame), 150), point)) {
        if (!self.lMovieId) {
            [self addNewMovie];
        } else {
            if (self.lMovieId && delegate && [delegate respondsToSelector:@selector(matchCell:touchedAtIndex:)]) {
                lUnit.hasFliped = !lUnit.hasFliped;

                [UIView flipTransitionFromView:lUnit.firstView
                                        toView:lUnit.secondView
                                      duration:0.6f
                                    completion:^(BOOL finished){

                                    }];

                [delegate matchCell:self touchedAtIndex:3 * row + 0];
            }
        }
    } else if (CGRectContainsPoint(CGRectMake(CGRectGetMinX(mUnit.frame), CGRectGetMinY(mUnit.frame), CGRectGetWidth(mUnit.frame), 150), point)) {
        if (self.mMovieId && delegate && [delegate respondsToSelector:@selector(matchCell:touchedAtIndex:)]) {
            mUnit.hasFliped = !mUnit.hasFliped;

            [UIView flipTransitionFromView:mUnit.firstView
                                    toView:mUnit.secondView
                                  duration:0.6f
                                completion:^(BOOL finished){

                                }];

            [delegate matchCell:self touchedAtIndex:3 * row + 1];
        }
    } else if (CGRectContainsPoint(CGRectMake(CGRectGetMinX(rUnit.frame), CGRectGetMinY(rUnit.frame), CGRectGetWidth(rUnit.frame), 150), point)) {
        if (self.rMovieId && delegate && [delegate respondsToSelector:@selector(matchCell:touchedAtIndex:)]) {
            rUnit.hasFliped = !rUnit.hasFliped;

            [UIView flipTransitionFromView:rUnit.firstView
                                    toView:rUnit.secondView
                                  duration:0.6f
                                completion:^(BOOL finished){

                                }];

            [delegate matchCell:self touchedAtIndex:3 * row + 2];
        }
    }
}

- (void)flipLUint {
    if (lUnit.hasFliped) {
        lUnit.hasFliped = NO;
        [UIView flipTransitionFromView:lUnit.firstView
                                toView:lUnit.secondView
                              duration:0.6f
                            completion:^(BOOL finished){
                            }];
    }
}

- (void)flipMUint {
    if (mUnit.hasFliped) {
        mUnit.hasFliped = NO;
        [UIView flipTransitionFromView:mUnit.firstView
                                toView:mUnit.secondView
                              duration:0.6f
                            completion:^(BOOL finished){
                            }];
    }
}

- (void)flipRUint {
    if (rUnit.hasFliped) {
        rUnit.hasFliped = NO;
        [UIView flipTransitionFromView:rUnit.firstView
                                toView:rUnit.secondView
                              duration:0.6f
                            completion:^(BOOL finished){
                            }];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

@end
