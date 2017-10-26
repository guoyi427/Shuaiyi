//
//  AudioPlayerManager.h
//  KoMovie
//
//  Created by zhoukai on 1/21/14.
//  Copyright (c) 2014 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioBarView.h"
#import "RecordAudio.h"

@interface AudioPlayerManager : NSObject <RecordAudioDelegate>

+(AudioPlayerManager*)sharedAudioPlayerManager;

-(void)addAudioBar:(AudioBarView*)bar;
-(void)removeAudioBar:(AudioBarView*)bar;
-(void)playAudioBar:(AudioBarView *)bar;
-(void)stopAll;

@end
