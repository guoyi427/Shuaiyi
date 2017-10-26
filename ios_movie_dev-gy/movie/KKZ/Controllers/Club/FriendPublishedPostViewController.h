//
//  FriendPublishedPostViewController.h
//  KoMovie
//
//  Created by KKZ on 16/3/4.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CommonViewController.h"

@class NoDataViewY;

@interface FriendPublishedPostViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate> {
    //我发表的帖子列表
    UITableView *clubTableView;
    //当前的页数
    NSInteger currentPage;
    //列表的提示信息
    NoDataViewY *nodataView;
}

/**
 *  帖子列表数据源
 */
@property (nonatomic, strong) NSMutableArray *clubPosts;
/**
 *  帖子图片列表缩略图
 */
@property (nonatomic, strong) NSMutableArray *clubPhotos;

/**
 *  是否含有更多的数据
 */
@property (nonatomic) BOOL hasMore;

/**
 *  用户的Id
 */
@property (nonatomic) NSUInteger userId;

@end
