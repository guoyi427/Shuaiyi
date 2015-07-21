//
//  MPHomeCollectionCell.h
//  MobilePrint
//
//  Created by guoyi on 15/6/8.
//  Copyright (c) 2015年 GuoYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPMobileShellModel;
@interface MPHomeCollectionCell : UICollectionViewCell

/// 手机壳数据模型
@property (nonatomic, strong) MPMobileShellModel * model;

@end
