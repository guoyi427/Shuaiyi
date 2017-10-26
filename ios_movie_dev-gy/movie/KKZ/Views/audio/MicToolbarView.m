//
//  MicToolbarView.m
//  KoMovie
//
//  Created by zhoukai on 12/18/13.
//  Copyright (c) 2013 kokozu. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "lame.h"
#import "MicToolbarView.h"
#import "MicCenterUIView.h"
#import "TaskQueue.h"
#import "DataEngine.h"
#import "VoiceTask.h"
#import "AudioPlayerManager.h"
#import "RIButtonItem.h"
#import "UIAlertView+Blocks.h"
#import "UIConstants.h"
#import "KKZUtility.h"
#import "CommonViewController.h"
#import "RoundCornersButton.h"


#define kTag 3800
#define MAX_TEXT_NUM 140


@implementation MicToolbarView
{
    RecordCommentView *recordCommentView;
    MicCenterView *micCenterView;
    int recordLength;
    AVAudioRecorder *recorder;
    NSTimer *_timer;
    int shuoAttitude;
    
    
    CGRect orignFrame;
    UIScrollView *scrollView;
    
    UIButton *keyBoardButton;
    UIButton *audioButton;
    UIButton *speakButton;
    
    UIImageView *textImageView;
    UITextView *textView;
    RoundCornersButton *sendButton;
    
    //    UITextView *activeView;
}

@synthesize delegate;
@synthesize parentView;

- (void)dealloc
{
    if (recordCommentView) [recordCommentView removeFromSuperview];
    if (micCenterView) [micCenterView removeFromSuperview];
    [self removeForKeyboardNotifications];
    DLog(@" ############  MicToolbarView dealloc");
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 52)];
        [scrollView setBackgroundColor:kUIColorGrayBackground];
        [self addSubview:scrollView];
        
        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, kDimensDividerHeight)];
        divider.backgroundColor = [UIColor r:216 g:216 b:216];
        [scrollView addSubview:divider];
        
//        UIView *backImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 52)];
//        [scrollView addSubview:backImage];
        
        CGFloat marginX = (screentWith - 320) * 0.5;
        
        // 语音模式
        keyBoardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        keyBoardButton.frame = CGRectMake(marginX + 10, 7, 38, 38);
        [keyBoardButton setBackgroundImage:[UIImage imageNamed:@"mic_keyboard"] forState:UIControlStateNormal];
        [keyBoardButton addTarget:self action:@selector(clickKeyboardButton:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:keyBoardButton];
        
        speakButton = [UIButton buttonWithType:UIButtonTypeCustom];
        speakButton.frame = CGRectMake(marginX + 58, 7, 240, 38);
        speakButton.tag = kTag + 3;
        [speakButton setBackgroundImage:[UIImage imageNamed:@"mic_click_speak"] forState:UIControlStateNormal];
        [speakButton setBackgroundImage:[UIImage imageNamed:@"mic_click_speak_down"] forState:UIControlStateHighlighted];
        [speakButton addTarget:self action:@selector(startRecord:) forControlEvents:UIControlEventTouchDown];
        [speakButton addTarget:self action:@selector(stopRecord:)
              forControlEvents: UIControlEventTouchUpInside|UIControlEventTouchCancel];
        [speakButton addTarget:self action:@selector(cancelRecord:)
              forControlEvents: UIControlEventTouchUpOutside];
        
        [scrollView addSubview:speakButton];
        
        // 文字模式
        audioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        audioButton.frame = keyBoardButton.frame;
        [audioButton setBackgroundImage:[UIImage imageNamed:@"mic_microphone"] forState:UIControlStateNormal];
        [audioButton addTarget:self action:@selector(clickAudioButton:) forControlEvents:UIControlEventTouchUpInside];
        audioButton.hidden = YES;
        [scrollView addSubview:audioButton];
        
        textImageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginX + 58, 7, 192, 38)];
        textImageView.image = [UIImage imageNamed:@"mic_textfield"];
        [scrollView addSubview:textImageView];
        textImageView.hidden = YES;
        
        
        textView = [[UITextView alloc] initWithFrame:CGRectMake(marginX + 62, 10.5, 186, 30)];
        textView.delegate = self;
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [UIColor blackColor];
        textView.font = [UIFont systemFontOfSize:13];
        textView.hidden = YES;
        [scrollView addSubview:textView];
        
        sendButton = [[RoundCornersButton alloc] initWithFrame:CGRectMake(marginX + 260, 7, 50, 38)];
        sendButton.rimWidth = 1;
        sendButton.rimColor = [UIColor r:200 g:200 b:200];
        sendButton.cornerNum = kDimensCornerNum;
        sendButton.fillColor = [UIColor whiteColor];
        sendButton.titleName = @"发送";
        sendButton.titleColor = [UIColor r:62 g:62 b:62];
        sendButton.titleFont = [UIFont systemFontOfSize:kTextSizeButton];
        [sendButton addTarget:self action:@selector(clickSendButton:) forControlEvents:UIControlEventTouchUpInside];
        [sendButton setHidden:YES];
        [scrollView addSubview:sendButton];
        
        
        [self registerForKeyboardNotifications];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(handleTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapRecognizer];
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//setFrame的时候会重新drawRect
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

