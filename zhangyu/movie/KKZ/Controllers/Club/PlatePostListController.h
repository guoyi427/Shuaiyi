//
//  PlatePostListController.h
//  KoMovie
//
//  Created by KKZ on 16/3/3.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CommonViewController.h"

@class NoDataViewY;
@interface PlatePostListController : CommonViewController<UITableViewDataSource, UITableViewDelegate> {
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

@property(nonatomic,assign)BOOL hasMore;

@property(nonatomic,copy)NSString *ctrTitle;

/**
 *  版块ID
 */
@property (nonatomic, assign) NSInteger plateId;

@end
