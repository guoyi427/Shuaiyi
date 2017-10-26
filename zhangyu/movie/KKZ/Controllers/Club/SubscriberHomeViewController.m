//
//  SubscriberHomeViewController.m
//  KoMovie
//
//  Created by KKZ on 16/2/17.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubPost.h"
#import "ClubPostPictureViewController.h"
#import "ClubTask.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "EGORefreshTableHeaderView.h"
#import "KKZUser.h"
#import "ShareView.h"
#import "ShowMoreIndicator.h"
#import "SubscriberHomeHeader.h"
#import "SubscriberHomeTypeOneCell.h"
#import "SubscriberHomeTypeTowCell.h"
#import "SubscriberHomeViewController.h"
#import "TaskQueue.h"
#import "WebViewController.h"
#import "NoDataViewY.h"
#import "AccountRequest.h"

#define SubscriberHomeHeaderHeight 210
#define homeBgHeight 274

#define marginX 15
#define marginY 15

#define wordHeight1 46
#define wordHeight2 21
#define wordH 30

#define cellHeight1 206
#define cellHeight2 181

#define cellOnlyWordHeight1 106
#define cellOnlyWordHeight2 81

#define wordFont 17

@interface SubscriberHomeViewController () {

    ShowMoreIndicator *showMoreFooterView;

    EGORefreshTableHeaderView *refreshHeaderView;
}
@property (nonatomic, strong) UserInfo *userInfo;
@end

@implementation SubscriberHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewBgColor];
    //加载导航栏
    [self loadNavBar];
    //添加订阅号帖子列表
    [self addClubTableView];

    [self addTableNotice];
    [self requestUserDetailWithUserId:self.userId];
}

/**
 
 *  添加列表数据提示信息
 
 */

- (void)addTableNotice

{

    CGFloat positionYN = (SubscriberHomeHeaderHeight > (self.view.frame.size.height * 0.5 - 100)) ? (SubscriberHomeHeaderHeight + 50) : (self.view.frame.size.height * 0.5 - 50);
    nodataView = [[NoDataViewY alloc] initWithFrame:CGRectMake(0, positionYN, screentWith, 120)];

    nodataView.alertLabelText = @"未获取到相关帖子";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];

    if (self.firstAppear) {
        [self refreshSubsribePublishedPostList];
        self.firstAppear = NO;
    }

    //    [subscriberHomeHeader upLoadData];
}

/**
 *  设置背景色
 */
- (void)setViewBgColor {

    [self.view setBackgroundColor:[UIColor whiteColor]];

    homeBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screentWith, homeBgHeight)];
    homeBackgroundView.backgroundColor = [UIColor clearColor];
    homeBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
    homeBackgroundView.clipsToBounds = YES;
    homeBackgroundView.image = [UIImage imageNamed:@"movie_post_bg"];
    [self.view addSubview:homeBackgroundView];

    homeBgCover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, homeBgHeight)];
    [homeBgCover setBackgroundColor:[UIColor r:0 g:0 b:0 alpha:0.4]];
    [homeBackgroundView addSubview:homeBgCover];
}

/**
 *  订阅号的帖子列表
 */
- (void)addClubTableView {
    //订阅号的帖子列表
    clubTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentHeight - (self.contentPositionY + 44))];
    [clubTableView setBackgroundColor:[UIColor clearColor]];
    clubTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:clubTableView];

    clubTableView.delegate = self;
    clubTableView.dataSource = self;

    //tableHeader
    subscriberHomeHeader = [[SubscriberHomeHeader alloc] initWithFrame:CGRectMake(0, 0, screentWith, SubscriberHomeHeaderHeight)];
    subscriberHomeHeader.userId = self.userId;
    [subscriberHomeHeader setBackgroundColor:[UIColor clearColor]];
    clubTableView.tableHeaderView = subscriberHomeHeader;

    refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,

                                                                                    0.0f - clubTableView.bounds.size.height,

                                                                                    screentWith,

                                                                                    clubTableView.bounds.size.height)];

    [refreshHeaderView setBackgroundColor:[UIColor clearColor] titleColor:[UIColor grayColor]];

    [refreshHeaderView setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

    [clubTableView addSubview:refreshHeaderView];

    showMoreFooterView = [[ShowMoreIndicator alloc] initWithFrame:CGRectMake(0, 0, screentWith, 30)];

    clubTableView.tableFooterView = showMoreFooterView;

    showMoreFooterView.hidden = YES; //永远隐藏
}

