//
//  EditProfileAgeChooseView.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/24.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditProfileChooseView.h"

@interface EditProfileBirthChooseView : EditProfileChooseView

/**
 *  工具条上的标题
 */
@property (nonatomic, strong) NSString *titleItemString;

/**
 *  日期的字符串
 */
@property (nonatomic, strong) NSString *dateString;

/**
 *  block方法传值
 *
 *  @param block
 */
- (void)setMethodBlock:(CAll_BACK)block;

/**
 *  显示选择视图
 */
- (void)show;

/**
 *  隐藏选择视图
 */
- (void)close;

@end
