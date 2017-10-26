//
//  FavRecordView.h
//
//  Created by su xinde on 13-3-13.
//  Copyright (c) 2013年 su xinde. All rights reserved.
// 单个语音条

#import "RecordAudio.h"

@class FavRecordView;

@protocol FavRecordViewDelegate <NSObject>

- (void)delSoundComment;

@end

@interface FavRecordView : UIView <RecordAudioDelegate, UIGestureRecognizerDelegate>
{
    UILabel     *_titleView;
    UIImageView *soundBarImage, *voiceImage;
    UILabel *soundLengthLabel;
    CGRect soundBarRect;
    RecordAudio *recordAudio;
    
    UIImageView * deleteImage;
}

@property (nonatomic, weak) id<FavRecordViewDelegate>   delegate;
@property (nonatomic, assign) PopViewAnimation   popViewAnimation;
@property (nonatomic, assign) int   shuoType;
@property (nonatomic, assign) int   shuoLength;
@property (nonatomic, assign) BOOL   isPlaying;

- (void)setTitle:(NSString *)title;

- (void)show;
- (void)dismiss;

- (void)updateWithType:(int)type andLength:(float)length;
-(void)playSound;
-(void)recordAudioDidFinishPlaying;
@end
