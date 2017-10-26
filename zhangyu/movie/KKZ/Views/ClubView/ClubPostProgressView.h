//
//  ClubPostProgressView.h
//  KoMovie
//
//  Created by 艾广华 on 16/3/1.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKZUtility.h"

@interface ClubPostProgressView : UIView

/**
 *  视频和音频录制的定时器
 */
@property (nonatomic, strong) NSTimer *timer;

/**
 *  音频播放器 
 */
@property (nonatomic, weak) AVAudioPlayer *player;

@property(nonatomic,copy) void(^audioPlayerPause)(BOOL isPause);

/**
 *  暂停按钮
 */
@property (nonatomic, strong) UIButton *pauseBtn;

/**
 *  移除定时器
 */
- (void)removeTimer;

@end