/**
 *  加载导航栏
 */
- (void)loadNavBar {
    [self.navBarView setBackgroundColor:[UIColor clearColor]];

    self.kkzTitleLabel.text = @"订阅号";
    self.kkzTitleLabel.hidden = YES;

    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    backBtn.frame = CGRectMake(0, 3, 60, 38);
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9, 29)]; //11 * 20
    [backBtn setImage:[UIImage imageNamed:@"movieComment_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:backBtn];

    //右边分享按钮
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(screentWith - 60, 0, 60, 40);
    [rightBtn setImage:[UIImage imageNamed:@"cinema_Ticket_share"] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 25, 10, 15)];
    [rightBtn addTarget:self action:@selector(shareMovieMassage) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:rightBtn];
}

#pragma mark table view date source delegate

- (void)configureStyleOneCell:(SubscriberHomeTypeOneCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    ClubPost *clubPost = [self.clubPosts objectAtIndex:indexPath.row];

    cell.userName = clubPost.author.userName;
    cell.userCategory = clubPost.author.userGroup;
    cell.supportNum = clubPost.upNum;
    cell.commentNum = clubPost.replyNum;
    cell.relationship = clubPost.author.rel;
    cell.postDate = clubPost.publishTime;
    cell.postWord = clubPost.title;
    cell.post = clubPost;
    if (clubPost.type.integerValue == 2) {
        cell.postImgPath = clubPost.author.head;
    } else
        cell.postImgPath = clubPost.filesImage[0];
    //    }
    //    1图文 2 语音 3 视频 4.订阅号内容  图文是第二种cell

    if (clubPost.type.integerValue == 2) {
        cell.postType = 2; //音频
    } else if (clubPost.type.integerValue == 3) {
        cell.postType = 1; //视频
    } else if (clubPost.type.integerValue == 1 || clubPost.type.integerValue == 4) {
        cell.postType = 3; //图文
    }

    [cell upLoadData];
}

