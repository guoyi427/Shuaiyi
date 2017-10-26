//
//  RecordCommentView.h
//
//  Created by su xinde on 13-3-13.
//  Copyright (c) 2013年 su xinde. All rights reserved.
//

#import "RecordAudio.h"
#import "RoundCornersButton.h"

@class RecordCommentView;

@protocol RecordCommentViewDelegate <NSObject>

- (void)uploadSoundComment;

@end

@interface RecordCommentView : UIView <RecordAudioDelegate, UIGestureRecognizerDelegate>
{
    UILabel     *_titleView;
    UIControl   *_overlayView;
    UIImageView *audioBarImage;
    UIImageView *trumpetImage; //喇叭
    UILabel *soundLengthLabel;
    CGRect soundBarRect; //声音条
    RecordAudio *recordAudio;
}

@property (nonatomic, weak) id<RecordCommentViewDelegate>   delegate;
@property (nonatomic, assign) PopViewAnimation   popViewAnimation;
@property (nonatomic, assign) BOOL   isQoute;
@property (nonatomic, assign) int   shuoLength;
@property (nonatomic, assign) BOOL   isPlaying;

- (void)setTitle:(NSString *)title;

- (void)show;
- (void)dismiss;

- (void)updateWithType:(BOOL)qoute andLength:(float)length;
@end
