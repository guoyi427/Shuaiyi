//
//  发起约电影页面
//
//  Created by avatar on 14-11-19.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AudioPlayerManager.h"
#import "Comment.h"
#import "DataEngine.h"
#import "InitiateAppointmentByMovieController.h"
#import "KKZUser.h"
#import "KotaHeadImageView.h"
#import "KotaHelpInfoViewController.h"
#import "KotaMovieImageView.h"
#import "KotaTask.h"
#import "MemContainer.h"
#import "TaskQueue.h"
#import "UIAlertView+Blocks.h"
#import "UIConstants.h"
#import "VoiceTask.h"
#import "kotaSucceedInitiateViewController.h"
#import "lame.h"
#import "UserManager.h"

#define kFavTag 1231

@interface InitiateAppointmentByMovieController ()

@end

@implementation InitiateAppointmentByMovieController

- (void)dealloc {
    [self removeForKeyboardNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.kkzTitleLabel.text = @"发起约电影";

    kotahelp = [[UIButton alloc] initWithFrame:CGRectMake(screentWith - 50, 0, 50, 50)];
    [kotahelp setImage:[UIImage imageNamed:@"kotahelp"] forState:UIControlStateNormal];
    [self.navBarView addSubview:kotahelp];
    [kotahelp addTarget:self action:@selector(helpBtnClicked) forControlEvents:UIControlEventTouchUpInside];

    holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)];
    holder.backgroundColor = kUIColorGrayBackground;
    holder.alwaysBounceVertical = YES;
    [self.view addSubview:holder];

    UIView *choosMovieV = [[UIView alloc] initWithFrame:CGRectMake(0, 9, screentWith, 50)];
    [choosMovieV setBackgroundColor:[UIColor clearColor]];

    UIImageView *imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17.5, 15, 15)];
    imgV1.image = [UIImage imageNamed:@"kotaByMovie1"];

    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(33, 17.5, 290, 15)];
    lbl1.backgroundColor = [UIColor clearColor];
    lbl1.text = @"选择您希望约看的电影";
    lbl1.textColor = [UIColor orangeColor];
    lbl1.font = [UIFont systemFontOfSize:13];

    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(33, 49, screentWith, kDimensDividerHeight)];
    [line1 setBackgroundColor:kUIColorDivider];

    [choosMovieV addSubview:line1];
    [choosMovieV addSubview:imgV1];
    [choosMovieV addSubview:lbl1];

    [holder addSubview:choosMovieV];

    movieImagesView = [[KotaMovieImageView alloc] initWithFrame:CGRectMake(15, 70, screentWith - 15, 105)];
    [holder addSubview:movieImagesView];
    movieImagesView.wantSeeMovie = self.movie;
    movieImagesView.wantSee = self.wantSee;
    [movieImagesView updateLayout];

    CGFloat positionY = 180;
    UIView *saySomeV = [[UIView alloc] initWithFrame:CGRectMake(0, positionY, screentWith, 50)];
    [choosMovieV setBackgroundColor:[UIColor clearColor]];

    UIImageView *imgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17.5, 15, 15)];
    imgV2.image = [UIImage imageNamed:@"kotaByMovie2"];

    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(33, 17.5, 290, 15)];
    lbl2.backgroundColor = [UIColor clearColor];
    lbl2.text = @"说点什么";
    lbl2.textColor = [UIColor orangeColor];
    lbl2.font = [UIFont systemFontOfSize:13];

    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(33, 49, screentWith, kDimensDividerHeight)];
    [line2 setBackgroundColor:kUIColorDivider];

    [saySomeV addSubview:line2];
    [saySomeV addSubview:imgV2];
    [saySomeV addSubview:lbl2];
    [holder addSubview:saySomeV];

    positionY += 80;

    //语音模式
    keyBoardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    keyBoardButton.frame = CGRectMake(17, positionY, 45, 45);
    [keyBoardButton setBackgroundImage:[UIImage imageNamed:@"mic_keyboard"] forState:UIControlStateNormal];
    [keyBoardButton addTarget:self action:@selector(clickKeyboardButton:) forControlEvents:UIControlEventTouchUpInside];
    keyBoardButton.hidden = YES;
    [holder addSubview:keyBoardButton];

    //文字模式
    audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    audioButton.frame = keyBoardButton.frame;
    [audioButton setBackgroundImage:[UIImage imageNamed:@"mic_microphone"] forState:UIControlStateNormal];
    [audioButton addTarget:self action:@selector(clickAudioButton:) forControlEvents:UIControlEventTouchUpInside];
    audioButton.hidden = NO;
    [holder addSubview:audioButton];

    //说话条
    recordView = [[UIView alloc] initWithFrame:CGRectMake(75, positionY - 12, 215, 100)];
    recordView.hidden = YES;
    [holder addSubview:recordView];

    //按住说评论
    UIButton *supportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    supportButton.frame = CGRectMake(0, 16, 210, 35);
    supportButton.tag = kFavTag + 3;
    [supportButton setBackgroundImage:[UIImage imageNamed:@"mic_click_speak"] forState:UIControlStateNormal];
    [supportButton setBackgroundImage:[UIImage imageNamed:@"mic_click_speak_down"] forState:UIControlStateHighlighted];
    [supportButton addTarget:self action:@selector(startRec) forControlEvents:UIControlEventTouchDown];
    [supportButton addTarget:self
                      action:@selector(stopRec:)
            forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchCancel];
    [supportButton addTarget:self
                      action:@selector(cancelRec)
            forControlEvents:UIControlEventTouchUpOutside];
    [recordView addSubview:supportButton];

    //语音条背景
    //    soundBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(2, 24 + 50, 215, 31)];
    //    soundBarBg.image = [UIImage imageNamed:@"fav_sound_bar_bg_new.png"];
    //    soundBarBg.hidden = YES;
    textImageView = [[UIImageView alloc] initWithFrame:CGRectMake(75, positionY + 2, screentWith - 105, 87)];
    [holder addSubview:textImageView];
    textImageView.backgroundColor = [UIColor whiteColor];
    textImageView.hidden = NO;

    UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screentWith, 30)];

    [topView setBarStyle:UIBarStyleDefault];

    UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

    UIButton *btnToolBar = [UIButton buttonWithType:UIButtonTypeCustom];

    btnToolBar.frame = CGRectMake(2, 5, 50, 30);

    [btnToolBar addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];

    [btnToolBar setTitle:@"完成" forState:UIControlStateNormal];

    [btnToolBar setTitleColor:appDelegate.kkzBlue forState:UIControlStateNormal];

    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithCustomView:btnToolBar];

    NSArray *buttonsArray = [NSArray arrayWithObjects:btnSpace, doneBtn, nil];

    [topView setItems:buttonsArray];

    statusTextView = [[UITextView alloc] initWithFrame:CGRectMake(73, positionY + 2, screentWith - 108, 85)];
    statusTextView.delegate = self;
    statusTextView.backgroundColor = [UIColor clearColor];
    statusTextView.textColor = [UIColor blackColor];
    statusTextView.font = [UIFont systemFontOfSize:13];
    statusTextView.hidden = NO;
    [holder addSubview:statusTextView];

    [statusTextView setInputAccessoryView:topView];

    statusViewPlaceHolder = [[UITextView alloc] initWithFrame:CGRectMake(74, positionY + 1, screentWith - 108, 50)];
    statusViewPlaceHolder.text = @"写点什么吧..."; //（不能超过140个字）
    statusViewPlaceHolder.clipsToBounds = YES;
    statusViewPlaceHolder.hidden = NO;
    statusViewPlaceHolder.userInteractionEnabled = NO;
    statusViewPlaceHolder.font = [UIFont systemFontOfSize:13];
    statusViewPlaceHolder.backgroundColor = [UIColor clearColor];
    statusViewPlaceHolder.textColor = [UIColor r:186 g:186 b:186];
    [holder addSubview:statusViewPlaceHolder];

    numLabel = [[UILabel alloc] initWithFrame:CGRectMake(73, positionY + 95, 200, 15)];
    numLabel.font = [UIFont systemFontOfSize:15];
    numLabel.textAlignment = NSTextAlignmentLeft;
    numLabel.hidden = NO;
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.textColor = [UIColor r:149 g:149 b:149];
    numLabel.text = @"还可输入140个字";
    [holder addSubview:numLabel];

    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(20, positionY + 135, screentWith - 40, 40);
    confirmBtn.layer.cornerRadius = 3;
    [confirmBtn setTitle:@"提交" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    confirmBtn.backgroundColor = [UIColor r:0 g:140 b:255];

    [confirmBtn addTarget:self action:@selector(confirmShare) forControlEvents:UIControlEventTouchUpInside];
    [holder addSubview:confirmBtn];

    positionY += 190;
    UILabel *lblWarn = [[UILabel alloc] initWithFrame:CGRectMake(20, positionY, screentWith - 20 * 2, 45)];
    lblWarn.backgroundColor = [UIColor clearColor];
    lblWarn.font = [UIFont systemFontOfSize:14];
    lblWarn.numberOfLines = 0;
    lblWarn.text = @"请勿发表任何违反国家规定，广告或骚扰内容，一经发现将永久封禁。";
    lblWarn.textColor = [UIColor grayColor];
    lblWarn.contentMode = UIViewContentModeCenter;
    [holder addSubview:lblWarn];

    positionY += 80;

    holder.contentSize = CGSizeMake(screentWith, positionY);

    isText = YES;

    self.movieId = 0;

    UIImage *img = [UIImage imageNamed:@"kotaSucceedInitiate"];
    imgVKotaSucceed = [[UIView alloc] initWithFrame:CGRectMake(0, 0, img.size.width * (screentWith / img.size.width), (img.size.height + 50) * (screentWith / img.size.width))];
    [imgVKotaSucceed setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width * (screentWith / img.size.width), img.size.height * (screentWith / img.size.width))];
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.userInteractionEnabled = YES;
    imgV.image = img;
    [imgVKotaSucceed addSubview:imgV];
    imgVKotaSucceed.hidden = YES;

    CGFloat marginY = (screentWith - 137.5 * 2) / 3;
    RoundCornersButton *doneBtn0 = [[RoundCornersButton alloc] init];
    doneBtn0.frame = CGRectMake(marginY, CGRectGetMaxY(imgV.frame) - 42, 137.5, 35);
    doneBtn0.cornerNum = 1;
    doneBtn0.rimWidth = 1;
    doneBtn0.titleName = @"查看";
    doneBtn0.rimColor = appDelegate.kkzBlue;
    doneBtn0.titleFont = [UIFont systemFontOfSize:14];
    doneBtn0.titleColor = appDelegate.kkzBlue;
    doneBtn0.backgroundColor = [UIColor whiteColor];
    [doneBtn0 addTarget:self action:@selector(doneBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [imgVKotaSucceed addSubview:doneBtn0];

    RoundCornersButton *doneBtnYN = [[RoundCornersButton alloc] init];
    doneBtnYN.frame = CGRectMake(137.5 + marginY * 2, CGRectGetMaxY(imgV.frame) - 42, 137.5, 35);
    doneBtnYN.cornerNum = 1;
    doneBtnYN.rimWidth = 1;
    doneBtnYN.titleName = @"返回";
    doneBtnYN.rimColor = appDelegate.kkzBlue;
    doneBtnYN.titleFont = [UIFont systemFontOfSize:14];
    doneBtnYN.titleColor = appDelegate.kkzBlue;
    doneBtnYN.backgroundColor = [UIColor whiteColor];
    [doneBtnYN addTarget:self action:@selector(doneBtn1Clicked) forControlEvents:UIControlEventTouchUpInside];
    [imgVKotaSucceed addSubview:doneBtnYN];

    [holder addSubview:imgVKotaSucceed];

    holder.contentSize = CGSizeMake(screentWith, 500);

    [[NSNotificationCenter defaultCenter] addObserver:self

                                             selector:@selector(getTheKotaMovieId:)
                                                 name:@"kotaMovieId"
                                               object:nil];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.delegate = self;
    [holder addGestureRecognizer:tap];

    [self registerForKeyboardNotifications];
}

- (void)doneBtnClicked {
    [self popToViewControllerAnimated:NO];
    [appDelegate setSelectedPage:2 tabBar:YES];
}

- (void)doneBtn1Clicked {
    [self popViewControllerAnimated:YES];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShown:(NSNotification *)notification

{
    NSDictionary *info = [notification userInfo];
    CGRect endFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

    // 添加移动动画，使视图跟随键盘移动

    [UIView animateWithDuration:duration.doubleValue
                     animations:^{
                         [UIView setAnimationBeginsFromCurrentState:YES];
                         [UIView setAnimationCurve:[curve intValue]];
                         [holder setFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44 + endFrame.size.height)];
                         holder.contentOffset = CGPointMake(0, endFrame.size.height - 80);
                     }];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification

{
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue
                     animations:^{
                         [UIView setAnimationBeginsFromCurrentState:YES];
                         [UIView setAnimationCurve:[curve intValue]];
                         [holder setFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)];
                         holder.contentOffset = CGPointMake(0, 0);
                     }];
}

