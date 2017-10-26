//
//  ClubTypeOneCell.h
//  KoMovie
//
//  Created by KKZ on 16/2/1.
//  Copyright © 2016年 kokozu. All rights reserved.
//

/**
 *  一张图片 左图片 右文字的类型
 */

#import <UIKit/UIKit.h>
@class ClubCellBottom;
@class TypeOnePostThumbnailContentView;
@class KKZAuthor;

@interface ClubTypeOneCell : UITableViewCell {
    //用户信息
    ClubCellBottom *clubCellBottom;
    //帖子内容缩略图
    TypeOnePostThumbnailContentView *thumbnailContentView;
}

/**
 *  点赞的用户数
 */
@property (nonatomic, strong) NSNumber *supportNum;

/**
 *  评论的用户数
 */
@property (nonatomic, strong) NSNumber *commentNum;

/**
 *  与用户的好友关系
 */
@property (nonatomic, copy) NSString *relationship;

/**
 *  发帖的日期
 */
@property (nonatomic, copy) NSString *postDate;

/**
 *  帖子文字
 */
@property (nonatomic, copy) NSString *postWord;

/**
 * 图片地址
 */
@property (nonatomic, copy) NSString *postImgPath;

/**
 *  视频路径
 */
@property (nonatomic, copy) NSString *videoPath;

/**
 *  音频路径
 */
@property (nonatomic, copy) NSString *audioPath;

/**
 *  帖子类型
 */
@property (nonatomic, assign) NSInteger postType;

@property (nonatomic, strong) ClubPost *post;

/**
 *  更新用户信息
 */
- (void)upLoadData;

@end
