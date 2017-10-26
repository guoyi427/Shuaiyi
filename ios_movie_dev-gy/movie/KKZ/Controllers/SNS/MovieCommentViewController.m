//
//  MovieCommentViewController.m
//  KoMovie
//
//  Created by 艾广华 on 16/1/27.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "MovieCommentViewController.h"
#import "KKZUtility.h"
#import "UIColor+Hex.h"
#import "CameraFlashView.h"
#import "ImageSelectView.h"
#import "MovieCommentData.h"

#define MAX_RECODE_TIME 30

static const CGFloat selectViewHeight = 255.0f;

/**************导航栏视图*******************/
static const CGFloat closeButtonOriginX = 15.0f;
static const CGFloat closeButtonOriginY = 17.0f;
static const CGFloat closeButtonWidth = 17.0f;

/**************切换按钮视图*******************/
static const CGFloat switchButtonRight = 15.0f;
static const CGFloat switchButtonTop = 15.0f;
static const CGFloat flashSwitchButtonRight = 10.0f;

/**************视频显示视图*******************/
static const CGFloat videoViewOriginY = 117.0f;

@interface MovieCommentViewController ()<UIGestureRecognizerDelegate>

/**
 *  闪光灯视图
 */
@property (nonatomic, strong) CameraFlashView *cameraFlashView;

/**
 *  闪光灯按钮
 */
@property (nonatomic, strong) UIButton *flashButton;

/**
 *  闪光灯切换摄像头按钮
 */
@property (nonatomic, strong) UIButton *flashSwitchButton;

/**
 *  前后摄像头切换按钮
 */
@property (nonatomic, strong) UIButton *switchButton;

/**
 *  关闭按钮
 */
@property (nonatomic, strong) UIButton *closelButton;

/**
 *  选择切换视图
 */
@property (nonatomic, strong) MovieSelectView *selectView;

/**
 *  图片选择视图
 */
@property (nonatomic, strong) ImageSelectView *imageSelectView;

@end

@implementation MovieCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载导航条
    [self loadNavBar];
    
    //加载相机视图
    [self loadMainView];
    
    //加载通知
    [self loadNotification];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    //状态栏隐藏
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

- (void)loadNavBar {
    
    //背景颜色
    self.view.backgroundColor = [UIColor colorWithHex:@"#191821"];
    
    //左导航按钮
    [self.view addSubview:self.closelButton];
}

- (void)loadMainView {
    //加载切换选择视图
    if (self.viewType == movieCommentViewType) {
        
        //加载多媒体页面
        [self loadMediaViewWithType:self.type];
        
        //加载按钮切换视图
        [self loadSelectView];
        
    }else if (self.viewType == addImageViewType) {
        
        //加载照相机页面
        [self loadMediaViewWithType:chooseTypeImageAndWord];
        
        //加载照相机视图
        [self loadImageSelectView];
    }
}

- (void)loadNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reciveCommonMethod:)
                                                 name:movieCommentSuccessCompleteNotification
                                               object:nil];
}

- (void)loadSelectView {
    
    //视图切换视图
    [self.view addSubview:self.selectView];
    
    //左扫手势
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    leftSwipe.delegate = self;
    [self.view addGestureRecognizer:leftSwipe];
    
    //右扫手势
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    rightSwipe.delegate = self;
    [self.view addGestureRecognizer:rightSwipe];
}

- (void)loadImageSelectView {
    
    //图片选择视图
    [self.view addSubview:self.imageSelectView];
}

- (void)loadMediaViewWithType:(chooseType)type {
    //根据当前多媒体类型来决定多媒体页面的显示形式
    if (type == chooseTypeAudio) {
        self.recordAudioView.hidden = NO;
        [self.recordAudioView startListen];
        _cameraHelperView.hidden = YES;
        [_cameraHelperView.cameraImageHelper stopRunning];
        _switchButton.hidden = YES;
        _flashButton.hidden = TRUE;
        _flashSwitchButton.hidden = TRUE;
    }else if (type == chooseTypeImageAndWord) {
        self.cameraHelperView.hidden = NO;
        [self.cameraHelperView.cameraImageHelper startRunning];
        _recordAudioView.hidden = YES;
        _switchButton.hidden = YES;
        self.flashButton.hidden = NO;
        AVCaptureDevice *captureDevice= [self.cameraHelperView.cameraImageHelper.videoCaptureDeviceInput device];
        if (captureDevice.flashMode == AVCaptureFlashModeAuto || captureDevice.flashMode == AVCaptureFlashModeOn) {
            self.flashButton.selected = FALSE;
        }else if (captureDevice.flashMode == AVCaptureFlashModeOff) {
            self.flashButton.selected = TRUE;
        }
        self.flashSwitchButton.hidden = NO;
    }
}

