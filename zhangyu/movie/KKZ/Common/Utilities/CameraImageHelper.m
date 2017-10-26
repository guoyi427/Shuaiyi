//
//  CameraImageHelper.m
//  图片滤镜以及动画效果
//
//  Created by 艾广华 on 15-1-30.
//  Copyright (c) 2015年 艾广华. All rights reserved.
//

#import "CameraImageHelper.h"
#import "KKZUtility.h"
#import "MovieCommentViewModel.h"

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);
#define DURATION 0.7f

@interface CameraImageHelper ()

/**
 *  设备捕捉会话
 */
@property(nonatomic,strong)AVCaptureSession *session;

/**
 *  取景视图
 */
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *preview;

/**
 *  创建捕获静止图片的输出设备
 */
@property(nonatomic,strong)AVCaptureStillImageOutput *captureOutput;

/**
 *  当前动画是否正在运行
 */
@property (nonatomic, assign) BOOL isAnimateLoading;

/**
 *  子线程
 */
@property (nonatomic) dispatch_queue_t sessionQueue;

@end

@implementation CameraImageHelper

@synthesize session;
@synthesize captureOutput;

- (BOOL)videoAuthorizationAccess {
    __block BOOL access = FALSE;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (granted) {
                    //第一次用户接受
                    access = TRUE;
                }else{
                    //用户拒绝
                    access = FALSE;
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            access = TRUE;
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            access = FALSE;
            break;
        default:
            break;
    }
    return access;
}

- (NSString *)instantiationVideoDevice {
    
    if (![self videoAuthorizationAccess]) {
        return failAudioPermissionFail;
    }
    
    //1.创建捕捉会话层
    self.session=[[AVCaptureSession alloc]init];
    self.sessionQueue = dispatch_queue_create("session queue", DISPATCH_QUEUE_SERIAL );
    
    //执行适用于输出高分辨率照片质量
    [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    
    //2.创建、配置输入设备
    //输入设备,包括麦克风、摄像头，通过该对象可以设置物理设备的一些属性
    AVCaptureDevice *device=[self getCameraDeviceWithPosition:AVCaptureDevicePositionFront];
    AVCaptureDevice *backDevide = [self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    if (!backDevide) {
        return @"获取不到您的摄像头设备";
    }
    
    NSError *error;
    AVCaptureDeviceInput *captureInput=[AVCaptureDeviceInput deviceInputWithDevice:device
                                                                             error:&error];//设备输入数据管理对象
    
    //设置输入设备和取景变量
    self.videoCaptureDeviceInput = captureInput;
   
    if(!captureInput){
        return failAudioPermissionFail;
    }
    if ([self.session canAddInput:captureInput]) {
        [self.session addInput:captureInput];
    }else {
        return failAudioPermissionFail;
    }
    
    //3.创建、配置输出
    self.captureOutput=[[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings=[NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [self.captureOutput setOutputSettings:outputSettings];
    if ([self.session canAddOutput:self.captureOutput]) {
        [self.session addOutput:self.captureOutput];
    }else {
        return failAudioPermissionFail;
    }
    
    //视频对象连接
    AVCaptureConnection *videoConnection = [self.captureOutput connectionWithMediaType:AVMediaTypeVideo];
    videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    return nil;
}

- (void)embedPreviewInView: (UIView *) aView
                 WithFrame:(CGRect)videoFrame {
    
    if(!session) return;
    
    //设置取景
    _preview=[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.frame=videoFrame;
    _preview.videoGravity=AVLayerVideoGravityResizeAspectFill;
    [aView.layer addSublayer:_preview];
}


-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice= [self.videoCaptureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

-(void)setFlashMode:(AVCaptureFlashMode )flashMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}

/**
 *  开始取景
 */
-(void)startRunning{
    [self setSessionStartRunning];
}

- (void)setSessionStartRunning {
    //判断当前session是否正在运行
    if (![self.session isRunning]) {
        [self.session startRunning];
    }
}

- (void)setSessionStopRunning {
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
}

/**
 *  停止取景
 */
-(void)stopRunning{
    [self setSessionStopRunning];
}

/**
 *  拍照
 *
 *  @param block
 */
- (void)takePicture:(DidCapturePhotoBlock)block{
    AVCaptureConnection *videoConnection=nil;
    for (AVCaptureConnection *connnection in captureOutput.connections) {
        for (AVCaptureInputPort *port in [connnection inputPorts]) {
            if([[port mediaType] isEqual:AVMediaTypeVideo]){
                videoConnection=connnection;
                break;
            }
        }
        if(videoConnection) break;
    }
    
    if(!videoConnection){
        block(nil);
        return;
    }
    
    //获取图片拍照静止的图片
    [captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                               completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if(imageDataSampleBuffer){
            
            //根据得到的相片数据得到图片
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *t_image = [UIImage imageWithData:imageData];
            if(block){
                block(t_image);
            }
        }
    }];
}

- (void)switchCamera{
    
    if ([self isAnimateLoading]) {
        return;
    }
    
    //将变量改变
    self.isAnimateLoading = TRUE;
    
    //得到当前预览视图的父layer对象
    CALayer *layer = [_preview superlayer];
    
    //创建CATransition对象
    CATransition *animation = [CATransition animation];
    
    //设置运动时间
    animation.duration = DURATION;
    
    //设置运动的type
    animation.type = @"oglFlip";
    
    //设置运动的方向
    animation.subtype = kCATransitionFromLeft;
    
    //
    animation.delegate = self;
    
    //设置运动速度
    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut;
    
    //给父视图的layer对象添加动画
    [layer addAnimation:animation forKey:@"animation"];
    
    //延时设置摄像头执行
    [self performSelector:@selector(configureDevicePostion)
               withObject:nil
               afterDelay:0.1f];
}

- (void)configureDevicePostion{
    
    //获取视频捕捉的设备
    AVCaptureDevice *currentDevice = [self.videoCaptureDeviceInput device];
    AVCaptureDevicePosition currentPosition = [currentDevice position];
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition = AVCaptureDevicePositionFront;
    if (currentPosition == AVCaptureDevicePositionUnspecified
        || currentPosition == AVCaptureDevicePositionFront) {
        toChangePosition = AVCaptureDevicePositionBack;
    }
    toChangeDevice = [self getCameraDeviceWithPosition:toChangePosition];
    
    //获取要调整的输入对象
    AVCaptureDeviceInput *toChangeDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:toChangeDevice
                                                                                       error:nil];
    //改变会话的配置前一定要开启配置，配置完成后提交配置改变
    [self.session beginConfiguration];
    
    //移除掉原有的输入对象
    [self.session removeInput:self.videoCaptureDeviceInput];
    
    //添加新的输入对象
    if ([self.session canAddInput:toChangeDeviceInput]) {
        [self.session addInput:toChangeDeviceInput];
        self.videoCaptureDeviceInput = toChangeDeviceInput;
    }
    //提交会话配置
    [self.session commitConfiguration];
}

- (void)animationDidStop:(CAAnimation *)anim
                finished:(BOOL)flag {
    if (flag) {
        self.isAnimateLoading = FALSE;
    }
}

-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

-(void)dealloc{
    if ([session isRunning]) {
        [session stopRunning];
    }
}

@end
