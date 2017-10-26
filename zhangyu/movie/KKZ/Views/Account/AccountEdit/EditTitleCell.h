//
//  EditTitleCell.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/23.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTitleCell : UITableViewCell

/**
 *  主标题
 */
@property (nonatomic, strong) NSString *titleStr;

/**
 *  副标题
 */
@property (nonatomic, strong) NSString *detailTitleStr;

/**
 *  是否隐藏箭头视图
 */
@property (nonatomic, assign) BOOL arrowHidden;

@end
