//
//  ClubCellBottom.h
//  KoMovie
//
//  Created by KKZ on 16/1/30.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RoundCornersButton;

#import "KKZAuthor.h"

@interface ClubCellBottom : UIView {
    //用户头像
    UIImageView *headPortraitV;
    //用户名
    UILabel *userNameLbl;
    //用户类别
    RoundCornersButton *userCategoryLbl;
    //支持的人数
    UILabel *supportLbl;
    //支持的Icon
    UIImageView *supportIconV;
    //评论的数目
    UILabel *commentLbl;
    //评论的Icon
    UIImageView *commentIconV;
    //好友关系
    UILabel *relationshipLbl;
    //发帖的日期
    UILabel *postDateLbl;
}

@property (nonatomic, strong) ClubPost *clubPost;

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
 *  是否是影片详情
 */
@property (nonatomic, assign) NSInteger postId;

/**
 *  更新用户信息
 */
- (void)upLoadData;
@end
