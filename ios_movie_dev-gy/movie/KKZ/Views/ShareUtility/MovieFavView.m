//
//  MovieFavView.m
//
//  Created by su xinde on 13-3-13.
//  Copyright (c) 2013年 su xinde. All rights reserved.
//

#import "MovieFavView.h"
#import <QuartzCore/QuartzCore.h>
#import "lame.h"
#import "FavoriteTask.h"
#import "TaskQueue.h"
#import "VoiceTask.h"


#define CHeight 50
#define kFavTag 1231
#define MAX_TEXT_NUM 140

#define MovieFavViewWidth 270
#define MovieFavViewHeight 230

@interface MovieFavView ()

- (void)defalutInit;
- (void)fadeIn;
- (void)fadeOut;

@end

@implementation MovieFavView

- (void)dealloc
{

}

- (id)initWithFrame:(CGRect)frame
{
    self.backgroundColor = [UIColor clearColor];
    
    CGRect f = CGRectMake((320-MovieFavViewWidth)/2, (screentContentHeight-MovieFavViewHeight)/2, MovieFavViewWidth, MovieFavViewHeight);
    
    if (self = [super initWithFrame:f]) {
        [self defalutInit];
    }
    return self;
}

- (void)defalutInit
{
    self.clipsToBounds = TRUE;
    self.popViewAnimation = PopViewAnimationBounce;
    
    showBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 210)];
    showBg.backgroundColor = [UIColor r:238 g:238 b:238];
    [self addSubview:showBg];
    
    //星星
    starView = [[RatingView alloc]initWithFrame:CGRectMake(28+5, 15, 207, 33)];
    [starView setImagesDeselected:@"fav_star_no_blue_match"
                   partlySelected:@"fav_star_half_blue"
                     fullSelected:@"fav_star_full_blue"
                         iconSize:CGSizeMake(66*0.54, 63*0.54)
                      marginWidth:5
                      andDelegate:self];
    starView.userInteractionEnabled = YES;
    [starView displayRating:0];
    [self addSubview:starView];
    
    //语音模式
    keyBoardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    keyBoardButton.frame = CGRectMake(17, 70, 49, 34);
    [keyBoardButton setBackgroundImage:[UIImage imageNamed:@"mic_keyboard"] forState:UIControlStateNormal];
    [keyBoardButton addTarget:self action:@selector(clickKeyboardButton:) forControlEvents:UIControlEventTouchUpInside];
    [showBg addSubview:keyBoardButton];
    
    //文字模式
    audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    audioButton.frame = keyBoardButton.frame;
    [audioButton setBackgroundImage:[UIImage imageNamed:@"mic_microphone"] forState:UIControlStateNormal];
    [audioButton addTarget:self action:@selector(clickAudioButton:) forControlEvents:UIControlEventTouchUpInside];
    audioButton.hidden = YES;
    [showBg addSubview:audioButton];
    
    //说话条
    recordView = [[UIView alloc] initWithFrame:CGRectMake(70, 50, 175, 60)];
    recordView.backgroundColor = [UIColor clearColor];
    [self addSubview:recordView];
    
    //按住说评论
    UIButton *supportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    supportButton.frame = CGRectMake(4, 20, 167+5, 36);
    supportButton.tag = kFavTag + 3;
    [supportButton setBackgroundImage:[UIImage imageNamed:@"mic_click_speak"] forState:UIControlStateNormal];
    [supportButton setBackgroundImage:[UIImage imageNamed:@"mic_click_speak_down"] forState:UIControlStateHighlighted];
    [supportButton addTarget:self action:@selector(startRec) forControlEvents:UIControlEventTouchDown];
    [supportButton addTarget:self action:@selector(stopRec:)
            forControlEvents: UIControlEventTouchUpInside|UIControlEventTouchCancel];
    [supportButton addTarget:self action:@selector(cancelRec)
            forControlEvents: UIControlEventTouchUpOutside];
    [recordView addSubview:supportButton];
    
    
    //语音条背景
