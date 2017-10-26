//
//  FavRecordView.m
//
//  Created by su xinde on 13-3-13.
//  Copyright (c) 2013年 su xinde. All rights reserved.
//

#import "FavRecordView.h"
#import <QuartzCore/QuartzCore.h>
#import "ShareView.h"
#import "UIConstants.h"

//#define FRAME_X_INSET 20.0f
//#define FRAME_Y_INSET 40.0f
#define CHeight 50

@interface FavRecordView ()

- (void)defalutInit;
- (void)fadeIn;
- (void)fadeOut;

@end

@implementation FavRecordView


- (void)dealloc
{
    DLog(@"FavRecordView dealloc");
}

- (id)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
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

    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(self.frame.size.width-40 + 10, 4, 24, 24);
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"ic_input_clear"] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancelBtn addTarget:self action:@selector(cancelShare) forControlEvents:UIControlEventTouchUpInside];

    
    soundBarImage = [[UIImageView alloc] init];
    [self addSubview:soundBarImage];
    
    voiceImage = [[UIImageView alloc] initWithFrame:CGRectMake(44, 9 , 14, 14)];
    voiceImage.image = [UIImage imageNamed:@"voice_play_right_1"];
    [self addSubview:voiceImage];

  
    UILabel *shitingLbl = [[UILabel alloc] initWithFrame:CGRectMake(55, 9, 60, 14)];
    shitingLbl.textAlignment = NSTextAlignmentCenter;
    shitingLbl.text = @"试听";
    shitingLbl.textColor = [UIColor whiteColor];
    shitingLbl.backgroundColor = [UIColor clearColor];
    shitingLbl.font = [UIFont systemFontOfSize:kTextSizeContent];
    [self addSubview:shitingLbl];
    
    soundLengthLabel = [[UILabel alloc] init];
    soundLengthLabel.textColor = [UIColor whiteColor];
    soundLengthLabel.backgroundColor = [UIColor clearColor];
    soundLengthLabel.font = [UIFont systemFontOfSize:kTextSizeContent];
    [self addSubview:soundLengthLabel];
    
    
    deleteImage = [[UIImageView alloc] init];
    [deleteImage setImage:[UIImage imageNamed:@"ic_input_clear"]];
     [self addSubview:deleteImage];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
}


- (void)updateWithType:(int)type andLength:(float)length {
    self.shuoType = type;
    
    float shuoBarLength = 55;
    
    if (length > 5 && length <= 30) {
        shuoBarLength = 55 + (length - 5)*5;
    }
    else if (length > 30) {
        shuoBarLength = 155;
    }
    
    if (self.shuoType == 1) {
       
        soundBarImage.image = [UIImage imageNamed:@"shuo_support_bar_blue"];// shuocell_support_bar
        soundBarImage.frame = CGRectMake(30, 0, 110, 32);//拉伸的最终大小

        soundLengthLabel.textAlignment = NSTextAlignmentRight;
        soundLengthLabel.frame = CGRectMake(92, 9, 40, 14);
        soundLengthLabel.text = [NSString stringWithFormat:@"%d\"", (int)length];
        
        voiceImage.image = [UIImage imageNamed:@"voice_play_right_1"];
        
        
        deleteImage.frame = CGRectMake(self.frame.size.width - 40 + 10, 4, 24, 24);
        [deleteImage setImage:[UIImage imageNamed:@"ic_input_clear"]];
    }
}


- (void)touchAtPoint:(CGPoint)point {
    if (CGRectContainsPoint(soundBarImage.frame, point)) {
        [self playSound];
		return;
	}
    else if (CGRectContainsPoint(deleteImage.frame, point)) {
        [self delSoundComY];
        return;
	}
}


- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    [self touchAtPoint:point];
}


-(void)delSoundComY {
    if (self.delegate && [self.delegate respondsToSelector:@selector(delSoundComment)]) {
        [self.delegate delSoundComment];
    }
    [self removeFromSuperview];
}

