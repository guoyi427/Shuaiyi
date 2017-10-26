//
//  EditTextCell.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/23.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditProfileLayout.h"

@interface EditTextCell : UITableViewCell

/**
 *  主标题
 */
@property (nonatomic, strong) NSString *titleStr;

/**
 *  副标题
 */
@property (nonatomic, strong) NSString *detailTitleStr;

/**
 *  布局类
 */
@property (nonatomic, strong) EditProfileLayout *layout;

@end
