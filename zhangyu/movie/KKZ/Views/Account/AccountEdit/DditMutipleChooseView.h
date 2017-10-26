//
//  DditMutipleChooseView.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/25.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "EditProfileChooseView.h"

@interface DditMutipleChooseView : EditProfileChooseView

/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray *mutipleDataArr;

/**
 *  需要选择器当前行显示的数据
 */
@property (nonatomic, strong) NSString *chooseDataString;

/**
 *  显示选择视图
 */
- (void)show;

/**
 *  隐藏选择视图
 */
- (void)close;

/**
 *  block方法传值
 *
 *  @param block
 */
- (void)setMethodBlock:(CAll_BACK)block;

@end
