//
//  YNPhoneField.h
//  KoMovie
//
//  Created by 艾广华 on 15/11/9.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YNPhoneField : UITextField

/**
 *  加密按钮
 */
@property (nonatomic, strong) UIButton *secureBtn;

/**
 *  清除按钮
 */
@property (nonatomic, strong) UIButton *clearBtnYN;

/**
 *  是否显示加密按钮
 */
@property (nonatomic, assign) BOOL isShowSecure;

/**
 *  初始化视图
 *
 *  @param frame
 *  @param isSecure 是否显示加密视图
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
     withShowSecure:(BOOL)isSecure;

@end
