//
//  RecordCommentView.m
//
//  Created by su xinde on 13-3-13.
//  Copyright (c) 2013年 su xinde. All rights reserved.
//

#import "RecordCommentView.h"
#import <QuartzCore/QuartzCore.h>
#import "ShareView.h"
#import "UIConstants.h"

//#define FRAME_X_INSET 20.0f
//#define FRAME_Y_INSET 40.0f
#define CHeight 50

@interface RecordCommentView ()

- (void)defalutInit;
- (void)fadeIn;
- (void)fadeOut;

@end

@implementation RecordCommentView

- (void)dealloc
{
    DLog(@"RecordCommentView dealloc");
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defalutInit];
    }
    return self;
}

- (void)defalutInit
{

    self.clipsToBounds = TRUE;
    self.popViewAnimation = PopViewAnimationBounce;
    
    recordAudio = [[RecordAudio alloc] init];
    recordAudio.delegate = self;

    UIImageView *showBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 52)];
    showBg.userInteractionEnabled = YES;
    [self addSubview:showBg];
   
    CGFloat marginY = (screentWith - 320) * 0.5;
    
    RoundCornersButton *cancelBtn = [[RoundCornersButton alloc] initWithFrame:CGRectMake(marginY + 10, 7, 50, 38)];
    cancelBtn.rimWidth = 1;
    cancelBtn.rimColor = [UIColor r:200 g:200 b:200];
    cancelBtn.cornerNum = kDimensCornerNum;
    cancelBtn.fillColor = [UIColor whiteColor];
    cancelBtn.titleName = @"取消";
    cancelBtn.titleColor = [UIColor r:150 g:150 b:150];
    cancelBtn.titleFont = [UIFont systemFontOfSize:kTextSizeButton];
    [cancelBtn addTarget:self action:@selector(cancelShare) forControlEvents:UIControlEventTouchUpInside];
    [showBg addSubview:cancelBtn];
    
    RoundCornersButton *confirmBtn = [[RoundCornersButton alloc] initWithFrame:CGRectMake(marginY + 260, 7, 50, 38)];
    confirmBtn.rimWidth = 1;
    confirmBtn.rimColor = [UIColor r:200 g:200 b:200];
    confirmBtn.cornerNum = kDimensCornerNum;
    confirmBtn.fillColor = [UIColor whiteColor];
    confirmBtn.titleName = @"发送";
    confirmBtn.titleColor = [UIColor r:62 g:62 b:62];
    confirmBtn.titleFont = [UIFont systemFontOfSize:kTextSizeButton];
    [confirmBtn addTarget:self action:@selector(confirmShare) forControlEvents:UIControlEventTouchUpInside];
    [showBg addSubview:confirmBtn];
    
    
    // 语音条
    audioBarImage = [[UIImageView alloc] init];
    [self addSubview:audioBarImage];
    
    // 喇叭
    trumpetImage = [[UIImageView alloc] init];
    [self addSubview:trumpetImage];
    
    
    soundLengthLabel = [[UILabel alloc] init];
    soundLengthLabel.textColor = [UIColor blackColor];
    soundLengthLabel.backgroundColor = [UIColor clearColor];
    soundLengthLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:soundLengthLabel];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}

- (void)updateWithType:(BOOL)qoute andLength:(float)length {
    self.isQoute = qoute;
    
    CGFloat marginY = (screentWith - 320) * 0.5;
    audioBarImage.image = [UIImage imageNamed:@"mic_audio_bar"];
    soundBarRect = CGRectMake(marginY + 105, 7, 110, 38);
    audioBarImage.frame = soundBarRect;
    
    trumpetImage.image = [UIImage imageNamed:@"mic_wifi_4"];
    trumpetImage.frame = CGRectMake(marginY + 116.5, 7 + 12, 14, 14);
    
    
    soundLengthLabel.textAlignment = NSTextAlignmentLeft;
    soundLengthLabel.frame = CGRectMake(marginY + 90 + 100 - 24 + 10, 7 + 12, 60, 14);
    soundLengthLabel.text = [NSString stringWithFormat:@"%d\"",(int)length];
    soundLengthLabel.font = [UIFont systemFontOfSize:kTextSizeContent];
}


