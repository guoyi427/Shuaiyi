//
//  排期列表顶部影院基本信息的View
//
//  Created by 艾广华 on 16/4/11.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@protocol CinemaTitleHeaderDelegate <NSObject>

/**
 *  影院标题视图的高度改变
 *
 *  @param viewHight
 */
- (void)cinemaTitleHeaderChangeHeight:(CGFloat)viewHight;

/**
 *  点击影院标题视图
 */
- (void)didSelectCinemaTitleHeaderView;

@end

@interface CinemaTitleHeader : UIView

/**
 *  影院名字
 */
@property(nonatomic, strong) NSString *cinemaName;

/**
 *  影院地址
 */
@property(nonatomic, strong) NSString *cinemaAddress;

/**
 *  标签数组
 */
@property(nonatomic, strong) NSArray *labelArray;

/**
 *  代理方法
 */
@property(nonatomic, weak) id<CinemaTitleHeaderDelegate> delegate;

@end
