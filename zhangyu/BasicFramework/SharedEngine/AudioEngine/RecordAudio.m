//
//  RecordAudio.m
//  
//
//  Created by zhangda on 13-4-5.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RecordAudio.h"
#import "lame.h"

@implementation RecordAudio

- (void)dealloc {
    [_recorder release], _recorder = nil;
    
    [_player stop];
    [_player release], _player = nil;
    
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
        NSError *error = nil;

        //初始化播放器的时候如下设置
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback; AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker; AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute, sizeof (audioRouteOverride), &audioRouteOverride);
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //默认情况下扬声器播放
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:&error];
    }
    return self;
}

+ (NSTimeInterval)getAudioTime:(NSData *) data {
    NSError *error = nil;
    AVAudioPlayer *play = [[AVAudioPlayer alloc] initWithData:data error:&error];
    NSTimeInterval n = [play duration];
    [play release];
    return n;
}


#pragma mark audio player
- (void)startPlayAMR:(NSData *)data {
    if (_player!=nil) {
        [self stopPlay];
        return;
    }
    if (!data) {
        return;
    }
    
//    NSLog(@"start decode amr");
//    NSData *pcm = DecodeAMRToWAVE(data);
//    NSLog(@"end decode amr");
    [self startPlayPCM:data];
}

- (void)startPlayPCM:(NSData *)data {
    if (_player!=nil) {
        [self stopPlay];
        return;
    }
    if (!data) {
        return;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];

    NSError *error = nil;
    _player = [[AVAudioPlayer alloc] initWithData:data error:&error];
    _player.delegate = self;
    if (![_player prepareToPlay]) {
        [self stopPlay];
    }
    [_player setVolume:0.8];
	if(![_player play]){
        [self stopPlay];
    }
}

