//
//  排期列表页面顶部电影列表的View
//
//  Created by 艾广华 on 16/4/12.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@protocol CinemHeaderDelegate <NSObject>

/**
 *  每当影院头部信息改变的时候
 *
 *  @param height
 */
- (void)cinemHeaderHeightChanged:(CGFloat)height;

/**
 *  切换电影选择代理
 *
 *  @param index 
 */
- (void)switchMovieDidSelectIndex:(NSInteger)index;

/**
 *  点击影院标题视图
 */
- (void)didSelectCinemaTitleHeaderView;

@end

@interface CinemaMovieView : UIView

/**
 *  电影数据模型
 */
@property (nonatomic, strong) NSArray *movieList;

/**
 *  默认选中的电影Id
 */
@property (nonatomic, copy) NSNumber *movieId;

/**
 *  点击进详情的的电影Id
 */
@property (nonatomic, copy) NSNumber *detailMovieId;

/**
 *  是否能够点击进详情
 */
@property (nonatomic, assign) BOOL isMoviedetailCanbeclicked;

/**
 *  代理对象
 */
@property (nonatomic, weak) id<CinemHeaderDelegate> delegate;

/**
 *  更新布局
 */
- (void)updateLayout;

@end
