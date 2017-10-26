//
//  CommentFavViewController.h
//  KoMovie
//
//  Created by gree2 on 15/11/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import "CommonViewController.h"
#import "RatingView.h"
#import "RecordAudio.h"
#import "MicView.h"
#import "FavRecordView.h"

@interface CommentFavViewController : CommonViewController <RatingViewDelegate, FavRecordViewDelegate, UIGestureRecognizerDelegate, UITextViewDelegate> {
    UIScrollView *holder;
    float starH;
    UILabel *_titleView;
    RatingView *starView;
    UIButton *addVoiceCommentBtn;

    UIView *recordView;
    UIView *uploadView;
    CGRect weixinFRect, weixinRect, sinaWeiboRect, qqWeiboRect, renrenRect, qZoneRect;

    AVAudioRecorder *recorder;
    NSTimer *_timer;
    MicView *shuoTipView;
    UILabel *durationLabel, *scoreLabel, *numLabel;
    int recordLength;
    int shuoAttitude;
    float score;
    UIControl *shuoHolder;
    FavRecordView *poplistview;
    BOOL hasVoice;

    UIButton *cancelBtn, *confirmBtn;
    UIButton *keyBoardButton;
    UIButton *audioButton;

    UIImageView *soundBarBg;
    UIImageView *textImageView;
    UITextView *statusTextView;
    UITextView *statusViewPlaceHolder;
    BOOL isText;
}

@property (nonatomic, assign) NSUInteger targetId;
@property (nonatomic, assign) unsigned int commentId;

@property (nonatomic, assign) BOOL showStar;
@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, assign) BOOL MovieComment;
@property (nonatomic, assign) BOOL hasMovieScoreInfo;

/**
 *  订单ID
 */
@property (nonatomic, strong) NSString *orderId;

@property (nonatomic, copy) NSString *buttonTitle;
@property (nonatomic, copy) NSString *titleName;

@property (nonatomic, copy) void (^collectFinished)(BOOL finished, NSDictionary *dict);

@end