- (void)configureStyleTwoCell:(SubscriberHomeTypeTowCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ClubPost *clubPost = [self.clubPosts objectAtIndex:indexPath.row];

    cell.userName = clubPost.author.userName;
    cell.userCategory = clubPost.author.userGroup;
    cell.supportNum = clubPost.upNum;
    cell.commentNum = clubPost.replyNum;
    cell.relationship = clubPost.author.rel;
    cell.postDate = clubPost.publishTime;
    cell.postWord = clubPost.title;
    cell.postImgPaths = clubPost.filesImage;
    cell.post = clubPost;
    [cell upLoadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.clubPosts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClubPost *clubPost = [self.clubPosts objectAtIndex:indexPath.row];
    if (clubPost.type.integerValue == 2 || clubPost.type.integerValue == 3 || (clubPost.type.integerValue == 4 && clubPost.filesImage.count == 1) || (clubPost.type.integerValue == 1 && clubPost.filesImage.count == 1)) {
        static NSString *cellStyleOneSubscriberID = @"clubstyleonesubscribercell";
        SubscriberHomeTypeOneCell *cell = [clubTableView dequeueReusableCellWithIdentifier:cellStyleOneSubscriberID];
        if (cell == nil) {
            cell = [[SubscriberHomeTypeOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStyleOneSubscriberID];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }

        [self configureStyleOneCell:cell atIndexPath:indexPath];
        return cell;
    } else if ((clubPost.type.integerValue == 1 && (clubPost.filesImage.count == 0 || clubPost.filesImage.count > 1)) || clubPost.type.integerValue == 4) {
        static NSString *cellStyleTwoSubscriberID = @"clubstyletowsubscribercell";
        SubscriberHomeTypeTowCell *cell = [clubTableView dequeueReusableCellWithIdentifier:cellStyleTwoSubscriberID];
        if (cell == nil) {
            cell = [[SubscriberHomeTypeTowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStyleTwoSubscriberID];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        [self configureStyleTwoCell:cell atIndexPath:indexPath];
        return cell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClubPost *clubPost = [self.clubPosts objectAtIndex:indexPath.row];

    if (clubPost.type.integerValue == 2 || clubPost.type.integerValue == 3 || (clubPost.type.integerValue == 4 && clubPost.filesImage.count == 1) || (clubPost.type.integerValue == 1 && clubPost.filesImage.count == 1)) {
        return 147;
    } else if ((clubPost.type.integerValue == 1 && (clubPost.filesImage.count == 0 || clubPost.filesImage.count > 1)) || clubPost.type.integerValue == 4) {
        //        CGSize s = [clubPost.title sizeWithFont:[UIFont systemFontOfSize:wordFont] constrainedToSize:CGSizeMake(screentWith - marginX * 2, CGFLOAT_MAX)];

        //设置行间距
        NSMutableParagraphStyle *paragraphStyle =
                [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;

        NSDictionary *attributes = @{
            NSFontAttributeName : [UIFont systemFontOfSize:wordFont],
            NSParagraphStyleAttributeName : paragraphStyle
        };

        CGFloat contentW = screentWith - marginX * 2;

        CGRect tmpRect = [clubPost.title boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:attributes
                                                      context:nil];

        CGSize s = tmpRect.size;

        if (clubPost.filesImage.count) { //上下结构 只有文字的情况
            if (s.height >= wordH) {
                return cellHeight1;
            } else {
                return cellHeight2;
            }

        } else {
            if (s.height >= wordH) {
                return cellOnlyWordHeight1;
            } else {
                return cellOnlyWordHeight2;
            }
        }
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClubPost *clubPost = [self.clubPosts objectAtIndex:indexPath.row];
    if (clubPost.url && clubPost.url.length) {

        WebViewController *ctr = [[WebViewController alloc] initWithTitle:@""];

        [ctr loadURL:clubPost.url];

        [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];

    } else {
        ClubPostPictureViewController *postDetail = [[ClubPostPictureViewController alloc] init];
        postDetail.articleId = clubPost.articleId;

        postDetail.postType = clubPost.type.integerValue;

        [self pushViewController:postDetail animation:CommonSwitchAnimationSwipeR2L];
    }
}

#pragma mark override from CommonViewController

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

/**
 *  刷新列表数据
 */

- (void)refreshSubsribePublishedPostList {
    [nodataView removeFromSuperview];
    currentPage = 1;
    [self requestPostList:[NSNumber numberWithUnsignedInteger:self.userId] page:currentPage];
}

- (void)requestPostList:(NSNumber *)userId page:(NSInteger)page {
    showMoreFooterView.isLoading = YES;

    [appDelegate showIndicatorWithTitle:@"加载中"

                               animated:YES

                             fullScreen:NO

                           overKeyboard:NO

                            andAutoHide:NO];

    ClubRequest *request = [ClubRequest new];
    [request requestSubcribeList:userId
            page:page
            success:^(NSArray *_Nullable posts, BOOL hasMore) {

                [appDelegate hideIndicator];

                showMoreFooterView.isLoading = NO;

                if (hasMore) {

                    self.hasMore = YES;

                    showMoreFooterView.hidden = NO;

                    showMoreFooterView.hasNoMore = NO;

                } else {

                    self.hasMore = NO;

                    showMoreFooterView.hidden = NO;

                    showMoreFooterView.hasNoMore = YES;
                }

                NSMutableArray *res = [[NSMutableArray alloc] initWithArray:posts];

                if (currentPage <= 1) {

                    self.clubPosts = [[NSMutableArray alloc] initWithArray:res];

                } else {

                    if (res.count > 0) {

                        [self.clubPosts addObjectsFromArray:res];
                    }
                }

                if (self.clubPosts.count == 0) {
                    showMoreFooterView.hidden = YES;
                    [clubTableView addSubview:nodataView];
                }
                [clubTableView reloadData];

            }
            failure:^(NSError *_Nullable err) {
                [appDelegate hideIndicator];

                showMoreFooterView.isLoading = NO;

                [appDelegate showAlertViewForTitle:nil message:err.userInfo[KKZRequestErrorMessageKey] cancelButton:@"确定"];

            }];
}

- (void)moreSubsribePublishedPostList {
    [nodataView removeFromSuperview];

    currentPage += 1;
    [self requestPostList:[NSNumber numberWithUnsignedInteger:self.userId] page:currentPage];
}

#pragma scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGRect frame = homeBackgroundView.frame;
    float postBgh = homeBgHeight;

    if (scrollView.contentOffset.y < 0) {
        frame.origin.x = scrollView.contentOffset.y / 2.0;
        frame.origin.y = 0;
        frame.size.height = postBgh - scrollView.contentOffset.y;
        frame.size.width = screentWith - scrollView.contentOffset.y;
    } else {
        frame.origin.x = 0;
        frame.origin.y = 0 - scrollView.contentOffset.y;
        frame.size.width = screentWith;
        frame.size.height = postBgh;
    }

    homeBackgroundView.frame = frame;
    if (scrollView.contentOffset.y >= SubscriberHomeHeaderHeight) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [homeBgCover setBackgroundColor:[UIColor whiteColor]];

        //设置导航栏背景色
        self.navBarView.backgroundColor = appDelegate.kkzBlue;
        self.statusView.backgroundColor = appDelegate.kkzBlue;

        self.kkzTitleLabel.hidden = NO;
    } else {
        [self.view setBackgroundColor:[UIColor clearColor]];

        [homeBgCover setBackgroundColor:[UIColor r:0 g:0 b:0 alpha:0.4]];

        //设置导航栏背景色
        self.navBarView.backgroundColor = [UIColor clearColor];
        self.statusView.backgroundColor = [UIColor clearColor];

        self.kkzTitleLabel.hidden = YES;
    }

    homeBackgroundView.frame = frame;
    frame = homeBgCover.frame;
    frame.size = homeBackgroundView.frame.size;
    homeBgCover.frame = frame;

    //在拖动

    if (scrollView.isDragging) {

        if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f) {

            [refreshHeaderView setState:EGOOPullRefreshNormal];

        } else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f) {

            [refreshHeaderView setState:EGOOPullRefreshPulling];
        }

    } else {
    }

    //进入下方区域+45像素

    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45) {

        if (!showMoreFooterView.isLoading && !showMoreFooterView.hasNoMore && refreshHeaderView.state != EGOOPullRefreshLoading) {
        }
    }
}

//拖动（释放手指）停止的时候执行

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (refreshHeaderView.state == EGOOPullRefreshLoading) {

        return;
    }

    //上拉刷新

    //    if (scrollView.contentOffset.y <= -65.0f && self.hasMore) {

    if (scrollView.contentOffset.y <= -65.0f) {

        //        if (!showMoreFooterView.hasNoMore) {

        [self performSelector:@selector(refreshSubsribePublishedPostList) withObject:nil afterDelay:0.2];
        //        }
    }

    //下拉刷新

    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45 && self.hasMore) {

        if (!showMoreFooterView.isLoading && refreshHeaderView.state != EGOOPullRefreshLoading) {

            [self moreSubsribePublishedPostList];
        }
    }
}

