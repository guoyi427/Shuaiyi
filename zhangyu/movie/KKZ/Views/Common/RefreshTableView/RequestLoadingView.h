//
//  RequestLoadingView.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/18.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestLoadingView : UIView

/**
 *  中心区域的标签文字
 */
@property (nonatomic, strong) UIColor *centerLblColor;

/**
 *  初始化页面
 *
 *  @param frame
 *  @param title 加载过程中显示的文字
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
          withTitle:(NSString *)title;

/**
 *  开始动画
 */
- (void)startAnimation;

/**
 *  停止动画
 */
- (void)stopAnimation;

@end
