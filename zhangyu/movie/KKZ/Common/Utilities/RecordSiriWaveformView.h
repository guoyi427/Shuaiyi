//
//  RecordSiriWaveformView.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/17.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordSiriWaveformView : UIView

/**
 *  告诉视图根据给定的值重新绘画自己
 *
 *  @param level
 */
- (void)updateWithLevel:(CGFloat)level;

/**
 *  当画波浪线时的颜色
 */
@property (nonatomic, strong) UIColor *waveColor;

/**
 *  波浪线的频率
 */
@property (nonatomic, assign) CGFloat frequency;

/**
 *  线条的宽度
 */
@property (nonatomic, assign) CGFloat primaryWaveLineWidth;

/**
 *  每个点在X轴上的距离,距离越小，绘制越密，CPU使用的功率越大
 */
@property (nonatomic, assign) CGFloat density;

/**
 *  X轴坐标点的偏移量
 */
@property (nonatomic, assign) CGFloat phaseShift;

/**
 *  清空已经绘画的波形视图
 */
- (void)clearWaveform;

@end
