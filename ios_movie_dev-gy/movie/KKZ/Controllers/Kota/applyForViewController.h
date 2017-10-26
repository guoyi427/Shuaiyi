//
//  约电影 - 详情 - 申请约电影
//
//  Created by avatar on 14-11-19.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"

#import "FavRecordView.h"
#import "MicView.h"
#import "RatingView.h"
#import "RecordAudio.h"
#import "RoundCornersButton.h"

@class KotaMovieImageView;

@interface applyForViewController : CommonViewController <UIScrollViewDelegate, RatingViewDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate, UITextViewDelegate, FavRecordViewDelegate> {

    UIImageView *soundBarBg, *textImageView;
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

    UIButton *cancelBtn;
    UIImageView *avatarView, *headImgV;
    UILabel *lblShareNickname, *lblFilmName, *lblCinemaName, *lblFilmTime, *lblScreenDegree, *lblScreenSize, *lblLang;
    UIView *imgVKotaSucceed;
}

@property (nonatomic, assign) unsigned int movieId;
@property (nonatomic, assign) unsigned int cinemaId;
@property (nonatomic, assign) unsigned int commentId;
@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, assign) BOOL MovieComment;

@property (nonatomic, copy) NSString *shareHeadimg;
@property (nonatomic, copy) NSString *cinemaName;
@property (nonatomic, copy) NSString *cinemaNameType;

@property (nonatomic, copy) NSString *filmName;
@property (nonatomic, copy) NSString *shareNickname;
@property (nonatomic, copy) NSString *lang;
@property (nonatomic, copy) NSString *langType;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, copy) NSString *createTimeType;

@property (nonatomic, strong) NSNumber *screenDegree;
@property (nonatomic, strong) NSNumber *screenSize;
@property (nonatomic, strong) NSNumber *kotaId;

@property (nonatomic, copy) NSString *screenDegreeType;
@property (nonatomic, copy) NSString *screenSizeType;

@end
