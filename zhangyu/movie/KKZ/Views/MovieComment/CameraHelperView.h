//
//  CameraHelperView.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/17.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraImageHelper.h"

@interface CameraHelperView : UIView

/**
 *  图片捕捉
 */
@property (nonatomic, strong) CameraImageHelper *cameraImageHelper;

/**
 *  初始化页面
 *
 *  @param frame
 *  @param controller
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
     withController:(CommonViewController *)controller;

@end
