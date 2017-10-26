//
//  PlatePostListController.m
//  KoMovie
//
//  Created by KKZ on 16/3/3.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubPost.h"
#import "ClubPostPictureViewController.h"
#import "ClubTask.h"
#import "ClubTypeOneCell.h"
#import "ClubTypeTowCell.h"
#import "DataEngine.h"
#import "EGORefreshTableHeaderView.h"
#import "KKZUser.h"
#import "PlatePostListController.h"
#import "PublishPostView.h"
#import "ShowMoreIndicator.h"
#import "TaskQueue.h"
#import "NoDataViewY.h"
#import "WebViewController.h"

#define publishBtnWidth 48
#define marginX 15
#define marginY 15

#define wordHeight1 46
#define wordHeight2 21
#define wordH 30

#define cellHeight1 226
#define cellHeight2 201

#define cellOnlyWordHeight1 126
#define cellOnlyWordHeight2 100

#define wordFont 17

@interface PlatePostListController () {
    ShowMoreIndicator *showMoreFooterView;
    EGORefreshTableHeaderView *refreshHeaderView;
}

@end

@implementation PlatePostListController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.kkzTitleLabel.text = self.ctrTitle;
    self.statusView.backgroundColor = self.navBarView.backgroundColor;
    //添加帖子列表
    [self addClubListTableView];
    //    //加载帖子列表数据
    //    [self clubListDataSource];
    //添加吐槽和发布帖子的按钮
    //    [self addPublishPostBtn];

    [self addTableNotice];
}

- (void)viewWillAppear:(BOOL)animated

