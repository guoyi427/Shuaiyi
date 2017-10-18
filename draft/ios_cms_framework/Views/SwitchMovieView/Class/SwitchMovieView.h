//
//  SwitchMovieView.h
//  切换视图
//
//  Created by 艾广华 on 16/4/6.
//  Copyright © 2016年 艾广华. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwitchMovieDelegate <NSObject>
@optional
/**
 *  选中的电影
 *
 *  @param viewHight
 */
- (void)switchMovieDidSelectIndex:(NSInteger)index;

/**
 是否显示优惠icon
 @param index 索引
 @return yes：显示 no：不显示(默认)
 */
- (BOOL) shouldShowOfferIconAtIndex:(NSInteger)index;

@end

@interface SwitchMovieView : UIImageView

/**
 *  未选中的电影海报的尺寸
 */
@property (nonatomic, assign) CGSize normalMovieSize;

/**
 *  选中的电影海报的尺寸
 */
@property (nonatomic, assign) CGSize currentMovieSize;

/**
 *  当前显示的图片数组索引
 */
@property (nonatomic, assign) NSInteger currentIndex;

/**
 *  是否可以切换影片
 */
@property (nonatomic, assign) BOOL isCanChangeMovie;

/**
 *  代理对象
 */
@property (nonatomic, weak) id<SwitchMovieDelegate>delegate;

/**
 *  加载网络请求图片
 *
 *  @param array
 */
- (void)loadImagesWithUrl:(NSArray *)array;

/**
 *  加载网络请求图片
 *
 *  @param array
 */

/**
 加载网络请求图片

 @param array 图片URl array
 @param sawArray 是否看过 [BOOL value] yes:看过 no：没看过 个数要与URL array一致
 */
- (void)loadImagesWithUrl:(NSArray *)array saw:(NSArray *)sawArray;

@end