- (void)playSound {
    DLog(@"addVoiceComment");
    if (self.isPlaying) {
        [self soundStopAinimation];
    }
    else {
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
    [self dismiss];
}


- (void)soundStopAinimation {
    self.isPlaying = NO;
    [voiceImage stopAnimating];
    if (self.shuoType == 1) {
        voiceImage.image = [UIImage imageNamed:@"voice_play_right_1"];
    }
}

- (void)soundPlayAinimation {
    self.isPlaying = YES;
    if (self.shuoType == 1) {

    NSArray *myImages;
    
    myImages = [NSArray arrayWithObjects:
                [UIImage imageNamed:@"voice_play_right_4"],
                [UIImage imageNamed:@"voice_play_right_3"],
                [UIImage imageNamed:@"voice_play_right_2"],
                [UIImage imageNamed:@"voice_play_right_1"], nil];
    voiceImage.animationImages = myImages; //animationImages属性返回一个存放动画图片的数组
    voiceImage.animationDuration = 0.85; //浏览整个图片一次所用的时间
    voiceImage.animationRepeatCount = 0; // 0 = loops forever 动画重复次数
    [voiceImage startAnimating];

    }
}


- (void)recordAudioDidFinishPlaying{
    [recordAudio stopPlay];
    [self soundStopAinimation];
}


#pragma mark - animations
- (void)fadeIn {
    if (self.popViewAnimation == PopViewAnimationNone) {
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0;
        [UIView animateWithDuration:.35 animations:^{
            self.alpha = 1;
            self.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }
    else if (self.popViewAnimation == PopViewAnimationBounce) {
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0;
        [UIView animateWithDuration:.35 animations:^{
            self.alpha = 1;
            self.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }
    else if (self.popViewAnimation == PopViewAnimationSwipeL2R) {
        CGRect popFrame = self.frame;
        self.frame = CGRectMake(-screentWith, popFrame.origin.y, popFrame.size.width, popFrame.size.height);
        [UIView animateWithDuration:.35 animations:^{
            self.frame = popFrame;
        }];
    }
    else if (self.popViewAnimation == PopViewAnimationSwipeR2L) {
        CGRect popFrame = self.frame;
        self.frame = CGRectMake(screentWith + popFrame.origin.x, popFrame.origin.y, popFrame.size.width, popFrame.size.height);
        [UIView animateWithDuration:.35 animations:^{
            self.frame = popFrame;
        }];
    }
    else if (self.popViewAnimation == PopViewAnimationSwipeD2U) {
        CGRect popFrame = self.frame;
        DLog(@"PopViewAnimationSwipeD2U--%@\n",NSStringFromCGRect(self.frame));
        self.frame = CGRectMake(popFrame.origin.x, screentWith * 2 + popFrame.origin.y, popFrame.size.width, popFrame.size.height);
        [UIView animateWithDuration:.35 animations:^{
            self.frame = popFrame;
        }];
    }
    else if (self.popViewAnimation == PopViewAnimationSwipeU2D) {
        CGRect popFrame = self.frame;
        self.frame = CGRectMake(popFrame.origin.x, -screentContentHeight + popFrame.origin.y, popFrame.size.width, popFrame.size.height);
        [UIView animateWithDuration:.35 animations:^{
            self.frame = popFrame;
        }];
    }
    else if (self.popViewAnimation == PopViewAnimationActionSheet) {
        CGRect popFrame = self.frame;
        DLog(@"PopViewAnimationActionSheet--%@\n",NSStringFromCGRect(self.frame));
        
        self.frame = CGRectMake(popFrame.origin.x, screentContentHeight, popFrame.size.width, popFrame.size.height);
        self.alpha = 0;
        [UIView animateWithDuration:.35 animations:^{
            self.frame = popFrame;
            self.alpha = 1;
        }];
    }
    else if (self.popViewAnimation == PopViewAnimationFade) {
        CGRect popFrame = self.frame;
        DLog(@"PopViewAnimationActionSheet--%@\n",NSStringFromCGRect(self.frame));
        
        self.frame = CGRectMake(popFrame.origin.x, popFrame.origin.y, popFrame.size.width, popFrame.size.height);
        self.alpha = 0;
        [UIView animateWithDuration:.35 animations:^{
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
                [self removeFromSuperview];
            }
        }];
    }else if (self.popViewAnimation == PopViewAnimationBounce) {
        [UIView animateWithDuration:.35 animations:^{
            self.transform = CGAffineTransformMakeScale(1.3, 1.3);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
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
                [self removeFromSuperview];
            }
        }];
    }else if (self.popViewAnimation == PopViewAnimationActionSheet) {
        [UIView animateWithDuration:.35 animations:^{
            CGRect popFrame = self.frame;
            self.frame = CGRectMake(popFrame.origin.x, screentHeight, popFrame.size.width, popFrame.size.height);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
            }
        }];
    }else if (self.popViewAnimation == PopViewAnimationFade) {
        
        [UIView animateWithDuration:.35 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(delSoundComment)]) {
                    [self.delegate delSoundComment];
                }
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
