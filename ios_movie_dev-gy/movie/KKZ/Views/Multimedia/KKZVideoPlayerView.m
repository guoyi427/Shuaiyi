//
//  播放器的View
//
//  Created by 艾广华 on 16/3/7.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "KKZVideoPlayerView.h"

#import "KKZVideoToolBar.h"
#import "UIColor+Hex.h"

static const NSString *PlayerItemStatusContext = @"PlayerItemStatusContext";
static const NSString *PlayerItemLoadedTimeRangesContext = @"PlayerItemLoadedTimeRangesContext";

static const CGFloat toolBarHeight = 39.0f;

@interface KKZVideoPlayerView () <CYVideoToolBarDelegate>

@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) NSTimer *progressTimer;

@end

@implementation KKZVideoPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        //添加视频播放器
        [self.layer addSublayer:self.playerLayer];

        //添加启动图
        [self.playerLayer addSublayer:self.imageView.layer];

        //添加视频工具栏
        [self addSubview:self.toolBarView];
        self.toolBarView.hidden = YES;
    }
    return self;
}

- (void)enterBackground {
    if (self.isPlaying) {
        [self tapGesture];
    }
}

- (void)routeChange:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    int changeReason = [dic[AVAudioSessionRouteChangeReasonKey] intValue];

    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable || changeReason == AVAudioSessionRouteChangeReasonNewDeviceAvailable) {

        if (self.isPlaying) {
            [self tapGesture];
        }
    }
}

- (void)setPlayURL:(NSURL *)playURL {
    _playURL = playURL;
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:_playURL];
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self addPlayerItemObserverWith:playerItem];
    [self addNotification];
    self.playerItem = playerItem;
}

- (void)play {
    [self.player play];
    self.imageView.hidden = YES;
}

- (void)pause {
    [self.player pause];
    self.imageView.hidden = YES;
}

- (void)stop {
    self.imageView.hidden = NO;
    [self.player pause];
    [self removeAllObserver];
    self.player = nil;
}

#pragma mark - KVO 观察AVPlayerItme的属性
/**
 *  添加观察者开始观察 AVPlayer 的状态
 */
- (void)addPlayerItemObserverWith:(AVPlayerItem *)playerItem {
    [self removePlayerItemObserver];
    [playerItem addObserver:self
                 forKeyPath:@"status"
                    options:NSKeyValueObservingOptionNew
                    context:&PlayerItemStatusContext];

    //监控网络加载情况属性(loadedTimeRange属性代表已经缓冲的进度)
    [playerItem addObserver:self
                 forKeyPath:@"loadedTimeRanges"
                    options:NSKeyValueObservingOptionNew
                    context:&PlayerItemLoadedTimeRangesContext];
}
/**
 *  移除观察者不再观察 AVPlayer 的状态
 */
- (void)removePlayerItemObserver {
    if (self.playerItem) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        self->_playerItem = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context {

    if (context == &PlayerItemStatusContext) {
        if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
            double durition = CMTimeGetSeconds(self.playerItem.duration);
            self.toolBarView.playerSlider.maximumValue = durition;
            NSLog(@"可以正常播放视频");
            //            self->_playing = YES;
            [self addProgressTimer];
        } else if (self.playerItem.status == AVPlayerItemStatusUnknown) {
            NSLog(@"未知状态");
        } else if (self.playerItem.status == AVPlayerItemStatusFailed) {
            NSLog(@"--> %@", self.playerItem.error.localizedDescription);
        }
    }
}

#pragma mark - 定时器操作
/**
 *  添加定时器
 */
- (void)addProgressTimer {
    [self removeProgressTimer];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                          target:self
                                                        selector:@selector(updateProgressInfo)
                                                        userInfo:nil
                                                         repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer
                              forMode:NSRunLoopCommonModes];
    [self.progressTimer fire];
}

/**
 *  移除定时器
 */
- (void)removeProgressTimer {
    if (self.progressTimer) {
        [self.progressTimer invalidate];
        self.progressTimer = nil;
    }
}

- (void)updateProgressInfo {
    if (!self.isPlaying) {
        return;
    }

    // 1.更新时间
    self.toolBarView.beginTimeLabel.text = self.currentTime;
    self.toolBarView.endTimeLabel.text = self.durationTime;
    double currentTime = CMTimeGetSeconds(self.player.currentTime);

    // 2.设置进度条的value
    self.toolBarView.playerSlider.value = currentTime;
}

