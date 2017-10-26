//
//  EditMutipleChooseCell.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/25.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditMutipleChooseCell : UITableViewCell

/**
 *  主标题
 */
@property (nonatomic, strong) NSString *titleStr;

/**
 *  是否选中
 */
@property (nonatomic, assign) BOOL checked;

/**
 *  当前Cell的高度
 *
 *  @return 
 */
+ (CGFloat)cellHeight;

@end
