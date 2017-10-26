//
//  ClubTypeTowCell.h
//  KoMovie
//
//  Created by KKZ on 16/2/1.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClubCellBottom;
@class TypeTwoPostThumbnailContentView;
@class KKZAuthor;

@interface ClubTypeTowCell : UITableViewCell {
    //用户信息
    ClubCellBottom *clubCellBottom;
    //cell的分割线
    UIView *bottomLine;
    //加载帖子缩略内容
    TypeTwoPostThumbnailContentView *thumbnailContentView;
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
 *  发帖的日期
 */
@property (nonatomic, copy) NSString *postDate;

/**
 * 图片地址
 */
@property (nonatomic, strong) NSArray *postImgPaths;

/**
 *  帖子文字
 */
@property (nonatomic, copy) NSString *postWord;

@property (nonatomic, strong) ClubPost *post;

/**
 *  更新用户信息
 */
- (void)upLoadData;

@end
