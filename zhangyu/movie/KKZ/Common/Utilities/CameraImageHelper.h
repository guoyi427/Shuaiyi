//
//  CameraImageHelper.h
//  图片滤镜以及动画效果
//
//  Created by 艾广华 on 15-1-30.
//  Copyright (c) 2015年 艾广华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

typedef void(^DidCapturePhotoBlock)(UIImage *stillImage);

@interface CameraImageHelper : NSObject

/**
 *  嵌入要显示的取景视图
 *
 *  @param aView      要嵌入显示的视图
 *  @param videoFrame 显示的视频尺寸
 */
- (void)embedPreviewInView: (UIView *) aView
                 WithFrame:(CGRect)videoFrame;

/**
 *  开始取景
 */
- (void) startRunning;

/**
 *  停止取景
 */
- (void) stopRunning;

/**
 *  拍照
 *
 *  @param block
 */
- (void)takePicture:(DidCapturePhotoBlock)block;

/**
 *  切换前后摄像头
 *
 */
- (void)switchCamera;

/**
 *  初始化设备
 *
 *  @return 返回初始化成功或者失败的文字
 */
- (NSString *)instantiationVideoDevice;

/**
 *  设置闪光灯类型
 *
 *  @param flashMode 
 */
-(void)setFlashMode:(AVCaptureFlashMode )flashMode;

/**
 *  视频输入捕获设备
 */
@property (nonatomic, strong) AVCaptureDeviceInput *videoCaptureDeviceInput;

@end
