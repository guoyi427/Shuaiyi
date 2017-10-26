//
//  ZDProgressView.h
//  PE
//
//  Created by 杨志达 on 14-6-20.
//  Copyright (c) 2014年 PE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZDProgressView : UIView

/**
 *  设置进度
 */
@property (nonatomic,assign) CGFloat progress;

/**
 *  设置进度条的背景颜色
 */
@property (nonatomic,strong) UIColor *noColor;

/**
 *  设置进度条变化的颜色
 */
@property (nonatomic,strong) UIColor *prsColor;


@end
