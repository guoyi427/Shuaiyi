//
//  KKZHorizonCollectionViewCell.h
//
//  Created by 艾广华 on 16/3/11.
//  Copyright © 2016年 艾广华. All rights reserved.
//

@interface KKZHorizonCollectionViewCell : UICollectionViewCell

/**
 *  图标文字介绍
 */
@property (nonatomic, strong) UILabel *iconLbel;

/**
 *  是否显示底部的分割线
 */
@property (nonatomic, assign) BOOL showBottomView;

/**
 *  是否显示优惠标签 默认：NO 不显示
 */
@property (nonatomic, assign) BOOL showOfferIcon;


@end
