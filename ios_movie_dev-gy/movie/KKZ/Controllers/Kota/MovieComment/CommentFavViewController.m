//
//  CommentFavViewController.m
//  KoMovie
//
//  Created by gree2 on 15/11/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import "Comment.h"
#import "CommentFavViewController.h"
#import "CommentSucceedViewController.h"
#import "DataEngine.h"
#import "FavoriteTask.h"
#import "KKZUser.h"
#import "MemContainer.h"
#import "TaskQueue.h"
#import "VoiceTask.h"
#import "lame.h"
#import <QuartzCore/QuartzCore.h>

#define CHeight 50
#define kFavTag 1231
#define MAX_TEXT_NUM 140

@implementation CommentFavViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PoptoCommentList" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.kkzTitleLabel.text = self.titleName;

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 3, 60, 38);
    [backBtn setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9, 29)];
    [backBtn addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:backBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(poptoCommentList:) name:@"PoptoCommentList" object:nil];

    holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44 + self.contentPositionY, screentWith, screentContentHeight)];
    [self.view addSubview:holder];
    holder.contentSize = CGSizeMake(screentWith, screentHeight);
    holder.backgroundColor = [UIColor r:245 g:245 b:245];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 22, 35, 15)];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor r:67 g:67 b:67];
    label.text = @"评分:";
    [holder addSubview:label];

    //星星
    starView = [[RatingView alloc] initWithFrame:CGRectMake(60, 15, 150, 30)];
    [starView setImagesDeselected:@"fav_star_no_cn_match"
                   partlySelected:@"fav_star_half_co"
                     fullSelected:@"fav_star_full_co"
                         iconSize:CGSizeMake(25, 25)
                      marginWidth:5
                      andDelegate:self];
    starView.userInteractionEnabled = YES;
    [starView displayRating:0];
    [holder addSubview:starView];

    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 22, 60, 15)];
    scoreLabel.font = [UIFont systemFontOfSize:15];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.textColor = [UIColor r:0 g:149 b:255];
    scoreLabel.text = @"0.0";
    [holder addSubview:scoreLabel];

    starH = 0;
    if (self.showStar) {
        label.hidden = NO;
        starView.hidden = NO;
        scoreLabel.hidden = NO;
        starH = 0;
    } else {
        label.hidden = YES;
        starView.hidden = YES;
        scoreLabel.hidden = YES;
        starH = 20;
    }
    //语音模式
    keyBoardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    keyBoardButton.frame = CGRectMake(17, 55 - starH, 45, 45);
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
    recordView = [[UIView alloc] initWithFrame:CGRectMake(75, 43 - starH, 215, 60)];
    recordView.backgroundColor = [UIColor clearColor];
    recordView.hidden = YES;
    [holder addSubview:recordView];

    //按住说评论
    UIButton *supportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    supportButton.frame = CGRectMake(4, 16, 210, 35);
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

    textImageView = [[UIImageView alloc] initWithFrame:CGRectMake(75, 57 - starH, screentWith - 105, 87)];
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

    statusTextView = [[UITextView alloc] initWithFrame:CGRectMake(75, 57 - starH, screentWith - 110, 85)];
    statusTextView.delegate = self;
    statusTextView.backgroundColor = [UIColor clearColor];
    statusTextView.textColor = [UIColor blackColor];
    statusTextView.font = [UIFont systemFontOfSize:13];
    statusTextView.hidden = NO;
    [holder addSubview:statusTextView];

    [statusTextView setInputAccessoryView:topView];

    statusViewPlaceHolder = [[UITextView alloc] initWithFrame:CGRectMake(76, 56 - starH, screentWith - 108, 50)];
    statusViewPlaceHolder.text = @"写点什么吧..."; //（不能超过140个字）
    statusViewPlaceHolder.clipsToBounds = YES;
    statusViewPlaceHolder.hidden = NO;
    statusViewPlaceHolder.userInteractionEnabled = NO;
    statusViewPlaceHolder.font = [UIFont systemFontOfSize:13];
    statusViewPlaceHolder.backgroundColor = [UIColor clearColor];
    statusViewPlaceHolder.textColor = [UIColor r:186 g:186 b:186];
    [holder addSubview:statusViewPlaceHolder];

    numLabel = [[UILabel alloc] initWithFrame:CGRectMake(73, 150 - starH, 200, 15)];
    numLabel.font = [UIFont systemFontOfSize:15];
    numLabel.textAlignment = NSTextAlignmentLeft;
    numLabel.hidden = NO;
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.textColor = [UIColor r:149 g:149 b:149];
    numLabel.text = @"还可输入140个字";
    [holder addSubview:numLabel];

    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(20, 190 - starH, screentWith - 40, 40);
    confirmBtn.layer.cornerRadius = 3;
    //        [confirmBtn setTitle:@"发表评论" forState:UIControlStateNormal];
    [confirmBtn setTitle:self.buttonTitle forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    confirmBtn.backgroundColor = [UIColor r:0 g:140 b:255];
    [confirmBtn addTarget:self action:@selector(confirmShare) forControlEvents:UIControlEventTouchUpInside];
    [holder addSubview:confirmBtn];

    isText = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.delegate = self;
    [holder addGestureRecognizer:tap];

    [self clickKeyboardButton:audioButton];
}