//    soundBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(2, 24 + 40, 175, 31)];
//    soundBarBg.image = [UIImage imageNamed:@"fav_sound_bar_bg_new.png"];
//    soundBarBg.hidden = YES;
//    [recordView addSubview:soundBarBg];
  
    
    textImageView = [[UIImageView alloc] initWithFrame:CGRectMake(75, 67, 170, 92)];
    textImageView.image = [UIImage imageNamed:@"mic_textfield_big"];
    [self addSubview:textImageView];
    textImageView.hidden = YES;
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(75, 67, 170, 90)];
    textView.delegate = self;
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont systemFontOfSize:13];
    textView.hidden = YES;
    [self addSubview:textView];
    
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(17, 160-31, 54, 31);
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"btn_white_gray_107x62"] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancelBtn addTarget:self action:@selector(cancelShare) forControlEvents:UIControlEventTouchUpInside];
    [showBg addSubview:cancelBtn];
    
    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(190, 160-31, 54, 31);
    [confirmBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_107x62"] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [confirmBtn addTarget:self action:@selector(confirmShare) forControlEvents:UIControlEventTouchUpInside];
    [showBg addSubview:confirmBtn];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _overlayView.backgroundColor = [[UIColor blackColor] alpha:.5];
    [_overlayView addTarget:self
                     action:@selector(dismiss)
           forControlEvents:UIControlEventTouchUpInside];
    
    
}



- (void)touchAtPoint:(CGPoint)point {

    if( CGRectContainsPoint(CGRectMake(0, 0, 270, 300), point) ) {
        [textView resignFirstResponder];
        return;
	}
    [self dismiss];
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:self];
    [self touchAtPoint:point];
}

//进入文字输入模式。    //显示键盘
-(void)clickKeyboardButton:(id)sender{
    recordLength = 0;
    textView.text = nil;
    keyBoardButton.hidden = YES;
    recordView.hidden = YES;
    audioButton.hidden = NO;
    textImageView.hidden = NO;
    textView.hidden = NO;
    poplistview.hidden = YES;
//    soundBarBg.hidden = YES;
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.frame = CGRectMake((320-MovieFavViewWidth)/2, (screentContentHeight-MovieFavViewHeight-20)/2, MovieFavViewWidth, MovieFavViewHeight+20);
                            showBg.frame = CGRectMake(0, 0, 270, 230);
                            cancelBtn.frame = CGRectMake(17, 180, 54, 31);
                            confirmBtn.frame = CGRectMake(190, 180, 54, 31);
                            
                        } completion:^(BOOL finished) {
                            
                        }];

}

//进入语音模式。隐藏键盘
-(void)clickAudioButton:(id)sender{
    textView.text = nil;
    recordLength = 0;
    keyBoardButton.hidden = NO;
    recordView.hidden = NO;
    audioButton.hidden = YES;
    textImageView.hidden = YES;
    textView.hidden = YES;
    
    [self hideKeyboard];

    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.frame = CGRectMake((320-MovieFavViewWidth)/2, (screentContentHeight-MovieFavViewHeight)/2, MovieFavViewWidth, MovieFavViewHeight);
                            
                            showBg.frame = CGRectMake(0, 0, 270, 210);
                            cancelBtn.frame = CGRectMake(17, 160-31, 54, 31);
                            confirmBtn.frame = CGRectMake(190, 160-31, 54, 31);
                            
                        } completion:^(BOOL finished) {
                            
                        }];
    


}

-(void)hideKeyboard{
    [textView resignFirstResponder];
}


- (BOOL)textView:(UITextView *)textView0 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        DLog(@"点击返回键");
        [self hideKeyboard];
        return NO;
    }
    
    if (textView0.text.length > MAX_TEXT_NUM) {
        textView0.text = [textView0.text substringToIndex:textView0.text.length - 1];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"输入文字太多，请不要超过140字。"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    return YES;
}




