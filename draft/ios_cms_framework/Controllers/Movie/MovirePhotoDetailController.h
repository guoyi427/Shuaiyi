//
//  MovirePhotoDetailController.h
//  CIASMovie
//
//  Created by avatar on 2017/2/8.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+XLExtension.h"
#import "XLPhotoBrowser.h"

@interface MovirePhotoDetailController : UIViewController<XLPhotoBrowserDelegate, XLPhotoBrowserDatasource>

/**
 * scrollView
 */
@property (nonatomic , strong) UIScrollView  *scrollView;
/**
 * 图片数据数组
 */
@property (nonatomic , strong) NSMutableArray  *photoList;
/**
 * 图片数组
 */
@property (nonatomic , strong) NSMutableArray  *images;
/**
 *  url strings
 */
@property (nonatomic , strong) NSMutableArray  *urlStrings;
@property (nonatomic , assign) NSUInteger  index;


/**
 *  浏览图片
 */
- (void)clickImage:(UITapGestureRecognizer *)tap;
- (void)resetScrollView;

@end
