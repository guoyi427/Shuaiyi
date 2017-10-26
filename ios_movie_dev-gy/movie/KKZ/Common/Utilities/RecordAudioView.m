//
//  RecordAudioView.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/15.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "RecordAudioView.h"
#import <AVFoundation/AVFoundation.h>
#include "lame.h"
#import "MovieSelectHeader.h"
#import "UIColor+Hex.h"
#import "KKZUtility.h"
#import "KKZExportVideoView.h"
#import "RecordSiriWaveformView.h"
#import "Recorder.h"
#import "MovieCommentViewController.h"

static const CGFloat progressHeight = 4.0f;

static const CGFloat cancelLabelHeight = 31.0f;
static const CGFloat cancelLabelWidth = 75.0f;
static const CGFloat cancelLabelBottom = 12.0f;

#define SOUND_METER_COUNT       [UIScreen mainScreen].bounds.size.width
#define WAVE_UPDATE_FREQUENCY   0.0001

@interface RecordAudioView ()<AVAudioRecorderDelegate>
{
    //音频录制
//    AVAudioRecorder *recorder;
    Recorder *recorder;
    
    //当前是否正在录制
    BOOL isRecording;
}

/**
 *  导出视频视图
 */
@property (nonatomic, strong) KKZExportVideoView *exportVideoView;

/**
 *  波形视图
 */
@property (nonatomic, strong) RecordSiriWaveformView *siriWaveformView;

/**
 *  刷新定时器
 */
@property (nonatomic, strong) CADisplayLink *displayLink;

/**
 *  松手取消标签
 */
@property (nonatomic, strong) UILabel *cancelLabel;

/**
 *  上移取消标签
 */
@property (nonatomic, strong) UILabel *moveLabel;

/**
 *  当前视图对应的控制器
 */
@property (nonatomic, weak) MovieCommentViewController *controller;

@end

@implementation RecordAudioView

- (void)initWithAudio {
   
    //音频会话
    recorder = [[Recorder alloc] initWithURL:audioOutputPath];
}

- (id)initWithFrame:(CGRect)frame
     withController:(CommonViewController *)controller {
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化录音会话
        [self initWithAudio];
        NSString *result = [recorder getInitAudioDeviceStatus];
        if (![KKZUtility stringIsEmpty:result]) {
            //未成功弹出提示框，页面消失
            self.controller = (MovieCommentViewController *)controller;
            [self.controller.movieCommentViewModel dismissViewControllerWhenMeidiaInitFail:result];
            return self;
        }
        
        //初始化后台监听
        [self loadNotification];
        
        //加载进度条
        [self addSubview:self.progressView];
        
        //初始化定时器
        self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                       selector:@selector(updateMeters)];
        
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                               forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)loadNotification {
    //增加进入前台之后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appBecomeActive)
                                                 name:@"appBecomeActive"
                                               object:nil];
}

- (void)appBecomeActive {
    [recorder startListen];
}

- (void)startRecord {
    
    if (isRecording) {
        return;
    }
    
    //当前正在录制
    isRecording = TRUE;
    
    //开始录音
    [recorder startRecord];
}

- (void)cancelRecord {
    
    //当前正在录制
    isRecording = FALSE;
    
    //停止录制声音
    [recorder stopRecord];
}

- (void)stopRecord {
    
    //当前正在录制
    isRecording = FALSE;
    
    //停止录制声音
    [recorder stopRecord];
    
    //音频转换
    [self convertAudioFormatToMp3];
    
    //添加视图
    [self.exportVideoView show];
}

- (void)startListen {
    [recorder startListen];
}

- (void)showMoveCancelTitle {
    self.moveLabel.hidden = NO;
    _cancelLabel.hidden = YES;
}

- (void)showLetGoCancelTitle {
    self.cancelLabel.hidden = NO;
    _moveLabel.hidden = YES;
}

- (void)hidenCancelTitle {
    _cancelLabel.hidden = YES;
    _moveLabel.hidden = YES;
}

