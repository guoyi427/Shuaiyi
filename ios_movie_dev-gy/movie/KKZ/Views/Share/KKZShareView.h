//
//  KKZShareView.h
//  KoMovie
//
//  Created by 艾广华 on 16/4/15.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKZShareView : UIView

/**
 *  标题
 */
@property (nonatomic, strong) NSString *title;

/**
 *  内容
 */
@property (nonatomic, strong) NSString *content;

/**
 *  链接
 */
@property (nonatomic, strong) NSString *url;

/**
 *  图片链接
 */
@property (nonatomic, strong) NSString *imageUrl;

/**
 *  统计的类型
 */
@property (nonatomic, assign) StatisticsType statisType;

/**
 *  页面显示
 */
- (void)show;

/**
 *  页面隐藏
 */
- (void)hiden;

@end
