//
//  MovieHotCommentController.h
//  KoMovie
//
//  Created by KKZ on 16/3/1.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CommonViewController.h"
#import "PublishPostView.h"

@class NoDataViewY;

@interface MovieHotCommentController : CommonViewController<UITableViewDataSource, UITableViewDelegate> {
    //社区帖子列表
    UITableView *clubTableView;
    //发布帖子按钮
    UIButton *publishPostBtn;
    //列表当前页
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
 *  影片ID
 */
@property (nonatomic, copy) NSNumber *movieId;

/**
 *  影院Id
 */
@property (nonatomic, copy) NSNumber *cinemaId;

/**
 *  当前的导航Id
 */
@property (nonatomic, assign)NSInteger navId;

@property(nonatomic,assign)BOOL hasMore;


/**
 *   区分是热门吐槽 还是 社区精华  1，2，3是热门吐槽 4，5是社区精华
 */
@property (nonatomic, strong) NSString *userGroup;

@property(nonatomic,copy)NSString *ctrTitle;
@end