- (void)stopPlay {
    if (_player!=nil) {
        [_player stop];
        [_player release],
        _player = nil;
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
        if (_delegate && [_delegate respondsToSelector:@selector(recordAudioDidFinishPlaying)]) {
            [_delegate recordAudioDidFinishPlaying];
        }
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    DLog(@"audio play finish，音频播放完成。RecordAudio.audioPlayerDidFinishPlaying。");
    [self stopPlay];
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    DLog(@"audio play error,音频播放失败，RecordAudio.audioPlayerDecodeErrorDidOccur。");
    [self stopPlay];
}


#pragma mark audio recorder
- (void)startRecord {
    //Begin the recording session.
    //Error handling removed.  Please add to your own code.
    
    //Setup the dictionary object with all the recording settings that this
    //Recording sessoin will use
    //Its not clear to me which of these are required and which are the bare minimum.
    //This is a good resource: http://www.totodotnet.net/tag/avaudiorecorder/
    //		NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
    //		[recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
    //		[recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    //		[recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    

//    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
//                              [NSNumber numberWithFloat: 8000],                  AVSampleRateKey,
//                              [NSNumber numberWithInt: kAudioFormatLinearPCM],                   AVFormatIDKey,
//                              [NSNumber numberWithInt: 1],                              AVNumberOfChannelsKey,
//                              [NSNumber numberWithInt: 0],                       AVEncoderAudioQualityKey,
//                              nil];
    
    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                   //[NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                   [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
                                   [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                   //  [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                                   [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                   [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                   nil];
    
//    NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
//                              [NSNumber numberWithFloat:8000],                  AVSampleRateKey, // 电话所用采样率
//                              [NSNumber numberWithInt:kAudioFormatMPEG4AAC],    AVFormatIDKey,
//                              [NSNumber numberWithInt:1],                       AVNumberOfChannelsKey,
//                              [NSNumber numberWithInt:16],                      AVLinearPCMBitDepthKey,
//                              [NSNumber numberWithInt:AVAudioQualityMin],       AVEncoderAudioQualityKey,
//                              nil];
    
    //Now that we have our settings we are going to instanciate an instance of our recorder instance.
    //Generate a temp file for use by the recording.
    //This sample was one I found online and seems to be a good choice for making a tmp file that
    //will not overwrite an existing one.
    //I know this is a mess of collapsed things into 1 call.  I can break it out if need be.
    NSURL *recordedTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:
                                                     [NSString stringWithFormat: @"%.0f.%@",
                                                      [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]
                                                     ]];
    
    
    //Setup the recorder to use this file and record to it.
    NSError *error = nil;
    _recorder = [[ AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:&error];
    DLog(@"1");
    //Use the recorder to start the recording.
    //Im not sure why we set the delegate to self yet.
    //Found this in antother example, but Im fuzzy on this still.
    [_recorder setDelegate:self];
    //We call this to start the recording process and initialize
    //the subsstems so that when we actually say "record" it starts right away.
    [_recorder prepareToRecord];
    DLog(@"2");
    //Start the actual Recording
    [_recorder record];
    DLog(@"3");
    //There is an optional method for doing the recording for a limited time see
    //[recorder recordForDuration:(NSTimeInterval) 10]
}

- (NSData *)stopRecordPCM {
    NSURL *url = [[NSURL alloc] initWithString:_recorder.url.absoluteString];
    [_recorder stop];
    [_recorder release], _recorder =nil;
    NSData *pcm = [[NSData alloc] initWithContentsOfURL:url];
    [url release], url =nil;
    
    return [pcm autorelease];
}

- (NSData *)stopRecordAMR:(NSString *)fileName {
    
    NSData *pcm = [self stopRecordPCM];
//    NSData *arm = EncodeWAVEToAMR(pcm, 1, 16);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    NSString *cafFilePath = [documentPath stringByAppendingPathComponent:@"RecordedFile"];
    [pcm writeToFile:cafFilePath atomically:YES];
 
    NSString *mp3FilePath = [documentPath stringByAppendingPathComponent:@"RecordedFile.mp3"];
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if([fileManager removeItemAtPath:mp3FilePath error:nil])
    {
        DLog(@"删除");
    }
    
    
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
//        [self performSelectorOnMainThread:@selector(convertMp3Finish)
//                               withObject:nil
//                            waitUntilDone:YES];
    }

    NSData *mp3Data = [NSData dataWithContentsOfFile:mp3FilePath];
    return mp3Data;
}


- (void) toMp3
{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentPath = [paths objectAtIndex:0];
//    NSString *cafFilePath = [documentPath stringByAppendingPathComponent:@"RecordedFile"];
//    NSString *mp3FilePath = [documentPath stringByAppendingPathComponent:@"RecordedFile.mp3"];
//    
//    NSFileManager* fileManager=[NSFileManager defaultManager];
//    if([fileManager removeItemAtPath:mp3FilePath error:nil])
//    {
//        NSLog(@"删除");
//    }
//    
//    
//    @try {
//        int read, write;
//        
//        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source
//        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
//        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output
//        
//        const int PCM_SIZE = 8192;
//        const int MP3_SIZE = 8192;
//        short int pcm_buffer[PCM_SIZE*2];
//        unsigned char mp3_buffer[MP3_SIZE];
//        
//        lame_t lame = lame_init();
//        lame_set_in_samplerate(lame, 8000);
//        lame_set_VBR(lame, vbr_default);
//        lame_init_params(lame);
//        
//        do {
//            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
//            if (read == 0)
//                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
//            else
//                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
//            
//            fwrite(mp3_buffer, write, 1, mp3);
//            
//        } while (read != 0);
//        
//        lame_close(lame);
//        fclose(mp3);
//        fclose(pcm);
//    }
//    @catch (NSException *exception) {
//        NSLog(@"%@",[exception description]);
//    }
//    @finally {
//        [self performSelectorOnMainThread:@selector(convertMp3Finish)
//                               withObject:nil
//                            waitUntilDone:YES];
//    }
}

- (void) convertMp3Finish
{
    
    
//    _hasMp3File = YES;
//    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//    NSInteger fileSize =  [self getFileSize:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", @"Mp3File.mp3"]];
//    _mp3FileSize.text = [NSString stringWithFormat:@"%d kb", fileSize/1024];
}


@end
