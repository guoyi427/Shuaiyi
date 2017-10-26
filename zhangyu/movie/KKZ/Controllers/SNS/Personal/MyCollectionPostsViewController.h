//
//  我的社区 - 我收藏的帖子列表页面
//
//  Created by KKZ on 16/2/17.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"
#import "ShareView.h"

@class NoDataViewY;

@interface MyCollectionPostsViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource, HideCoverViewDelegate> {

    //我收藏的帖子列表
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
@property (nonatomic, assign) BOOL hasMore;

@end
