//
//  RecordAudioView.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/15.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDProgressView.h"

/*页面接收通知*/
static NSString * const recordAudioSuccessNotification = @"recordAudioSuccessNotification";

@interface RecordAudioView : UIView

/**
 *  进度条视图
 */
@property (nonatomic, strong) ZDProgressView *progressView;

/**
 *  初始化视图
 *
 *  @param frame      视图尺寸
 *  @param controller 视图对应的控制器
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
     withController:(CommonViewController *)controller;

/**
 *  显示松手取消文字
 */
- (void)showLetGoCancelTitle;

/**
 *  显示上移取消文字
 */
- (void)showMoveCancelTitle;

/**
 *  隐藏松手取消文字和上移取消文字
 */
- (void)hidenCancelTitle;

/**
 *  开始监听声音
 */
- (void)startListen;

/**
 *  开始声音的录制
 */
- (void)startRecord;

/**
 *  取消录制音频
 */
- (void)cancelRecord;

/**
 *  结束声音的录制
 */
- (void)stopRecord;

/**
 *  清空音频数据
 */
- (void)clearAudioData;



@end
