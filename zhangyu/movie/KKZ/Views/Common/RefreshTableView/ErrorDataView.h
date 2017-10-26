//
//  ErrorDataView.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/18.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorDataView : UIView

/**
 *  初始化页面
 *
 *  @param frame 视图尺寸
 *  @param title 错误提示文字
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
          withTitle:(NSString *)title;

@end