- (void)setFlashButtonType:(FlashChooseType)type {
    if (type == FlashChooseOn) {
        self.flashButton.selected = FALSE;
        [self.cameraHelperView.cameraImageHelper setFlashMode:AVCaptureFlashModeOn];
    }else if (type == FlashChooseOff) {
        self.flashButton.selected = TRUE;
        [self.cameraHelperView.cameraImageHelper setFlashMode:AVCaptureFlashModeOff];
    }else if (type == FlashChooseAuto) {
        self.flashButton.selected = FALSE;
        [self.cameraHelperView.cameraImageHelper setFlashMode:AVCaptureFlashModeAuto];
    }
}

- (void)reciveCommonMethod:(NSNotification *)note {
    [self.navigationController popToViewController:self
                                          animated:NO];
    [self popViewControllerAnimated:NO];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)swipeGesture:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.type < chooseTypeAudio) {
            UIButton *button = self.selectView.buttonsArray[self.type + 1];
            [self commonBtnClick:button];
        }
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (self.type > chooseTypeImageAndWord) {
            UIButton *button = self.selectView.buttonsArray[self.type - 1];
            [self commonBtnClick:button];
        }
    }
}

#pragma mark - CameraEditorViewControllerDelegate

- (CGRect)changeVideoViewFrame:(CGRect)frame {
    CGFloat maxHeight = videoViewOriginY - CGRectGetMaxY(self.closelButton.frame);
    CGFloat ratioHeight = CGRectGetWidth(frame) * 3 / 4;
    CGFloat actualHeight = CGRectGetHeight(frame);
    if (actualHeight < ratioHeight) {
        CGFloat diffHeight = ratioHeight - actualHeight;
        if (diffHeight > maxHeight) {
            diffHeight = maxHeight;
        }
        frame = CGRectMake(0,videoViewOriginY - diffHeight, kCommonScreenWidth, kCommonScreenHeight - videoViewOriginY - selectViewHeight + diffHeight);
    }
    return frame;
}

#pragma mark - View pulic Method

- (void)commonBtnClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case imageAndWordButtonTag:
        case audioButtonTag:{
            
            //如果点击的两次按钮相同就返回
            if (self.selectView.currentSelectBtn == sender) {
                return;
            }
            
            //标记当前的选择类型是图文类型
            self.type = sender.tag - imageAndWordButtonTag;
            [self loadMediaViewWithType:self.type];
            
            //切换选择视图动画
            [self.selectView changeSelectView:sender.tag - imageAndWordButtonTag
                             withChangeButton:sender
                                  withAnimate:YES];
            break;
        }
        case switchCameraButton:{
            
            break;
        }
        case flashSwitchButtonTag:{
            
            //切换照相机录制摄像头
            [self.cameraHelperView.cameraImageHelper switchCamera];
            break;
        }
        case flashChooseButtonTag:{
            
            //执行动画
            [self.view addSubview:self.cameraFlashView];
            if (self.cameraFlashView.isOpen) {
                [self.cameraFlashView closeChooseView];
            }else {
                AVCaptureDevice *captureDevice= [self.cameraHelperView.cameraImageHelper.videoCaptureDeviceInput device];
                __weak MovieCommentViewController *weak_self = self;
                [self.cameraFlashView openChooseViewWithChooseType:(FlashChooseType)captureDevice.flashMode
                                                   withChooseBlock:^(FlashChooseType flashType) {
                                                       [weak_self setFlashButtonType:flashType];
                                                   }];
            }
            break;
        }
        case MovieCommentCloseButtonTag:{
            [self popViewControllerAnimated:YES];
            break;
        }
        case chooseAlbumButtonTag: {
            [self.movieCommentViewModel choooseLibrary];
            break;
        }
        default:
            break;
    }
}

- (BOOL)showNavBar {
    return FALSE;
}

- (BOOL)isNavMainColor{
    return NO;
}

#pragma mark - getter Method

- (MovieSelectView *)selectView {
    if (!_selectView) {
        CGRect selectFrame = CGRectMake(0, kCommonScreenHeight - selectViewHeight, kCommonScreenWidth, selectViewHeight);
        _selectView = [[MovieSelectView alloc] initWithFrame:selectFrame
                                              withController:self];
        _selectView.backgroundColor = self.view.backgroundColor;
    }
    return _selectView;
}

- (ImageSelectView *)imageSelectView {
    if (!_imageSelectView) {
        CGRect selectFrame = CGRectMake(0, kCommonScreenHeight - selectViewHeight, kCommonScreenWidth, selectViewHeight);
        _imageSelectView = [[ImageSelectView alloc] initWithFrame:selectFrame
                                                   withController:self];
        _imageSelectView.backgroundColor = self.view.backgroundColor;
    }
    return _imageSelectView;
}

- (MovieCommentViewModel *)movieCommentViewModel {
    if (!_movieCommentViewModel) {
        _movieCommentViewModel = [[MovieCommentViewModel alloc] initWithController:self
                                                                          withView:_selectView];
    }
    return _movieCommentViewModel;
}

