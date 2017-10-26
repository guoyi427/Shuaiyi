//
//  我的社区 - 我发表的帖子页面
//
//  Created by KKZ on 16/2/17.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "ClubPostPictureViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "MyPublishedPostsViewController.h"
#import "ShowMoreIndicator.h"
#import "SubscriberHomeTypeOneCell.h"
#import "SubscriberHomeTypeTowCell.h"
#import "UITableViewRowAction+JZExtension.h"

#import "ClubPost.h"

#import "ClubTask.h"
#import "KKZUser.h"
#import "TaskQueue.h"

#import "ClubRequest.h"
#import "NoDataViewY.h"
#import "RIButtonItem.h"
#import "ShareView.h"
#import "UIAlertView+Blocks.h"
#import "WebViewController.h"

#define navBackgroundColor appDelegate.kkzBlue

#define marginX 15

#define wordHeight1 46
#define wordHeight2 21
#define wordH 30

#define cellHeight1 206
#define cellHeight2 181

#define cellOnlyWordHeight1 106
#define cellOnlyWordHeight2 81

#define wordFont 17

@interface MyPublishedPostsViewController () {

    ShowMoreIndicator *showMoreFooterView;

    EGORefreshTableHeaderView *refreshHeaderView;
}

@end

@implementation MyPublishedPostsViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"isPostDeleteComplete" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加导航栏
    [self addNavView];
    //添加订阅号帖子列表
    [self addClubTableView];
    //请求帖子列表数据
    self.clubPosts = [[NSMutableArray alloc] initWithCapacity:0];

    [self addTableNotice];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deletePostComplete:)
                                                 name:@"isPostDeleteComplete"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setStatusBarLightStyle];

    if (self.firstAppear) {
        [self refreshMinePublishedPostList];
        self.firstAppear = NO;
    }
}

/**
 *  添加列表数据提示信息
 */
- (void)addTableNotice {
    nodataView = [[NoDataViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 100, screentWith, 120)];
    nodataView.alertLabelText = @"未获取到相关帖子";
}

//添加导航栏
- (void)addNavView {
    [self.view setBackgroundColor:navBackgroundColor];
    [self.navBarView setBackgroundColor:navBackgroundColor];
    [self.kkzBackBtn setImage:[UIImage imageNamed:@"backButtonImg"] forState:UIControlStateNormal];
    self.kkzTitleLabel.text = @"我发表的帖子";
    self.kkzTitleLabel.textColor = [UIColor whiteColor];
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

    refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - clubTableView.bounds.size.height, screentWith, clubTableView.bounds.size.height)];
    [refreshHeaderView setBackgroundColor:[UIColor clearColor] titleColor:[UIColor grayColor]];
    [refreshHeaderView setActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [clubTableView addSubview:refreshHeaderView];

    showMoreFooterView = [[ShowMoreIndicator alloc] initWithFrame:CGRectMake(0, 0, screentWith, 30)];
    clubTableView.tableFooterView = showMoreFooterView;
    showMoreFooterView.hidden = YES; //永远隐藏
}

#pragma mark - UITableView date source delegate
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

        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
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
        //        postDetail.postType = clubPost.type;
        //        postDetail.clubPost = clubPost;
        [self pushViewController:postDetail
                         animation:CommonSwitchAnimationSwipeR2L];
    }
}

//侧滑删除、分享
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DLog(@"删除按钮被点击");
    }

    [tableView setEditing:YES animated:true];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {

    ClubPost *clubPost = [self.clubPosts objectAtIndex:indexPath.row];

    __weak typeof(self) weakSelf = self;
    void (^rowActionHandler1)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction *_Nonnull action, NSIndexPath *_Nonnull indexPath) {

        DLog(@"按钮被点击啦啦啦啦啦啦 删除");
        //        [tableView setEditing:false animated:true];

        [weakSelf deletePostWithArticleId:clubPost.articleId.integerValue andIndexPath:indexPath andClubPost:clubPost];
    };

    void (^rowActionHandler2)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction *_Nonnull action, NSIndexPath *_Nonnull indexPath) {

        DLog(@"按钮被点击啦啦啦啦啦啦 分享");
        [weakSelf shareMassage:clubPost];

    };

    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:rowActionHandler1];
    action1.backgroundColor = [UIColor redColor];

    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"分享" handler:rowActionHandler2];
    action2.backgroundColor = [UIColor r:251 g:103 b:25];

    return @[ action1, action2 ];
}

/**
 *  刷新列表数据
 */
