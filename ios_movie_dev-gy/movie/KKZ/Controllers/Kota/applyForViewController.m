//
//  约电影 - 详情 - 申请约电影
//
//  Created by avatar on 14-11-19.
//  Copyright (c) 2014年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AudioPlayerManager.h"
#import "Comment.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "KKZUser.h"
#import "KotaHeadImageView.h"
#import "KotaHelpInfoViewController.h"
#import "KotaMovieImageView.h"
#import "KotaTask.h"
#import "MemContainer.h"
#import "TaskQueue.h"
#import "UIAlertView+Blocks.h"
#import "VoiceTask.h"
#import "applyForViewController.h"
#import "kotaSucceedApplyViewController.h"
#import "lame.h"
#import "UserManager.h"

#define kFavTag 1231

@interface applyForViewController ()

@end

@implementation applyForViewController

- (void)dealloc {
    [self removeForKeyboardNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 3, 60, 38);
    [backBtn setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9, 29)];
    [backBtn addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:backBtn];

    self.kkzTitleLabel.text = @"约电影";

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(screentWith - 50, 0, 50, 50)];
    [btn setImage:[UIImage imageNamed:@"kotahelp"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(helpBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:btn];

    holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)];
    holder.backgroundColor = [UIColor colorWithRed:237 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1.0];
    holder.alwaysBounceVertical = YES;
    [self.view addSubview:holder];

    UIView *choosMovieV = [[UIView alloc] initWithFrame:CGRectMake(0, 9, screentWith, 50)];
    [choosMovieV setBackgroundColor:[UIColor clearColor]];

    UIImageView *imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17.5, 15, 15)];
    imgV1.image = [UIImage imageNamed:@"kotaByMovie1"];
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(30, 17.5, 290, 15)];
    lbl1.backgroundColor = [UIColor clearColor];
    lbl1.text = @"对方的观影概况";
    lbl1.textColor = [UIColor orangeColor];
    lbl1.font = [UIFont systemFontOfSize:13];

    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 49, screentWith, 1)];
    [line1 setBackgroundColor:[UIColor colorWithRed:223 / 255.0 green:223 / 255.0 blue:223 / 255.0 alpha:1.0]];
    [choosMovieV addSubview:line1];
    [choosMovieV addSubview:imgV1];
    [choosMovieV addSubview:lbl1];

    [holder addSubview:choosMovieV];

    UIView *objectInfo = [[UIView alloc] initWithFrame:CGRectMake(0, 70, screentWith, 100)];
    [objectInfo setBackgroundColor:[UIColor clearColor]];

    //头像
    CGRect avatarRect = CGRectMake(13, 20, 60, 60);
    avatarView = [[UIImageView alloc] initWithFrame:avatarRect];
    avatarView.contentMode = UIViewContentModeScaleAspectFit;
    avatarView.clipsToBounds = YES;
    [objectInfo addSubview:avatarView];

    CALayer *l = avatarView.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:30.0];

    lblShareNickname = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 90, 20)];
    lblShareNickname.textColor = [UIColor grayColor];
    lblShareNickname.font = [UIFont systemFontOfSize:16];
    lblShareNickname.backgroundColor = [UIColor clearColor];
    [objectInfo addSubview:lblShareNickname];

    //把头像切成圆角
    [avatarView loadImageWithURL:self.shareHeadimg andSize:ImageSizeMiddle];

    CGSize lblShareNicknameSize = [self.shareNickname sizeWithFont:[UIFont systemFontOfSize:16]];
    CGFloat w = screentWith - 100;
    if (lblShareNicknameSize.width < screentWith - 100) {
        w = lblShareNicknameSize.width;
    }
    lblShareNickname.frame = CGRectMake(80, 20, w, lblShareNicknameSize.height);
    lblShareNickname.text = self.shareNickname;

    lblFilmName = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, screentWith - 95, 20)];
    lblFilmName.textColor = [UIColor grayColor];
    lblFilmName.font = [UIFont systemFontOfSize:14];
    lblFilmName.backgroundColor = [UIColor clearColor];
    [objectInfo addSubview:lblFilmName];

    if ([self.filmName isEqualToString:@"(null)"]) {
        lblFilmName.text = @"";
    } else {
        if (self.filmName.length) {
            lblFilmName.text = [NSString stringWithFormat:@"《%@》", self.filmName];
        } else {
            lblFilmName.text = @"";
        }
    }

    if ([self.cinemaName isEqual:[NSNull null]]) {

        self.cinemaNameType = @"";
    } else if ([self.cinemaName isEqualToString:@"(null)"]) {
        self.cinemaNameType = @"";

    } else if ([self.cinemaName isEqualToString:@"<null>"]) {
        self.cinemaNameType = @"";
    } else {
        self.cinemaNameType = self.cinemaName;
    }

    lblCinemaName = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, screentWith - 95, 20)];
    lblCinemaName.textColor = [UIColor grayColor];
    lblCinemaName.font = [UIFont systemFontOfSize:14];
    lblCinemaName.backgroundColor = [UIColor clearColor];
    [objectInfo addSubview:lblCinemaName];
    lblCinemaName.text = self.cinemaNameType;

    lblFilmTime = [[UILabel alloc] initWithFrame:CGRectMake(80, 80, screentWith - 80, 20)];
    lblFilmTime.textColor = [UIColor grayColor];
    lblFilmTime.font = [UIFont systemFontOfSize:14];
    lblFilmTime.backgroundColor = [UIColor clearColor];
    [objectInfo addSubview:lblFilmTime];

    if ([self.screenDegree isEqualToNumber:@2]) {
        self.screenDegreeType = @"2D";
    } else if ([self.screenDegree isEqualToNumber:@3]) {
        self.screenDegreeType = @"3D";
    } else if ([self.screenDegree isEqualToNumber:@4]) {
        self.screenDegreeType = @"4D";
    } else {
        self.screenDegreeType = @"";
    }

    if ([self.screenSize isEqual:@0]) {
        self.screenSizeType = @"普通";
    } else if ([self.screenSize isEqual:@1]) {
        self.screenSizeType = @"imax";
    } else if ([self.screenSize isEqual:@2]) {
        self.screenSizeType = @"dmax";
    }

    if ([self.createTime isEqual:[NSNull null]]) {
        self.createTimeType = @"";
    } else if ([[NSString stringWithFormat:@"%@", [[DateEngine sharedDateEngine] shortDateStringFromDateNYR:self.createTime]] isEqualToString:@"(null)"]) {
        self.createTimeType = @"";
    } else if ([[NSString stringWithFormat:@"%@", [[DateEngine sharedDateEngine] shortDateStringFromDateNYR:self.createTime]] isEqualToString:@"<null>"]) {
        self.createTimeType = @"";
    } else {
        self.createTimeType = [NSString stringWithFormat:@"%@", [[DateEngine sharedDateEngine] shortDateStringFromDateMdHs:self.createTime]];
    }
    if ([self.lang isEqual:[NSNull null]]) {
        self.langType = @"";
    } else if ([self.lang isEqualToString:@"(null)"]) {
        self.langType = @"";
    } else if ([self.lang isEqualToString:@"<null>"]) {
        self.langType = @"";
    } else {
        self.langType = self.lang;
    }

    lblFilmTime.text = [NSString stringWithFormat:@"%@ %@ %@", self.createTimeType, self.screenDegreeType, self.langType];
    [holder addSubview:objectInfo];

    CGFloat positionY = 180;
    UIView *saySomeV = [[UIView alloc] initWithFrame:CGRectMake(0, positionY, screentWith, 50)];
    [choosMovieV setBackgroundColor:[UIColor clearColor]];

    UIImageView *imgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17.5, 15, 15)];
    imgV2.image = [UIImage imageNamed:@"kotaByMovie2"];

    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 17.5, 290, 15)];
    lbl2.backgroundColor = [UIColor clearColor];
    lbl2.text = @"说点什么";
    lbl2.textColor = [UIColor orangeColor];
    lbl2.font = [UIFont systemFontOfSize:13];

    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 49, screentWith, 1)];
    [line2 setBackgroundColor:[UIColor colorWithRed:223 / 255.0 green:223 / 255.0 blue:223 / 255.0 alpha:1.0]];
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
    recordView = [[UIView alloc] initWithFrame:CGRectMake(75, positionY, 245, 160)];
    recordView.hidden = YES;
    [holder addSubview:recordView];

    //按住说评论
    UIButton *supportButton = [UIButton buttonWithType:UIButtonTypeCustom];
    supportButton.frame = CGRectMake(0, 4, 210, 35);
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
    //    soundBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(2, 24 + 40, 215, 31)];
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

    numLabel = [[UILabel alloc] initWithFrame:CGRectMake(73, positionY + 95, screentWith - 120, 15)];
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
    //    lblWarn.image = [UIImage imageNamed:@"kotawarn"];
    lblWarn.textColor = [UIColor grayColor];
    lblWarn.contentMode = UIViewContentModeCenter;

    [holder addSubview:lblWarn];

    positionY += 80;

    holder.contentSize = CGSizeMake(screentWith, positionY + 50);

    isText = YES;

    UIImage *img = [UIImage imageNamed:@"kotaSucceedApply"];
    imgVKotaSucceed = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width * (screentWith / img.size.width), (img.size.height + 50) * (screentWith / img.size.width))];
    [imgVKotaSucceed setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width * (screentWith / img.size.width), img.size.height * (screentWith / img.size.width))];
    [imgVKotaSucceed addSubview:imgV];
    imgV.contentMode = UIViewContentModeScaleAspectFill;
    imgV.userInteractionEnabled = YES;
    imgV.image = img;
    imgVKotaSucceed.hidden = YES;
    RoundCornersButton *doneBtnYN = [[RoundCornersButton alloc] init];

    doneBtnYN.frame = CGRectMake(15, CGRectGetMaxY(imgV.frame) - 40, screentWith - 15 * 2, 40);
    doneBtnYN.cornerNum = 1;
    doneBtnYN.rimWidth = 1;
    doneBtnYN.rimColor = appDelegate.kkzBlue;

    doneBtnYN.titleName = @"返回";
    doneBtnYN.titleFont = [UIFont systemFontOfSize:14];
    doneBtnYN.titleColor = appDelegate.kkzBlue;
    doneBtnYN.backgroundColor = [UIColor whiteColor];
    [doneBtnYN addTarget:self action:@selector(doneBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [imgVKotaSucceed addSubview:doneBtnYN];

    [holder addSubview:imgVKotaSucceed];

    [[NSNotificationCenter defaultCenter] addObserver:self

                                             selector:@selector(getTheKotaMovieId:)
                                                 name:@"kotaMovieId"
                                               object:nil];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tap.delegate = self;
    [holder addGestureRecognizer:tap];
    [self registerForKeyboardNotifications];
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

- (void)removeForKeyboardNotifications {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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

- (void)getTheKotaMovieId:(NSNotification *)notification {
    self.movieId = [notification.userInfo[@"movirId"] intValue];
}

- (void)touchAtPoint:(CGPoint)point {

    if (!CGRectContainsPoint(statusViewPlaceHolder.frame, point)) {
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
    int existTextNum = (int) [textView.text length];
    numLabel.text = [NSString stringWithFormat:@"还可输入%d个字", 140 - existTextNum];
}

- (NSInteger)getToInt:(NSString *)strtemp {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *da = [strtemp dataUsingEncoding:enc];
    return [da length];
}

- (void)confirmShare {
    [poplistview recordAudioDidFinishPlaying];
    if (statusTextView.text.length > 140) {
        [appDelegate showAlertViewForTitle:@"" message:@"输入字数不能超过140个" cancelButton:@"OK"];
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
            if (appDelegate.isAuthorized) {

                NSString *str;
                str = [statusTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

                if (str.length == 0) {
                    [appDelegate showAlertViewForTitle:@"" message:@"写点儿什么吧~~" cancelButton:@"OK"];
                } else {
                    VoiceTask *task = [[VoiceTask alloc] initUploadKotaApplyForCommentVoiceWithData:nil
                                                                                          forKotaId:[NSString stringWithFormat:@"%@", self.kotaId]
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
                [[UserManager shareInstance] gotoLoginControllerFrom:self];
                
//                LoginViewController *ctr = [[LoginViewController alloc] init];
//                [self pushViewController:ctr animation:CommonSwitchAnimationBounce];
            }

        } else { //语音评论

            if (appDelegate.isAuthorized) {
                if (recordLength == 0) {
                    [appDelegate showAlertViewForTitle:@"" message:@"多说点儿吧~" cancelButton:@"OK"];
                    return;
                }
                VoiceTask *task = [[VoiceTask alloc] initUploadKotaApplyForCommentVoiceWithData:amr
                                                                                      forKotaId:[NSString stringWithFormat:@"%@", self.kotaId]
                                                                                    commentType:@"2"
                                                                                        content:@""
                                                                                         length:recordLength
                                                                                       finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                                           [self uploadCommentFinished:userInfo status:succeeded];
                                                                                       }];

                if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
                }
            } else {
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RenewStatusApplyY" object:nil userInfo:nil];
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
                [self setForRecording];
            }

            else {

                [appDelegate showAlertViewForTitle:@"您还不能使用麦克风" message:@"请到系统设置-隐私-麦克风中打开应用的权限" cancelButton:@"OK"];
                return;
            }

        }];

    } else {
        [self setForRecording];
    }
}

- (void)timerUpdate

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
    hasVoice = NO;
    recordLength = 0;
    cancelBtn.hidden = YES;
}

#pragma mark Sound & Vedio

- (void)showShuoWave {

    shuoHolder = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentHeight)];
    shuoHolder.backgroundColor = [[UIColor blackColor] alpha:.5];
    [appDelegate.window addSubview:shuoHolder];
    shuoTipView = [[MicView alloc] initWithFrame:CGRectMake(0, (screentContentHeight - screentWith) / 2.0 - 50, screentWith, screentWith)];
    shuoTipView.userInteractionEnabled = YES;
    [shuoHolder addSubview:shuoTipView];
    durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 160 + 50, screentWith, 14)];
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
    KotaHelpInfoViewController *helpVc = [[KotaHelpInfoViewController alloc] init];
    [self pushViewController:helpVc animation:CommonSwitchAnimationSwipeR2L];
}

- (void)cancelViewController {
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)doneBtnClicked {
    [self popViewControllerAnimated:YES];
}

- (void)setForRecording {
    DLog(@"Enabled Mic");
    if (poplistview && [poplistview superview]) {
        [poplistview dismiss];
        //            soundBarBg.hidden = YES;
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
        case kFavTag + 4:

        {
            shuoAttitude = 2;

        } break;
        default:
            break;
    }

    NSString *cafFilePath = [NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"];
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

#pragma mark override from CommonViewController

- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return NO;
}

- (BOOL)showTitleBar {
    return TRUE;
}

@end
