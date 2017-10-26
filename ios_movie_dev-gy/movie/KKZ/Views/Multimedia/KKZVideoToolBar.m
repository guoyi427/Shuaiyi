//
//  播放器进度、播放控制按钮的View
//
//  Created by 艾广华 on 16/3/7.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "KKZVideoToolBar.h"

#import "UIColor+Hex.h"

/*****************工具条布局*******************/
static const CGFloat fullBtnWidth = 46.0f;
static const CGFloat playBtnWidth = 43.0f;
static const CGFloat beginTimeWidth = 40.0f;
static const CGFloat endTimeWidth = 40.0f;

@interface KKZVideoToolBar ()

@property (nonatomic, strong) UIImage *thumbImg;

@end

@implementation KKZVideoToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.playBtn];
        [self addSubview:self.fullBtn];
        [self addSubview:self.beginTimeLabel];
        [self addSubview:self.endTimeLabel];
        [self addSubview:self.playerSlider];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat originX = playBtnWidth + beginTimeWidth;
    self.playerSlider.frame = CGRectMake(originX, (self.frame.size.height - self.thumbImg.size.height) / 2.0f, self.frame.size.width - originX - endTimeWidth - fullBtnWidth, self.thumbImg.size.height);
    self.endTimeLabel.frame = CGRectMake(self.frame.size.width - endTimeWidth - fullBtnWidth, 0, endTimeWidth, self.frame.size.height);
    self.fullBtn.frame = CGRectMake(self.frame.size.width - fullBtnWidth, 0, fullBtnWidth, self.frame.size.height);
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.frame = CGRectMake(0, 0, playBtnWidth, self.frame.size.height);
        [_playBtn setImage:[UIImage imageNamed:@"videoPlayer_play"]
                  forState:UIControlStateNormal];
        _playBtn.selected = YES;
        [_playBtn setImage:[UIImage imageNamed:@"videoPlayer_pause"]
                  forState:UIControlStateSelected];
        _playBtn.backgroundColor = [UIColor clearColor];
        [_playBtn addTarget:self
                          action:@selector(playBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIButton *)fullBtn {
    if (!_fullBtn) {
        _fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _fullBtn.frame = CGRectMake(self.frame.size.width - fullBtnWidth, 0, fullBtnWidth, self.frame.size.height);
        [_fullBtn setImage:[UIImage imageNamed:@"videoPlayer_fullscreen"]
                  forState:UIControlStateNormal];
        [_fullBtn setImage:[UIImage imageNamed:@"videoPlayer_fullscreen"]
                  forState:UIControlStateSelected];
        [_fullBtn addTarget:self
                          action:@selector(fullBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullBtn;
}

- (UILabel *)beginTimeLabel {
    if (!_beginTimeLabel) {
        _beginTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(playBtnWidth, 0, beginTimeWidth, self.frame.size.height)];
        _beginTimeLabel.textAlignment = NSTextAlignmentCenter;
        _beginTimeLabel.font = [UIFont systemFontOfSize:10.0f];
        _beginTimeLabel.textColor = [UIColor whiteColor];
        _beginTimeLabel.text = @"00:00";
    }
    return _beginTimeLabel;
}

- (UILabel *)endTimeLabel {
    if (!_endTimeLabel) {
        _endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - endTimeWidth - fullBtnWidth, 0, endTimeWidth, self.frame.size.height)];
        _endTimeLabel.textAlignment = NSTextAlignmentCenter;
        _endTimeLabel.font = [UIFont systemFontOfSize:10.0f];
        _endTimeLabel.textColor = [UIColor whiteColor];
        _endTimeLabel.text = @"00:00";
    }
    return _endTimeLabel;
}

- (UISlider *)playerSlider {
    if (!_playerSlider) {
        _playerSlider = [[UISlider alloc] init];
        CGFloat originX = playBtnWidth + beginTimeWidth;
        _playerSlider.frame = CGRectMake(originX, (self.frame.size.height - self.thumbImg.size.height) / 2.0f, self.frame.size.width - originX - endTimeWidth - fullBtnWidth, self.thumbImg.size.height);
        _playerSlider.maximumTrackTintColor = [UIColor blackColor];
        _playerSlider.minimumTrackTintColor = [UIColor colorWithHex:@"#37c580"];
        [_playerSlider setThumbImage:self.thumbImg
                            forState:UIControlStateNormal];
        [_playerSlider addTarget:self
                          action:@selector(didDragSlider:)
                forControlEvents:UIControlEventTouchDown];
        [_playerSlider addTarget:self
                          action:@selector(didReplay:)
                forControlEvents:UIControlEventTouchUpInside];
        [_playerSlider addTarget:self
                          action:@selector(didReplay:)
                forControlEvents:UIControlEventTouchUpOutside];
        [_playerSlider addTarget:self
                          action:@selector(didChangeValue:)
                forControlEvents:UIControlEventValueChanged];
    }
    return _playerSlider;
}

- (UIImage *)thumbImg {
    if (!_thumbImg) {
        _thumbImg = [UIImage imageNamed:@"videoPlayer_thumb"];
    }
    return _thumbImg;
}

- (void)playBtnClick:(UIButton *)playBtn {
    if ([self.delegate respondsToSelector:@selector(cyVideoToolBarView:didPlayVideo:)]) {
        [self.delegate cyVideoToolBarView:self didPlayVideo:!playBtn.selected];
    }
}

- (void)fullBtnClick:(UIButton *)fullBtn {
    fullBtn.selected = !fullBtn.selected;
    if ([self.delegate respondsToSelector:@selector(cyVideoToolBarView:shouldFullScreen:)]) {
        [self.delegate cyVideoToolBarView:self shouldFullScreen:fullBtn.selected];
    }
}

#pragma mark - 监听滑块的一些事件
- (void)didDragSlider:(UISlider *)playerSlider {
    self.playBtn.selected = YES;
    if ([self.delegate respondsToSelector:@selector(cyVideoToolBarView:didDragSlider:)]) {
        [self.delegate cyVideoToolBarView:self didDragSlider:playerSlider];
    }
}

- (void)didReplay:(UISlider *)playerSlider {
    self.playBtn.selected = !self.playBtn.selected;
    NSLog(@"selected===%d", self.playBtn.selected);
    if ([self.delegate respondsToSelector:@selector(cyVideoToolBarView:didReplayVideo:)]) {
        [self.delegate cyVideoToolBarView:self didReplayVideo:playerSlider];
    }
}

- (void)didChangeValue:(UISlider *)playerSlider {
    if ([self.delegate respondsToSelector:@selector(cyVideoToolBarView:didChangeValue:)]) {
        [self.delegate cyVideoToolBarView:self didChangeValue:playerSlider];
    }
}

@end
