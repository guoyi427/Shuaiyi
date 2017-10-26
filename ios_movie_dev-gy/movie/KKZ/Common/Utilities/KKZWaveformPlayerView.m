//
//  KKZWaveformPlayerView.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/16.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "KKZWaveformPlayerView.h"
#import "SCWaveformView.h"

@implementation KKZWaveformPlayerView {
    
    //音乐播放器
    AVAudioPlayer *player;
    
    //音频波形
    SCWaveformView *waveformView;
    
    //波形定时器
    NSTimer *waveTimer;
}

- (id)initWithFrame:(CGRect)frame
              asset:(AVURLAsset *)asset
              color:(UIColor *)normalColor
      progressColor:(UIColor *)progressColor {
    
    if (self = [super initWithFrame:frame]) {
        //初始化语音
        NSError *error = nil;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:asset.URL
                                                        error:&error];
        if (error) {
            NSLog(@"err====%@",[error description]);
        }
        player.volume = 1.0f;
        player.numberOfLoops = -1;
        [player play];
        
        //初始化音频波形视图
        waveformView = [[SCWaveformView alloc] init];
        waveformView.normalColor = normalColor;
        waveformView.progressColor = progressColor;
        waveformView.alpha = 0.8;
        waveformView.backgroundColor = [UIColor clearColor];
        waveformView.asset = asset;
        [self addSubview:waveformView];
        
        //定时器
        waveTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                     target:self
                                                   selector:@selector(updateWaveform:)
                                                   userInfo:nil
                                                    repeats:YES];
        
    }
    return self;
}

- (void)updateWaveform:(id)sender {
    
    if(player.playing) {
        waveformView.progress = player.currentTime/player.duration;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    waveformView.frame = CGRectMake(0, 0, self.frame.size.width,self.frame.size.height);
}

- (void)stopAudioPlayer {
    
    //定时器释放
    [waveTimer invalidate];
    
    //音频播放停止
    waveTimer = nil;
    [player stop];
    player = nil;
    
}

@end