- (void)removeForKeyboardNotifications {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)getTheKotaMovieId:(NSNotification *)notification {

    self.movieId = notification.userInfo[@"movirId"];
}

- (void)touchAtPoint:(CGPoint)point {

    if (!CGRectContainsPoint(statusViewPlaceHolder.frame, point)) {
        [statusTextView resignFirstResponder];
        return;
    }
    if (!CGRectContainsPoint(recordView.frame, point) && recordView.hidden == NO) {
        [poplistview playSound];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:holder];
    [self touchAtPoint:point];
}

//进入文字输入模式。    //显示键盘

- (void)clickKeyboardButton:(id)sender {
    numLabel.text = @"还可输入140个字";
    isText = YES;
    recordLength = 0;
    statusTextView.text = nil;
    keyBoardButton.hidden = YES;
    recordView.hidden = YES;
    audioButton.hidden = NO;
    textImageView.hidden = NO;
    numLabel.hidden = NO;
    statusTextView.hidden = NO;
    statusViewPlaceHolder.hidden = NO;
    poplistview.hidden = YES;
    //    soundBarBg.hidden = YES;
}

//进入语音模式。隐藏键盘

- (void)clickAudioButton:(id)sender {
    numLabel.text = @"还可输入0个字";
    isText = NO;
    statusTextView.text = nil;
    recordLength = 0;
    keyBoardButton.hidden = NO;
    recordView.hidden = NO;
    audioButton.hidden = YES;
    numLabel.hidden = YES;
    textImageView.hidden = YES;
    statusTextView.hidden = YES;
    statusViewPlaceHolder.hidden = YES;
    [self hideKeyboard];
}

