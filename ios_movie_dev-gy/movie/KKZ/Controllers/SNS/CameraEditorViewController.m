//
//  CameraEditorViewController.m
//  KoMovie
//
//  Created by 艾广华 on 16/2/18.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CameraEditorViewController.h"
#import "CameraPreView.h"
#import "KKZUtility.h"
#import "MovieCommentData.h"
#import "MovieSelectHeader.h"

static const CGFloat photoBackViewHeight = 80.0f;

#define ratioHeight         3 * kCommonScreenWidth / 4
#define ratioTop            (kCommonScreenHeight - ratioHeight)/2.0f

typedef enum : NSUInteger {
    chooseButtonTag = 1000,
    cancelButtonTag,
} cameraEditorAllButtonTag;

@interface CameraEditorViewController ()

/**
 *  相机的视图
 */
@property (nonatomic, strong) UIView *photoBackView;

/**
 *  剪切视图
 */
@property (nonatomic, strong) UIView *ratioView;

/**
 *  覆盖图层
 */
@property (nonatomic, strong) UIView *overlayView;

/**
 *  预览图片
 */
@property (nonatomic, strong) CameraPreView *cameraPreView;

/**
 *  取消按钮
 */
@property (nonatomic, strong) UIButton *cancelBtn;

/**
 *  选取按钮
 */
@property (nonatomic, strong) UIButton *useBtn;

@end

@implementation CameraEditorViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //加载剪切视图
    [self loadCropView];
    
    //加载底部视图
    [self loadBottomView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)loadBottomView {
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.photoBackView];
}

- (void)loadCropView {
    self.cameraPreView.originalImg = self.originalImg;
    [self.view addSubview:self.cameraPreView];
    [self.view addSubview:self.overlayView];
    [self.view addSubview:self.ratioView];
    [self overlayClipping];
}

- (void)overlayClipping
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    
    // Left side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0,
                                        0,
                                        self.ratioView.frame.origin.x,
                                        self.overlayView.frame.size.height));
    // Right side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(
                                        self.ratioView.frame.origin.x + self.ratioView.frame.size.width,
                                        0,
                                        self.overlayView.frame.size.width - self.ratioView.frame.origin.x - self.ratioView.frame.size.width,
                                        self.overlayView.frame.size.height));
    // Top side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0,
                                        0,
                                        self.overlayView.frame.size.width,
                                        self.ratioView.frame.origin.y));
    // Bottom side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0,
                                        self.ratioView.frame.origin.y + self.ratioView.frame.size.height,
                                        self.overlayView.frame.size.width,
                                        self.overlayView.frame.size.height - self.ratioView.frame.origin.y + self.ratioView.frame.size.height));
    maskLayer.path = path;
    self.overlayView.layer.mask = maskLayer;
    CGPathRelease(path);
}

- (CGRect)getCropImageRect {
    
    //原始的图片尺寸
    CGFloat imageHeight = self.originalImg.size.height;
    CGFloat imageWidth = self.originalImg.size.width;
    
    //变化后的图片尺寸
    CGFloat changeHeight = kCommonScreenWidth * imageHeight / imageWidth;
    CGFloat changeWidth = kCommonScreenWidth;
    
    //剪切框的尺寸
    if (changeHeight < ratioHeight) {
        changeHeight = ratioHeight;
        changeWidth = changeHeight * imageWidth / imageHeight;
    }
    CGRect originalFrame = CGRectMake((kCommonScreenWidth - changeWidth)/2.0f,(kCommonScreenHeight - changeHeight)/2.0f, changeWidth, changeHeight);
    return originalFrame;
}

- (CGRect)getCropRect {
    return CGRectMake(0,ratioTop, kCommonScreenWidth, ratioHeight);
}

- (BOOL)showNavBar {
    return FALSE;
}

