//
//  SingleCenterTableViewCell.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/22.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleCenterModel.h"
#import "SingleCenterLayout.h"

#define TABLEVIEW_FOOTER_HEIGHT 20

@interface SingleCenterTableViewCell : UITableViewCell

/**
 *  个人中心model数据
 */
@property (nonatomic, strong) SingleCenterModel *model;

/**
 *  是否画线
 */
@property (nonatomic, assign) BOOL is_DrawLine;

/**
 *  更新数据模型和模型布局
 *
 *  @param model
 *  @param layout
 */
- (void)updateModel:(SingleCenterModel *)model
        modelLayout:(SingleCenterLayout *)layout;

@end
