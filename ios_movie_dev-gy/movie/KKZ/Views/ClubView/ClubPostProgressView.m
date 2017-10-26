//
//  ClubPostProgressView.m
//  KoMovie
//
//  Created by 艾广华 on 16/3/1.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubPostProgressView.h"
#import "ZDProgressView.h"
#import "UIColor+Hex.h"

/*****************间距****************/
static const CGFloat marginTimeToProgress = 9;

/*****************播放进度条的高度****************/
static const CGFloat progressTop = 16.0f;
static const CGFloat progressHeight = 8.0f;

/*****************播放时间按钮****************/
static const CGFloat beginTimeLabelTop = 14.0f;
static const CGFloat beginTimeLabelHeight = 12.0f;
static const CGFloat beginTimeLabelWeight = 40.0f;

/*****************剩余时间按钮****************/
static const CGFloat endTimeLabelTop = 14.0f;
static const CGFloat endTimeLabelWeight = 46.0f;

/*****************暂停按钮****************/
static const CGFloat pauseBtnLeft = 6.0f;
static const CGFloat pauseBtnTop = 0.0f;
static const CGFloat pauseBtnWidth = 40.0f;
static const CGFloat pauseBtnHeight = 40.0f;

@interface ClubPostProgressView ()



/**
 *  进度条视图
 */
@property (nonatomic, strong) ZDProgressView *progressView;

/**
 *  开始时间
 */
@property (nonatomic, strong) UILabel *beginTimeLabel;

/**
 *  结束时间
 */
@property (nonatomic, strong) UILabel *endTimeLabel;

@end

@implementation ClubPostProgressView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置背景色
        [self setBackgroundColor:[UIColor r:0 g:0 b:0 alpha:0.8]];
        
        //添加暂停按钮
        [self addSubview:self.pauseBtn];
        
        //当前播放时间
        [self addSubview:self.beginTimeLabel];
        
        //总的播放时间
        [self addSubview:self.endTimeLabel];
        
        //添加进度条
        [self addSubview:self.progressView];
    }
    return self;
}

- (void)addTimer {
    
    //移除定时器
    [self removeTimer];
    
    //增加定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                  target:self
                                                selector:@selector(recordTime:)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer
                                 forMode:NSRunLoopCommonModes];
}

- (void)setPlayer:(AVAudioPlayer *)player {
    _player = player;
    
    //实时监测播放进度
    [self addTimer];
}

- (void)recordTime:(id)sender {
    
    //判断当前播放器是不是正在播放
    if(self.player.playing) {
        CGFloat progress = self.player.currentTime/self.player.duration;
        if (progress >= 0.96f) {
            progress = 1.0f;
        }
        self.progressView.progress = progress;
    }
    
    //设置播放时间
    [self setPlayTimeWithCurrent:self.player.currentTime
                       withTotal:self.player.duration];
}

//- (CGFloat)lengthOfMusic {
//    
//    //获取当前播放器的时长
//    NSTimeInterval theTimeInterval = self.player.duration;
//    
//    // 获取system calendar
//    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
//    
//    // 创建NSDates
//    NSDate *date1 = [[NSDate alloc] init];
//    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:theTimeInterval sinceDate:date1];
//    
//    // 转换到小时、分钟
//    unsigned int unitFlags = NSMinuteCalendarUnit | NSSecondCalendarUnit;
//    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
//    NSLog(@"Duration: MM/SS %d:%d",[breakdownInfo minute], [breakdownInfo second]);
//}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)setPlayTimeWithCurrent:(NSInteger)current
                     withTotal:(NSInteger)total {
    
    //当前播放时间
    NSString *currentTime = [NSString stringWithFormat:@"%@:%@",[self getFormatterTimeWithTime:current/60],[self getFormatterTimeWithTime:current]];
    self.beginTimeLabel.text = currentTime;
    
    //总的播放时间
    NSString *totalTime = [NSString stringWithFormat:@"%@:%@",[self getFormatterTimeWithTime:total/60],[self getFormatterTimeWithTime:total%60]];
    self.endTimeLabel.text = totalTime;
}

- (NSString *)getFormatterTimeWithTime:(NSInteger)time {
    NSString *second = nil;
    if (time < 60.0f){
        second = [NSString stringWithFormat:@"%02ld",(long)time];
    }else {
        second = [NSString stringWithFormat:@"00"];
    }
    return second;
}

- (ZDProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[ZDProgressView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.beginTimeLabel.frame) + marginTimeToProgress, progressTop, CGRectGetMinX(self.endTimeLabel.frame) - marginTimeToProgress * 2 - CGRectGetMaxX(self.beginTimeLabel.frame),progressHeight)];
        [_progressView setNoColor:[UIColor whiteColor]];
        [_progressView setPrsColor:appDelegate.kkzBlue];
        _progressView.progress = 0.0f;
    }
    return _progressView;
}

- (UILabel *)beginTimeLabel {
    if (!_beginTimeLabel) {
        _beginTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.pauseBtn.frame),beginTimeLabelTop,beginTimeLabelWeight, beginTimeLabelHeight)];
        _beginTimeLabel.textAlignment = NSTextAlignmentRight;
        _beginTimeLabel.textColor = [UIColor whiteColor];
        _beginTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _beginTimeLabel;
}

- (UILabel *)endTimeLabel {
    if (!_endTimeLabel) {
        _endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(screentWith - endTimeLabelWeight, endTimeLabelTop, beginTimeLabelWeight, beginTimeLabelHeight)];
        _endTimeLabel.textAlignment = NSTextAlignmentLeft;
        _endTimeLabel.textColor = [UIColor whiteColor];
        _endTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _endTimeLabel;
}

- (void)dealloc {
    [self removeTimer];
}

/**
 *  暂停按钮
 */
-(UIButton *)pauseBtn
{
    if (!_pauseBtn) {
        _pauseBtn = [[UIButton alloc] initWithFrame:CGRectMake(pauseBtnLeft, pauseBtnTop, pauseBtnWidth, pauseBtnHeight)];
        [_pauseBtn addTarget:self action:@selector(pauseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_pauseBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
    return _pauseBtn;
}

-(void)pauseBtnClicked{
    if (self.player.playing) {
        [self.pauseBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.player pause];
        self.audioPlayerPause(YES);
    } else {
        [self.pauseBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.player play];
        self.audioPlayerPause(NO);
    }
}
@end
