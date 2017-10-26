//
//  SubscriberHomeViewController.h
//  KoMovie
//
//  Created by KKZ on 16/2/17.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CommonViewController.h"
#import "ShareView.h"
#import "ProfileViewModel.h"
#import "UserInfo.h"

@class NoDataViewY;
@class SubscriberHomeHeader;

@interface SubscriberHomeViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate, HideCoverViewDelegate> {
    //订阅号帖子列表
    UITableView *clubTableView;

    NSInteger currentPage;

    UIImageView *homeBackgroundView;

    UIView *homeBgCover;

    UIButton *backBtn;
    UIButton *rightBtn;
    //列表的提示信息
    NoDataViewY *nodataView;

    SubscriberHomeHeader *subscriberHomeHeader;
}

/**
 *  帖子列表数据源
 */
@property (nonatomic, strong) NSMutableArray *clubPosts;
/**
 *  帖子图片列表缩略图
 */
@property (nonatomic, strong) NSMutableArray *clubPhotos;

@property (nonatomic) NSUInteger userId;

@property (nonatomic) BOOL hasMore;


@end
