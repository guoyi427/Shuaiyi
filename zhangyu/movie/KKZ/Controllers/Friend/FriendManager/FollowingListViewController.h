//
//  我的关注列表
//
//  Created by alfaromeo on 12-3-30.
//  Copyright (c) 2012年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"
#import "FollowCell.h"

@class EGORefreshTableHeaderView;
@class ShowMoreIndicator;
@class AlertViewY;
@class NoDataViewY;

@protocol FollowingListViewControllerDelegate <NSObject>

- (void)backHostAchievementViewController:(BOOL)isFriend;

@end

@interface FollowingListViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {

    UITableView *fansTable;
    ShowMoreIndicator *showMoreFooterView;
    NSInteger currentPage;

    BOOL tableLocked;
    UILabel *noFansAlertLabel;

    NSMutableArray *searchFans, *dataSource;

    NoDataViewY *nodataView;
}

@property (nonatomic, weak) id<FollowingListViewControllerDelegate> delegate;

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;

@property (nonatomic, strong) NSString *appKey;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, assign) BOOL isMyList; //是自己家，还是别人家
@property (nonatomic, assign) BOOL isFriend; //是好友，还是关注的
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) BOOL isFromFriend; //是好友，还是关注的

@property (nonatomic, assign) BOOL refreshHeaderF;

/**
 *  是否显示顶部导航栏
 */
@property (nonatomic, assign) BOOL isShowTopBar;

/**
 *  是否显示顶部视图
 *
 *  @return
 */
- (id)initWithShowTopBar:(BOOL)isShow;

- (void)refreshFriendList;

@end