- (void)hideKeyboard {
    [statusTextView resignFirstResponder];
}

#pragma mark text view delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView

{
    if (textView.text.length > 0) {
        statusViewPlaceHolder.hidden = YES;
    } else {
        statusViewPlaceHolder.hidden = NO;
    }
    NSInteger existTextNum = [textView.text length];
    numLabel.text = [NSString stringWithFormat:@"还可输入%d个字", (int) (140 - existTextNum)];
}
- (NSInteger)getToInt:(NSString *)strtemp {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *da = [strtemp dataUsingEncoding:enc];
    return [da length];
}

- (void)confirmShare {

    [poplistview recordAudioDidFinishPlaying];

    confirmBtn.userInteractionEnabled = NO;
    if (statusTextView.text.length > 140) {
        [appDelegate showAlertViewForTitle:@"" message:@"输入字数不能超过140个" cancelButton:@"OK"];
        confirmBtn.userInteractionEnabled = YES;
        return;
    }
    if (score == 0 && self.isCollect) {
    }
    [self addFavoriteMovie];
}

- (void)addFavoriteMovie {

    void (^doAction)() = ^() {

        NSString *mp3FileName = @"Mp3File";
        mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
        NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
        NSData *amr = [NSData dataWithContentsOfFile:mp3FilePath];

        if (isText) { //文字评论
            [statusTextView resignFirstResponder];
            if (self.wantSee) {
                self.movieId = self.movie.movieId;
            }
            if (appDelegate.isAuthorized) {

                NSString *str;
                str = [statusTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

                if (str.length == 0) {

                    //                        [appDelegate showAlertViewForTitle:@"" message:@"写点儿什么吧~~" cancelButton:@"OK"];
                    [self performSelector:@selector(showalertView:) withObject:@"写点儿什么吧~~" afterDelay:.6];
                    confirmBtn.userInteractionEnabled = YES;
                    return;
                } else if (self.movieId == 0) {

                    [self performSelector:@selector(showalertView:) withObject:@"请选取要发起约电影的影片~~" afterDelay:.6];

                    confirmBtn.userInteractionEnabled = YES;
                    return;
                } else {
                    VoiceTask *task = [[VoiceTask alloc] initUploadKotaCommentVoiceWithData:nil
                                                                                   forMovie:[self.movieId stringValue]
                                                                                commentType:@"1"
                                                                                    content:str
                                                                                     length:0
                                                                                   finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                                       [self uploadCommentFinished:userInfo status:succeeded];
                                                                                   }];
                    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
                    }
                }
            } else {
                confirmBtn.userInteractionEnabled = YES;
                
                [[UserManager shareInstance] gotoLoginControllerFrom:self];
                
//                LoginViewController *ctr = [[LoginViewController alloc] init];
//                [self pushViewController:ctr animation:CommonSwitchAnimationBounce];
            }
        } else { //语音评论

            if (self.wantSee) {
                self.movieId = self.movie.movieId;
            }
            if (appDelegate.isAuthorized) {
                if (self.movieId == 0) {
                    [appDelegate showAlertViewForTitle:@"" message:@"请选取要发起约电影的影片~~" cancelButton:@"OK"];
                    confirmBtn.userInteractionEnabled = YES;
                    return;
                }
                if (recordLength == 0) {
                    [appDelegate showAlertViewForTitle:@"" message:@"多说点儿吧~" cancelButton:@"OK"];
                    confirmBtn.userInteractionEnabled = YES;
                    return;
                }
                VoiceTask *task = [[VoiceTask alloc] initUploadKotaCommentVoiceWithData:amr
                                                                               forMovie:[self.movieId stringValue]
                                                                            commentType:@"2"
                                                                                content:@""
                                                                                 length:recordLength
                                                                               finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                                   [self uploadCommentFinished:userInfo status:succeeded];
                                                                               }];
                if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
                }
            } else {
                confirmBtn.userInteractionEnabled = YES;
                
                [[UserManager shareInstance] gotoLoginControllerFrom:self];
                
//                LoginViewController *ctr = [[LoginViewController alloc] init];
//                [self pushViewController:ctr animation:CommonSwitchAnimationBounce];
            }
        }
    };
    doAction();
}

