//
//  EditProfileView.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/22.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditHeadingTitleCell.h"
#import "ProfileViewModel.h"
#import "UserInfo.h"

@interface EditProfileView : UIView

/**
 *  数据模型
 */
@property (nonatomic, strong) UserInfo *userInfo;

/**
 *  VM模型
 */
@property (nonatomic, weak) ProfileViewModel *profileViewModel;

/**
 *  初始化视图
 *
 *  @param frame      尺寸
 *  @param controller 控制器
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
     withController:(CommonViewController *)controller;

@end
