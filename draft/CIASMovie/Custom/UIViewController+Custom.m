//
//  UIViewController+Custom.m
//  CIASMovie
//
//  Created by cias on 2016/12/13.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "UIViewController+Custom.h"
#import <objc/runtime.h>

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/PHPhotoLibrary.h>
#import <MediaPlayer/MediaPlayer.h>


@implementation UIViewController (Custom)

/**
 *  override initialize(for support swift)
 */
+ (void)initialize {
    if (self != UIViewController.self) {
        return;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewDidLoad);
        SEL swizzledSelector = @selector(custom_viewDidLoad);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
        SEL originalviewWillAppear = @selector(viewWillAppear:);
        SEL swizzledviewWillAppear = @selector(custom_viewWillAppear:);
        
        Method originalMethodViewWillAppear = class_getInstanceMethod(class, originalviewWillAppear);
        Method swizzledMethodViewWillAppear = class_getInstanceMethod(class, swizzledviewWillAppear);
        
        method_exchangeImplementations(originalMethodViewWillAppear, swizzledMethodViewWillAppear);
        
        SEL originalviewWillDisappear = @selector(viewWillDisappear:);
        SEL swizzledviewWillDisappear = @selector(custom_viewWillDisappear:);
        
        Method originalMethodViewWillDisappear = class_getInstanceMethod(class, originalviewWillDisappear);
        Method swizzledMethodViewWillDisappear = class_getInstanceMethod(class, swizzledviewWillDisappear);
        
        method_exchangeImplementations(originalMethodViewWillDisappear, swizzledMethodViewWillDisappear);
        
    });
}


/**
 *  swizz viewDidLoad
 */
- (void)custom_viewDidLoad {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self custom_viewDidLoad];
    
//    if (self.navigationController.viewControllers.count > 1 && self.hideNavigationBar == NO && self.hideBackBtn == NO) {
//        self.navigationItem.leftBarButtonItem = [self customLeftBackButton];
//    }
}

/**
 *  swizz viewWillAppear
 *
 *  @param animated animated
 */
- (void)custom_viewWillAppear:(BOOL)animated {
    //default setup
//    [self od_setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:self.hideNavigationBar animated:YES];
    if (self.navigationController.viewControllers.count > 1 && self.hideNavigationBar==NO && self.hideBackBtn==NO) {
        self.navigationItem.leftBarButtonItem = [self customLeftBackButton];
    }

    [self custom_viewWillAppear:animated];
    
    if (self.navigationController.viewControllers.count > 1 && self.hideNavigationBar == YES && self.hideBackBtn == NO) {
        UIButton *btn = [self backBtn];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@5);
            make.top.equalTo(@20);
            make.width.height.equalTo(@44);
        }];
    }
    
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    
    if (self.hideNavigationBar == YES) {
        [self.navigationItem setLeftBarButtonItem:nil];
    }
}



#pragma mark - 自定义返回按钮图片
- (UIBarButtonItem *)customLeftBackButton {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:[self backBtn]];
    
    return backItem;
}

- (UIButton *)backBtn {
//    UIImage *image = [UIImage imageNamed:@""];
//    if (self.backBtnImageName) {
//        image = [UIImage imageNamed:self.backBtnImageName];
//    } else {
//        image = [UIImage imageNamed:@"mBack"];
//    }
//    
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    backButton.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//    
//    [backButton setImage:image
//                forState:UIControlStateNormal];
//    [backButton addTarget:self
//                   action:@selector(backItemClick)
//         forControlEvents:UIControlEventTouchUpInside];

//    }
    
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 7, 28, 28);
    [backButton setImage:[UIImage imageNamed:@"titlebar_back1"]
                forState:UIControlStateNormal];
//    [backButton setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9, 29)];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self
                   action:@selector(backItemClick)
         forControlEvents:UIControlEventTouchUpInside];
    return backButton;

}
/**
 *  MARK: 返回按钮
 */
- (void)backItemClick {
    //如果VC响应backAction，则调用VC的backAction
    if ([self respondsToSelector:@selector(backAction)]) {
        [self performSelector:@selector(backAction)];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
}


//置换viewWillDisappear
- (void)custom_viewWillDisappear:(BOOL)animated {
//    [SVProgressHUD dismiss];
    [self custom_viewWillDisappear:animated];
}

- (void)setHideNavigationBar:(BOOL)hideNavigationBar {
    objc_setAssociatedObject(self, @selector(hideNavigationBar), @(hideNavigationBar), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)hideNavigationBar {
    NSNumber *num = objc_getAssociatedObject(self, @selector(hideNavigationBar));
    return num.boolValue;
}

- (void)setHideBackBtn:(BOOL)hideBackBtn {
    objc_setAssociatedObject(self, @selector(hideBackBtn), @(hideBackBtn), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)hideBackBtn {
    NSNumber *num = objc_getAssociatedObject(self, @selector(hideBackBtn));
    return num.boolValue;
}

- (void)setBackBtnImageName:(NSString *)backBtnImageName {
    objc_setAssociatedObject(self, @selector(backBtnImageName), backBtnImageName, OBJC_ASSOCIATION_COPY);
}

- (NSString *)backBtnImageName {
    return objc_getAssociatedObject(self, @selector(backBtnImageName));
}





/**
 判断相册权限，无权限会弹出吐司
 */
- (void)judgeAssetLibraryAuthorCallback:(void (^)(BOOL))callback {
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if (authorStatus == MPMediaLibraryAuthorizationStatusDenied || authorStatus == MPMediaLibraryAuthorizationStatusRestricted) {
        callback(false);
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"没有相册的使用权限" cancleTitle:@"知道了" callback:^(BOOL confirm) {
        }];
    } else if (authorStatus == MPMediaLibraryAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == MPMediaLibraryAuthorizationStatusAuthorized) {
                callback(true);
            } else {
                callback(false);
                [[CIASAlertCancleView new] show:@"温馨提示" message:@"没有相册的使用权限" cancleTitle:@"知道了" callback:^(BOOL confirm) {
                }];
            }
        }];
    } else {
        callback(true);
    }
}

/**
 判断摄像头权限，无权限会弹出吐司
 */
- (void)judgeCameraAuthorCallback:(void (^)(BOOL))callback {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        callback(false);
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"没有摄像头的使用权限" cancleTitle:@"知道了" callback:^(BOOL confirm) {
        }];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            callback(granted);
            if (!granted) {
                [[CIASAlertCancleView new] show:@"温馨提示" message:@"没有摄像头的使用权限" cancleTitle:@"知道了" callback:^(BOOL confirm) {
                }];
            }
        }];
    } else {
        callback(true);
    }
}












@end
