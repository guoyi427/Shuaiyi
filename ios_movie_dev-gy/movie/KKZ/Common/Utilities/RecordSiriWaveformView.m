//
//  RecordSiriWaveformView.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/17.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "RecordSiriWaveformView.h"

static const CGFloat kDefaultFrequency          = 1.5f;
static const CGFloat kDefaultPrimaryLineWidth   = 3.0f;
static const CGFloat kDefaultDensity            = 5.0f;
static const CGFloat kDefaultPhaseShift         = -0.15f;

@interface RecordSiriWaveformView ()

/**
 *  显示幅度
 */
@property (nonatomic, assign) CGFloat amplitude;

/**
 *  点的变化区间值
 */
@property (nonatomic, assign) CGFloat phase;

/**
 *  清空波形视图
 */
@property (nonatomic, assign) BOOL clearWaveView;

@end

@implementation RecordSiriWaveformView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.waveColor = [UIColor whiteColor];
    self.frequency = kDefaultFrequency;
    self.primaryWaveLineWidth = kDefaultPrimaryLineWidth;
    self.density = kDefaultDensity;
    self.phaseShift = kDefaultPhaseShift;
}

- (void)updateWithLevel:(CGFloat)level {
    
    //清空视图标志为False
    self.clearWaveView = FALSE;
    
    //设置绘画的参数
    self.phase += self.phaseShift;
    self.amplitude = fmax(level, 0.01f);
    [self setNeedsDisplay];
}

- (void)clearWaveform {
    
    //清空视图标志为TRUE
    self.clearWaveView = TRUE;
    
    //刷新视图
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    //获取绘画的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置线条宽度
    CGContextSetLineWidth(context, self.primaryWaveLineWidth);
    
    //设置视图的尺寸
    CGFloat halfHeight = CGRectGetHeight(self.bounds) / 2.0f;
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat mid = width / 2.0f;
    
    //设置波形的幅度
    CGFloat normedAmplitude = self.amplitude;
    const CGFloat maxAmplitude = halfHeight;
    
    //设置线条颜色
    [self.waveColor set];
    
    //绘制线条
    if (!self.clearWaveView) {
        for (CGFloat x = 0; x < width + self.density; x += self.density) {
            
            //点的幅度变化是从小到大
            CGFloat scaling = - powf((x - mid)/mid, 2) + 1;
            
            //计算每个点的y坐标
            CGFloat y = maxAmplitude * normedAmplitude * scaling * sinf(2 * M_PI *(x / width) * self.frequency + self.phase) + halfHeight;
            if (x == 0) {
                CGContextMoveToPoint(context, x, y);
            }else {
                CGContextAddLineToPoint(context, x, y);
            }
        }
        CGContextStrokePath(context);
    }
}

@end
