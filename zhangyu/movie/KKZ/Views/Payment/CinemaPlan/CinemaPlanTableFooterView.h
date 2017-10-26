//
//  排期列表没有排期数据时显示提示信息的View
//
//  Created by 艾广华 on 16/4/14.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CinemaPlanTableFooterDelegate <NSObject>

/**
 *  点击查看明天场次按钮
 */
- (void)onClickTomorrowEventButton;

@end

@interface CinemaPlanTableFooterView : UIView

/**
 *  显示显示标题
 */
@property (nonatomic, strong) NSString *title;

/**
 *  按钮的显示标题(为空就将视图从父视图移除,不为空就添加到父视图)
 */
@property (nonatomic, strong) NSString *buttonTitle;

/**
 *  代理对象
 */
@property (nonatomic, weak) id<CinemaPlanTableFooterDelegate> delegate;

@end
