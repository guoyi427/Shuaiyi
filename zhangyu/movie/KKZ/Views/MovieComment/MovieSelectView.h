//
//  MovieSelectView.h
//  KoMovie
//
//  Created by 艾广华 on 16/1/29.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieCommentControllerModel.h"
#import "MovieSelectHeader.h"

#define DEFAULT_TAKE_BUTTON_TOP 49.0f

@interface MovieSelectView : UIView

/**
 *  当前选择的按钮
 */
@property (nonatomic, strong) UIButton *currentSelectBtn;

/**
 *  按钮视图
 */
@property (nonatomic, strong) NSMutableArray *buttonsArray;

/**
 *  初始化页面
 *
 *  @param frame
 *  @param controller 视图的父控制器
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame
     withController:(CommonViewController *)controller;

/**
 *  切换选择按钮当前显示的择视图
 *
 *  @param type     切换的类型
 *  @param sender   点击的按钮
 *  @param animated 是否有动画
 */
- (void)changeSelectView:(chooseType)type
        withChangeButton:(UIButton *)sender
             withAnimate:(BOOL)animated;

@end
