//
//  KKZWaveformPlayerView.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/16.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface KKZWaveformPlayerView : UIView

/**
 *  初始化播放影音的视图
 *
 *  @param frame         影音视图的尺寸
 *  @param asset         语音的信息
 *  @param normalColor   语音播放的时候进度条默认的颜色
 *  @param progressColor 语音播放的时候进度条变化的颜色
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
              asset:(AVURLAsset *)asset
              color:(UIColor *)normalColor
      progressColor:(UIColor *)progressColor;

/**
 *  停止音频播放器播放
 */
- (void)stopAudioPlayer;

@end
