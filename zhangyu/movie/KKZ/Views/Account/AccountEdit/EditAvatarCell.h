//
//  EditAvatarCell.h
//  KoMovie
//
//  Created by 艾广华 on 16/2/22.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAvatarCell : UITableViewCell

/**
 *  头像视图
 */
@property (nonatomic, strong) UIImageView *avatarImgV;

/**
 *  头像图片
 */
@property (nonatomic, strong) UIImage *avatarImg;

/**
 *  主标题
 */
@property (nonatomic, strong) NSString *titleStr;

/**
 *  默认头像图片
 */
@property (nonatomic, strong) UIImage *defaultImg;

/**
 *  获取当前CELL的高度
 *
 *  @return
 */
+ (CGFloat)cellHeight;

@end
