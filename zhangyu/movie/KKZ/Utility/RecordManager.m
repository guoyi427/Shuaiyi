//
//  RecordManager.m
//  KoMovie
//
//  Created by wuzhen on 15/7/21.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "RecordManager.h"
#import "lame.h"
#import "RecordAudio.h"
#import "MicView.h"

@implementation RecordManager


- (id)init {
    self = [super init];
    return self;
}


- (void)startRecord {
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
    [audioSession setActive:YES error: &error];
    
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {

            if (granted) {
                [self start];
            }
            else {
                [self performSelectorOnMainThread:@selector(showRecordAlert) withObject:nil waitUntilDone:YES];
            }
        }];
    }
    else {
        [self start];
    }
}


- (void)showRecordAlert {
    [appDelegate showAlertViewForTitle:@"您还不能使用麦克风" message:@"请到系统设置-隐私-麦克风中打开应用的权限" cancelButton:@"确定"];
}


- (void)start {
    [self performSelectorOnMainThread:@selector(performDelegateStarted) withObject:nil waitUntilDone:YES];

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
    NSError* error;
    recorder = [[AVAudioRecorder alloc] initWithURL:recordedFile settings:recordSetting error:&error];
    
    DLog(@"%@", [error description]);
    
    [recorder prepareToRecord];
    [recorder record];
    _timer = [NSTimer scheduledTimerWithTimeInterval:.01f target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
}


- (void)timerUpdate {
    recordLength = ((int) recorder.currentTime) % 60;

    [self performSelectorOnMainThread:@selector(performDelegateUpdate) withObject:nil waitUntilDone:YES];

    if (recordLength >= 59) {
        [_timer invalidate];
        _timer = nil;
        [recorder stop];
        recorder = nil;
    }
}


- (void)stopRecord {
    [self performSelectorOnMainThread:@selector(performDelegateStop) withObject:nil waitUntilDone:YES];

    if (recordLength < 1.0) {
        [appDelegate showAlertViewForTitle:@"" message:@"请再多说点吧" cancelButton:@"确定"];
        
        [self resetProperty];
        return;
    }

    [self resetProperty];

    NSString *cafFilePath = [self getCafFilePath];
    NSString *mp3FilePath = [self getRecordFilePath];

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
            if (read == 0) {
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            }
            else {
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, (int)read, mp3_buffer, MP3_SIZE);
            }
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
        [self performSelectorOnMainThread:@selector(performDelegateSucceed) withObject:nil waitUntilDone:YES];
    }
}


- (void)cancelRecord {
    [self performSelectorOnMainThread:@selector(performDelegateCancel) withObject:nil waitUntilDone:YES];

    [self resetProperty];
}


- (NSString *)getCafFilePath {
    NSString *cafFilePath =[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"];
    return cafFilePath;
}


- (NSString *)getRecordFilePath {
    NSString *mp3FileName = @"Mp3File";
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
    return mp3FilePath;
}


- (void)resetProperty {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }

    if (recorder) {
        [recorder stop];
        recorder = nil;
    }

    recordLength = 0;
}



- (void)performDelegateStarted {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordStarted)]) {
        [self.delegate recordStarted];
    }
}


- (void)performDelegateUpdate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordUpdate:)]) {
        [self.delegate recordUpdate:recordLength];
    }
}


- (void)performDelegateStop {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordStopped)]) {
        [self.delegate recordStopped];
    }
}


- (void)performDelegateSucceed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordSucceed)]) {
        [self.delegate recordSucceed];
    }
}


- (void)performDelegateCancel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(recordCancelled)]) {
        [self.delegate recordCancelled];
    }
}



@end
