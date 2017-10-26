//
//  好友的个人页面
//
//  Created by zhang da on 12-8-15.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "CommonViewController.h"
#import "MyFavHeaderView.h"
#import "kotaComment.h"

@class EGORefreshTableHeaderView;
@class RefreshButton;
@class ShowMoreIndicator;
@class UIImageControl;
@class RefreshButton;
@class AudioPlayer;
@class RoundCornersButton;
@class KKZUser;
@class NoDataViewY;
@class AlertViewY;
@class NoDataViewY;

@interface FriendHomeViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource, MyFavHeaderViewDelegate> {

    UIButton *loginBtn;
    UIButton *backBtn;
    NSInteger currentPage;
    BOOL tableLocked;

    UITableView *matchListTable;

    RefreshButton *refreshBtn;
    RoundCornersButton *rightButton;

    UIView *maskView;

    AudioPlayer *_songAudioPlayer;

    int flipIndex;

    BOOL flipLock;
    BOOL userRefresh;
    BOOL isFriend;

    UIImageView *homeBackgroundView;

    NoDataViewY *nodataView;

    AlertViewY *noAlertView;

    UIView *coverV;
}

@property (nonatomic, assign) unsigned int userId;
@property (nonatomic, strong) KKZUser *user;
@property (nonatomic, strong) NSString *headImg;
@property (nonatomic, strong) NSIndexPath *indexPathChange;
@property (nonatomic, assign) BOOL fromComment;
@property (nonatomic, strong) kotaComment *kotacomnt;
@property (nonatomic, copy) NSString *userNickname;

/**
 *  帖子列表数据源
 */
@property (nonatomic, strong) NSMutableArray *clubPosts;
/**
 *  帖子图片列表缩略图
 */
@property (nonatomic, strong) NSMutableArray *clubPhotos;

@property (nonatomic, assign) BOOL hasMore;

@end
