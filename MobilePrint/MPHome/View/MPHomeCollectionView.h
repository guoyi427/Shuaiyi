//
//  MPHomeCollectionView.h
//  MobilePrint
//
//  Created by guoyi on 15/6/8.
//  Copyright (c) 2015年 GuoYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPHomeCollectionView : UICollectionView

/// 首页收藏列表的数据源 元素为：MPMobileShellModel
@property (nonatomic, strong) NSArray * mobileShellModelList;

@end