- (void)touchAtPoint:(CGPoint)point {
    if( CGRectContainsPoint(soundBarRect, point) ) {
        [self playSound];
		return;
	}
	if( CGRectContainsPoint(self.bounds, point) ) {
		return;
	}
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    [self touchAtPoint:point];
}

- (void)playSound {
    if (self.isPlaying) {
        [self soundStopAinimation];
    }else {
        NSString *mp3FileName = @"Mp3File";
        mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
        NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
        
        NSData *data = [NSData dataWithContentsOfFile:mp3FilePath];
        
        [recordAudio startPlayAMR:data];

        [self soundPlayAinimation];
    }
}

- (void)cancelShare {
    DLog(@"cancelShare");
    [self dismiss];
}

- (void)confirmShare {
    DLog(@"confirmShare");
    if (self.delegate && [self.delegate respondsToSelector:@selector(uploadSoundComment)]) {
        [self.delegate uploadSoundComment];
    }
}


- (void)soundStopAinimation {
    self.isPlaying = NO;
    [trumpetImage stopAnimating];
    trumpetImage.image = [UIImage imageNamed:@"mic_wifi_4"];

}

- (void)soundPlayAinimation {
    self.isPlaying = YES;
    
    NSArray *myImages;
    

        myImages = [NSArray arrayWithObjects:
                    [UIImage imageNamed:@"mic_wifi_1"],
                    [UIImage imageNamed:@"mic_wifi_2"],
                    [UIImage imageNamed:@"mic_wifi_3"],
                    [UIImage imageNamed:@"mic_wifi_4"], nil];

    trumpetImage.animationImages = myImages; //animationImages属性返回一个存放动画图片的数组
    trumpetImage.animationDuration = 0.85; //浏览整个图片一次所用的时间
    trumpetImage.animationRepeatCount = 0; // 0 = loops forever 动画重复次数
    [trumpetImage startAnimating];
}


#pragma mark - recordAudioDelegate
- (void)recordAudioDidFinishPlaying{
    [self soundStopAinimation];
}


#pragma mark - animations

