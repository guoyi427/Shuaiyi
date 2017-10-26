//
//  AudioPlayer.m
//  Share
//
//  Created by Lin Zhang on 11-4-26.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import "AudioPlayer.h"
#import "AudioButton.h"
#import "AudioStreamer.h"

@implementation AudioPlayer

@synthesize streamer, button, url;


static AudioPlayer *singleton = nil;

+ (AudioPlayer*)sharedAudioPlayer
{
    if (singleton == nil) {
        singleton = [[self alloc] init];
    }
    return singleton;
}

//- (id)init
//{
//    self = [super init];
//    if (self) {
//        
//    }
//
//    return self;
//}

- (void)dealloc
{
    [super dealloc];
    [url release];
    [streamer release];
    [button release];
    [timer invalidate];
}


- (BOOL)isProcessing
{
    return [streamer isPlaying] || [streamer isWaiting] || [streamer isFinishing] ;
}

- (void)play
{
    DLog(@"tag--%ld  play",(long)button.tag);

    if (!streamer) {
        
        streamer = [[AudioStreamer alloc] initWithURL:self.url];
        
        // set up display updater
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:@selector(updateProgress)]];    
        [invocation setSelector:@selector(updateProgress)];
        [invocation setTarget:self];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             invocation:invocation 
                                                repeats:YES];
        
        // register the streamer on notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playbackStateChanged:)
                                                     name:ASStatusChangedNotification
                                                   object:streamer];
    }
    
    if ([streamer isPlaying]) {
        [streamer pause];
    } else {
        [streamer start];
    }
}


- (void)stop
{
    DLog(@"tag--%ld  soundStopAinimation停止动画",(long)button.tag);

    if (button) {
        [button setProgress:0];
        [button stopSpin];
        
        button.image = [UIImage imageNamed:playImage];
        [button release];
        button = nil; // 避免播放器的闪烁问题
    }
  
    
    // release streamer
	if (streamer)
	{        
		[streamer stop];
		[streamer release];
		streamer = nil;
        
        // remove notification observer for streamer
		[[NSNotificationCenter defaultCenter] removeObserver:self 
                                                        name:ASStatusChangedNotification
                                                      object:streamer];		
	}
}

- (void)updateProgress
{
    if (streamer.progress <= streamer.duration ) {
        [button setProgress:streamer.progress/streamer.duration];        
    } else {
        [button setProgress:0.0f];        
    }
}


/*
 *  observe the notification listener when loading an audio
 */
- (void)playbackStateChanged:(NSNotification *)notification
{
	if ([streamer isWaiting])
	{
        DLog(@"tag--%ld  waiting等待--》startspin开始旋转",(long)button.tag);

        button.image = [UIImage imageNamed:stopImage];
        [button startSpin];
    } else if ([streamer isIdle]) {
        DLog(@"tag--%ld  idle空闲--》stop停止",(long)button.tag);
        button.image = [UIImage imageNamed:playImage];
		[self stop];		
	} else if ([streamer isPaused]) {
        DLog(@"tag--%ld  paused暂停--》stopspin停止旋转",(long)button.tag);
        button.image = [UIImage imageNamed:playImage];
        [button stopSpin];
        [button setColourR:0.0 G:0.0 B:0.0 A:0.0];
    } else if ([streamer isPlaying] || [streamer isFinishing]) {
        DLog(@"tag--%ld  playing播放\finishing完成--》stopspin停止旋转",(long)button.tag);

        button.image = [UIImage imageNamed:stopImage];
        [button stopSpin];        
	} else {
        DLog(@"tag--%ld  else",(long)button.tag);

    }
    
    [button setNeedsLayout];    
    [button setNeedsDisplay];
}


@end