#pragma mark - Notification
- (void)uploadCommentFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    if (succeeded) {
        imgVKotaSucceed.hidden = NO;
    } else {
        confirmBtn.userInteractionEnabled = YES;
        NSDictionary *logicError = [userInfo objectForKey:@"LogicError"];
        [appDelegate showAlertViewForTitle:@""
                                   message:[logicError kkz_stringForKey:@"error"]
                              cancelButton:@"知道了"];
    }
    recordLength = 0;
}

#pragma mark - UITouch

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

#pragma mark gestureRecognizer view delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch

{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    if ([touch.view isKindOfClass:[RatingView class]]) {
        return NO;
    }
    return YES;
}

#pragma mark Rating view delegate

- (void)ratingChanged:(CGFloat)newRating {
    score = newRating * 2;
    scoreLabel.text = [NSString stringWithFormat:@"%.1f", newRating * 2];
}

#pragma mark Record relate

- (void)startRec {

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [audioSession setActive:YES error:&error];
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {

            if (granted) {
                [self setForRecording];
            } else {
                [appDelegate showAlertViewForTitle:@"您还不能使用麦克风" message:@"请到系统设置-隐私-麦克风中打开应用的权限" cancelButton:@"OK"];
                return;
            }
        }];
    } else {
        [self setForRecording];
    }
}

