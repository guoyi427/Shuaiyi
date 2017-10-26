//
//  CameraPreView.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/18.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraPreView : UIView

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

/**
 *  显示的图片
 */
@property (nonatomic, strong) UIImage *originalImg;

/**
 *  预览图片视图
 */
@property (nonatomic, strong) UIImageView *originalImgV;

/**
 *  内容滚动条
 */
@property (nonatomic, strong) UIScrollView *contentScroll;

@end
