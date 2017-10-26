//
//  AudioPlayer.h
//  Share
//
//  Created by Lin Zhang on 11-4-26.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class CommentPlayButton;

@interface CommentAudioPlayer : NSObject <AVAudioPlayerDelegate> {
    AVAudioPlayer *player;
    CommentPlayButton *button;
    NSString *url;
    NSTimer *timer;
}

@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) CommentPlayButton *button;
@property (nonatomic, retain) NSString *url;

- (void)play;
- (void)stop;
- (void)pause;
- (BOOL)isProcessing;
- (void)getState;

@end
