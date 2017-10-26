//
//  MovieCommentViewModel.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/2.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "MovieCommentViewModel.h"
#import "MovieDetailCommentViewController.h"
#import "KKZUtility.h"
#import "MovieCommentViewController.h"
#import "MovieSelectView.h"
#import "CustomImagePickerController.h"

#define MAX_RECODE_TIME 60

@interface MovieCommentViewModel ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/**
 *  对应着的Controller对象
 */
@property (nonatomic, weak) MovieCommentViewController *controller;

/**
 *  选择视图
 */
@property (nonatomic, weak) MovieSelectView *movieSelectView;

/**
 *  视频和音频录制的定时器
 */
@property (nonatomic, strong) NSTimer *timer;

/**
 *  总的录制时间
 */
@property (nonatomic, assign) NSUInteger totalRecordTime;

@end

@implementation MovieCommentViewModel

- (id)initWithController:(MovieCommentViewController *)controller {
    self = [super init];
    if (self) {
        self.controller = controller;
        
        //接收音频
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(joinMovieDetailCommentController)
                                                     name:recordAudioSuccessNotification
                                                   object:nil];
    }
    return self;
}

- (id)initWithController:(MovieCommentViewController *)controller
                withView:(MovieSelectView *)movieSelectView {
    self = [super init];
    if (self) {
        self.controller = controller;
        self.movieSelectView = movieSelectView;
        
        //接收音频
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(joinMovieDetailCommentController)
                                                     name:recordAudioSuccessNotification
                                                   object:nil];
    }
    return self;
}

- (void)startRecordVideo {
    
    //增加定时器
    [self addTimer];
    
    //禁止页面点击
    self.controller.view.userInteractionEnabled = NO;
}
- (void)startRecordAudio {
    
    //增加定时器
    [self addTimer];
    
    //禁止页面点击
    self.controller.view.userInteractionEnabled = NO;
    
    //开始录像
    [self.controller.recordAudioView startRecord];
}

- (void)showAudioCancelTitle {
    [self.controller.recordAudioView showMoveCancelTitle];
}

- (void)showAudioLetGoCancelTitle {
    [self.controller.recordAudioView showLetGoCancelTitle];
}

- (void)hidenAudioCancelTitle {
    [self.controller.recordAudioView hidenCancelTitle];
}

- (void)takePicture {
    __weak MovieCommentViewModel *weak_self = self;
    [self.controller.cameraHelperView.cameraImageHelper takePicture:^(UIImage *stillImage) {
        [weak_self joinImageEditorViewWithImage:stillImage];
    }];
}

- (void)joinImageEditorViewWithImage:(UIImage *)stillImage {
    CameraEditorViewController *cameraView = [[CameraEditorViewController alloc] init];
    cameraView.originalImg = stillImage;
    cameraView.pageFrom = joinCurrentPageFromCamera;
    cameraView.viewType = self.controller.viewType;
    [self.controller pushViewController:cameraView
                              animation:CommonSwitchAnimationFlipL];
}

- (void)choooseLibrary {
    CustomImagePickerController *picker = [[CustomImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self.controller presentViewController:picker
                                  animated:YES
                                completion:nil];
}

#pragma 拍照选择照片协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    CameraEditorViewController *cameraView = [[CameraEditorViewController alloc] init];
    cameraView.originalImg = originImage;
    cameraView.pageFrom = joinCurrentPageFromLibrary;
    cameraView.viewType = self.controller.viewType;
    [picker pushViewController:cameraView
                      animated:YES];
}

- (void)addTimer {
    
    //移除定时器
    [self removeTimer];
    
    //增加定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(recordTime)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)recordTime {
    
    //每隔一秒录制时间增加1
    self.totalRecordTime += 1;
    
    //如果录制时间大于最大秒
    if (self.totalRecordTime >= MAX_RECODE_TIME) {
        
        //页面跳转
        [self stopRecordVideo];
    }
}

- (void)stopRecordVideo {
    
    //如果已经移除掉声音播放
    if (self.timer == nil) {
        return;
    }
    
    //允许页面点击
    self.controller.view.userInteractionEnabled = YES;
    
    //判断录制视频时间
    if (self.totalRecordTime < 2) {
        
        //取消录制
        [self cancelRecord];
        
        //弹出录制时间过短的警告框
        [KKZUtility showAlertTitle:@"您录制的时间太短了"
                            detail:@""
                            cancel:@"知道了"
                         clickCall:nil
                            others:nil];
    }else {
        
        //录制完成
        [self recordComplte];
    }
    
    //总的录制时间清空
    self.totalRecordTime = 0;
}

- (void)cancelRecord {
    
    //如果已经移除掉声音播放
    if (self.timer == nil) {
        return;
    }
    
    //允许页面点击
    self.controller.view.userInteractionEnabled = YES;
    
    //移除定时器
    [self removeTimer];
    
    //判断录制的类型
    if (self.controller.type == chooseTypeAudio) {
        [self.controller.recordAudioView cancelRecord];
    }
    
    //录音时间清除
    self.totalRecordTime = 0;
}

- (void)recordComplte {
    
    //移除定时器
    [self removeTimer];
    
    if (self.controller.type == chooseTypeAudio) {
        
        //停止录制视频
        [self.controller.recordAudioView stopRecord];
    }
}

- (void)joinMovieDetailCommentController {
    
    //进入到视频详情页面
    MovieDetailCommentViewController *detailVC = [[MovieDetailCommentViewController alloc] init];
    detailVC.type = self.controller.type;
    [self.controller pushViewController:detailVC
                              animation:CommonSwitchAnimationFlipR];
}

- (void)dismissViewControllerWhenUserProhibitAccess {
    [self dismissViewControllerWhenMeidiaInitFail:failAudioPermissionFail];
}

- (void)dismissViewControllerWhenMeidiaInitFail:(NSString *)failReason {
    [KKZUtility showAlertTitle:failReason
                        detail:@""
                        cancel:@"确定"
                     clickCall:^(NSInteger buttonIndex) {
                         [self.controller popViewControllerAnimated:YES];
                     }
                        others:nil];
}

- (void)setTotalRecordTime:(NSUInteger)totalRecordTime {
    
    //设置当前录音的 总时间
    _totalRecordTime = totalRecordTime;
    
    //更新进度条
    CGFloat progress = (CGFloat)self.totalRecordTime /(CGFloat)MAX_RECODE_TIME;
    if (self.controller.type == chooseTypeAudio) {
        self.controller.recordAudioView.progressView.progress = progress;
    }
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
