//
//  MovieFavView.h
//
//  Created by su xinde on 13-3-13.
//  Copyright (c) 2013年 su xinde. All rights reserved.
// 收藏，评分。

#import "RatingView.h"
#import "RecordAudio.h"
#import "MicView.h"
#import "FavRecordView.h"

@class MovieFavView;



@interface MovieFavView : UIView <RatingViewDelegate,FavRecordViewDelegate, UIGestureRecognizerDelegate,UITextViewDelegate>
{
    UILabel     *_titleView;
    UIControl   *_overlayView;
    RatingView *starView;
    UIButton *addVoiceCommentBtn;
    UIView *recordView;
    UIView *uploadView;
    CGRect weixinFRect, weixinRect, sinaWeiboRect, qqWeiboRect, renrenRect, qZoneRect;
    
    AVAudioRecorder *recorder;
    NSTimer *_timer;
    MicView *shuoTipView;
    UILabel *durationLabel;
    int recordLength;
    int shuoAttitude;
    float score;
    UIControl *shuoHolder;
    FavRecordView *poplistview;
    BOOL hasVoice;
    
    UIButton *cancelBtn,*confirmBtn;
    UIButton *keyBoardButton;
    UIButton *audioButton;

    UIImageView *soundBarBg;
    UIImageView *textImageView;
    UITextView *textView;
    UIView *showBg;
}


//@property (nonatomic, assign) id<UIPopoverListViewDataSource> datasource;
//@property (nonatomic, assign) id<UIPopoverListViewDelegate>   delegate;
@property (nonatomic, weak) id   delegate;

@property (nonatomic, copy) NSNumber *movieId;
@property (nonatomic, assign) PopViewAnimation   popViewAnimation;
@property (nonatomic, copy) void (^collectFinished)(BOOL finished, NSDictionary *dict);


//@property (nonatomic, retain) UITableView *listView;

- (void)setTitle:(NSString *)title;

- (void)showAndcompletion:(void (^)(BOOL finished,NSDictionary *dict))completion;
- (void)dismiss;

@end
