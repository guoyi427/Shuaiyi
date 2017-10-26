//
//  Recorder.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/23.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "Recorder.h"
#import <AudioToolbox/AudioQueue.h>
#import "MovieCommentViewModel.h"

#define t_sample            SInt16

@interface Recorder ()
{
    //音频数据格式
    AudioStreamBasicDescription format;
    
    //创建音频队列对象
    AudioQueueRef queue;
    
    //每个声道都有一个相对应的结构
    AudioQueueLevelMeterState *levels;
}

/**
 *  文件输出流
 */
@property (nonatomic, strong) NSOutputStream *fileOutputStream;

/**
 *  音频路径
 */
@property (nonatomic, strong) NSString *audioPath;

/**
 *  开始录制
 */
@property (nonatomic, assign) BOOL startRecording;

@end

static void listeningCallback(void *inUserData,
                              AudioQueueRef inAQ,
                              AudioQueueBufferRef inBuffer,
                              const AudioTimeStamp *inStartTime,
                              UInt32 inNumberPacketsDescriptions,
                              const AudioStreamPacketDescription *inPacketDescs)
{
    Recorder *listener = (__bridge Recorder *)inUserData;
    if (inNumberPacketsDescriptions > 0)
    {
        [listener processAudioBuffer:inBuffer
                         withQueue:inAQ];
    }
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}

@implementation Recorder

- (id)initWithURL:(NSString *)audioPath {
    self = [super init];
    if (self) {
        //设置录制的音频路径
        self.audioPath = audioPath;
    }
    return self;
}

- (BOOL)audioAuthorizationAccess {
    __block BOOL access = FALSE;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if (granted) {
                    //第一次用户接受
                    access = TRUE;
                }else{
                    //用户拒绝
                    access = FALSE;
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            access = TRUE;
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            access = FALSE;
            break;
        default:
            break;
    }
    return access;
}

- (NSString *)getInitAudioDeviceStatus {
    
    //判断是否授权麦克风数据
    if (![self audioAuthorizationAccess]) {
        return failAudioPermissionFail;
    }
    
    //创建一个音频捕捉设备
    AVCaptureDevice *audioCaptureDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    if (!audioCaptureDevice) {
        return failAudioPermissionFail;
    }
    //错误信息
    NSError *error = nil;
    AVCaptureDeviceInput *audioCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioCaptureDevice
                                                                                           error:&error];
    if (error || !audioCaptureDeviceInput) {
        return failAudioPermissionFail;
    }
    //设置音频会话
    if (![self setupAudioSession]) {
        return initAudioDeviceFailReason;
    }
    //设置音频数据
    [self setupFormat];
    //录制音频队列
    AudioQueueNewInput(&format, listeningCallback, (__bridge void *)(self), NULL, NULL, 0, &queue);
    if (queue == nil) {
        return initAudioDeviceFailReason;
    }
    //设置音频数据缓冲区
    [self setupBuffer];
    //设置音量监测
    [self setupMetering];
    //返回数据正常状态
    return initAudioDeviceSuccess;
}

- (BOOL)setupAudioSession {
    
    //音频会话
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                        error:&err];
    if (err) {
        return FALSE;
    }
    //激活音频会话
    [audioSession setActive:YES
                      error:&err];
    if(err){
        NSLog(@"音频会话激活失败");
        return FALSE;;
    }
    return TRUE;
}

- (void)setupFormat {
    format.mSampleRate=11025.0;
    format.mFormatID=kAudioFormatLinearPCM; //音频格式(PCM)
    format.mFormatFlags=kAudioFormatFlagIsSignedInteger|kAudioFormatFlagIsPacked;
    format.mFramesPerPacket=1; //每个数据包下的帧数,即每个数据包里面有多少帧
    format.mChannelsPerFrame=2; //1 单声道 2立体声
    format.mBitsPerChannel=16; //语音每采样点占用位数
    format.mBytesPerFrame=4; //每帧的bytes数(mBitsPerChannel/8)*mChannelsPerFrame
    format.mBytesPerPacket=4; //每个数据包的bytes总数(每帧的bytes数*每个数据包的帧数)
}

-(void)setupBuffer {
    AudioQueueBufferRef buffer[3];
    for(int i = 0;i < 3;i++){
        AudioQueueAllocateBuffer(queue, 735, &buffer[i]);
        AudioQueueEnqueueBuffer(queue, buffer[i], 0, NULL);
    }
}

-(void)setupMetering{
    levels=(AudioQueueLevelMeterState*)calloc(sizeof(AudioQueueLevelMeterState), format.mChannelsPerFrame);
    UInt32 trueValue = true;
    //启用音频队列对象的音量计
    AudioQueueSetProperty(queue, kAudioQueueProperty_EnableLevelMetering, &trueValue, sizeof(UInt32));
}

- (void)startListen {
    AudioQueueStart(queue, NULL);
}

- (void) stopListen {
    AudioQueueStop(queue, true);
}

- (void) pauseListen {
    AudioQueuePause(queue);
}

- (void)startRecord {
    
    //每次录制前，先移除掉音频录制
    NSError *err = nil;
    NSURL *url = [NSURL fileURLWithPath:self.audioPath];
    NSData *audioData = [NSData dataWithContentsOfFile:[url path]
                                               options: 0
                                                 error:&err];
    if(audioData)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[url path]
                       error:&err];
    }
    err = nil;
    
    //当前正在录制
    self.startRecording = TRUE;
}

- (void)stopRecord {
    self.startRecording = FALSE;
    [self.fileOutputStream close];
    self.fileOutputStream = nil;
}

-(BOOL)isLsitening {
    if(queue==nil)
        return NO;
    
    UInt32 isListening, ioDataSize = sizeof(UInt32);
    OSStatus result = AudioQueueGetProperty(queue, kAudioQueueProperty_IsRunning, &isListening, &ioDataSize);
    return (result!=noErr?NO:isListening);
}

- (Float32)averagePower{
    return [self levels][0].mAveragePower;
}

- (AudioQueueLevelMeterState *)levels{
    [self updateLevels];
    return levels;
}

- (void)updateLevels {
    UInt32 ioDataSize = format.mChannelsPerFrame * sizeof(AudioQueueLevelMeterState);
    AudioQueueGetProperty(queue, (AudioQueuePropertyID)kAudioQueueProperty_CurrentLevelMeter, levels, &ioDataSize);
}

- (void) processAudioBuffer:(AudioQueueBufferRef) buffer
                  withQueue:(AudioQueueRef) queue
{
    long size = buffer->mAudioDataByteSize;
    UInt8 * data = (UInt8 *) buffer->mAudioData;
    if (self.startRecording) {
        [self.fileOutputStream write:data
                           maxLength:size];
    }
}

- (NSOutputStream *)fileOutputStream {
    
    if (!_fileOutputStream) {
        _fileOutputStream = [[NSOutputStream alloc] initToFileAtPath:self.audioPath
                                                              append:YES];
        [_fileOutputStream open];
    }
    return _fileOutputStream;
}

- (void)dealloc {
    
    //移除声道对象
    free(levels);
    
    //销毁AudioQueue
    AudioQueueDispose(queue,YES);
    
    //停止监听音频
    [self stopListen];
}

@end
