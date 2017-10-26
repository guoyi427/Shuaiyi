//
//  ProfileViewModel.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/25.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EditProfileViewController;
@class EditProfileView;

typedef void(^ProfileViewModel_CAll_BACK)(NSObject *o);

#define CHANGE_PHOTO_SUCCESS @"avatarPathY"

@interface ProfileViewModel : NSObject

/**
 *  初始化VM类
 *
 *  @param controller 控制器
 *  @param view       视图
 *
 *  @return
 */
- (id)initWithController:(EditProfileViewController *)controller
                withView:(EditProfileView *)view;

/**
 *  TableView点击Cell
 *
 *  @param row
 */
- (void)didSelectRowAtRowNum:(NSInteger)rowNum;

/**
 *  设置回调方法
 *
 *  @param callBack
 */
- (void)setBlockMethod:(ProfileViewModel_CAll_BACK)callBack;

@end
