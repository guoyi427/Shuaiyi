//
//  AudioPlayer.m
//  Share
//
//  Created by Lin Zhang on 11-4-26.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import "CommentAudioPlayer.h"
#import "CommentPlayButton.h"
#import "BDMultiDownloader.h"

@implementation CommentAudioPlayer

@synthesize player, button, url;


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [url release];
    [player release];
    [button release];
    [timer invalidate];
}


//- (BOOL)isProcessing
//{
//    return [streamer isPlaying] || [streamer isWaiting] || [streamer isFinishing] ;
//}

- (void)play
{
    if ([player isPlaying]) {
        [self stop];
    }else {
        //    [self stop];
        [button startSpin];
        [[BDMultiDownloader shared]
         dataWithPath:url
         completion:^(NSData *data,BOOL cache) {
             //         voiceLocked = NO;
             //         self.soundData = data;
             //         isPlayingRow = row*2;
             //         singlePlay = YES;
             
             [button stopSpin];
             [self startPlay:data];
             
             [button soundPlayAinimation];
         }];
    }
    
    
    
    //    if (!streamer) {
    //
    //        self.streamer = [[AudioStreamer alloc] initWithURL:self.url];
    //
    //        // set up display updater
    //        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
    //                                    [self methodSignatureForSelector:@selector(updateProgress)]];
    //        [invocation setSelector:@selector(updateProgress)];
    //        [invocation setTarget:self];
    //
    //        timer = [NSTimer scheduledTimerWithTimeInterval:0.1
    //                                             invocation:invocation
    //                                                repeats:YES];
    //
    //        // register the streamer on notification
    //        [[NSNotificationCenter defaultCenter] addObserver:self
    //                                                 selector:@selector(playbackStateChanged:)
    //                                                     name:ASStatusChangedNotification
    //                                                   object:streamer];
    //    }
    //
    //    if ([streamer isPlaying]) {
    //        [streamer pause];
    //    } else {
    //        [streamer start];
    //    }
}

- (void)startPlay:(NSData *)data {
    if (player!=nil) {
        [self stop];
        return;
    }
    if (!data) {
        return;
    }
    
    NSError *error = nil;
    player = [[AVAudioPlayer alloc] initWithData:data error:&error];
    player.delegate = self;
    if (![player prepareToPlay]) {
        [self stop];
    }
    [player setVolume:0.8];
	if(![player play]){
        [self stop];
    }
}

- (void)getState {
    if ([player isPlaying]) {
        [button soundPlayAinimation];
    }else {
        [button soundStopAinimation];
    }
}

- (void)audioDidFinishPlaying {
    [button soundStopAinimation];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    DLog(@"audio play finish");
    [self stop];
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    DLog(@"audio play error");
    [self stop];
}

- (void)stop
{
    if (player!=nil) {
        [player stop];
        [player release],
        player = nil;
        
        [self audioDidFinishPlaying];
        //        if (_delegate && [_delegate respondsToSelector:@selector(recordAudioDidFinishPlaying)]) {
        //            [_delegate recordAudioDidFinishPlaying];
        //        }
    }
}

//- (void)updateProgress
//{
//    if (streamer.progress <= streamer.duration ) {
//        [button setProgress:streamer.progress/streamer.duration];
//    } else {
//        [button setProgress:0.0f];
//    }
//}


/*
 *  observe the notification listener when loading an audio
 */
//- (void)playbackStateChanged:(NSNotification *)notification
//{
//	if ([streamer isWaiting])
//	{
//        [button soundStopAinimation];
//        [button startSpin];
//    } else if ([streamer isIdle]) {
//        [button soundStopAinimation];
//		[self stop];
//	} else if ([streamer isPaused]) {
//        [button soundStopAinimation];
//        [button stopSpin];
////        [button setColourR:0.0 G:0.0 B:0.0 A:0.0];
//    } else if ([streamer isPlaying] || [streamer isFinishing]) {
//        [button soundPlayAinimation];
//        [button stopSpin];
//	} else {
//        
//    }
//    
//    [button setNeedsLayout];    
//    [button setNeedsDisplay];
//}


@end
