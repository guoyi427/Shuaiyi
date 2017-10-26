//
//  MyReplyPostTypeTwoCell.h
//  KoMovie
//
//  Created by KKZ on 16/2/18.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyReplyView;
@class MyReplyTypeTwoPostThumbnailContentView;

@interface MyReplyPostTypeTwoCell : UITableViewCell {
    //我的回复
    MyReplyView *myReplyView;
    //缩略帖子内容
    MyReplyTypeTwoPostThumbnailContentView *thumbnailContentView;
    //下划线
    UIView *bottomLine;
}

/**
 *  我回复的帖子信息
 */
@property (nonatomic, copy) NSString *myReplyWords;

/**
 *  用户名
 */
@property (nonatomic, copy) NSString *userName;

/**
 *  用户类别
 */
@property (nonatomic, copy) NSString *userCategory;

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
@property (nonatomic, strong) NSString *postDate;

/**
 * 图片地址
 */
@property (nonatomic, strong) NSArray *postImgPaths;

/**
 *  帖子文字
 */
@property (nonatomic, copy) NSString *postWord;

/**
 *  帖子
 */
@property (nonatomic, strong) ClubPost *post;
;

/**
 *  更新用户信息
 */
- (void)upLoadData;
@end
