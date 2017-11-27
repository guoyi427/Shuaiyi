//
//  MovieCommentViewModel.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/2.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CameraEditorViewController.h"

static NSString *failAudioPermissionFail = @"请在iPhone的\"设置－隐私\"选项中，允许章鱼电影访问你的摄像头和麦克风";

@class MovieCommentViewController;
@class MovieSelectView;

@interface MovieCommentViewModel : NSObject

/**
 *  初始化ViewModel模块
 *
 *  @param controller 对应的哪个Controller的模块
 *
 *  @return
 */
- (id)initWithController:(MovieCommentViewController *)controller;

/**
 *  初始化ViewModel模块
 *
 *  @param controller      <#controller description#>
 *  @param movieSelectView <#movieSelectView description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithController:(MovieCommentViewController *)controller
                withView:(MovieSelectView *)movieSelectView;

/**
 *  当用户禁止访问相机，麦克风权限，页面销毁
 */
- (void)dismissViewControllerWhenUserProhibitAccess;

/**
 *  初始化音频数据或者音频失败，页面销毁
 *
 *  @param fail 失败原因
 */
- (void)dismissViewControllerWhenMeidiaInitFail:(NSString *)failReason;

/**
 *  开始视频的录制
 */
- (void)startRecordVideo;

/**
 *  当录制视频时显示的文字
 */
- (void)showVideoCancelTitle;

/**
 *  当手指移动出录制的圆圈区域显示的文字
 */
- (void)showVideoLetGoCancelTitle;

/**
 *  隐藏掉视频录制的文字
 */
- (void)hidenVideoCancelTitle;

/**
 *  开始音频的录制
 */
- (void)startRecordAudio;

/**
 *  当录制音频时显示的文字
 */
- (void)showAudioCancelTitle;

/**
 *  当手指移动出录制的圆圈区域显示的文字
 */
- (void)showAudioLetGoCancelTitle;

/**
 *  隐藏掉音频录制的文字
 */
- (void)hidenAudioCancelTitle;

/**
 *  取消音视频的录制
 */
- (void)cancelRecord;

/**
 *  停止视频的录制
 */
- (void)stopRecordVideo;

/**
 *  照相
 */
- (void)takePicture;

/**
 *  选择系统的相册
 */
- (void)choooseLibrary;

@end
