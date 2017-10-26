//
//  发起约电影页面
//
//  Created by avatar on 14-11-19.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"

#import "RatingView.h"

#import "Movie.h"

#import "RecordAudio.h"

#import "MicView.h"

#import "FavRecordView.h"

@class KotaMovieImageView;

@interface InitiateAppointmentByMovieController : CommonViewController <UIScrollViewDelegate, RatingViewDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate, UITextViewDelegate, FavRecordViewDelegate> {

    UIImageView *headview, *soundBarBg, *textImageView;
    UIScrollView *holder;
    KotaMovieImageView *movieImagesView;

    UIButton *audioButton, *keyBoardButton;
    UIView *recordView;

    UITextView *statusTextView, *statusViewPlaceHolder;

    UIButton *confirmBtn;

    CGFloat recordLength;

    BOOL isText;

    UILabel *_titleView;

    RatingView *starView;

    UIButton *addVoiceCommentBtn;

    UIView *uploadView;

    CGRect weixinFRect, weixinRect, sinaWeiboRect, qqWeiboRect, renrenRect, qZoneRect;

    AVAudioRecorder *recorder;

    NSTimer *_timer;

    MicView *shuoTipView;

    UILabel *durationLabel, *scoreLabel, *numLabel;

    int shuoAttitude;

    float score;

    UIControl *shuoHolder;

    FavRecordView *poplistview;

    BOOL hasVoice;

    UIView *imgVKotaSucceed;
    UIButton *cancelBtn, *kotahelp;
}

@property (nonatomic, copy) NSNumber *movieId;
@property (nonatomic, assign) unsigned int cinemaId;
@property (nonatomic, assign) unsigned int commentId;
@property (nonatomic, strong) Movie *movie;

@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, assign) BOOL MovieComment;
@property (nonatomic, assign) BOOL wantSee;

@end
