//
//  想看或看过的电影列表页面
//
//  Created by zhang da on 12-8-15.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "CollectedMovieCell.h"
#import "CommonViewController.h"

@class EGORefreshTableHeaderView;
@class ShowMoreIndicator;
@class AlertViewY;

@protocol MyFavViewControllerDelegate <NSObject>

- (void)backHostAchievementView:(BOOL)isCollect;

@end

@interface CollectedMovieViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource, MatchCellDelegate> {

    int currentPage;
    BOOL tableLocked;

    UITableView *matchListTable;

    ShowMoreIndicator *showMoreFooterView;
    EGORefreshTableHeaderView *refreshHeaderView;

    UIView *maskView;

    UILabel *accountTitleLabel;

    NSInteger flipIndex;
    BOOL userRefresh;

    UIImageView *headview;

    UILabel *nodataLabel;

    AlertViewY *noAlertView;
}

@property (nonatomic, weak) id<MyFavViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) BOOL isCollect; //是否看过（收藏），还是想看
@property (nonatomic, assign) BOOL refreshHeader;

- (id)initWithUser:(NSString *)userId;

@end
