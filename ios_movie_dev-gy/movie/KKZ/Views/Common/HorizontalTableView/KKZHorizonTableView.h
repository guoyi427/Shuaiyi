//
//  KKZHorizonTableView.h
//
//  Created by 艾广华 on 16/3/11.
//  Copyright © 2016年 艾广华. All rights reserved.
//

@protocol KKZHorizonTableViewDelegate <NSObject>

/**
 *  点击标签
 *
 *  @param tableView
 *  @param index     
 */
- (void)horizonTableView:(UICollectionView *)tableView didSelectRowAtIndex:(NSInteger)index;

/**
 *  当点击标签的时候是否需要放大标签
 *
 *  @return
 */
- (BOOL)horizonTableViewNeedToEnlargeTheTitleLabelOnClickLabel;

/**
 *  当点击标签的时候是否需要显示cell底部的视图
 *
 *  @return
 */
- (BOOL)horizonTableViewNeedToShowBottomViewOnClickLabel;

@optional

/**
 是否显示优惠标签

 @param index 索引
 @return yes：显示 no：不显示
 */
- (BOOL) shouldShowOfferIconAtIndex:(NSInteger)index;

@end

@interface KKZHorizonTableView : UIView

/**
 *  标签字体
 */
@property (nonatomic, strong) UIFont *labelFont;

/**
 *  标签颜色
 */
@property (nonatomic, strong) UIColor *labelColor;

/**
 *  放大后的标签字体
 */
@property (nonatomic, strong) UIFont *bigLabelFont;

/**
 *  点击后的的标签颜色
 */
@property (nonatomic, strong) UIColor *clickLabelColor;

/**
 *  每个Item之间的距离
 */
@property (nonatomic, assign) CGFloat itemSpacing;

/**
 *  在cell上的数据源(必须是字符串类型)
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 *  代理对象
 */
@property (nonatomic, weak) id<KKZHorizonTableViewDelegate> delegate;

/**
 *  默认选择的索引值
 */
@property (nonatomic, assign) NSInteger defaultChooseIndex;

/**
 *  整个视图的宽度
 */
@property (nonatomic, assign) CGFloat tableViewWidth;

/**
 *  表视图
 */
@property (nonatomic, strong) UICollectionView *listCollectionView;

/**
 *  手动调用CollectionView的选中Cell方法
 *
 *  @param collectionView
 *  @param indexPath
 */
- (void)collectionView:(UICollectionView *)collectionView
        didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end
