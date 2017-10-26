//
//  CustomButton.h
//  TaduFramework
//
//  Created by 艾广华 on 15-4-10.
//  Copyright (c) 2015年 惠每. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACustomButton : UIButton
{
    NSMutableDictionary *_colors;
}
//设置按钮的背景颜色
- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state; // default is nil
//得到按钮不同状态时的背景颜色
-(UIColor *)backgroundColorForState:(UIControlState)state;
@end
