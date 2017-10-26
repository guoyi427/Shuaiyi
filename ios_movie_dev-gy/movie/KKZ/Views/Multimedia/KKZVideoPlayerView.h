//
//  播放器的View
//
//  Created by 艾广华 on 16/3/7.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@class KKZVideoToolBar;

/******************************系统默认尺寸*******************************/
#define kCommonScreenBounds [UIScreen mainScreen].bounds //整个APP屏幕尺寸
#define kCommonScreenWidth kCommonScreenBounds.size.width //整个APP屏幕的宽度
#define kCommonScreenHeight kCommonScreenBounds.size.height //整个APP屏幕的高度

@protocol CYVideoPlayerDelegate <NSObject>

@optional

/** <是否全屏播放视频> */
- (void)cyVideoToolBarView:(KKZVideoToolBar *)cyVideoToolBar
          shouldFullScreen:(BOOL)isFull;

/**
 *  点击屏幕结束
 */
- (void)clickScreenTouchEnd;

@end

@interface KKZVideoPlayerView : UIView

/** <封面图片> */
@property (nonatomic, strong) UIImageView *imageView;

/** <底部工具条> */
@property (nonatomic, strong) KKZVideoToolBar *toolBarView;

/** < player > */
@property (nonatomic, strong) AVPlayer *player;

/** <playerItem> */
@property (nonatomic, strong) AVPlayerItem *playerItem;

/** < 视频播放的URL > */
@property (nonatomic, strong) NSURL *playURL;

/** <播放器播放状态> */
@property (nonatomic, assign, getter=isPlaying, readonly) BOOL playing;

/** <delegate> */
@property (nonatomic, weak) id<CYVideoPlayerDelegate> delegate;

/** < 当前视频播放的时间 > */
- (NSString *)currentTime;

/** < 当前视频播放的总时间 > */
- (NSString *)durationTime;

/** < 视频播放 > */
- (void)play;

/** < 视频停止 > */
- (void)stop;

/** < 视频暂停 > */
- (void)pause;

@end