/**
 *  分享影片信息
 */
- (void)shareMovieMassage {

    ShareView *poplistview = [[ShareView alloc] initWithFrame:CGRectMake(0, screentHeight - 200, screentWith, 200)];
    poplistview.delegateY = self;
    poplistview.userShareInfo = @"SubscriberHomeShare";

    [poplistview updateWithcontent:[NSString stringWithFormat:@"%@,%@", self.userInfo.share.title, self.userInfo.share.url]
                     contentWeChat:self.userInfo.share.title
                    contentQQSpace:self.userInfo.share.title
                             title:self.userInfo.share.title
                         imagePath:nil
                          imageURL:self.userInfo.share.image
                               url:self.userInfo.share.url
                          soundUrl:nil
                          delegate:self
                         mediaType:SSPublishContentMediaTypeNews
                    statisticsType:StatisticsTypeSubscriber
                         shareInfo:nil
                         sharedUid:nil];

    [poplistview show];
}

/**
 *  请求用户详情
 */
- (void)requestUserDetailWithUserId:(NSUInteger)userId {

    AccountRequest *request = [[AccountRequest alloc] init];

    [request requestUser:[NSNumber numberWithLong:userId]
            success:^(User *_Nullable user) {
                self.userInfo = user.detail;
                subscriberHomeHeader.subTitle = self.userInfo.signature;
                [subscriberHomeHeader upLoadData:user];
            }
            failure:^(NSError *_Nullable err) {
                DLog(@"err %@", err);
            }];
}
@end