- (void)updateMeters {
    if ([recorder isLsitening]) {
        CGFloat power = [recorder averagePower];
        [self.siriWaveformView updateWithLevel:power];
    }else {
        [recorder startListen];
    }
}

- (void)clearAudioData {
    [recorder stopListen];
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)convertAudioFormatToMp3 {
    [NSThread detachNewThreadSelector:@selector(audio_PCMtoMP3)
                             toTarget:self
                           withObject:nil];
}

- (void)audio_PCMtoMP3
{
    
    //需要生成的MP3的文件路径
    NSString *mp3FileName = [audioOutputPath lastPathComponent];
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [audioTemporarySavePath stringByAppendingPathComponent:mp3FileName];
    
    //MP3转换的错误信息
    __block NSString *errorMsg = nil;
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([audioOutputPath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        errorMsg = [exception description];
        NSLog(@"%@",[exception description]);
    }
    @finally {
        [self performSelectorOnMainThread:@selector(sendAudioExportSucess:)
                               withObject:errorMsg
                            waitUntilDone:NO];
    }
}

- (void)sendAudioExportSucess:(NSString *)errorMsg {
    
    //导出视频视图消失
    [self.exportVideoView hiden];
    
    //判断是否转码成功
    if ([KKZUtility stringIsEmpty:errorMsg]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:recordAudioSuccessNotification
                                                            object:nil];
    }else {
        [KKZUtility showAlert:@"导出音频失败,请重试"];
    }
}

- (ZDProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[ZDProgressView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - progressHeight, self.frame.size.width, progressHeight)];
        [_progressView setNoColor:[UIColor colorWithHex:@"#a1a1a3"]];
        [_progressView setPrsColor:[UIColor colorWithHex:@"#f9c452"]];
        _progressView.progress = 0.0f;
    }
    return _progressView;
}

- (KKZExportVideoView *)exportVideoView {
    if (!_exportVideoView) {
        _exportVideoView = [[KKZExportVideoView alloc] initWithFrame:CGRectMake(0.0f,0.0f,kCommonScreenWidth,kCommonScreenHeight)];
        _exportVideoView.backgroundColor = [UIColor clearColor];
        _exportVideoView.tipString = @"导出音频中，请勿退出";
        [self addSubview:_exportVideoView];
    }
    return _exportVideoView;
}

- (RecordSiriWaveformView *)siriWaveformView {
    if (!_siriWaveformView) {
        _siriWaveformView = [[RecordSiriWaveformView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _siriWaveformView.backgroundColor = [UIColor clearColor];
        [self addSubview:_siriWaveformView];
    }
    return _siriWaveformView;
}

- (UILabel *)cancelLabel {
    if (!_cancelLabel) {
        _cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - cancelLabelWidth)/2.0f, CGRectGetHeight(self.frame) - progressHeight - cancelLabelHeight - cancelLabelBottom, cancelLabelWidth, cancelLabelHeight)];
        _cancelLabel.backgroundColor = [UIColor colorWithHex:@"#c93452"];
        _cancelLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _cancelLabel.textColor = [UIColor whiteColor];
        _cancelLabel.textAlignment = NSTextAlignmentCenter;
        _cancelLabel.text = @"松手取消";
        _cancelLabel.hidden = YES;
        [self addSubview:_cancelLabel];
    }
    return _cancelLabel;
}

- (UILabel *)moveLabel {
    if (!_moveLabel) {
        _moveLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - cancelLabelWidth)/2.0f, CGRectGetHeight(self.frame) - progressHeight - cancelLabelHeight - cancelLabelBottom, cancelLabelWidth, cancelLabelHeight)];
        _moveLabel.backgroundColor = [UIColor clearColor];
        _moveLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _moveLabel.text = @"上移取消";
        _moveLabel.textAlignment = NSTextAlignmentCenter;
        _moveLabel.textColor = [UIColor colorWithHex:@"#7fea37"];
        _moveLabel.hidden = YES;
        [self addSubview:_moveLabel];
    }
    return _moveLabel;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
