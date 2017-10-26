//
//  FriendPublishedPostViewController.m
//  KoMovie
//
//  Created by KKZ on 16/3/4.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubPostPictureViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "FriendPublishedPostViewController.h"
#import "MyPublishedPostsViewController.h"
#import "ShowMoreIndicator.h"
#import "SubscriberHomeTypeOneCell.h"
#import "SubscriberHomeTypeTowCell.h"
#import "UITableViewRowAction+JZExtension.h"

#import "ClubPost.h"
#import "ClubTask.h"
#import "KKZUser.h"
#import "TaskQueue.h"
#import "NoDataViewY.h"

#import "WebViewController.h"

#define navBackgroundColor [UIColor r:55 g:197 b:128]

#define marginX 15

#define wordHeight1 46
#define wordHeight2 21
#define wordH 30

#define cellHeight1 206
#define cellHeight2 181

#define cellOnlyWordHeight1 106
#define cellOnlyWordHeight2 81

#define wordFont 17

@interface FriendPublishedPostViewController () {

    ShowMoreIndicator *showMoreFooterView;

    EGORefreshTableHeaderView *refreshHeaderView;
}

@end

@implementation FriendPublishedPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航栏
    [self addNavView];
    //添加订阅号帖子列表
    [self addClubTableView];
    //请求帖子列表数据
    self.clubPosts = [[NSMutableArray alloc] initWithCapacity:0];

    [self addTableNotice];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setStatusBarLightStyle];

    if (self.firstAppear) {
        [self refreshSubsribePublishedPostList];
        self.firstAppear = NO;
    }
}

/**
 
 *  添加列表数据提示信息
 
 */

- (void)addTableNotice

{

    nodataView = [[NoDataViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 100, screentWith, 120)];

    nodataView.alertLabelText = @"未获取到相关帖子";
}

//添加导航栏
- (void)addNavView {
    self.kkzTitleLabel.text = @"TA发表的帖子";
}

/**
 *  我发表的的帖子列表
 */
- (void)addClubTableView {
    //订阅号的帖子列表
    clubTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentHeight - (self.contentPositionY + 44))];
    [clubTableView setBackgroundColor:[UIColor whiteColor]];
    clubTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:clubTableView];

    clubTableView.delegate = self;
    clubTableView.dataSource = self;

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
    //    if (clubPost.filesImage.count) {
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
    ;
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

    // 1图文（一张图片） 2 语音 3 视频 4.订阅号内容
    if (clubPost.type.integerValue == 2 || clubPost.type.integerValue == 3 || (clubPost.type.integerValue == 4 && clubPost.filesImage.count == 1) || (clubPost.type.integerValue == 1 && clubPost.filesImage.count == 1)) {
        static NSString *cellStyleOnePublishID = @"clubstyleonepublishcell";
        SubscriberHomeTypeOneCell *cell = [clubTableView dequeueReusableCellWithIdentifier:cellStyleOnePublishID];
        if (cell == nil) {
            cell = [[SubscriberHomeTypeOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStyleOnePublishID];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }

        [self configureStyleOneCell:cell atIndexPath:indexPath];
        return cell;
    } else if ((clubPost.type.integerValue == 1 && (clubPost.filesImage.count == 0 || clubPost.filesImage.count > 1)) || clubPost.type.integerValue == 4) {
        //图文没有图片或者多张图片
        static NSString *cellStyleTwoPublishID = @"clubstyletowpublishcell";
        SubscriberHomeTypeTowCell *cell = [clubTableView dequeueReusableCellWithIdentifier:cellStyleTwoPublishID];
        if (cell == nil) {
            cell = [[SubscriberHomeTypeTowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStyleTwoPublishID];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        [self configureStyleTwoCell:cell atIndexPath:indexPath];
        return cell;
    } else
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
        postDetail.articleId = clubPost.articleId;
        [self pushViewController:postDetail
                         animation:CommonSwitchAnimationSwipeR2L];
    }
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

#pragma mark override from CommonViewController

- (BOOL)showNavBar {

    return TRUE;
}

- (BOOL)showBackButton {

    return YES;
}

- (BOOL)showTitleBar {

    return TRUE;
}

#pragma scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

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
@end