- (void)commonBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case chooseButtonTag:{
            CGFloat top = self.cameraPreView.contentScroll.contentOffset.y;
            CGFloat left = self.cameraPreView.contentScroll.contentOffset.x;
            CGSize toCropSize = self.cameraPreView.originalImgV.frame.size;
            _originalImg = [KKZUtility resibleImage:_originalImg
                                             toSize:toCropSize];
            _originalImg= [KKZUtility croppedImage:_originalImg
                                         withFrame:CGRectMake(left, top, kCommonScreenWidth, ratioHeight)];
            [[MovieCommentData sharedInstance].imagesArray addObject:_originalImg];
            if (self.viewType == CameraCommentViewType) {
                //进入到图片评论页面
                ImageDetailCommentViewController *detail = [[ImageDetailCommentViewController alloc] init];
                detail.imagesArray = [MovieCommentData sharedInstance].imagesArray;
                detail.pageFrom = self.pageFrom;
                [self pushViewController:detail
                               animation:CommonSwitchAnimationFlipL];
            }else if (self.viewType == CameraAddImageViewType) {
                if (self.pageFrom == joinCurrentPageFromCamera) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:cameraEditorChooseButtonNotification object:nil];
                }else if (self.pageFrom == joinCurrentPageFromLibrary) {
                    [self dismissViewControllerAnimated:NO
                                             completion:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:cameraEditorChooseButtonNotification object:nil];
                }
            }
            break;
        }
        case cancelButtonTag:{
            [self popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
}

- (UIView *)ratioView {
    
    if (!_ratioView) {
        CGFloat width = kCommonScreenWidth;
        _ratioView = [[UIView alloc] initWithFrame:CGRectMake(0,ratioTop, width, ratioHeight)];
        _ratioView.backgroundColor = [UIColor clearColor];
        _ratioView.layer.borderColor = [UIColor whiteColor].CGColor;
        _ratioView.layer.borderWidth = 0.3f;
        _ratioView.userInteractionEnabled = NO;
        
    }
    return _ratioView;
}

- (UIView *)overlayView {
    
    if (!_overlayView) {
        _overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight - photoBackViewHeight)];
        _overlayView.backgroundColor = [UIColor blackColor];
        _overlayView.userInteractionEnabled = NO;
        _overlayView.alpha = 0.7;
    }
    return _overlayView;
}

- (CameraPreView *)cameraPreView {
    
    if (!_cameraPreView) {
        _cameraPreView = [[CameraPreView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight) withController:self];
    }
    return _cameraPreView;
}

-(UIView *)photoBackView{
    if(!_photoBackView){
        
        _photoBackView = [[UIView alloc]initWithFrame:CGRectMake(0,kCommonScreenHeight - photoBackViewHeight,kCommonScreenWidth, photoBackViewHeight)];
        _photoBackView.backgroundColor = [UIColor colorWithRed:20.0f/255.0f
                                                         green:20.0f/255.0f
                                                          blue:20.0f/255.0f
                                                         alpha:1.0f];
        //重拍按钮
        [_photoBackView addSubview:self.cancelBtn];
        
        //使用图片按钮
        [_photoBackView addSubview:self.useBtn];
        
    }
    return _photoBackView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat cancelBtnHeight = 30.0f;
        CGFloat cancelBtnWidth = photoBackViewHeight;
        CGFloat cancelBtnLeft = 10.0f;
        [_cancelBtn setTitle:@"取消"
                    forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
        [_cancelBtn setFrame:CGRectMake(cancelBtnLeft,(_photoBackView.frame.size.height-cancelBtnHeight)/2.0f,cancelBtnWidth,cancelBtnHeight)];
        _cancelBtn.tag = cancelButtonTag;
        [_cancelBtn addTarget:self
                      action:@selector(commonBtnClick:)
            forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    return _cancelBtn;
}

- (UIButton *)useBtn {
    if (!_useBtn) {
        _useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat useBtnHeight = 30.0f;
        CGFloat cancelBtnLeft = 10.0f;
        CGFloat useBtnWidth = photoBackViewHeight;
        CGFloat useBtnOriginX = _photoBackView.frame.size.width - useBtnWidth - cancelBtnLeft;
        [_useBtn setTitle:@"选取"
                 forState:UIControlStateNormal];
        [_useBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
        [_useBtn setFrame:CGRectMake(useBtnOriginX,(_photoBackView.frame.size.height-useBtnHeight)/2.0f,useBtnWidth,useBtnHeight)];
        _useBtn.tag = chooseButtonTag;
        [_useBtn addTarget:self
                   action:@selector(commonBtnClick:)
         forControlEvents:UIControlEventTouchUpInside];
        [_useBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
    return _useBtn;
}

- (void)dealloc {
    
}

@end
