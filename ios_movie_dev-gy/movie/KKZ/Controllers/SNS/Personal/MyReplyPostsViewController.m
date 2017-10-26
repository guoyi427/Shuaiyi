//
//  我的社区 - 我回复的帖子页面
//
//  Created by KKZ on 16/2/17.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "ClubPost.h"
#import "ClubPostComment.h"
#import "ClubPostPictureViewController.h"
#import "ClubTask.h"
#import "EGORefreshTableHeaderView.h"
#import "KKZUser.h"
#import "MyReplyPostTypeOneCell.h"
#import "MyReplyPostTypeTwoCell.h"
#import "MyReplyPostsViewController.h"
#import "MyReplyView.h"
#import "NoDataViewY.h"
#import "RIButtonItem.h"
#import "ShowMoreIndicator.h"
#import "TaskQueue.h"
#import "UIAlertView+Blocks.h"
#import "UITableViewRowAction+JZExtension.h"
#import "WebViewController.h"

#define navBackgroundColor appDelegate.kkzBlue
#define oneTypeThumbnailContentViewHeight 85

#define photosViewHeight 85

#define wordFont 17

#define wordHeight1 46
#define wordHeight2 21
#define wordH 30

#define twoTypeThumbnailContentViewHeight11 wordHeight1
#define twoTypeThumbnailContentViewHeight21 wordHeight1 + 15 + photosViewHeight

#define twoTypeThumbnailContentViewHeight12 wordHeight2
#define twoTypeThumbnailContentViewHeight22 wordHeight2 + 15 + photosViewHeight

#define cellMarginX 15
#define myReplyWordFont 17
#define marginY 15
#define myReplyWordLblWidth (screentWith - cellMarginX * 2 - 10 * 2)

#define marginTypeCell (marginY * 2 + 10 * 2 + 7 + 12 + 15 + 5)

@interface MyReplyPostsViewController () {

    ShowMoreIndicator *showMoreFooterView;

    EGORefreshTableHeaderView *refreshHeaderView;
}

@end

@implementation MyReplyPostsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self settingNavView];
    [self addClubTableView];
    [self addTableNotice];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setStatusBarLightStyle];

    if (self.firstAppear) {
        [self refreshMineReplyPostList];
        self.firstAppear = NO;
    }
}

// 添加列表数据提示信息
- (void)addTableNotice {
    nodataView = [[NoDataViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 100, screentWith, 120)];
    nodataView.alertLabelText = @"未获取到相关帖子";
}

// 配置导航栏
- (void)settingNavView {
    [self.view setBackgroundColor:navBackgroundColor];
    [self.navBarView setBackgroundColor:navBackgroundColor];
    [self.kkzBackBtn setImage:[UIImage imageNamed:@"backButtonImg"] forState:UIControlStateNormal];
    self.kkzTitleLabel.text = @"我回复的帖子";
    self.kkzTitleLabel.textColor = [UIColor whiteColor];
}

// 我发表的的帖子列表
- (void)addClubTableView {
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
    showMoreFooterView.hidden = YES; //永远隐藏
    clubTableView.tableFooterView = showMoreFooterView;
}