#pragma mark - 讲当前时间转成时间戳给label显示
- (NSString *)currentTime {
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.currentTime);
    return [self stringWithTime:currentTime];
}

- (NSString *)durationTime {
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    return [self stringWithTime:duration];
}

- (NSString *)stringWithTime:(NSTimeInterval)totalTime {
    NSInteger cMin = totalTime / 60;
    NSInteger cSec = (NSInteger) totalTime % 60;
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", (long) cMin, (long) cSec];
    return currentString;
}

#pragma mark - 监听播放器播放结束的通知
/**
 *  添加通知
 */
- (void)addNotification {
    [self removeNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerEndPlay:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];
    //增加进入后台之后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackground)
                                                 name:@"AppDidEnterBackground"
                                               object:nil];
    //添加通知，拔出耳机后暂停播放
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(routeChange:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:nil];
}

/**
 *  移除通知
 */
- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  播放结束时的通知
 */
- (void)playerEndPlay:(NSNotification *)noti {
    AVPlayerItem *playItem = [noti object];

    //关键代码
    [playItem seekToTime:kCMTimeZero];
    [self tapGesture];
}

- (void)removeAllObserver {
    [self removePlayerItemObserver];
    [self removeNotification];
    [self removeProgressTimer];
}

#pragma mark - CYVideoToolBarDelegate
/** 
 * 点击了底部工具条上的播放/暂停按钮
 */
- (void)cyVideoToolBarView:(KKZVideoToolBar *)cyVideoToolBar
              didPlayVideo:(BOOL)isPlay {
    [self tapGesture];
}

- (void)cyVideoToolBarView:(KKZVideoToolBar *)cyVideoToolBar
          shouldFullScreen:(BOOL)isFull {
    if ([self.delegate respondsToSelector:@selector(cyVideoToolBarView:shouldFullScreen:)]) {
        [self.delegate cyVideoToolBarView:self.toolBarView shouldFullScreen:isFull];
    }
}

/**
 * 开始拖到滑块
 */
- (void)cyVideoToolBarView:(KKZVideoToolBar *)cyVideoToolBar
             didDragSlider:(UISlider *)slider {
    [self.player pause];
    self->_playing = NO;
}

/**
 * 松开滑块继续播放
 */
- (void)cyVideoToolBarView:(KKZVideoToolBar *)cyVideoToolBar
            didReplayVideo:(UISlider *)slider {
    double currentTime = (double) (slider.value);
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC)
            toleranceBefore:kCMTimeZero
             toleranceAfter:kCMTimeZero];
    [self.player play];
    self->_playing = YES;
}

/**
 * 改变滑块的当前值
 */
- (void)cyVideoToolBarView:(KKZVideoToolBar *)cyVideoToolBar
            didChangeValue:(UISlider *)slider {
    double currentTime = (double) (slider.value);
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC)
            toleranceBefore:kCMTimeZero
             toleranceAfter:kCMTimeZero];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}

- (KKZVideoToolBar *)toolBarView {
    if (!_toolBarView) {
        _toolBarView = [[KKZVideoToolBar alloc] initWithFrame:CGRectMake(0, self.frame.size.height - toolBarHeight, self.frame.size.width, toolBarHeight)];
        _toolBarView.delegate = self;
        _toolBarView.backgroundColor = [UIColor colorWithHex:@"#222222"];
    }
    return _toolBarView;
}

- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

- (AVPlayerLayer *)playerLayer {
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = CGRectMake(0, 0, _imageView.frame.size.width, _imageView.frame.size.height);
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        //添加单击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        [self addGestureRecognizer:tap];
    }
    return _playerLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    self.playerLayer.frame = self.bounds;
    self.toolBarView.frame = CGRectMake(0, self.frame.size.height - toolBarHeight, self.frame.size.width, toolBarHeight);
}

- (void)tapGesture {
    //单击屏幕或者点击播放/暂停按钮来控制视图的显示
    self.toolBarView.hidden = !self.toolBarView.hidden;
    self.toolBarView.playBtn.selected = !self.toolBarView.playBtn.selected;

    //控制播放器播放还是停止
    if (!self.toolBarView.hidden) {
        self.imageView.hidden = YES;
        [self.player play];
        self->_playing = YES;
    } else {
        self.imageView.hidden = NO;
        [self.player pause];
        self->_playing = NO;
    }

    //触发代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickScreenTouchEnd)]) {
        [self.delegate clickScreenTouchEnd];
    }
}

- (void)dealloc {
    [self removeAllObserver];
}

@end