#pragma mark - animations
- (void)fadeIn
{
    if (self.popViewAnimation == PopViewAnimationNone) {
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0;
        [UIView animateWithDuration:.2 animations:^{
            self.alpha = 1;
            self.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }else if (self.popViewAnimation == PopViewAnimationBounce) {
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
        self.alpha = 0;
        [UIView animateWithDuration:.2 animations:^{
            self.alpha = 1;
            self.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }else if (self.popViewAnimation == PopViewAnimationSwipeL2R) {
        CGRect popFrame = self.frame;
        self.frame = CGRectMake(-320, popFrame.origin.y, popFrame.size.width, popFrame.size.height);
        [UIView animateWithDuration:.2 animations:^{
            self.frame = popFrame;
        }];
    }else if (self.popViewAnimation == PopViewAnimationSwipeR2L) {
        CGRect popFrame = self.frame;
        self.frame = CGRectMake(320 + popFrame.origin.x, popFrame.origin.y, popFrame.size.width, popFrame.size.height);
        [UIView animateWithDuration:.2 animations:^{
            self.frame = popFrame;
        }];
    }else if (self.popViewAnimation == PopViewAnimationSwipeD2U) {
        CGRect popFrame = self.frame;
        DLog(@"PopViewAnimationSwipeD2U--%@\n",NSStringFromCGRect(self.frame));
        self.frame = CGRectMake(popFrame.origin.x, 460 + popFrame.origin.y, popFrame.size.width, popFrame.size.height);
        [UIView animateWithDuration:.2 animations:^{
            self.frame = popFrame;
        }];
    }else if (self.popViewAnimation == PopViewAnimationSwipeU2D) {
        CGRect popFrame = self.frame;
        self.frame = CGRectMake(popFrame.origin.x, -460 + popFrame.origin.y, popFrame.size.width, popFrame.size.height);
        [UIView animateWithDuration:.2 animations:^{
            self.frame = popFrame;
        }];
    } else if (self.popViewAnimation == PopViewAnimationActionSheet) {
        CGRect popFrame = self.frame;
        DLog(@"PopViewAnimationActionSheet--%@\n",NSStringFromCGRect(self.frame));
        
        self.frame = CGRectMake(popFrame.origin.x, 460, popFrame.size.width, popFrame.size.height);
        [UIView animateWithDuration:.2 animations:^{
            self.frame = popFrame;
        }];
    }
    
    
}
- (void)fadeOut
{
    if (self.popViewAnimation == PopViewAnimationNone) {
        [UIView animateWithDuration:.2 animations:^{
            self.transform = CGAffineTransformMakeScale(1.3, 1.3);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [_overlayView removeFromSuperview];
                [self removeFromSuperview];
            }
        }];
    }else if (self.popViewAnimation == PopViewAnimationBounce) {
        [UIView animateWithDuration:.2 animations:^{
            self.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [_overlayView removeFromSuperview];
                [self removeFromSuperview];
            }
        }];
    }else if (self.popViewAnimation == PopViewAnimationSwipeL2R) {
        [UIView animateWithDuration:.2 animations:^{
            CGRect popFrame = self.frame;
            self.frame = CGRectMake(-320, popFrame.origin.y, popFrame.size.width, popFrame.size.height);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [_overlayView removeFromSuperview];
                [self removeFromSuperview];
            }
        }];
    }else if (self.popViewAnimation == PopViewAnimationSwipeR2L) {
        [UIView animateWithDuration:.2 animations:^{
            CGRect popFrame = self.frame;
            self.frame = CGRectMake(320 + popFrame.origin.x, popFrame.origin.y, popFrame.size.width, popFrame.size.height);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [_overlayView removeFromSuperview];
                [self removeFromSuperview];
            }
        }];
    }else if (self.popViewAnimation == PopViewAnimationSwipeD2U) {
        [UIView animateWithDuration:.2 animations:^{
            CGRect popFrame = self.frame;
            self.frame = CGRectMake(popFrame.origin.x, 460 + popFrame.origin.y, popFrame.size.width, popFrame.size.height);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [_overlayView removeFromSuperview];
                [self removeFromSuperview];
            }
        }];
    }else if (self.popViewAnimation == PopViewAnimationSwipeU2D) {
        [UIView animateWithDuration:.2 animations:^{
            CGRect popFrame = self.frame;
            self.frame = CGRectMake(popFrame.origin.x, -460 + popFrame.origin.y, popFrame.size.width, popFrame.size.height);
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [_overlayView removeFromSuperview];
                [self removeFromSuperview];
            }
        }];
    }else if (self.popViewAnimation == PopViewAnimationActionSheet) {
        [UIView animateWithDuration:.2 animations:^{
            CGRect popFrame = self.frame;
            self.frame = CGRectMake(popFrame.origin.x, screentHeight, popFrame.size.width, popFrame.size.height);
            self.alpha = 0.3;
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

- (void)showAndcompletion:(void (^)(BOOL finished, NSDictionary *dict))completion
{
    _collectFinished = completion;
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:_overlayView];
    [keywindow addSubview:self];
    [self fadeIn];
}

- (void)dismiss
{
    [self fadeOut];
    
}

- (void)addVoiceComment {
    DLog(@"addVoiceComment");
    [self showRecordView];
}

- (void)cancelShare {
    DLog(@"cancelShare");
    [self dismiss];
}

- (void)confirmShare {
    DLog(@"confirmShare");
    if (score == 0) {
        [appDelegate showAlertViewForTitle:@"" message:@"亲，请先给电影打分喔~" cancelButton:@"OK"];
        return;
    }
    
    [self addFavoriteMovie];

}

- (void)addFavoriteMovie {
    void (^doAction)() = ^(){
        
        NSString *mp3FileName = @"Mp3File";
        mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
        NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
        
        NSData *amr = [NSData dataWithContentsOfFile:mp3FilePath];
        
        DLog(@"length-----------%d",recordLength);
        
        
        
        FavoriteTask *task = [[FavoriteTask alloc] initAddFavMovie:self.movieId.unsignedIntegerValue withPoint:score withAudioData:amr withAudioLength:recordLength withText:textView.text finished:^(BOOL succeeded, NSDictionary *userInfo) {
                
            [self addMovieFavFinished:userInfo status:succeeded];
            
        }];
            
        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
            [appDelegate showIndicatorWithTitle:@"正在收藏..."
                                           animated:YES
                                         fullScreen:NO
                                       overKeyboard:YES
                                        andAutoHide:NO];
            }

        
//        NSLog(@"------------%ld", strlen((char *)[amr bytes]));
        recordLength = 0;
    };
    
    doAction();
    
}

- (void)showRecordView {
}



#pragma mark - Notification
- (void)addMovieFavFinished:(NSDictionary *)dict status:(BOOL)succeeded {
    [appDelegate hideIndicator];

    NSString * scores = [NSString stringWithFormat:@"%f",score];
    
    NSMutableDictionary *scoreObj = [NSMutableDictionary dictionaryWithObjectsAndKeys: dict, @"dict", scores,@"score", nil];
    
    
    if (succeeded) {
        if (self.collectFinished) {
            self.collectFinished(TRUE, scoreObj);
        }

        [appDelegate showIndicatorWithTitle:@"收藏成功啦!"
                                   animated:NO
                                 fullScreen:NO
                               overKeyboard:YES
                                andAutoHide:YES];
        [self dismiss];
        

    } else {
        [appDelegate showAlertViewForTaskInfo:dict];

    }
    
}



#pragma mark - UITouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
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



#pragma mark Rating view delegate
- (void)ratingChanged:(CGFloat)newRating {
    score = newRating*2;
    DLog(@"%f",score);
}


#pragma mark Record relate
- (void)startRec {
    
    
    if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]){
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                DLog(@"Enabled Mic");
                if (poplistview && [poplistview superview]) {
                    [poplistview dismiss];
//                    soundBarBg.hidden = YES;
                    cancelBtn.frame = CGRectMake(17, 160-31, 54, 31);
                    confirmBtn.frame = CGRectMake(190, 160-31, 54, 31);
                }
                //    [recordAudio startRecord];
                [self showShuoWave];
                recordLength = 0.0;
                durationLabel.text = @"";
                NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                               //[NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                               [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
                                               [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
                                               //  [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                                               [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                               [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                               [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                               [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                               nil];
                
                NSURL *recordedFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];
                NSError* error;
                recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:recordSetting error:&error];
                DLog(@"%@", [error description]);
                
                [recorder prepareToRecord];
                [recorder record];
                
                _timer = [NSTimer scheduledTimerWithTimeInterval:.01f
                                                          target:self
                                                        selector:@selector(timerUpdate)
                                                        userInfo:nil
                                                         repeats:YES];
            }
            else {
                [appDelegate showAlertViewForTitle:@"您还不能使用麦克风" message:@"请到系统设置-隐私-麦克风中打开应用的权限" cancelButton:@"OK"];
                return;
                DLog(@"Disabled Mic");
            }
        }];
    }else {
        if (poplistview && [poplistview superview]) {
            [poplistview dismiss];
//            soundBarBg.hidden = YES;
            cancelBtn.frame = CGRectMake(17, 160-31, 54, 31);
            confirmBtn.frame = CGRectMake(190, 160-31, 54, 31);
        }
        [self showShuoWave];
        recordLength = 0.0;
        durationLabel.text = @"";
        NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                       [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
                                       [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
                                       [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                       [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                       [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                       [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                       nil];
        
        NSURL *recordedFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];
        NSError* error;
        recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:recordSetting error:&error];
        DLog(@"%@", [error description]);
        
        [recorder prepareToRecord];
        [recorder record];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:.01f
                                                  target:self
                                                selector:@selector(timerUpdate)
                                                userInfo:nil
                                                 repeats:YES];
    }
    
    
}


- (void) timerUpdate
{
    int s = ((int) recorder.currentTime) % 60;
    recordLength = s;
    durationLabel.text = [NSString stringWithFormat:@"%d\"", s];
    durationLabel.textColor = [UIColor whiteColor];

    if (recordLength >= 59) {
        durationLabel.textColor = appDelegate.kkzYellow;
        [self timeAlert];
        
        [_timer invalidate];
        _timer = nil;
        
        [recorder stop];
        recorder = nil;
    }
    
}

- (void)timeAlert {
    CAKeyframeAnimation *animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = .4;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.2)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [durationLabel.layer addAnimation:animation forKey:nil];
}