- (void)showMicCenterView {
    
    micCenterView = [[MicCenterView alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentContentHeight + 20)];
    
    micCenterView.backgroundColor = [[UIColor blackColor] alpha:.5];
    [parentView addSubview:micCenterView];
    
}

- (void)hideMicCenterView {
    if (micCenterView && [micCenterView superview]) {
        [micCenterView stopAnimation];
        [micCenterView removeFromSuperview];
    }
    
}

//进入文字输入模式。    //显示键盘
-(void)clickKeyboardButton:(id)sender{
    keyBoardButton.hidden = YES;
    speakButton.hidden = YES;
    audioButton.hidden = NO;
    textImageView.hidden = NO;
    textView.hidden = NO;
    sendButton.hidden = NO;
    
}

//进入语音模式。隐藏键盘
-(void)clickAudioButton:(id)sender{
    keyBoardButton.hidden = NO;
    speakButton.hidden = NO;
    audioButton.hidden = YES;
    textImageView.hidden = YES;
    textView.hidden = YES;
    sendButton.hidden = YES;

    [self hideKeyboard];
}

//点击发送（文字）
-(void)clickSendButton:(id)sender{
    [self hideKeyboard];
    
    if ([textView.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"请输入评论"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    if (textView.text.length > MAX_TEXT_NUM) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"输入文字太多，请不要超过140字。"
                                                       delegate:nil
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //处理发送事件......
    if (self.isMessage) {
        [self sendMessageText];
    }else{
        [self sendCommentText];
    }

    
}

-(void)sendCommentText{
    VoiceTask *task = [[VoiceTask alloc]initUploadCommentWithString:textView.text forMovie:self.movieId referId:self.referId withPoint:0 targetType:CommentTargetTypeMovie finished:^(BOOL succeeded, NSDictionary *userInfo) {
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
-(void)sendMessageText{
    VoiceTask *task = [[VoiceTask alloc]initUploadCommentMessageWithString:textView.text forUserId:self.uid finished:^(BOOL succeeded, NSDictionary *userInfo) {
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

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)removeForKeyboardNotifications{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShown:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
//    CGRect beginFrame = [[info valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGSize kbSize = endFrame.size;
    
    
//    DLog(@"----开始显示键盘---");
//    DLog(@"beginFrame:%.0f,%.0f,%.0f,%.0f",beginFrame.origin.x,beginFrame.origin.y,beginFrame.size.width,beginFrame.size.height);
//    DLog(@"endFrame:%.0f,%.0f,%.0f,%.0f",endFrame.origin.x,endFrame.origin.y,endFrame.size.width,endFrame.size.height);
//    DLog(@"animationDuration:%.0f",animationDuration);
    
    NSDictionary *userInfo = [notification userInfo];
//    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        CGFloat h = 0;
        if (runningOniOS7) {
            h = 20;
        }else{
            h = 0;
        }
        
        [self setFrame:CGRectMake(0, 0, screentWith, screentContentHeight)];
        [scrollView setFrame:CGRectMake(0, screentContentHeight-kbSize.height-52 + h, kbSize.width, 52+kbSize.height)];
       
//        _mainView.center = CGPointMake(_mainView.center.x, keyBoardEndY - STATUS_BAR_HEIGHT - _mainView.bounds.size.height/2.0);   // keyBoardEndY的坐标包括了状态栏的高度，要减去
//        
    }];
    
    //    CGPoint endCentre = [[[notification userInfo] valueForKey:UIKeyboardCenterEndUserInfoKey] CGPointValue];
    
    //    DLog(@"kbSize:%1f,%1f",kbSize.width,kbSize.height);
    //    DLog(@"view:%1f,%1f,%1f,%1f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    //    DLog(@"scrollview:%f,%f,%f,%f",scrollView.frame.origin.x,scrollView.frame.origin.y,scrollView.frame.size.width,scrollView.frame.size.height);
    
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)notification
{
//    NSDictionary* info = [notification userInfo];
//    CGRect beginFrame = [[info valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//    CGRect endFrame = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGSize kbSize = endFrame.size;
//    

//    DLog(@"----开始隐藏键盘----");
//    DLog(@"beginFrame:%.0f,%.0f,%.0f,%.0f",beginFrame.origin.x,beginFrame.origin.y,beginFrame.size.width,beginFrame.size.height);
//    DLog(@"endFrame:%.0f,%.0f,%.0f,%.0f",endFrame.origin.x,endFrame.origin.y,endFrame.size.width,endFrame.size.height);
//    DLog(@"animationDuration:%.0f",animationDuration);
    
    
    NSDictionary *userInfo = [notification userInfo];
//    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGFloat keyBoardEndY = value.CGRectValue.origin.y;  // 得到键盘弹出后的键盘视图所在y坐标
    
    NSNumber *duration = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // 添加移动动画，使视图跟随键盘移动
    [UIView animateWithDuration:duration.doubleValue animations:^{
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationCurve:[curve intValue]];
        
        CGFloat h = 0;
        if (runningOniOS7) {
            h = 20;
        }else{
            h = 0;
        }
        
        [self setFrame:CGRectMake(0, screentContentHeight - 52 + h, screentWith, 52)];
        [scrollView setFrame:CGRectMake(0, 0, screentWith, 52)];
    }];

    
    //    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    //    scrollView.contentInset = contentInsets;
    //    scrollView.scrollIndicatorInsets = contentInsets;
}


- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        // handling code
        [self hideKeyboard];
//        DLog(@"键盘消失");
        //        [textView becomeFirstResponder];
    }
}

-(void)hideKeyboard{
    [textView resignFirstResponder];
}
#pragma mark UITextViewDelegate mathod
//-(void)textViewDidBeginEditing:(UITextView *)textView0{
//    activeView = textView0;
//    DLog(@"开始编辑");
//}
//
//-(void)textViewDidEndEditing:(UITextView *)textView{
//    activeView = nil;
//    DLog(@"编辑结束");
//}

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


#pragma mark 录音相关----
- (void)startRecord:(id)sender {
    
    
    [[AudioPlayerManager sharedAudioPlayerManager] stopAll];
    if (delegate && [delegate respondsToSelector:@selector(beforeRecord)]) {
        [delegate beforeRecord];
    }
    
    
    if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]){
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                DLog(@"Enabled Mic");
                [self showMicCenterView];
                recordLength = 0.0;
                [micCenterView getDurationLabel].text = @"";
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
        [self showMicCenterView];
        recordLength = 0.0;
        [micCenterView getDurationLabel].text = @"";
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
        [recorder prepareToRecord];
        [recorder record];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:.01f
                                                  target:self
                                                selector:@selector(timerUpdate)
                                                userInfo:nil
                                                 repeats:YES];
    }
    
    
    //    [recordAudio startRecord];
    
}