{

    [super viewWillAppear:animated];

    if (self.firstAppear) {
        [self refreshMovieHotCommentList];
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

/**
 *  添加社区帖子列表
 */
- (void)addClubListTableView {
    //社区的帖子列表
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

- (void)configureStyleOneCell:(ClubTypeOneCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ClubPost *clubPost = [self.clubPosts objectAtIndex:indexPath.row];
    cell.post = clubPost;
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

- (void)configureStyleTwoCell:(ClubTypeTowCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ClubPost *clubPost = [self.clubPosts objectAtIndex:indexPath.row];

    cell.supportNum = clubPost.upNum;
    cell.commentNum = clubPost.replyNum;
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

        static NSString *cellStyleoneID = @"styleonecell";
        ClubTypeOneCell *cell = [clubTableView dequeueReusableCellWithIdentifier:cellStyleoneID];
        if (cell == nil) {
            cell = [[ClubTypeOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStyleoneID];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }

        [self configureStyleOneCell:cell atIndexPath:indexPath];
        return cell;
    } else if ((clubPost.type.integerValue == 1 && (clubPost.filesImage.count == 0 || clubPost.filesImage.count > 1)) || clubPost.type.integerValue == 4) {
        static NSString *cellStyleTwoID = @"styletowcell";
        ClubTypeTowCell *cell = [clubTableView dequeueReusableCellWithIdentifier:cellStyleTwoID];
        if (cell == nil) {
            cell = [[ClubTypeTowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStyleTwoID];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        [self configureStyleTwoCell:cell atIndexPath:indexPath];
        return cell;
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClubPost *clubPost = self.clubPosts[indexPath.row];

    if (clubPost.type.integerValue == 2 || clubPost.type.integerValue == 3 || (clubPost.type.integerValue == 4 && clubPost.filesImage.count == 1) || (clubPost.type.integerValue == 1 && clubPost.filesImage.count == 1)) {
        return 165;
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

    ClubPost *clubPost = self.clubPosts[indexPath.row];

    if (clubPost.url && clubPost.url.length) {

        WebViewController *ctr = [[WebViewController alloc] initWithTitle:@""];

        [ctr loadRequestWithURL:clubPost.url];

        [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];

    } else {

        ClubPostPictureViewController *postDetail = [[ClubPostPictureViewController alloc] init];
        postDetail.articleId = clubPost.articleId;

        postDetail.postType = clubPost.type.integerValue;

        postDetail.articleId = clubPost.articleId;
        [self pushViewController:postDetail animation:CommonSwitchAnimationSwipeR2L];
    }
}

#pragma mark-- 吐槽和发布帖子的功能
- (void)addPublishPostBtn {
    publishPostBtn = [[UIButton alloc] initWithFrame:CGRectMake(screentWith - publishBtnWidth - marginX, screentHeight - publishBtnWidth - marginY, publishBtnWidth, publishBtnWidth)];
    publishPostBtn.layer.cornerRadius = publishBtnWidth * 0.5;
    publishPostBtn.clipsToBounds = YES;
    [publishPostBtn setImage:[UIImage imageNamed:@"subscriberBtnIcon"] forState:UIControlStateNormal];
    [publishPostBtn addTarget:self action:@selector(publishPostBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:publishPostBtn aboveSubview:clubTableView];
}

/**
 *  发布帖子按钮被点击
 */
- (void)publishPostBtnClicked {
    DLog(@"发布帖子按钮被点击");

    PublishPostView *publishPostV = [[PublishPostView alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentHeight)];
    //    [effe addSubview:publishPostV];

    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:publishPostV];
}

#pragma mark-- 继承自commonviewcontroller

- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return TRUE;
}

- (BOOL)showTitleBar {
    return TRUE;
}

- (BOOL)setRightButton {
    return FALSE;
}

/**
 *  刷新列表数据
 */
- (void)refreshMovieHotCommentList {
    [nodataView removeFromSuperview];
    currentPage = 1;

    [self requestPosts:currentPage];
}


/**
 MARK: 请求帖子列表
 @param page <#page description#>
 */
- (void)requestPosts:(NSInteger)page
{
    
    showMoreFooterView.isLoading = YES;
    
    [appDelegate showIndicatorWithTitle:@"加载中"
     
                               animated:YES
     
                             fullScreen:NO
     
                           overKeyboard:NO
     
                            andAutoHide:NO];
    
    ClubRequest *request = [ClubRequest new];
    [request requestMoviePlatePosts:self.movieId
                             pateId:[NSNumber numberWithInteger:self.plateId]
                               page:page
                            success:^(NSArray * _Nullable posts, BOOL hasMore) {
                                
                                [appDelegate hideIndicator];
                                showMoreFooterView.isLoading = NO;
                                
                                
                                if (currentPage <= 1) {
                                    self.clubPosts = [[NSMutableArray alloc] initWithArray:posts];
                                } else {
                                    
                                    if (posts.count > 0) {
                                        
                                        [self.clubPosts addObjectsFromArray:posts];
                                    }
                                }
                                
                                if (hasMore) {
                                    
                                    self.hasMore = YES;
                                    
                                    showMoreFooterView.hidden = NO;
                                    
                                    showMoreFooterView.hasNoMore = NO;
                                    
                                } else {
                                    
                                    self.hasMore = NO;
                                    
                                    showMoreFooterView.hidden = NO;
                                    
                                    showMoreFooterView.hasNoMore = YES;
                                }
                                
                                if (self.clubPosts.count == 0) {
                                    showMoreFooterView.hidden = YES;
                                    [clubTableView addSubview:nodataView];
                                }
                                
                                [clubTableView reloadData];
                                
                            } failure:^(NSError * _Nullable err) {
                                
                                [appDelegate hideIndicator];
                                showMoreFooterView.isLoading = NO;
                                
                                [appDelegate showAlertViewForTitle:nil message:err.userInfo[KKZRequestErrorMessageKey] cancelButton:@"确定"];
    }];
}


- (void)moreMovieHotCommentListt {
    [nodataView removeFromSuperview];

    currentPage += 1;

   [self requestPosts:currentPage];
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
        [self performSelector:@selector(refreshMovieHotCommentList) withObject:nil afterDelay:0.2];
        //        }
    }
    //下拉刷新
    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45 && self.hasMore) {
        if (!showMoreFooterView.isLoading && refreshHeaderView.state != EGOOPullRefreshLoading) {
            [self moreMovieHotCommentListt];
        }
    }
}
@end