- (RecordAudioView *)recordAudioView {
    if (!_recordAudioView) {
        _recordAudioView = [[RecordAudioView alloc] initWithFrame:CGRectMake(0,videoViewOriginY, kCommonScreenWidth, kCommonScreenHeight - videoViewOriginY - selectViewHeight) withController:self];
        _recordAudioView.backgroundColor = [UIColor colorWithHex:@"#242328"];
        [self.view addSubview:_recordAudioView];
    }
    return _recordAudioView;
}

- (CameraHelperView *)cameraHelperView {
    if (!_cameraHelperView) {
        CGRect helperFrame = CGRectMake(0,videoViewOriginY, kCommonScreenWidth, kCommonScreenHeight - videoViewOriginY - selectViewHeight);
        helperFrame = [self changeVideoViewFrame:helperFrame];
        _cameraHelperView = [[CameraHelperView alloc] initWithFrame:helperFrame
                                                     withController:self];
        _cameraHelperView.backgroundColor = self.view.backgroundColor;
        _cameraHelperView.opaque = YES;
        [self.view addSubview:_cameraHelperView];
    }
    return _cameraHelperView;
}

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:0];
        UIImage *switchImg = [UIImage imageNamed:@"movieComment_switch"];
        CGFloat switchWidth = switchImg.size.width + 2 * switchButtonRight;
        _switchButton.frame = CGRectMake(kCommonScreenWidth - switchWidth,0,switchWidth, switchImg.size.height + 2*switchButtonTop);
        [_switchButton setImage:switchImg
                       forState:UIControlStateNormal];
        _switchButton.tag = switchCameraButton;
        [_switchButton addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_switchButton];
    }
    return _switchButton;
}

- (UIButton *)flashButton {
    if (!_flashButton) {
        _flashButton = [UIButton buttonWithType:0];
        UIImage *openFlashImg = [UIImage imageNamed:@"movieComment_open_flash"];
        UIImage *closeFlashImg = [UIImage imageNamed:@"movieComment_close_flash"];
        CGFloat flashWidth = openFlashImg.size.width + 2*switchButtonRight;
        _flashButton.frame = CGRectMake(kCommonScreenWidth - flashWidth,0,flashWidth, openFlashImg.size.height + 2*switchButtonTop);
        [_flashButton setImage:openFlashImg
                      forState:UIControlStateNormal];
        [_flashButton setImage:closeFlashImg
                      forState:UIControlStateSelected];
        _flashButton.tag = flashChooseButtonTag;
        [_flashButton addTarget:self
                         action:@selector(commonBtnClick:)
               forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_flashButton];
    }
    return _flashButton;
}

- (UIButton *)flashSwitchButton {
    if (!_flashSwitchButton) {
        _flashSwitchButton = [UIButton buttonWithType:0];
        UIImage *switchImg = [UIImage imageNamed:@"movieComment_switch"];
        CGFloat switchWidth = switchImg.size.width + 2*flashSwitchButtonRight;
        CGFloat switchLeft = kCommonScreenWidth - CGRectGetWidth(_flashButton.frame) - switchWidth;
        _flashSwitchButton.frame = CGRectMake(switchLeft,0,switchWidth, switchImg.size.height + 2*switchButtonTop);
        [_flashSwitchButton setImage:switchImg
                            forState:UIControlStateNormal];
        _flashSwitchButton.tag = flashSwitchButtonTag;
        [_flashSwitchButton addTarget:self
                               action:@selector(commonBtnClick:)
                     forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_flashSwitchButton];
    }
    return _flashSwitchButton;
}

- (CameraFlashView *)cameraFlashView {
    if (!_cameraFlashView) {
        UIImage *openFlashImg = [UIImage imageNamed:@"movieComment_open_flash"];
        CGFloat width = openFlashImg.size.width + switchButtonRight;
        _cameraFlashView = [[CameraFlashView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth - width, 50.0f)];
        _cameraFlashView.backgroundColor = self.view.backgroundColor;
    }
    return _cameraFlashView;
}

- (UIButton *)closelButton {
    if (!_closelButton) {
        UIImage *closeImg = [UIImage imageNamed:@"loginCloseButton"];
        _closelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closelButton.frame = CGRectMake(0.0f,0.0f,closeButtonWidth + closeButtonOriginX*2,closeButtonWidth + closeButtonOriginY*2);
        _closelButton.backgroundColor = [UIColor clearColor];
        [_closelButton setImage:closeImg forState:UIControlStateNormal];
        [_closelButton setImageEdgeInsets:UIEdgeInsetsMake(closeButtonOriginY, closeButtonOriginX,closeButtonOriginY, closeButtonOriginX)];
        _closelButton.tag = MovieCommentCloseButtonTag;
        [_closelButton addTarget:self
                         action:@selector(commonBtnClick:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _closelButton;
}

- (void)dealloc {
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    if (_recordAudioView) {
        [_recordAudioView clearAudioData];
    }
    if (self.viewType == CameraCommentViewType) {
        MovieCommentData *data = [MovieCommentData sharedInstance];
        [data freeMovieCommentData];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