- (void)poptoCommentList:(NSNotification *)notification {
    [self popViewControllerAnimated:NO];
}

- (void)touchAtPoint:(CGPoint)point {

    if (!CGRectContainsPoint(CGRectMake(30, 0, 200, 50), point)) {
        [statusTextView resignFirstResponder];
        return;
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:holder];
    [self touchAtPoint:point];
}

//进入文字输入模式。    //显示键盘
- (void)clickKeyboardButton:(id)sender {
    confirmBtn.userInteractionEnabled = YES;
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
    soundBarBg.hidden = YES;
    cancelBtn.hidden = YES;
}

//进入语音模式。隐藏键盘
- (void)clickAudioButton:(id)sender {
    confirmBtn.userInteractionEnabled = YES;
    numLabel.text = @"还可输入140个字";
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

    if (textView == statusTextView) {
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {

    if ([textView.text length] > 0) {
        statusViewPlaceHolder.text = @"";
    } else {
        statusViewPlaceHolder.text = @"写点什么吧...";
    }
    int existTextNum = (int) [textView.text length];
    int remain = 140 - existTextNum;
    numLabel.text = [NSString stringWithFormat:@"还可输入%d个字", remain];
}

- (NSInteger)getToInt:(NSString *)strtemp

{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *da = [strtemp dataUsingEncoding:enc];
    return [da length];
}

- (void)cancelShare {
    if (poplistview && [poplistview superview]) {
        [poplistview dismiss];
        cancelBtn.hidden = YES;
    }
}

- (void)confirmShare {
    DLog(@"confirmShare");
    confirmBtn.userInteractionEnabled = NO;

    if (statusTextView.text.length > 140) {
        [appDelegate showAlertViewForTitle:@"" message:@"输入字数不能超过140个" cancelButton:@"OK"];
        confirmBtn.userInteractionEnabled = YES;
        return;
    }
    if (score == 0 && self.isCollect) {
        [appDelegate showAlertViewForTitle:@"" message:@"亲，请先给电影打分喔~" cancelButton:@"OK"];
        confirmBtn.userInteractionEnabled = YES;
        return;
    }
    if (keyBoardButton.hidden == NO && audioButton.hidden == YES) {
        statusTextView.text = nil;
    } else if (keyBoardButton.hidden == YES && audioButton.hidden == NO && !self.isCollect) {
        recordLength = 0;
        if (statusTextView.text.length <= 0) {
            [appDelegate showAlertViewForTitle:@"" message:@"请输入内容" cancelButton:@"OK"];
            confirmBtn.userInteractionEnabled = YES;
            return;
        }
    } else {
    }

    [self addFavoriteMovie];
}

- (void)addFavoriteMovie {
    void (^doAction)() = ^() {

        NSString *mp3FileName = @"Mp3File";
        mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
        NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];

        NSData *amr = [NSData dataWithContentsOfFile:mp3FilePath];
        //        [recordAudio startPlayAMR:amr];

        DLog(@"length-----------%d", recordLength);

        if (self.isCollect) { //评分

            if (self.MovieComment) {

                NSString *str = [statusTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

                if (str.length > 0 || recordLength > 0) {
                    self.hasMovieScoreInfo = YES;
                } else {
                    self.hasMovieScoreInfo = NO;
                }

                FavoriteTask *task = [[FavoriteTask alloc] initAddFavMovie:self.targetId
                                                                 withPoint:score
                                                             withAudioData:amr
                                                           withAudioLength:recordLength
                                                                  withText:str
                                                                  finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                                      [self addMovieFavFinished:userInfo status:succeeded];

                                                                  }];

                if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
                    [appDelegate showIndicatorWithTitle:@"正在发表评论..."
                                               animated:YES
                                             fullScreen:NO
                                           overKeyboard:YES
                                            andAutoHide:NO];
                }

            } else {
            }

        } else { //评论

            if (isText) { //文字评论

                NSString *str = [statusTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

                if (str.length == 0) {

                    [appDelegate showAlertViewForTitle:@"" message:@"写点儿什么吧~~" cancelButton:@"OK"];

                    return;
                }
                if (self.MovieComment) {

                    VoiceTask *task;

                    //判断一下是否需要订单Id,需要传订单Id就传订单Id
                    if (self.orderId) {
                        task = [[VoiceTask alloc] initUploadCommentWithString:str
                                                                     forMovie:self.targetId
                                                                    withPoint:score
                                                                  withOrderId:self.orderId
                                                                   targetType:CommentTargetTypeMovie
                                                                     finished:^(BOOL succeeded,
                                                                                NSDictionary *userInfo) {
                                                                         [self uploadCommentFinished:userInfo
                                                                                                status:succeeded];
                                                                     }];
                    } else {
                        task = [[VoiceTask alloc] initUploadCommentWithString:str
                                                                     forMovie:self.targetId
                                                                      referId:[NSString stringWithFormat:@"%u", self.commentId]
                                                                    withPoint:score
                                                                   targetType:CommentTargetTypeMovie
                                                                     finished:^(BOOL succeeded,
                                                                                NSDictionary *userInfo) {
                                                                         [self uploadCommentFinished:userInfo
                                                                                                status:succeeded];
                                                                     }];
                    }

                    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
                        [appDelegate showIndicatorWithTitle:@"发送中"
                                                   animated:YES
                                                 fullScreen:NO
                                               overKeyboard:YES
                                                andAutoHide:NO];
                    }
                } else {
                    VoiceTask *task = [[VoiceTask alloc] initUploadCommentWithString:statusTextView.text
                                                                            forMovie:self.targetId
                                                                             referId:[NSString stringWithFormat:@"%u", self.commentId]
                                                                           withPoint:score
                                                                          targetType:CommentTargetTypeCinema
                                                                            finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                                [self uploadCommentFinished:userInfo status:succeeded];
                                                                            }];

                    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
                        [appDelegate showIndicatorWithTitle:@"发送中"
                                                   animated:YES
                                                 fullScreen:NO
                                               overKeyboard:YES
                                                andAutoHide:NO];
                    }
                }

            } else { //语音评论

                if (recordLength == 0) {
                    confirmBtn.userInteractionEnabled = YES;
                    [appDelegate showAlertViewForTitle:@"" message:@"多说点儿吧~" cancelButton:@"OK"];
                    return;
                }

                if (self.MovieComment) {

                    VoiceTask *task;

                    //判断一下是否需要订单Id,需要传订单Id就传订单Id
                    if (self.orderId) {
                        task = [[VoiceTask alloc] initUploadVoiceWithData:amr
                                                                 forMovie:self.targetId
                                                                  orderId:self.orderId
                                                                   length:recordLength
                                                                withPoint:score
                                                               targetType:CommentTargetTypeMovie
                                                                 finished:^(BOOL succeeded,
                                                                            NSDictionary *userInfo) {
                                                                     [self uploadCommentFinished:userInfo
                                                                                            status:succeeded];
                                                                 }];
                    } else {
                        task = [[VoiceTask alloc] initUploadVoiceWithData:amr
                                                                 forMovie:self.targetId
                                                                   length:recordLength
                                                                  referId:[NSString stringWithFormat:@"%u", self.commentId]
                                                                withPoint:score
                                                               targetType:CommentTargetTypeMovie
                                                                 finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                     [self uploadCommentFinished:userInfo
                                                                                            status:succeeded];
                                                                 }];
                    }

                    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
                        [appDelegate showIndicatorWithTitle:@"上传中"
                                                   animated:YES
                                                 fullScreen:NO
                                               overKeyboard:YES
                                                andAutoHide:NO];
                    }
                } else {
                    VoiceTask *task = [[VoiceTask alloc] initUploadVoiceWithData:amr
                                                                        forMovie:self.targetId
                                                                          length:recordLength
                                                                         referId:[NSString stringWithFormat:@"%u", self.commentId]
                                                                       withPoint:score
                                                                      targetType:CommentTargetTypeCinema
                                                                        finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                            [self uploadCommentFinished:userInfo status:succeeded];
                                                                        }];

                    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
                        [appDelegate showIndicatorWithTitle:@"上传中"
                                                   animated:YES
                                                 fullScreen:NO
                                               overKeyboard:YES
                                                andAutoHide:NO];
                    }
                }
            }
        }
        recordLength = 0;
    };

    doAction();
}

