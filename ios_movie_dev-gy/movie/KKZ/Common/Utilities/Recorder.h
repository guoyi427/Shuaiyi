//
//  Recorder.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/23.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

static NSString *initAudioDeviceFailReason = @"获取麦克风失败,请重试";
static NSString *initAudioDeviceSuccess = nil;


@interface Recorder : NSObject

/**
 *  初始化视图
 *
 *  @param audioPath
 *
 *  @return
 */
- (id)initWithURL:(NSString *)audioPath;

/**
 *  初始化音频设备
 *
 *  @return 返回音频数据失败原因
 */
- (NSString *)getInitAudioDeviceStatus;

/**
 *  处理录制的音频数据
 *
 *  @param buffer
 *  @param queue
 */
- (void) processAudioBuffer:(AudioQueueBufferRef) buffer
                  withQueue:(AudioQueueRef) queue;

/**
 *  开始监听声音
 */
- (void)startListen;

/**
 *  停止监听声音
 */
- (void) stopListen;

/**
 *  暂停监听声音
 */
- (void) pauseListen;

/**
 *  开始录制声音
 */
- (void)startRecord;

/**
 *  停止录制声音
 */
- (void)stopRecord;

/**
 *  声音的平均峰值
 *
 *  @return 
 */
- (Float32)averagePower;

/**
 *  当前收音是否正在运行
 *
 *  @return
 */
-(BOOL)isLsitening;

@end
