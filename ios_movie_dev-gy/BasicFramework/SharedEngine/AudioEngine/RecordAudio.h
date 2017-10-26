//
//  RecordAudio.h
//  
//
//  Created by zhangda on 13-4-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol RecordAudioDelegate <NSObject>
@optional
- (void)recordAudioDidFinishPlaying;

@end

@interface RecordAudio : NSObject <AVAudioRecorderDelegate,AVAudioPlayerDelegate> {
    
	AVAudioRecorder *_recorder;
    AVAudioPlayer *_player;
    
}

@property (nonatomic, assign) id <RecordAudioDelegate> delegate;

+ (NSTimeInterval)getAudioTime:(NSData *)data;

- (void)startRecord;
- (NSData *)stopRecordPCM;
- (NSData *)stopRecordAMR:(NSString *)fileName;

- (void)startPlayAMR:(NSData *)data;
- (void)startPlayPCM:(NSData *)data;
- (void)stopPlay;

@end
