//
//  好友的个人页面
//
//  Created by zhang da on 12-8-15.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "AlertViewY.h"
#import "AudioPlayer.h"
#import "AudioPlayerManager.h"
#import "ClubPost.h"
#import "ClubPostPictureViewController.h"
#import "ClubTask.h"
#import "ClubTask.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "FansListViewController.h"
#import "FollowingListViewController.h"
#import "FriendHomeListCell.h"
#import "FriendHomeViewController.h"
#import "KKZUser.h"
#import "KKZUserTask.h"
#import "KotaHomePageMessCell.h"
#import "KotaTicketMessage.h"
#import "MJRefresh.h"
#import "ShowMoreIndicator.h"
#import "SubscriberHomeTypeOneCell.h"
#import "SubscriberHomeTypeTowCell.h"
#import "TaskQueue.h"
#import "UIAlertView+Blocks.h"
#import "WebViewController.h"
#import "NoDataViewY.h"
#import "NoDataViewY.h"
#import "UserRequest.h"

#define kHeadHeight 150

@implementation FriendHomeViewController {
    MyFavHeaderView *favHeaderView;
    NSMutableArray *userMessageArray;
    ShowMoreIndicator *showMoreFooterView;
    BOOL afterFirstRefresh;
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"fromComment" object:nil];
    if (matchListTable)
        [matchListTable removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"headImg" object:nil];
}

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    self.navBarView.backgroundColor = [UIColor clearColor];

    userMessageArray = [[NSMutableArray alloc] init];

    KKZUser *user = [KKZUser getUserWithId:self.userId];
    self.user = user;

    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 60, 38);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 11, 5, 21)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:backBtn];

    if (self.userNickname.length) {
        self.kkzTitleLabel.text = self.userNickname;
    } else
        self.kkzTitleLabel.text = user.nicknameFinal;

    homeBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 214)];
    homeBackgroundView.backgroundColor = [UIColor whiteColor];
    homeBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
    homeBackgroundView.clipsToBounds = YES;
    homeBackgroundView.image = [UIImage imageNamed:@"user_bg_header_default.jpg"];

    coverV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 287)];
    coverV.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.4];
    [homeBackgroundView addSubview:coverV];

    [self.view addSubview:homeBackgroundView];

    matchListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 44 + self.contentPositionY, screentWith, screentContentHeight - 44)
                                                  style:UITableViewStylePlain];
    matchListTable.delegate = self;
    matchListTable.dataSource = self;
    matchListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [matchListTable setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:matchListTable];
    showMoreFooterView = [[ShowMoreIndicator alloc] initWithFrame:CGRectMake(0, 0, screentWith, 40)];
    matchListTable.tableFooterView = showMoreFooterView;
    favHeaderView = [[MyFavHeaderView alloc] initWithFrame:CGRectMake(0, 0, screentWith, kHeadHeight)];

    if (self.userNickname.length) {
        favHeaderView.userNickname = self.userNickname;
    } else
        favHeaderView.userNickname = user.nicknameFinal;

    favHeaderView.delegate = self;
    favHeaderView.userId = self.userId;
    matchListTable.tableHeaderView = favHeaderView;

    tableLocked = NO;
    flipIndex = -1;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadHeadImg:) name:@"headImg" object:nil];

    [self refreshAll];

    noAlertView = [[AlertViewY alloc] initWithFrame:CGRectMake(0, 287 + 40, screentWith, 120)];
    noAlertView.alertLabelText = @"亲，正在查询请稍候~";

    nodataView = [[NoDataViewY alloc] initWithFrame:CGRectMake(0, 287 + 40, screentWith, 120)];
    nodataView.alertLabelText = @"亲，这家伙很懒什么都没有留下~";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFromComment) name:@"fromComment" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    if (self.fromComment) {
        [self refreshMessageList];
    }
    self.fromComment = NO;
}

