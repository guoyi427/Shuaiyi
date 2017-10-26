//
//  KKZVideoMaskView.m
//  KoMovie
//
//  Created by 艾广华 on 16/3/7.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "KKZVideoMaskView.h"

static const CGFloat videoPlayLabelTop = 15.0f;
static const CGFloat videoPlayLabelHeight = 13.0f;
static const CGFloat videoTimeLabelTop = 10.0f;
static const CGFloat videoTimeLabelHeight = 11.0f;

@interface KKZVideoMaskView ()

/**
 *  播放图片视图
 */
@property (nonatomic, strong) UIImageView *playImageView;

/**
 *  播放图片
 */
@property (nonatomic, strong) UIImage *playImage;

/**
 *  视频点击播放文字
 */
@property (nonatomic, strong) UILabel *videoPlayLabel;

@end

@implementation KKZVideoMaskView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //播放视频按钮
        [self addSubview:self.playImageView];
        [self addSubview:self.videoPlayLabel];
        [self addSubview:self.videoTimeLabel];
    }
    return self;
}

- (void)layoutSubviews {
    CGFloat originY = (CGRectGetHeight(self.frame) - self.playImage.size.height - videoPlayLabelTop - videoPlayLabelHeight - videoTimeLabelTop - videoTimeLabelHeight) / 2.0f;
    self.playImageView.frame = CGRectMake((CGRectGetWidth(self.frame) - self.playImage.size.width) / 2.0f, originY, self.playImage.size.width, self.playImage.size.height);
    self.videoPlayLabel.frame = CGRectMake(0, CGRectGetMaxY(_playImageView.frame) + videoPlayLabelTop, self.frame.size.width, videoPlayLabelHeight);
    self.videoTimeLabel.frame = CGRectMake(0, CGRectGetMaxY(_videoPlayLabel.frame) + videoTimeLabelTop, self.frame.size.width, videoTimeLabelHeight);
}

- (UIImageView *)playImageView {
    if (!_playImageView) {
        CGFloat originY = (CGRectGetHeight(self.frame) - self.playImage.size.height - videoPlayLabelTop - videoPlayLabelHeight - videoTimeLabelTop - videoTimeLabelHeight) / 2.0f;
        _playImageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) - self.playImage.size.width) / 2.0f, originY, self.playImage.size.width, self.playImage.size.height)];
        _playImageView.image = self.playImage;
    }
    return _playImageView;
}

- (UIImage *)playImage {
    if (!_playImage) {
        _playImage = [UIImage imageNamed:@"club_PlayPause"];
    }
    return _playImage;
}

- (UILabel *)videoPlayLabel {
    if (!_videoPlayLabel) {
        _videoPlayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_playImageView.frame) + videoPlayLabelTop, self.frame.size.width, videoPlayLabelHeight)];
        _videoPlayLabel.textAlignment = NSTextAlignmentCenter;
        _videoPlayLabel.font = [UIFont systemFontOfSize:13.0f];
        _videoPlayLabel.backgroundColor = [UIColor clearColor];
        _videoPlayLabel.textColor = [UIColor whiteColor];
        _videoPlayLabel.text = @"点击播放";
    }
    return _videoPlayLabel;
}

- (UILabel *)videoTimeLabel {
    if (!_videoTimeLabel) {
        _videoTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_videoPlayLabel.frame) + videoTimeLabelTop, self.frame.size.width, videoTimeLabelHeight)];
        _videoTimeLabel.textAlignment = NSTextAlignmentCenter;
        _videoTimeLabel.font = [UIFont systemFontOfSize:11.0f];
        _videoTimeLabel.backgroundColor = [UIColor clearColor];
        _videoTimeLabel.textColor = [UIColor whiteColor];
    }
    return _videoTimeLabel;
}

@end
