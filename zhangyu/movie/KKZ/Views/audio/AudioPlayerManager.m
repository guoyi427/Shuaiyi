//
//  AudioPlayerManager.m
//  KoMovie
//
//  Created by zhoukai on 1/21/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import "AudioPlayerManager.h"
#import "RecordAudio.h"
#import "BDMultiDownloader.h"

static AudioPlayerManager *_AudioPlayerManager = nil;

@implementation AudioPlayerManager{
    
    NSMutableSet *audioBarAll;
    
    RecordAudio *recordAudio;
    
    BOOL downLocked;
}

+(AudioPlayerManager*)sharedAudioPlayerManager{
    @synchronized(self){
        if (!_AudioPlayerManager) {
            _AudioPlayerManager = [[AudioPlayerManager alloc] init];
            
        }
    }
    return _AudioPlayerManager;
}

-(void)addAudioBar:(AudioBarView *)bar{
    if (!audioBarAll) {
        audioBarAll = [[NSMutableSet alloc] init];
    }
    if (!recordAudio) {
        recordAudio = [[RecordAudio alloc] init];
        recordAudio.delegate = self;
        
        downLocked = NO;
    }
//    audioBarAll[bar.audioURL] = bar;
    [audioBarAll addObject:bar];
}

-(void)removeAudioBar:(AudioBarView *)bar{
//    audioBarAll[bar.audioURL] = nil;
    [audioBarAll removeObject:bar];
}
-(void)playAudioBar:(AudioBarView *)bar{
    if (downLocked) {
        return;
    }
    
    [recordAudio stopPlay];
    

    [audioBarAll enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (![((AudioBarView*)obj).audioURL isEqualToString:bar.audioURL]) {
                [(AudioBarView*)obj stopIndicatorAinimation];
                [(AudioBarView*)obj stopAudioAinimation];
    
        }
    }];
    
    [bar startIndicatorAinimation]; //播放喇叭变大变小动画
    //开始下载
//    downLocked = YES;
    [[BDMultiDownloader shared]
     dataWithPath:bar.audioURL
     completion:^(NSData *data,BOOL cache) {
         DLog(@"BDMultiDownloader download finish 下载语音完成");
         DLog(@"播放单个音频,url：%@",bar.audioURL);
//         downLocked = NO;
         [bar stopIndicatorAinimation]; //播放喇叭变大变小动画
         [recordAudio startPlayAMR:data];
         [bar playAudioAinimation];
     }];

}

-(void)stopAll{
    [recordAudio stopPlay];
    if (audioBarAll) {
        [audioBarAll enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            
            [(AudioBarView*)obj stopIndicatorAinimation];
            [(AudioBarView*)obj stopAudioAinimation];
            
        }];
    }
}

#pragma mark- RecordAudioDelegate
-(void)recordAudioDidFinishPlaying{
    [self stopAll];
}

@end
