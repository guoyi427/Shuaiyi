//
//  播放器进度、播放控制按钮的View
//
//  Created by 艾广华 on 16/3/7.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@class KKZVideoToolBar;

@protocol CYVideoToolBarDelegate <NSObject>

@optional

/** <点击了底部工具条上的播放/暂停按钮> */
- (void)cyVideoToolBarView:(KKZVideoToolBar *)cyVideoToolBar didPlayVideo:(BOOL)isPlay;

/** <是否全屏播放视频> */
- (void)cyVideoToolBarView:(KKZVideoToolBar *)cyVideoToolBar shouldFullScreen:(BOOL)isFull;

/** <开始拖到滑块> */
- (void)cyVideoToolBarView:(KKZVideoToolBar *)cyVideoToolBar didDragSlider:(UISlider *)slider;

/** <松开滑块继续播放> */
- (void)cyVideoToolBarView:(KKZVideoToolBar *)cyVideoToolBar didReplayVideo:(UISlider *)slider;

/** <改变滑块的当前值> */
- (void)cyVideoToolBarView:(KKZVideoToolBar *)cyVideoToolBar didChangeValue:(UISlider *)slider;

@end

@interface KKZVideoToolBar : UIView

/** <播放的按钮> */
@property (nonatomic, strong) UIButton *playBtn;

/** < 全屏或半屏的按钮 > */
@property (nonatomic, strong) UIButton *fullBtn;

/** < 滑块 > */
@property (nonatomic, strong) UISlider *playerSlider;

/** < timeLabel > */
@property (nonatomic, strong) UILabel *beginTimeLabel;

/** < timeLabel > */
@property (nonatomic, strong) UILabel *endTimeLabel;

/** <delegate> */
@property (nonatomic, weak) id<CYVideoToolBarDelegate> delegate;

@end