- (void) convertMp3Finish
{
    if (recordLength <1.0) {
        [appDelegate showAlertViewForTitle:@""
                                   message:@"请多说点~"
                              cancelButton:@"OK"];
    }else {
        [self showSelfSound];
    }
    
}


//显示语音条
- (void)showSelfSound {
    CGFloat xWidth = self.frame.size.width-50;
    CGFloat yHeight = 40.0f;
    if (!hasVoice) {
        poplistview = [[FavRecordView alloc] initWithFrame:CGRectMake(47,0, xWidth, yHeight)];
        poplistview.delegate = self;
        poplistview.popViewAnimation = PopViewAnimationFade;
        
        [self addSubview:poplistview];
//        soundBarBg.hidden = NO;
        cancelBtn.frame = CGRectMake(17, 160, 54, 31);
        confirmBtn.frame = CGRectMake(190, 160, 54, 31);
        
       [poplistview setBackgroundColor:[UIColor whiteColor]];
    }
    
    [poplistview updateWithType:shuoAttitude andLength:recordLength];
    hasVoice = YES;
}

- (void)stopRec:(id)selector{
    
    if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]){
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                [self hideShuoWave];
                if (_timer) {
                    [_timer invalidate];
                    _timer = nil;
                }
                
                if (recorder) {
                    [recorder stop];
                    recorder = nil;
                }
                
                //    shuoPopLabel.text = @"";
                
                UIButton *btn = (UIButton *)selector;
                shuoAttitude = 1;
                switch (btn.tag) {
                    case kFavTag + 3:
                    {
                        shuoAttitude = 1;
                    }
                        break;
                    case kFavTag + 4:
                    {
                        shuoAttitude = 2;
                    }
                        break;
                    default:
                        break;
                }
                
                NSString *cafFilePath =[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"];
                if (![[NSFileManager defaultManager] fileExistsAtPath:cafFilePath]) {
                    //抠电影正在访问您的麦克风，选择”好“程序闪退或卡死
                    return;
                }
                
                NSString *mp3FileName = @"Mp3File";
                mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
                NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
                
                @try {
                    NSInteger read, write;
                    
                    FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source
                    fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
                    FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output
                    
                    const int PCM_SIZE = 8192;
                    const int MP3_SIZE = 8192;
                    short int pcm_buffer[PCM_SIZE*2];
                    unsigned char mp3_buffer[MP3_SIZE];
                    
                    lame_t lame = lame_init();
                    lame_set_in_samplerate(lame, 8000);
                    lame_set_VBR(lame, vbr_default);
                    lame_init_params(lame);
                    
                    do {
                        read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
                        if (read == 0)
                            write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                        else
                            write = lame_encode_buffer_interleaved(lame, pcm_buffer, (int)read, mp3_buffer, MP3_SIZE);
                        
                        fwrite(mp3_buffer, write, 1, mp3);
                        
                    } while (read != 0);
                    
                    lame_close(lame);
                    fclose(mp3);
                    fclose(pcm);
                }
                @catch (NSException *exception) {
                    DLog(@"%@",[exception description]);
                }
                @finally {
                    [self performSelectorOnMainThread:@selector(convertMp3Finish)
                                           withObject:nil
                                        waitUntilDone:YES];
                }
                
            }
            else {
                DLog(@"Disabled Mic");
            }
        }];
    }else{
        [self hideShuoWave];
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        
        if (recorder) {
            [recorder stop];
            recorder = nil;
        }
        
        UIButton *btn = (UIButton *)selector;
        shuoAttitude = 1;
        switch (btn.tag) {
            case kFavTag + 3:
            {
                shuoAttitude = 1;
            }
                break;
            case kFavTag + 4:
            {
                shuoAttitude = 2;
            }
                break;
            default:
                break;
        }
        
        NSString *cafFilePath =[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:cafFilePath]) {
            //抠电影正在访问您的麦克风，选择”好“程序闪退或卡死
            return;
        }
        
        NSString *mp3FileName = @"Mp3File";
        mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
        NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
        
        @try {
            NSInteger read, write;
            
            FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source
            fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
            FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output
            
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE*2];
            unsigned char mp3_buffer[MP3_SIZE];
            
            lame_t lame = lame_init();
            lame_set_in_samplerate(lame, 8000);
            lame_set_VBR(lame, vbr_default);
            lame_init_params(lame);
            
            do {
                read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
                if (read == 0)
                    write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                else
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, (int)read, mp3_buffer, MP3_SIZE);
                
                fwrite(mp3_buffer, write, 1, mp3);
                
            } while (read != 0);
            
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
        }
        @catch (NSException *exception) {
            DLog(@"%@",[exception description]);
        }
        @finally {
            [self performSelectorOnMainThread:@selector(convertMp3Finish)
                                   withObject:nil
                                waitUntilDone:YES];
        }
    }
    
}


