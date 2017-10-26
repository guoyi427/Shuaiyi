//
//  ImageReviewView.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/21.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageReviewView : UIView

/**
 *  显示的图片
 */
@property (nonatomic,strong) UIImage *originalImage;

/**
 *  滚动条
 */
@property (nonatomic, strong) UIScrollView *contentScroll;

@end