- (void)stopRecord:(id)sender{
    
    if([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]){
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            if (granted) {
                [self hideMicCenterView];
                if (_timer) {
                    [_timer invalidate];
                    _timer = nil;
                }
                
                if (recorder) {
                    [recorder stop];
                    recorder = nil;
                }
                
                UIButton *btn = (UIButton *)sender;
                shuoAttitude = 1;
                switch (btn.tag) {
                    case kTag + 3:
                    {
                        shuoAttitude = 1;
                    }
                        break;
                    case kTag + 4:
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
                    DLog(@"$$$$$$$$$$$$$$$$$ %@",[exception description]);
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
    }else {
        
        [self hideMicCenterView];
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        
        if (recorder) {
            [recorder stop];
            recorder = nil;
        }
        
        UIButton *btn = (UIButton *)sender;
        shuoAttitude = 1;
        switch (btn.tag) {
            case kTag + 3:
            {
                shuoAttitude = 1;
            }
                break;
            case kTag + 4:
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

- (void)cancelRecord:(id)sender{
    [self hideMicCenterView];
    
    [_timer invalidate];
    _timer = nil;
    
    [recorder stop];
    recorder = nil;
}

- (void) timerUpdate
{
    
    //    int m = recorder.currentTime / 60;
    int s = ((int) recorder.currentTime) % 60;
    //    int ss = (recorder.currentTime - ((int) recorder.currentTime)) * 100;
    recordLength = s;
    [micCenterView getDurationLabel].text = [NSString stringWithFormat:@"%d\"", s];
    [micCenterView getDurationLabel].textColor = [UIColor whiteColor];
    
    if (recordLength >= 59) {
        [micCenterView getDurationLabel].textColor = appDelegate.kkzYellow;
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
    //    [durationLabel.layer addAnimation:animation forKey:nil];
    [[micCenterView getDurationLabel].layer addAnimation:animation forKey:nil];
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

//显示自己说得录音条
- (void)showSelfSound {
//    CGFloat xWidth = 320.0f;
    CGFloat yHeight = 51.0f;
    CGFloat yOffset = screentHeight - yHeight;
    
    recordCommentView = [[RecordCommentView alloc] initWithFrame:CGRectMake(0, yOffset, screentWith, yHeight)];
    [recordCommentView setBackgroundColor:kUIColorGrayBackground];
    recordCommentView.delegate = self;
    recordCommentView.popViewAnimation = PopViewAnimationActionSheet;
    [recordCommentView updateWithType:NO andLength:recordLength];
    [recordCommentView show];
    
}

#pragma mark RecordCommentView Delegate
//发送语音
- (void)uploadSoundComment {
    
    if (!appDelegate.isAuthorized) {
         CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [[DataEngine sharedDataEngine] startLoginFinished:^(BOOL succeeded) {
            if (succeeded){
                [self uploadVoice];
            }
        } withController:parentCtr];
    } else {
        [self uploadVoice];
    }
    
    if (recordCommentView) {
        [recordCommentView dismiss];
        recordCommentView = nil;
    }
    
}
-(void)uploadVoice{
    
    NSString *mp3FileName = @"Mp3File";
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
    
    NSData *amr = [NSData dataWithContentsOfFile:mp3FilePath];
    //        [recordAudio startPlayAMR:amr];
    
    DLog(@"length-----------%d",recordLength);
    if (recordLength <= 0) {
        [appDelegate showAlertViewForTitle:@""
                                   message:@"请多说点~"
                              cancelButton:@"OK"];
        return;

    }
    //        if (![shuoQouteView superview]) {
    //            self.qouteId = nil;
    //        }else {
    //            [shuoQouteView dismiss];
    //        }
    VoiceTask *task = nil;
    if (self.isMessage) {
        task = [[VoiceTask alloc] initUploadVoiceMessageWithData:amr
                                                 forUserId:self.uid
                                                   length:recordLength
                                                 finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                     [self uploadCommentFinished:userInfo status:succeeded];
                                                 }];

    }else{
        task = [[VoiceTask alloc] initUploadVoiceWithData:amr
                                                            forMovie:self.movieId
                                                              length:recordLength
                                                             referId:self.referId
                                                withPoint:0
                                               targetType:CommentTargetTypeMovie
                                                            finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                [self uploadCommentFinished:userInfo status:succeeded];
                                                            }];
    }
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        [appDelegate showIndicatorWithTitle:@"上传中"
                                   animated:YES
                                 fullScreen:NO
                               overKeyboard:YES
                                andAutoHide:NO];
    }

    
    DLog(@"------------%ld", strlen((char *)[amr bytes]));
    recordLength = 0;
}



- (void)uploadCommentFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    textView.text = @"";
    
//    commentId	String	评论ID
//    status	Int	0为成功
//    filePath	String	语音评论地址
//    content	String	文字评论内容
//    
    [appDelegate hideIndicator];
    
    if (delegate) {
        [delegate uploadCommentFinished:userInfo status:succeeded];
    }
}

@end