#pragma mark - UITableView date source delegate
- (void)configureStyleOneCell:(MyReplyPostTypeOneCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ClubPostComment *clubPostComment = [self.clubPostComments objectAtIndex:indexPath.row];

    ClubPost *clubPost = clubPostComment.article;
    cell.myReplyWords = clubPostComment.content;
    cell.postDate = clubPostComment.createTime;
    cell.userName = clubPostComment.commentor.userName;
    cell.userCategory = clubPostComment.commentor.userGroup;
    cell.relationship = clubPostComment.commentor.rel;
    cell.supportNum = clubPost.upNum;
    cell.commentNum = clubPost.replyNum;
    cell.postWord = clubPost.title;
    cell.post = clubPost;

    //    if (clubPost.filesImage.count) {
    if (clubPost.type.integerValue == 2) {
        cell.postImgPath = clubPostComment.commentor.head;
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

- (void)configureStyleTwoCell:(MyReplyPostTypeTwoCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ClubPostComment *clubPostComment = [self.clubPostComments objectAtIndex:indexPath.row];

    ClubPost *clubPost = clubPostComment.article;

    cell.myReplyWords = clubPostComment.content;
    cell.postDate = clubPostComment.createTime;
    cell.supportNum = clubPost.upNum;
    cell.commentNum = clubPost.replyNum;
    cell.postWord = clubPost.title;
    cell.postImgPaths = clubPost.filesImage;
    cell.post = clubPost;
    [cell upLoadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.clubPostComments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClubPostComment *clubPostComment = [self.clubPostComments objectAtIndex:indexPath.row];
    ClubPost *clubPost = clubPostComment.article;

    // 1图文（一张图片） 2 语音 3 视频 4.订阅号内容

    if (clubPost.type.integerValue == 2 || clubPost.type.integerValue == 3 || (clubPost.type.integerValue == 4 && clubPost.filesImage.count == 1) || (clubPost.type.integerValue == 1 && clubPost.filesImage.count == 1)) {
        static NSString *cellStyleOneReplyID = @"clubstyleonereplycell";
        MyReplyPostTypeOneCell *cell = [clubTableView dequeueReusableCellWithIdentifier:cellStyleOneReplyID];
        if (cell == nil) {
            cell = [[MyReplyPostTypeOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStyleOneReplyID];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }

        [self configureStyleOneCell:cell atIndexPath:indexPath];
        return cell;
    } else if ((clubPost.type.integerValue == 1 && (clubPost.filesImage.count == 0 || clubPost.filesImage.count > 1)) || clubPost.type.integerValue == 4) {
        //图文没有图片或者多张图片
        static NSString *cellStyleTwoReplyID = @"clubstyletowreplycell";
        MyReplyPostTypeTwoCell *cell = [clubTableView dequeueReusableCellWithIdentifier:cellStyleTwoReplyID];
        if (cell == nil) {
            cell = [[MyReplyPostTypeTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStyleTwoReplyID];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        [self configureStyleTwoCell:cell atIndexPath:indexPath];
        return cell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    ClubPostComment *clubPostComment = [self.clubPostComments objectAtIndex:indexPath.row];
    ClubPost *clubPost = clubPostComment.article;
    NSString *str = [NSString stringWithFormat:@"我的回复：%@", clubPostComment.content];

    //设置行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;

    NSDictionary *attributes = @{
        NSFontAttributeName : [UIFont systemFontOfSize:myReplyWordFont],
        NSParagraphStyleAttributeName : paragraphStyle
    };

    CGFloat contentW = myReplyWordLblWidth;

    CGRect tmpRect = [str boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes
                                       context:nil];

    CGSize s = tmpRect.size;

    // 1图文（一张图片） 2 语音 3 视频 4.订阅号内容

    if (clubPost.type.integerValue == 2 || clubPost.type.integerValue == 3 || (clubPost.type.integerValue == 4 && clubPost.filesImage.count == 1) || (clubPost.type.integerValue == 1 && clubPost.filesImage.count == 1)) {

        return s.height + marginTypeCell + oneTypeThumbnailContentViewHeight;
    } else if ((clubPost.type.integerValue == 1 && (clubPost.filesImage.count == 0 || clubPost.filesImage.count > 1)) || clubPost.type.integerValue == 4) {
        //图文没有图片或者多张图片

        NSString *postWordStr = [NSString stringWithFormat:@"原帖标题：%@", clubPost.title];

        //设置行间距
        NSMutableParagraphStyle *paragraphStyle =
                [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5;

        NSDictionary *attributes = @{
            NSFontAttributeName : [UIFont systemFontOfSize:wordFont],
            NSParagraphStyleAttributeName : paragraphStyle
        };

        CGFloat contentW = screentWith - cellMarginX * 2;

        CGRect tmpRect = [postWordStr boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:attributes
                                                   context:nil];

        CGSize s1 = tmpRect.size;

        if (clubPost.filesImage.count) { //上下结构 只有文字的情况
            if (s1.height >= wordH) {
                return s.height + marginTypeCell + twoTypeThumbnailContentViewHeight21;
            } else {
                return s.height + marginTypeCell + twoTypeThumbnailContentViewHeight22;
            }

        } else {
            if (s1.height >= wordH) {
                return s.height + marginTypeCell + twoTypeThumbnailContentViewHeight11;
            } else {
                return s.height + marginTypeCell + twoTypeThumbnailContentViewHeight12;
            }
        }
    }

    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClubPostComment *clubPostComment = [self.clubPostComments objectAtIndex:indexPath.row];
    ClubPost *clubPost = clubPostComment.article;

    if (clubPost.tip && clubPost.tip.length) {
        [appDelegate showAlertViewForTitle:@"" message:clubPost.tip cancelButton:@"OK"];
        return;
    }

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

//侧滑删除、分享
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DLog(@"删除按钮被点击");
    }
    [tableView setEditing:YES animated:true];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {

    ClubPostComment *clubPostComment = [self.clubPostComments objectAtIndex:indexPath.row];
    __weak typeof(self) weakSelf = self;
    void (^rowActionHandler1)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction *_Nonnull action, NSIndexPath *_Nonnull indexPath) {

        DLog(@"按钮被点击啦啦啦啦啦啦 删除");
        //        [tableView setEditing:false animated:true];
        [weakSelf deletePostReplyWithCommentId:clubPostComment.commentId.integerValue andIndexPath:indexPath andClubPostComment:clubPostComment];

    };

    void (^rowActionHandler2)(UITableViewRowAction *, NSIndexPath *) = ^(UITableViewRowAction *_Nonnull action, NSIndexPath *_Nonnull indexPath) {

        DLog(@"按钮被点击啦啦啦啦啦啦 分享");
        //        [tableView setEditing:false animated:true];

        [self shareMassage:clubPostComment];
    };

    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:rowActionHandler1];
    action1.backgroundColor = [UIColor redColor];

    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"分享" handler:rowActionHandler2];
    action2.backgroundColor = [UIColor r:251 g:103 b:25];

    return @[ action1, action2 ];
}

/**
 *  请求我回复的帖子列表
 */
- (void)refreshMineReplyPostList {
    [nodataView removeFromSuperview];
    currentPage = 1;

    [self requestMyPostReplyList:currentPage];
}

/**
 请求我回复的帖子列表

 @param page 页码
 */
- (void)requestMyPostReplyList:(NSUInteger)page {

    showMoreFooterView.isLoading = YES;
    [appDelegate showIndicatorWithTitle:@"加载中"
                               animated:YES
                             fullScreen:NO
                           overKeyboard:NO
                            andAutoHide:NO];

    ClubRequest *request = [ClubRequest new];
    [request requestMyPostReply:page
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
                    self.clubPostComments = [[NSMutableArray alloc] initWithArray:res];
                } else {
                    if (res.count > 0) {
                        [self.clubPostComments addObjectsFromArray:res];
                    }
                }

                if (self.clubPostComments.count == 0) {
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

- (void)moreMineReplyPostList {
    [nodataView removeFromSuperview];
    currentPage += 1;
    [self requestMyPostReplyList:currentPage];
}

/**
 *  删除帖子回复
 */
- (void)deletePostReplyWithCommentId:(NSInteger)commentId andIndexPath:(NSIndexPath *)indexPath andClubPostComment:(ClubPostComment *)clubPostComment {

    RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
    cancel.action = ^{
        [clubTableView reloadData];
    };

    RIButtonItem *ok = [RIButtonItem
            itemWithLabel:@"删除"
                   action:^{

                       [self.clubPostComments removeObject:clubPostComment];
                       [clubTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];

                       ClubTask *task = [[ClubTask alloc] initDeletePostReplyWithCommentId:commentId
                                                                                  Finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                                      [self deletePostReplyFinish:userInfo andSucced:succeeded andIndexPath:indexPath andClubPostComment:clubPostComment];
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

- (void)deletePostReplyFinish:(NSDictionary *)userInfo andSucced:(BOOL)succeed andIndexPath:(NSIndexPath *)indexPath andClubPostComment:(ClubPostComment *)clubPostComment {
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
        [self performSelector:@selector(refreshMineReplyPostList) withObject:nil afterDelay:0.2];
        //        }
    }

    //下拉刷新
    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45 && self.hasMore) {
        if (!showMoreFooterView.isLoading && refreshHeaderView.state != EGOOPullRefreshLoading) {
            [self moreMineReplyPostList];
        }
    }
}

/**
 *  分享影片信息
 */
- (void)shareMassage:(ClubPostComment *)comment {
    ClubPost *clubPost = comment.article;

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

@end