- (void)timerUpdate {
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

- (void)convertMp3Finish

{
    if (recordLength < 1.0) {
        [appDelegate showAlertViewForTitle:@""
                                   message:@"请多说点~"
                              cancelButton:@"OK"];

    } else {
        [self showSelfSound];
    }
}

//显示语音条

- (void)showSelfSound {
    CGFloat xWidth = 180;
    CGFloat yHeight = 40.0f;
    if (!hasVoice) {
        poplistview = [[FavRecordView alloc] initWithFrame:CGRectMake(-30, 24 + 41, xWidth, yHeight)];
        poplistview.delegate = self;
        poplistview.popViewAnimation = PopViewAnimationFade;
        [recordView addSubview:poplistview];
        //        soundBarBg.hidden = NO;
        cancelBtn.hidden = NO;
    }
    [poplistview updateWithType:shuoAttitude andLength:recordLength];
    hasVoice = YES;
}

- (void)stopRec:(id)selector {
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                [self stopForRecording:selector];
            } else {
            }
        }];
    } else {
        [self stopForRecording:selector];
    }
}

- (void)cancelRec {
    [self hideShuoWave];
    [_timer invalidate];
    _timer = nil;
    [recorder stop];
    recorder = nil;
}
#pragma mark FavRecordView view delegate

