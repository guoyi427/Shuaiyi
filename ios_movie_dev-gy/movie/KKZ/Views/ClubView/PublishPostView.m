//
//  PublishPostView.m
//  KoMovie
//
//  Created by KKZ on 16/2/16.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CommonViewController.h"
#import "KKZUtility.h"
#import "MovieCommentViewController.h"
#import "PublishPostView.h"
#import "MovieCommentData.h"
#import "UIColorExtra.h"
#define oprationBtnWidth 92
#define oprationBtnHeight 82
#define imgToTitle 10
#define titleFont 14

#define btnToBtn 60
#define marginYTop (screentHeight - oprationBtnHeight * 2 - btnToBtn * 2) * 0.5

@implementation PublishPostView
@synthesize effe;
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //添加模糊效果
        if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)) {
            [self addEffe];
        } else {
            effe = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentHeight)];
            [effe setBackgroundColor:[UIColor r:255 g:255 b:255 alpha:0.95]];
            [self addSubview:effe];
        }

        //设置半透明的背景色
        //        [self setBackgroundColor:[UIColor r:255 g:255 b:255 alpha:0.6]];
        //添加视频、语音、文字的功能按钮
        [self addOprationBtn];
        //添加手势
        [self addTapGesture];
    }
    return self;
}

- (void)addEffe {
    // 定义毛玻璃效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    effe = [[UIVisualEffectView alloc] initWithEffect:blur];
    effe.frame = CGRectMake(0, 0, screentWith, screentHeight);
    [self addSubview:effe];
    //    他的效果是枚举，有三种
    //    UIBlurEffectStyleExtraLight
    //    UIBlurEffectStyleLight
    //    UIBlurEffectStyleDark

    // 把要添加的视图加到毛玻璃上
}

/**
 *  添加视频、语音、文字的功能按钮
 */
- (void)addOprationBtn {
    for (int i = 0; i < 2; i++) {
        [self addOprationBtnWithIndex:i];
    }
}

- (void)setClick_block:(PublishPostView_CAll_BACK)click_block {
    _click_block = click_block;
}

/**
 *  添加按钮
 */
- (void)addOprationBtnWithIndex:(NSInteger)index {
    UIButton *oprationBtn = [[UIButton alloc] initWithFrame:CGRectMake((screentWith - oprationBtnWidth) * 0.5, marginYTop + index * (oprationBtnHeight + btnToBtn), oprationBtnWidth, oprationBtnHeight)];
    [effe addSubview:oprationBtn];
    oprationBtn.tag = index + 300;
    [oprationBtn addTarget:self action:@selector(oprationBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    //添加图标
    UIImageView *oprationImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, oprationBtnWidth, oprationBtnHeight)];
    oprationImg.clipsToBounds = YES;
    oprationImg.userInteractionEnabled = NO;
    [oprationBtn addSubview:oprationImg];

    //添加标题
    UILabel *oprationLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(oprationImg.frame) + imgToTitle, oprationBtnWidth, titleFont)];
    oprationLbl.font = [UIFont systemFontOfSize:titleFont];
    oprationLbl.textColor = [UIColor blackColor];
    [oprationBtn addSubview:oprationLbl];
    oprationLbl.textAlignment = NSTextAlignmentCenter;

    switch (index) {
        case 0:
            oprationLbl.text = @"语音";
            [oprationImg setImage:[UIImage imageNamed:@"sns_publish_audio"]];
            break;
        case 1:
            oprationLbl.text = @"图文";
            [oprationImg setImage:[UIImage imageNamed:@"sns_publish_picture"]];
            break;

        default:
            break;
    }
}

- (void)oprationBtnClicked:(UIButton *)btn {

    MovieCommentViewController *ctr = [[MovieCommentViewController alloc] init];
    CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
    if (btn.tag - 300 == 0) {
        ctr.type = chooseTypeAudio;
        [KKZAnalytics postActionWithEvent:nil action:AnalyticsActionComment_voice];
    } else if (btn.tag - 300 == 1) {
        ctr.type = chooseTypeImageAndWord;
        [KKZAnalytics postActionWithEvent:nil action:AnalyticsActionComment_text];
    }
    ctr.viewType = movieCommentViewType;
    [parentCtr pushViewController:ctr
                        animation:CommonSwitchAnimationSwipeR2L];
    [self removeFromSuperview];
}

- (void)setMovieId:(unsigned int)movieId {
    _movieId = movieId;
    [[MovieCommentData sharedInstance] setMovieId:[NSString stringWithFormat:@"%u", _movieId]];
}

- (void)setOrderId:(NSString *)orderId {
    _orderId = orderId;
    [[MovieCommentData sharedInstance] setOrderId:_orderId];
}

- (void)setNavId:(NSInteger)navId {
    _navId = navId;
    [[MovieCommentData sharedInstance] setNavId:_navId];
}

- (void)setMovieName:(NSString *)movieName {
    _movieName = movieName;
    [MovieCommentData sharedInstance].movieName = movieName;
}

- (void)setCinemaName:(NSString *)cinemaName {
    _cinemaName = cinemaName;
    [MovieCommentData sharedInstance].cinemaName = cinemaName;
}

- (void)setCinemaId:(NSString *)cinemaId {
    _cinemaId = cinemaId;
    [MovieCommentData sharedInstance].cinemaId = cinemaId;
}

/**
 * 添加手势
 */
- (void)addTapGesture {

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    [self removeFromSuperview];
    //    if (self.delegate && [self.delegate respondsToSelector:@selector(removePresentEffe)]) {
    //        [self.delegate removePresentEffe];
    //    }
}

/**
 *  监听手势
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

@end