- (void)showRecordView {
}

#pragma mark - Notification
- (void)addMovieFavFinished:(NSDictionary *)dict status:(BOOL)succeeded {
    [appDelegate hideIndicator];
    NSDictionary *result = [dict objectForKey:@"result"];

    NSNumber *existed = nil;

    Comment *current = (Comment *) [[MemContainer me] instanceFromDict:result
                                                                 clazz:[Comment class]
                                                                 exist:&existed];

    current.commentTime = [dict kkz_dateForKey:@"createTime" withFormat:@"yyyy-MM-dd HH:mm:ss"];

    //    KKZUser *user = [KKZUser getUserWithId:[DataEngine sharedDataEngine].userId.intValue];
    //    current.userAvatar = user.avatarPath;

    NSMutableDictionary *scoreObj = [NSMutableDictionary dictionaryWithObjectsAndKeys:current, @"current", nil];

    if (succeeded) {
        if (self.hasMovieScoreInfo) {
            self.collectFinished(YES, scoreObj);
        }
        [appDelegate showIndicatorWithTitle:@"评分成功啦!"
                                   animated:NO
                                 fullScreen:NO
                               overKeyboard:YES
                                andAutoHide:YES];

        [self performSelector:@selector(cancelViewController) withObject:nil afterDelay:0.5];

    } else {
        confirmBtn.userInteractionEnabled = YES;
        [appDelegate showAlertViewForTaskInfo:dict];
    }
}

