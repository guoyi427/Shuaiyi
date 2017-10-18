//
//  UIImage+Resize.h
//  Category_KKZ
//
//  Created by Albert on 8/19/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Resize_KKZ)
/**
 *  中心只放大背景（需要提供背景色）
 *  主要用在UIImageView使用SDWebImage加载网络图片时的place holder
 *  > 主题色可以自己提取，框架UIImageColors基于ColorArt实现了UIImage的色彩提取
 *  > 但ColorArt的license要求严
 *
 *  @param image   原图
 *  @param newSize 要放大的size
 *  @param color   背景色
 *
 *  @return 放大后的图
 */
+ (UIImage *) centerResizeFrom:(UIImage *)image newSize:(CGSize)newSize bgColor:(UIColor *)color;
@end