- (void)delSoundComment {
    recordLength = 0;
    hasVoice = NO;
    //    soundBarBg.hidden = YES;
}

#pragma mark Sound & Vedio

- (void)showShuoWave {
    shuoHolder = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentHeight)];
    shuoHolder.backgroundColor = [[UIColor blackColor] alpha:.5];
    [appDelegate.window addSubview:shuoHolder];
    shuoTipView = [[MicView alloc] initWithFrame:CGRectMake(0, (screentContentHeight - screentWith) / 2.0 - 50, screentWith, screentWith)];
    shuoTipView.userInteractionEnabled = YES;
    [shuoHolder addSubview:shuoTipView];
    durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 160 + 50, screentWith, 14)];
    durationLabel.backgroundColor = [UIColor clearColor];
    durationLabel.textColor = [UIColor whiteColor];
    durationLabel.text = @"";
    durationLabel.font = [UIFont systemFontOfSize:12];
    durationLabel.textAlignment = NSTextAlignmentCenter;
    durationLabel.numberOfLines = 2;
    [shuoTipView addSubview:durationLabel];
}

- (void)hideShuoWave {
    if (shuoHolder && [shuoHolder superview]) {
        [shuoTipView stopAnimation];
        [shuoHolder removeFromSuperview];
    }
}

- (void)helpBtnClicked {

    [statusTextView resignFirstResponder];

    KotaHelpInfoViewController *helpVc = [[KotaHelpInfoViewController alloc] init];
    [self pushViewController:helpVc animation:CommonSwitchAnimationSwipeR2L];
}

- (void)setForRecording {
    if (poplistview && [poplistview superview]) {
        [poplistview dismiss];
        cancelBtn.hidden = YES;
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
                                                        [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                                                        [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                                        nil];
    NSURL *recordedFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]];
    NSError *error;
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

- (void)stopForRecording:(id)selector {

    [self hideShuoWave];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    if (recorder) {
        [recorder stop];
        recorder = nil;
    }
    UIButton *btn = (UIButton *) selector;
    shuoAttitude = 1;
    switch (btn.tag) {
        case kFavTag + 3: {
            shuoAttitude = 1;
        } break;
        case kFavTag + 4: {
            shuoAttitude = 2;
        } break;
        default:
            break;
    }
    NSString *cafFilePath = [NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cafFilePath]) {
        //抠电影正在访问您的麦克风，选择”好“程序闪退或卡死
        return;
    }
    NSString *mp3FileName = @"Mp3File";
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];

    @try {
        NSInteger read, write;
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb"); //source
        fseek(pcm, 4 * 1024, SEEK_CUR); //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb"); //output
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE * 2];
        unsigned char mp3_buffer[MP3_SIZE];
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 8000);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        do {
            read = fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, (int) read, mp3_buffer, MP3_SIZE);
            fwrite(mp3_buffer, write, 1, mp3);
        } while (read != 0);
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        DLog(@"%@", [exception description]);
    }
    @finally {
        [self performSelectorOnMainThread:@selector(convertMp3Finish)
                                 withObject:nil
                              waitUntilDone:YES];
    }
}

- (void)dismissKeyBoard {
    [statusTextView resignFirstResponder];
}

- (void)showalertView:(NSString *)message {
    [appDelegate showAlertViewForTitle:@"" message:message cancelButton:@"OK"];
}

@end