- (void)uploadCommentFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    [appDelegate hideIndicator];

    if (succeeded) {

        self.collectFinished(YES, userInfo);

        NSString *shareContent = userInfo[@"shareContent"];
        NSString *sharePicUrl = userInfo[@"sharePicUrl"];
        NSString *shareUrl = userInfo[@"shareUrl"];
        NSString *shareDetailUrl = userInfo[@"shareDetailUrl"];
        NSString *titile = userInfo[@"titile"];

        if (shareUrl.length > 0) {

            CommentSucceedViewController *ctr = [[CommentSucceedViewController alloc] init];
            ctr.shareContent = shareContent;
            ctr.sharePicUrl = sharePicUrl;
            ctr.titile = titile;
            ctr.shareUrl = shareUrl;
            ctr.shareDetailUrl = shareDetailUrl;
            [ctr loadURL:shareUrl];
            [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];

        } else {
            [appDelegate showIndicatorWithTitle:@"评论成功啦!"
                                       animated:NO
                                     fullScreen:NO
                                   overKeyboard:YES
                                    andAutoHide:YES];
        }
        [self delSoundComment];
        [self popViewControllerAnimated:YES];

    } else {

        confirmBtn.userInteractionEnabled = YES;
        NSDictionary *logicError = [userInfo objectForKey:@"LogicError"];

        [appDelegate showAlertViewForTitle:@""

                                   message:[logicError kkz_stringForKey:@"error"]

                              cancelButton:@"知道了"];

        [self delSoundComment];
    }
}

