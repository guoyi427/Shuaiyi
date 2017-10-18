//
//  UIViewController+Custom.h
//  CIASMovie
//
//  Created by cias on 2016/12/13.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Custom)

/**
 *  是否隐藏导航条 set in viewDidLoad
 *  不要使用navigationController setNavigationBarHidden
 */
@property (nonatomic) BOOL hideNavigationBar;

/**
 *  隐藏返回按钮
 */
@property (nonatomic) BOOL hideBackBtn;

@property (nonatomic, copy) NSString *backBtnImageName;


/**
 判断相册权限，无权限会弹出吐司
 */
- (void)judgeAssetLibraryAuthorCallback:(void (^)(BOOL Authorized))callback;

/**
 判断摄像头权限，无权限会弹出吐司
 */
- (void)judgeCameraAuthorCallback:(void (^)(BOOL Authorized))callback;



@end
