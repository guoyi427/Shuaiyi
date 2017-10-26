//
//  影院详情页面列表的每个Section的Header
//
//  Created by 艾广华 on 15/12/8.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@protocol CinemaTableSectionViewDelegate <NSObject>

/**
 *  更多按钮点击的时候进行调用
 *
 *  @param sectionNum 
 */
- (void)CinemaDetailShowMore:(NSInteger)sectionNum;

@end

@interface CinemaTableSectionView : UIView

/**
 *  标题字符串
 */
@property (nonatomic, strong) NSString *titleStr;

/**
 *  更多按钮是否隐藏
 */
@property (nonatomic, assign) BOOL BtnHidden;

/**
 *  代理对象
 */
@property (nonatomic, assign) id<CinemaTableSectionViewDelegate> delegate;

/**
 *  当前的是第几个section对象
 */
@property (nonatomic, assign) NSInteger sectionNum;

/**
 *  更新视图
 */
- (void)updateLayout;

@end
