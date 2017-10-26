//
//  CameraEditorViewController.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/18.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CommonViewController.h"
#import "ImageDetailCommentViewController.h"

typedef enum : NSUInteger {
    CameraCommentViewType,
    CameraAddImageViewType,
} CameraViewType;

@interface CameraEditorViewController : CommonViewController

/**
 *  用户选取的图片
 */
@property (nonatomic, strong) UIImage *originalImg;

/**
 *  从哪个页面进入
 */
@property (nonatomic, assign) joinCurrentPageFrom pageFrom;

/**
 *  当前页面类型
 */
@property (nonatomic, assign) CameraViewType viewType;

/**
 *  获取需要剪切的图片尺寸
 *
 *  @return
 */
- (CGRect)getCropImageRect;

/**
 *  获取剪切框的尺寸
 *
 *  @return
 */
- (CGRect)getCropRect;

@end
