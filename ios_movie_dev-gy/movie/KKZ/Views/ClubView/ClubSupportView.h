//
//  ClubSupportView.h
//  KoMovie
//
//  Created by KKZ on 16/2/2.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClubPost.h"

@interface ClubSupportView : UIView {
    UILabel *supportLbl;
    UIImageView *supportImgV;
}
/**
 *  帖子ID
 */
@property (nonatomic, assign) NSInteger articleId;

/**
 *  点赞的用户头像
 */
@property (nonatomic, strong) NSMutableArray *supportUsers;

@property (nonatomic, strong) ClubPost *clubPost;

/**
 *  点赞的用户头像数组
 */
@property (nonatomic, strong) NSMutableArray *supportHeaderImgV;

/**
 *  加载数据
 */
- (void)reloadData;
@end