- (void)changeFromComment {
    self.fromComment = YES;
}

- (void)loadHeadImg:(NSString *)img {
    self.headImg = img;
}

- (void)refreshAll {

    //    [self performSelector:@selector(refreshUserDetails) withObject:nil afterDelay:0.1];
    //    [self performSelector:@selector(refreshSubsribePublishedPostList) withObject:nil afterDelay:0.1];
    //    [self performSelector:@selector(getFriendLastMovie) withObject:nil afterDelay:0.2];
    [self performSelector:@selector(refreshUserDetails) withObject:nil afterDelay:0.1];
    [self performSelector:@selector(refreshMessageList) withObject:nil afterDelay:0.1];
    [self performSelector:@selector(getFriendLastMovie) withObject:nil afterDelay:0.2];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[AudioPlayerManager sharedAudioPlayerManager] stopAll];
    [_songAudioPlayer stop];
}

#pragma mark utilities
- (void)refreshUserDetails {
    [favHeaderView refreshUserDetails];
}

- (void)refreshUserInfoComplete:(KKZUser *)user {

    self.kkzTitleLabel.text = user.nicknameFinal;
}
- (void)refreshMessageList {

    if (self.userId == [DataEngine sharedDataEngine].userId.intValue) {

        if (userMessageArray.count == 0) {
            [matchListTable addSubview:noAlertView];
            [nodataView removeFromSuperview];
            [noAlertView startAnimation];
        }

        currentPage = 1;

        KKZUserTask *task = [[KKZUserTask alloc] initMyHomeListFor:[DataEngine sharedDataEngine].userId.intValue
                                                              page:1
                                                          finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                              [self messageListFinished:userInfo status:succeeded];

                                                          }];

        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        }

        DLog(@"self.userId ======  %d", self.userId);

    } else {

        currentPage = 1;

        if (userMessageArray.count == 0) {
            [matchListTable addSubview:noAlertView];
            [nodataView removeFromSuperview];
            [noAlertView startAnimation];
        }

        KKZUserTask *task = [[KKZUserTask alloc] initFriendHomeListFor:self.userId
                                                                  page:1
                                                              finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                  [self messageListFinished:userInfo status:succeeded];
                                                              }];

        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        }
    }
}

- (void)showMoreMessage {

    currentPage++;

    if (self.userId == [DataEngine sharedDataEngine].userId.intValue) {

        KKZUserTask *task = [[KKZUserTask alloc] initMyHomeListFor:[DataEngine sharedDataEngine].userId.intValue
                                                              page:currentPage
                                                          finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                              [self messageListFinished:userInfo status:succeeded];

                                                          }];

        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        }

        DLog(@"self.userId ======  %d", self.userId);

    } else {

        KKZUserTask *task = [[KKZUserTask alloc] initFriendHomeListFor:self.userId
                                                                  page:currentPage
                                                              finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                  [self messageListFinished:userInfo status:succeeded];
                                                              }];

        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        }
    }
}

#pragma mark handle notifications
- (void)messageListFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    DLog(@"match list finished");
    [appDelegate hideIndicator];
    [self resetRefreshHeader];

    if (currentPage == 1) {
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [matchListTable headerEndRefreshing];
    } else {
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [matchListTable footerEndRefreshing];
    }

    afterFirstRefresh = YES;
    tableLocked = NO;
    showMoreFooterView.isLoading = NO;

    [noAlertView removeFromSuperview];

    NSArray *res = userInfo[@"results"];

    if (currentPage == 1 && !res.count) {

        [matchListTable addSubview:nodataView];

        showMoreFooterView.hidden = YES;
    } else {

        [nodataView removeFromSuperview];
    }

    if (succeeded) {

        BOOL hasMore = [[userInfo objectForKey:@"hasMore"] boolValue];

        if (hasMore) {
            showMoreFooterView.hasNoMore = NO;
            matchListTable.footerHidden = NO;
        } else {
            showMoreFooterView.hasNoMore = YES;
            matchListTable.footerHidden = YES;
        }

        if (currentPage <= 1) {
            userMessageArray = [[NSMutableArray alloc] initWithArray:res];

            [matchListTable reloadData];

        } else {

            [userMessageArray addObjectsFromArray:res];

            [matchListTable reloadData];
        }

    } else {

        [appDelegate showAlertViewForTaskInfo:userInfo];

        currentPage--;
    }
}

