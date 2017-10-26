//
//  KKZExportVideoView.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/16.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "KKZExportVideoView.h"
#import "KKZRotationLoopProgressView.h"
#import "UIColor+Hex.h"

/**************提示文字视图*******************/
static const CGFloat tipLabelLeft = 10.0f;
static const CGFloat tipLabelBottom = 12.0f;
static const CGFloat tipLabelHeight = 16.0f;

/**************圆圈旋转视图*******************/
static const CGFloat rotateViewWidth = 70.0f;
static const CGFloat rotateViewHeight = 70.0f;
static const CGFloat rotateViewTop = 15.0f;

/**************导出视频视图*******************/
static const CGFloat exportViewWidth = 216.0f;
static const CGFloat exportViewHeight = 120.0f;

@interface KKZExportVideoView ()

/**
 *  提示标签
 */
@property (nonatomic, strong) UILabel *tipLabel;

/**
 *  旋转的视图
 */
@property (nonatomic, strong) KKZRotationLoopProgressView *rotateView;

@end

@implementation KKZExportVideoView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        //导出视频的背景
        UIView *exportView = [[UIView alloc] initWithFrame:CGRectMake((kCommonScreenWidth - exportViewWidth)/2.0f, (kCommonScreenHeight - exportViewHeight) / 2.0f,exportViewWidth, exportViewHeight)];
        exportView.backgroundColor = [UIColor colorWithHex:@"#3a3a3a"];
        [self addSubview:exportView];
        
        //圆圈旋转的视图
        [exportView addSubview:self.rotateView];
        
        //提示标签
        [exportView addSubview:self.tipLabel];
    }
    return self;
}

- (void)show {
    
    //将当前页面添加到window上
    UIWindow *appWindow = [[UIApplication sharedApplication].delegate window];
    [appWindow addSubview:self];
    
    //开始执行旋转动画
    [self.rotateView beginAnimation];
}

- (void)hiden {
    
    //将当前页面从window上移除掉
    [self removeFromSuperview];
    
    //停止执行旋转动画
    [self.rotateView stopAnimation];
}

- (UILabel *)tipLabel {
    
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(tipLabelLeft, exportViewHeight - tipLabelBottom - tipLabelHeight, exportViewWidth - tipLabelLeft*2, tipLabelHeight)];
        _tipLabel.font = [UIFont systemFontOfSize:15.0f];
        [_tipLabel setTextColor:[UIColor whiteColor]];
        [_tipLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _tipLabel;
}

- (KKZRotationLoopProgressView *)rotateView {
    
    if (!_rotateView) {
        _rotateView = [[KKZRotationLoopProgressView alloc] initWithFrame:CGRectMake((exportViewWidth - rotateViewWidth)/2.0f,rotateViewTop,rotateViewWidth, rotateViewHeight)];
        _rotateView.backgroundColor = [UIColor clearColor];
    }
    return _rotateView;
}

- (void)setTipString:(NSString *)tipString {
    _tipString = tipString;
    self.tipLabel.text = _tipString;
}

@end