- (void)fadeIn
{
    if (self.popViewAnimation == PopViewAnimationNone) {
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0;
        [UIView animateWithDuration:.35 animations:^{
            self.alpha = 1;
            self.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }else if (self.popViewAnimation == PopViewAnimationBounce) {
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0;
        [UIView animateWithDuration:.35 animations:^{
            self.alpha = 1;
            self.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }else if (self.popViewAnimation == PopViewAnimationSwipeL2R) {
        CGRect popFrame = self.frame;
        self.frame = CGRectMake(-screentWith, popFrame.origin.y, popFrame.size.width, popFrame.size.height);
        [UIView animateWithDuration:.35 animations:^{
            self.frame = popFrame;
        }];
    }else if (self.popViewAnimation == PopViewAnimationSwipeR2L) {
        CGRect popFrame = self.frame;
        self.frame = CGRectMake(screentWith + popFrame.origin.x, popFrame.origin.y, popFrame.size.width, popFrame.size.height);
        [UIView animateWithDuration:.35 animations:^{
            self.frame = popFrame;
        }];
    }else if (self.popViewAnimation == PopViewAnimationSwipeD2U) {
        CGRect popFrame = self.frame;
        DLog(@"PopViewAnimationSwipeD2U--%@\n",NSStringFromCGRect(self.frame));
        self.frame = CGRectMake(popFrame.origin.x, screentContentHeight + popFrame.origin.y, popFrame.size.width, popFrame.size.height);
        [UIView animateWithDuration:.35 animations:^{
            self.frame = popFrame;
        }];
    }else if (self.popViewAnimation == PopViewAnimationSwipeU2D) {
        CGRect popFrame = self.frame;
        self.frame = CGRectMake(popFrame.origin.x, -screentContentHeight + popFrame.origin.y, popFrame.size.width, popFrame.size.height);
        [UIView animateWithDuration:.35 animations:^{
            self.frame = popFrame;
        }];
    } else if (self.popViewAnimation == PopViewAnimationActionSheet) {
        CGRect popFrame = self.frame;
        DLog(@"PopViewAnimationActionSheet--%@\n",NSStringFromCGRect(self.frame));
        
        self.frame = CGRectMake(popFrame.origin.x, screentContentHeight, popFrame.size.width, popFrame.size.height);
        self.alpha = 0;
        [UIView animateWithDuration:.35 animations:^{
            self.frame = popFrame;
            self.alpha = 1;
        }];
    }
    
    
}
- (void)fadeOut
{
    if (self.popViewAnimation == PopViewAnimationNone) {
        [UIView animateWithDuration:.35 animations:^{
            self.transform = CGAffineTransformMakeScale(1.3, 1.3);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [_overlayView removeFromSuperview];
                [self removeFromSuperview];
            }
        }];
    }else if (self.popViewAnimation == PopViewAnimationBounce) {
        [UIView animateWithDuration:.35 animations:^{
            self.transform = CGAffineTransformMakeScale(1.3, 1.3);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [_overlayView removeFromSuperview];
                [self removeFromSuperview];
            }
        }];
    }else if (self.popViewAnimation == PopViewAnimationSwipeL2R) {
        [UIView animateWithDuration:.35 animations:^{
            CGRect popFrame = self.frame;
            self.frame = CGRectMake(-screentWith, popFrame.origin.y, popFrame.size.width, popFrame.size.height);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [_overlayView removeFromSuperview];
                [self removeFromSuperview];
            }
        }];
    }else if (self.popViewAnimation == PopViewAnimationSwipeR2L) {
        [UIView animateWithDuration:.35 animations:^{
            CGRect popFrame = self.frame;
            self.frame = CGRectMake(screentWith + popFrame.origin.x, popFrame.origin.y, popFrame.size.width, popFrame.size.height);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [_overlayView removeFromSuperview];
                [self removeFromSuperview];
            }
        }];
    }else if (self.popViewAnimation == PopViewAnimationSwipeD2U) {
        [UIView animateWithDuration:.35 animations:^{
            CGRect popFrame = self.frame;
            self.frame = CGRectMake(popFrame.origin.x, screentWith * 2 + popFrame.origin.y, popFrame.size.width, popFrame.size.height);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [_overlayView removeFromSuperview];
                [self removeFromSuperview];
            }
        }];
    }else if (self.popViewAnimation == PopViewAnimationSwipeU2D) {
        [UIView animateWithDuration:.35 animations:^{
            CGRect popFrame = self.frame;
            self.frame = CGRectMake(popFrame.origin.x, -screentWith * 2 + popFrame.origin.y, popFrame.size.width, popFrame.size.height);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [_overlayView removeFromSuperview];
                [self removeFromSuperview];
            }
        }];
    }else if (self.popViewAnimation == PopViewAnimationActionSheet) {
        [UIView animateWithDuration:.35 animations:^{
            CGRect popFrame = self.frame;
            self.frame = CGRectMake(popFrame.origin.x, screentHeight, popFrame.size.width, popFrame.size.height);
            self.alpha = 0.0;
            _overlayView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [_overlayView removeFromSuperview];
                [self removeFromSuperview];
            }
        }];
    }
    
}


- (void)setTitle:(NSString *)title
{
    _titleView.text = title;
}

- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
}

#define mark - UITouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}




#pragma mark gestureRecognizer view delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

@end
