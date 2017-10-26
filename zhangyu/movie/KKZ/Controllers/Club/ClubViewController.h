//
//  ClubViewController.h
//  KoMovie
//
//  Created by KKZ on 16/1/30.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CommonViewController.h"
#import "PublishPostView.h"
@class ClubNavTab;
@class WaitIndicatorView;

@class NoDataViewY;

@interface ClubViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate> {
    //社区帖子列表
    UITableView *clubTableView;
    //发布帖子按钮
    UIButton *publishPostBtn;
    //列表当前页
    NSInteger currentPage;
    //列表的提示信息ClubNavTab
    NoDataViewY *nodataView;

    WaitIndicatorView *indicatorYn;
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
 *  影片ID
 */
@property (nonatomic, assign) unsigned int movieId;

@property (nonatomic, strong) ClubNavTab *clubTab;

/**
 *  影片ID
 */
@property (nonatomic, assign) BOOL hasMore;

- (void)refreshClubList;

@end
