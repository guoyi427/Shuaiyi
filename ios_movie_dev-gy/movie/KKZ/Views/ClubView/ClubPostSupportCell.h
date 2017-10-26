//
//  ClubPostSupportCell.h
//  KoMovie
//
//  Created by KKZ on 16/2/26.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ClubPost.h"
@class ClubSupportView;

@interface ClubPostSupportCell : UITableViewCell {
    //点赞区域
    ClubSupportView *supportV;
}

/**
 *  帖子图片数组
 */
@property (nonatomic, strong) NSArray *clubSupportUsers;

@property (nonatomic, strong) ClubPost *postModel;

/**
 *  帖子Id
 */
@property (nonatomic, assign) NSInteger articleId;
/**
 *  加载数据
 */
- (void)reloadData;
@end