#pragma mark - UITouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}

#pragma mark gestureRecognizer view delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
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
    DLog(@"%f", score);
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

                DLog(@"Enabled Mic....1");
                if (poplistview && [poplistview superview]) {
                    [poplistview dismiss];
                    soundBarBg.hidden = YES;
                    cancelBtn.hidden = YES;
                }
                [self showShuoWave];
                recordLength = 0.0;
                durationLabel.text = @"";
                DLog(@"Enabled Mic....2");

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
                DLog(@"Enabled Mic....3");

                NSError *error;
                recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:recordSetting error:&error];
                DLog(@"%@", [error description]);

                [recorder prepareToRecord];
                [recorder record];
                DLog(@"Enabled Mic....4");

                _timer = [NSTimer scheduledTimerWithTimeInterval:.01f
                                                          target:self
                                                        selector:@selector(timerUpdate)
                                                        userInfo:nil
                                                         repeats:YES];
                DLog(@"Enabled Mic....5");

            } else {
                [appDelegate showAlertViewForTitle:@"您还不能使用麦克风" message:@"请到系统设置-隐私-麦克风中打开应用的权限" cancelButton:@"OK"];
                return;
                DLog(@"Disabled Mic");
            }
        }];
    } else {
        if (poplistview && [poplistview superview]) {
            [poplistview dismiss];
            soundBarBg.hidden = YES;
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
    //animation.delegate = self;
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

- (void)convertMp3Finish {
    confirmBtn.userInteractionEnabled = YES;
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
    CGFloat xWidth = 180; //holder.frame.size.width-50;
    CGFloat yHeight = 52.0f;
    if (!hasVoice) {
        poplistview = [[FavRecordView alloc] initWithFrame:CGRectMake(47, 68 + 45 - starH, xWidth, yHeight)];
        poplistview.delegate = self;
        poplistview.popViewAnimation = PopViewAnimationFade;

        [holder addSubview:poplistview];
        soundBarBg.hidden = NO;
        cancelBtn.hidden = NO;
    }

    [poplistview updateWithType:shuoAttitude andLength:recordLength];
    hasVoice = YES;
}

- (void)stopRec:(id)selector {

    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
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

                    FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb"); //source卡主了
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

            } else {
                DLog(@"Disabled Mic");
            }
        }];
    } else {
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
    hasVoice = NO;
    soundBarBg.hidden = YES;
    cancelBtn.hidden = YES;
    recordLength = 0;
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:NO];
    [statusTextView resignFirstResponder];
}

- (void)dismissKeyBoard {
    [statusTextView resignFirstResponder];
}

- (BOOL)showBackButton {
    return NO;
}

- (BOOL)showTitleBar {
    return YES;
}
- (BOOL)showNavBar {
    return YES;
}

@end