- (void)cancelRec{
    [self hideShuoWave];
    [_timer invalidate];
    _timer = nil;
    
    [recorder stop];
    recorder = nil;
}



#pragma mark FavRecordView view delegate
- (void)delSoundComment {
    hasVoice = NO;
//    soundBarBg.hidden = YES;
    cancelBtn.frame = CGRectMake(17, 160-31, 54, 31);
    confirmBtn.frame = CGRectMake(190, 160-31, 54, 31);
}



#pragma mark Sound & Vedio
- (void)showShuoWave {
    
    shuoHolder = [[UIControl alloc] initWithFrame:CGRectMake(0, 20 + 42, 320, screentContentHeight - 44)];
    shuoHolder.backgroundColor = [[UIColor blackColor] alpha:.5];
    [appDelegate.window addSubview:shuoHolder];

    
    shuoTipView = [[MicView alloc] initWithFrame:CGRectMake(0, (screentContentHeight - 320)/2.0 - 25, screentWith, 320)];
    shuoTipView.userInteractionEnabled = YES;
    [shuoHolder addSubview:shuoTipView];
    
    durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 160 + 24, 320, 14)];
    durationLabel.backgroundColor = [UIColor clearColor];
    durationLabel.textColor = [UIColor whiteColor];
    durationLabel.text = @"";
    durationLabel.font = [UIFont systemFontOfSize:12];
    durationLabel.textAlignment = NSTextAlignmentCenter;
    durationLabel.numberOfLines = 2;
    [shuoTipView addSubview:durationLabel];
    
}

- (void)hideShuoWave {
    if (shuoHolder &&[shuoHolder superview]) {
        [shuoTipView stopAnimation];
        [shuoHolder removeFromSuperview];
    }
    
}

@end