- (void)refreshMinePublishedPostList {
    [nodataView removeFromSuperview];
    currentPage = 1;

    [self requestPostList:currentPage];
}

- (void)requestPostList:(NSInteger)page {

    showMoreFooterView.isLoading = YES;

    [appDelegate showIndicatorWithTitle:@"加载中"
                               animated:YES
                             fullScreen:NO
                           overKeyboard:NO
                            andAutoHide:NO];

    ClubRequest *request = [ClubRequest new];
    [request requestMyPost:currentPage
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

- (void)moreMinePublishedPostList {
    [nodataView removeFromSuperview];
    currentPage += 1;

    [self requestPostList:currentPage];
}

/**
 *  删除帖子
 */
- (void)deletePostWithArticleId:(NSInteger)articleId andIndexPath:(NSIndexPath *)indexPath andClubPost:(ClubPost *)clubPost {

    RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
    cancel.action = ^{
        [clubTableView reloadData];
    };

    RIButtonItem *ok = [RIButtonItem
            itemWithLabel:@"删除"
                   action:^{

                       [self.clubPosts removeObject:clubPost];
                       [clubTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];

                       ClubTask *task = [[ClubTask alloc] initDeletePostWithArticleId:articleId
                                                                             Finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                                 [self deletePostFinish:userInfo andSucced:succeeded andIndexPath:indexPath andClubPost:clubPost];
                                                                             }];

                       if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
                       }
                   }];

    UIAlertView *alertAt = [[UIAlertView alloc] initWithTitle:@""
                                                      message:@"是否删除该帖子"
                                             cancelButtonItem:cancel
                                             otherButtonItems:ok, nil];
    [alertAt show];
}

- (void)deletePostFinish:(NSDictionary *)userInfo andSucced:(BOOL)succeed andIndexPath:(NSIndexPath *)indexPath andClubPost:(ClubPost *)clubPost {
    if (succeed) {
        [appDelegate showAlertViewForTitle:@"" message:@"已删除该贴" cancelButton:@"OK"];
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

#pragma mark - UIScrollView delegate
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
        [self performSelector:@selector(refreshMinePublishedPostList) withObject:nil afterDelay:0.2];
        //        }
    }

    //下拉刷新
    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45 && self.hasMore) {
        if (!showMoreFooterView.isLoading && refreshHeaderView.state != EGOOPullRefreshLoading) {
            [self moreMinePublishedPostList];
        }
    }
}

/**
 *  分享影片信息
 */
- (void)shareMassage:(ClubPost *)clubPost {
    if (clubPost.tip && clubPost.tip.length) {
        [appDelegate showAlertViewForTitle:@"" message:clubPost.tip cancelButton:@"OK"];
        return;
    }

    ShareView *poplistview = [[ShareView alloc] initWithFrame:CGRectMake(0, screentHeight - 200, screentWith, 200)];
    poplistview.delegateY = self;
    poplistview.userShareInfo = @"posterDetail";

    if (clubPost.share.image && clubPost.share.image.length) {
        [poplistview updateWithcontent:[NSString stringWithFormat:@"%@%@", clubPost.share.title, clubPost.share.url]
                         contentWeChat:clubPost.share.title
                        contentQQSpace:clubPost.share.title
                                 title:clubPost.share.title
                             imagePath:nil
                              imageURL:clubPost.share.image
                                   url:clubPost.share.url
                              soundUrl:nil
                              delegate:self
                             mediaType:SSPublishContentMediaTypeNews
                        statisticsType:StatisticsTypeSnsPoster
                             shareInfo:nil
                             sharedUid:nil];
    } else {
        [poplistview updateWithcontent:[NSString stringWithFormat:@"%@%@", clubPost.share.title, clubPost.share.url]
                         contentWeChat:clubPost.share.title
                        contentQQSpace:clubPost.share.title
                                 title:clubPost.share.title
                             imagePath:[UIImage imageNamed:@"ShareIcon"]
                                   url:clubPost.share.url
                              soundUrl:nil
                              delegate:self
                             mediaType:SSPublishContentMediaTypeNews
                        statisticsType:StatisticsTypeSnsPoster];
    }

    [poplistview show];
}

- (void)deletePostComplete:(NSNotification *) not{
    
    ClubPost *post = [ClubPost getClubPostWithArticleId:not.userInfo[@"articleId"] fromArray:self.clubPosts];

    if (post) {
        [self.clubPosts removeObject:post];
    }

    [clubTableView reloadData];
}

@end