#pragma mark message cell delegate
- (void)handleTouchOnAvatarOnCell:(unsigned int)uid {
    if (uid == self.userId) {

    } else {
        if (uid == [[DataEngine sharedDataEngine].userId intValue]) {
            [self popToViewControllerAnimated:NO];

        } else {
            FriendHomeViewController *ctr = [[FriendHomeViewController alloc] init];
            ctr.userId = uid;
            [self pushViewController:ctr animation:CommonSwitchAnimationBounce];
        }
    }
}

#pragma mark MyFavHeaderView delegate

- (void)handleTouchOnAvatar {
    DLog(@"handleTouchOnAvatar");
}

#pragma mark UIScrollViewDelegate
- (void)resetRefreshHeader {
    [UIView animateWithDuration:0.3f
            delay:0.0f
            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
            animations:^{

                matchListTable.contentInset = UIEdgeInsetsZero;

            }
            completion:^(BOOL finished) {
                //                            [refreshHeaderView setState:EGOOPullRefreshNormal];

                if (matchListTable.contentOffset.y <= 0) {

                    [matchListTable setContentOffset:CGPointZero animated:YES];
                }

            }];
}

- (void)checkUserIsFriendComplete {

    [matchListTable reloadData];
}

- (void)addFriendComplete {
    //    [self refreshSubsribePublishedPostList];
    [self refreshMessageList];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y <= -65.0f) {

        if (currentPage == 1) {
            [self refreshAll];
        }
    }

    //下拉刷新
    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45) {
        if (!showMoreFooterView.hasNoMore) {
            //            [self moreSubsribePublishedPostList];
            [self showMoreMessage];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

#pragma mark - Table View Data Source
- (void)configureTicketCell:(FriendHomeListCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    FriendHomeMessage *kota = userMessageArray[indexPath.row];
    @try {

        cell.currentUid = self.userId;

        if (self.userId == [DataEngine sharedDataEngine].userId.intValue) {
            cell.isInFriendHome = NO;

        } else {

            cell.isInFriendHome = YES;
        }
        cell.friendMessage = kota;
        cell.currentUid = self.userId;
        [cell updateLayout];
    }
    @catch (NSException *exception) {
        LERR(exception);
    }
    @finally {
    }
}

#pragma mark - Table View Data Source
- (void)configureMovieCell:(KotaHomePageMessCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    FriendHomeMessage *kota = userMessageArray[indexPath.row];
    @try {

        cell.userIdNow = self.userId;

        if (self.userId == [DataEngine sharedDataEngine].userId.intValue) {
            cell.isInFriendHome = NO;

        } else {

            cell.isInFriendHome = YES;
        }
        cell.friendMessage = kota;
        [cell updateLayout];
    }
    @catch (NSException *exception) {
        LERR(exception);
    }
    @finally {
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    FriendHomeMessage *kota = userMessageArray[indexPath.row];

    if (kota.status == 17 || kota.status == 13 || kota.status == 16) {

        static NSString *TicketIdentifier = @"KotaMessageCellIdentifier";

        FriendHomeListCell *cell = (FriendHomeListCell *) [tableView dequeueReusableCellWithIdentifier:TicketIdentifier];
        if (cell == nil) {
            cell = [[FriendHomeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TicketIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

        [self configureTicketCell:cell atIndexPath:indexPath];

        return cell;

    } else {

        static NSString *TicketIdentifier = @"KotaMessageCell";

        KotaHomePageMessCell *cell = (KotaHomePageMessCell *) [tableView dequeueReusableCellWithIdentifier:TicketIdentifier];

        if (cell == nil) {
            cell = [[KotaHomePageMessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TicketIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [self configureMovieCell:cell atIndexPath:indexPath];

        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return userMessageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendHomeMessage *kota = userMessageArray[indexPath.row];

    if (kota.status == 0 || kota.status == 7) {

        self.kotacomnt = [kotaComment getKotaCommentMessageWithId:kota.kotaCommentId];

        CGFloat height = 0;

        if (self.kotacomnt.commentType == 1) {

            CGSize s = [self.kotacomnt.content sizeWithFont:[UIFont systemFontOfSize:14]

                                          constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

            height = s.height;

            return height + 115 + 60 + 20;
        } else if (self.kotacomnt.commentType == 2) {

            height = 40;

            return height + 110 + 50 + 20;
        }

        return 240;
    }

    if (kota.status == 1) {
        if (kota.shareUserId == [DataEngine sharedDataEngine].userId.intValue) {

            self.kotacomnt = [kotaComment getKotaCommentMessageWithId:kota.requestKotaCommentId];

        } else

            self.kotacomnt = [kotaComment getKotaCommentMessageWithId:kota.kotaCommentId];

        CGFloat height = 0;

        if (self.kotacomnt.commentType == 1) {

            CGSize s = [self.kotacomnt.content sizeWithFont:[UIFont systemFontOfSize:14]

                                          constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

            height = s.height;

            return height + 115 + 60 + 20;
        } else if (self.kotacomnt.commentType == 2) {

            height = 40;

            return height + 110 + 50 + 20;
        }

        return 240;
    }

    if (kota.status == 2) {

        KotaTicketMessage *ticketMess = [KotaTicketMessage getKotaTicketMessageWithId:kota.kotaId];
        NSDate *lateDate = [[NSDate date] dateByAddingTimeInterval:60 * 60];
        if (ticketMess.ticketId) {

            if ([[[DateEngine sharedDateEngine] dateFromString:ticketMess.ticketTime] compare:lateDate] < 0) {

                self.kotacomnt.content = @"约电影失败";

                CGSize s = [self.kotacomnt.content sizeWithFont:[UIFont systemFontOfSize:14]

                                              constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

                return 110 + 20 + 50 + s.height + 15;
            } else {

                if (kota.shareUserId == [DataEngine sharedDataEngine].userId.intValue) {

                    self.kotacomnt = [kotaComment getKotaCommentMessageWithId:kota.requestKotaCommentId];

                    CGFloat height = 0;

                    if (self.kotacomnt.commentType == 1) {

                        CGSize s = [self.kotacomnt.content sizeWithFont:[UIFont systemFontOfSize:14]

                                                      constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

                        height = s.height;

                        return height + 115 + 60 + 20;
                    } else if (self.kotacomnt.commentType == 2) {

                        height = 40;

                        return height + 110 + 50 + 20;
                    }
                } else {
                    self.kotacomnt = [kotaComment getKotaCommentMessageWithId:kota.kotaCommentId];

                    self.kotacomnt.commentType = 1;

                    self.kotacomnt.content = @"接受了您的申请";

                    CGSize s = [self.kotacomnt.content sizeWithFont:[UIFont systemFontOfSize:14]

                                                  constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

                    return s.height + 15 + 50 + 110 + 20;
                }
            }

        } else {

            self.kotacomnt = [kotaComment getKotaCommentMessageWithId:kota.kotaCommentId];

            self.kotacomnt.commentType = 1;

            self.kotacomnt.content = @"约电影成功";

            CGSize s = [self.kotacomnt.content sizeWithFont:[UIFont systemFontOfSize:14]

                                          constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

            return s.height + 15 + 50 + 110 + 20;
        }
    }

    if (kota.status == 3) {

        if (kota.shareUserId == [DataEngine sharedDataEngine].userId.intValue) {

            self.kotacomnt = [kotaComment getKotaCommentMessageWithId:kota.requestKotaCommentId];

            CGFloat height = 0;

            if (self.kotacomnt.commentType == 1) {

                CGSize s = [self.kotacomnt.content sizeWithFont:[UIFont systemFontOfSize:14]

                                              constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

                height = s.height;

                return height + 115 + 60 + 20;
            } else if (self.kotacomnt.commentType == 2) {

                height = 40;

                return height + 110 + 50 + 20;
            }

        } else {

            self.kotacomnt = [kotaComment getKotaCommentMessageWithId:kota.kotaCommentId];

            self.kotacomnt.commentType = 1;

            self.kotacomnt.content = @"无情的拒绝了您";

            CGSize s = [self.kotacomnt.content sizeWithFont:[UIFont systemFontOfSize:14]

                                          constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

            return s.height + 115 + 60 + 20;
        }
    }

    if (kota.status == 4) {

        self.kotacomnt = [kotaComment getKotaCommentMessageWithId:kota.kotaCommentId];
        self.kotacomnt.commentType = 1;
        self.kotacomnt.content = @"约电影成功了";

        CGSize s = [self.kotacomnt.content sizeWithFont:[UIFont systemFontOfSize:14]
                                      constrainedToSize:CGSizeMake((screentWith - 320) + 235, MAXFLOAT)];

        return s.height + 15 + 50 + 110 + 20;
    }
    if (kota.status == 13) {
        return 150;
    } else if (kota.status == 16 || kota.status == 17) {
        return 185;
    }

    return 0;
}

// 开始滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGRect frame = homeBackgroundView.frame;
    if (scrollView.contentOffset.y < 0) {

        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 11, 5, 21)];
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        //设置导航栏背景色
        self.navBarView.backgroundColor = [UIColor clearColor];
        self.statusView.backgroundColor = [UIColor clearColor];

        frame.origin.x = scrollView.contentOffset.y / 2.0;
        frame.size.height = 214 - scrollView.contentOffset.y;
        frame.size.width = screentWith - scrollView.contentOffset.y;
    } else if (scrollView.contentOffset.y < 214 - self.contentPositionY - 44) {

        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 11, 5, 21)];
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];

        //设置导航栏背景色
        self.navBarView.backgroundColor = [UIColor clearColor];
        self.statusView.backgroundColor = [UIColor clearColor];
        frame.size.height = 214 - scrollView.contentOffset.y;
    } else {

        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9, 29)];
        [backBtn setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];

        //设置导航栏背景色
//        self.navBarView.backgroundColor = appDelegate.kkzBlue;
//        self.statusView.backgroundColor = appDelegate.kkzBlue;

        frame.size.height = 0;
    }

    homeBackgroundView.frame = frame;

    CGRect frame1 = coverV.frame;
    frame1.size.width = frame.size.width;
    frame1.size.height = frame.size.height;
    coverV.frame = frame1;
}

- (void)getFriendLastMovie {
    
    UserRequest *request = [[UserRequest alloc] init];
    [request requestUserHomePageBg:[NSNumber numberWithInteger:self.userId] success:^(NSString * _Nullable url) {
        
        favHeaderView.avatarPath = url;
        
        if (url.length > 0) {
            
            [homeBackgroundView loadImageWithURL:url andSize:ImageSizeMiddle imgNameDefault:@"user_bg_header_default.jpg"];
        }
        
    } failure:^(NSError * _Nullable err) {
        
    }];
}



#pragma mark override from CommonViewController

- (void)cancelViewController {
    [self popViewControllerAnimated:YES];
}

- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return NO;
}

- (BOOL)showTitleBar {
    return TRUE;
}

- (BOOL)isNavMainColor {
    return NO;
}

@end
