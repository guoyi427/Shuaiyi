//
//  EditHeadingTitleCell.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/23.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"

#define CELL_BACKGROUND_COLOR [UIColor colorWithHex:@"#f5f5f5"]

@interface EditHeadingTitleCell : UITableViewCell

/**
 *  主标题
 */
@property (nonatomic, strong) NSString *titleStr;

/**
 *  副标题
 */
@property (nonatomic, strong) NSString *detailTitleStr;

/**
 *  顶部标题
 */
@property (nonatomic, strong) NSString *headingStr;

@end
