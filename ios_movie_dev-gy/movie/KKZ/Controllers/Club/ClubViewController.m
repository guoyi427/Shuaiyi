//
//  ClubViewController.m
//  KoMovie
//
//  Created by KKZ on 16/1/30.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "ClubNavTab.h"
#import "ClubPost.h"
#import "ClubPostPictureViewController.h"
#import "ClubTask.h"
#import "ClubTypeOneCell.h"
#import "ClubTypeTowCell.h"
#import "ClubViewController.h"
#import "DataEngine.h"
#import "EGORefreshTableHeaderView.h"
#import "KKZUser.h"
#import "KKZUtility.h"
#import "ShowMoreIndicator.h"
#import "TaskQueue.h"
#import "WaitIndicatorView.h"
#import "WebViewController.h"
#import "NoDataViewY.h"
#import "BannerPlayerView.h"
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

@interface ClubViewController () {
    ShowMoreIndicator *showMoreFooterView;
    EGORefreshTableHeaderView *refreshHeaderView;
}
@property (nonatomic, strong) BannerPlayerView *bannerView;
@end

@implementation ClubViewController

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SubscribePostSucceedClub" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加帖子列表
    [self addClubListTableView];
    //添加吐槽和发布帖子的按钮
    //    [self addPublishPostBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subscribePostSucceed:) name:@"SubscribePostSucceedClub" object:nil];
    [self addTableNotice];
    
    [self loadBanners];
    //广告位是否显示通知
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(imgPlayerHeight:)
     name:@"imagePlayerViewHeightDiscover"
     object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setStatusBarLightStyle];
    //    //请求列表数据
    //    if (self.firstAppear) {
    //        [self refreshClubList];
    //        self.firstAppear = NO;
    //    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    [self setStatusBarLightStyle];
}

/**
 
 *  添加列表数据提示信息
 
 */

- (void)addTableNotice

{
    nodataView = [[NoDataViewY alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height * 0.5 - 100, screentWith, 120)];

    nodataView.alertLabelText = @"未获取到相关帖子";
}

- (void)subscribePostSucceed:(NSNotification *) not{
    NSDictionary *dict = not.userInfo[@"SubscribeClubPost"];
    [self.clubPosts addObject:dict];
    [clubTableView reloadData];
}

/**
 *  添加社区帖子列表
 */
- (void)addClubListTableView {
    //社区的帖子列表
    clubTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentHeight - self.contentPositionY - 44 - 50)];
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

/**
 *  加载广告位
 */
- (void)loadBanners {
    CGFloat heightN = 75 * (screentWith / 320);
    self.bannerView = [[BannerPlayerView alloc]
                       initWithFrame:CGRectMake(0, 0, screentWith, heightN)];
    self.bannerView.backgroundColor = [UIColor clearColor];
    self.bannerView.typeId = @"15";
    [self.bannerView updateBannerData];
}

/**
 *  是否显示广告位
 */
- (void)imgPlayerHeight:(NSNotification *)notification {
    
    float height = [notification.userInfo[NOTIFICATION_KEY_HEIGHT] intValue];
    
    if (height > 0) {
        clubTableView.tableHeaderView = self.bannerView;
    } else {
        [clubTableView setTableHeaderView:nil];
    }
}


- (void)clubListDataSource {
    //帖子列表数据源
    self.clubPosts = [[NSMutableArray alloc] initWithCapacity:0];

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"后天呆", @"userName", @"特约撰稿人", @"userCategory", @"3423", @"supportNum", @"2345", @"commentNum", @"微信好友", @"relationship", @"2016-12-13", @"postDate", @"1月31日下午，周星驰最新电影", @"postWord", nil];

    for (int i = 0; i < 15; i++) {
        [self.clubPosts addObject:dic];
    }

    if (self.clubPosts.count) {
        [clubTableView reloadData];
    }

    //帖子图片缩略图
    self.clubPhotos = [[NSMutableArray alloc] initWithCapacity:0];

    for (int i = 0; i < 9; i++) {
        [self.clubPhotos addObject:@"http://pic.nipic.com/2007-09-11/2007911115213916_2.jpg"];
    }
}

#pragma mark table view date source delegate

- (void)configureStyleOneCell:(ClubTypeOneCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ClubPost *clubPost = [self.clubPosts objectAtIndex:indexPath.row];
    cell.post = clubPost;
    cell.supportNum = clubPost.upNum;
    cell.commentNum = clubPost.replyNum;
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

- (void)configureStyleTwoCell:(ClubTypeTowCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    ClubPost *clubPost = [self.clubPosts objectAtIndex:indexPath.row];

    cell.post = clubPost;
    cell.supportNum = clubPost.upNum;
    cell.commentNum = clubPost.replyNum;

    cell.postDate = clubPost.publishTime;
    cell.postWord = clubPost.title;

    cell.postImgPaths = clubPost.filesImage;
    [cell upLoadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.clubPosts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ClubPost *clubPost = self.clubPosts[indexPath.row];

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
    ClubPost *clubPost = [self.clubPosts objectAtIndex:indexPath.row];

    if (clubPost.url && clubPost.url.length) {
        WebViewController *ctr = [[WebViewController alloc] initWithTitle:@""];
        [ctr loadURL:clubPost.url];
        [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
    } else {
        ClubPostPictureViewController *postDetail = [[ClubPostPictureViewController alloc] init];
        postDetail.articleId = clubPost.articleId;
        postDetail.postType = clubPost.type.integerValue;
        [self pushViewController:postDetail
                         animation:CommonSwitchAnimationSwipeR2L];
    }
}

#pragma mark-- 吐槽和发布帖子的功能
- (void)addPublishPostBtn {
    publishPostBtn = [[UIButton alloc] initWithFrame:CGRectMake(screentWith - publishBtnWidth - marginX, screentHeight - publishBtnWidth - 50 - marginY - self.contentPositionY - 44, publishBtnWidth, publishBtnWidth)];
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

    if (!appDelegate.isAuthorized) {

        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];

        [[DataEngine sharedDataEngine] startLoginFinished:nil withController:parentCtr];

    } else {

        PublishPostView *publishPostV = [[PublishPostView alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentHeight)];
        publishPostV.navId = self.clubTab.navId.integerValue;
        UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
        [keywindow addSubview:publishPostV];
    }
}

#pragma mark-- PublishPostViewDelegate

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  刷新列表数据
 */
- (void)refreshClubList {
    //    [self.clubPosts removeAllObjects];
    //    [clubTableView reloadData];
    //    clubTableView.hidden = YES;
    [nodataView removeFromSuperview];
    currentPage = 1;

    [self requestPosts:currentPage];
    [self.bannerView updateBannerData];
}

/**
 MARK: 请求文章列表

 @param page 页码
 */
- (void)requestPosts:(NSInteger)page {
    ClubRequest *request = [ClubRequest new];

    [request requestClubHomePagePostList:self.clubTab.firstPageUrl
            page:page
            success:^(NSArray *_Nullable posts, BOOL hasMore) {

                [indicatorYn removeFromSuperview];
                showMoreFooterView.isLoading = NO;
                if (currentPage <= 1 && posts) {
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

            }
            failure:^(NSError *_Nullable err) {
                DLog(@"");
                [indicatorYn removeFromSuperview];
                showMoreFooterView.isLoading = NO;
                [appDelegate showAlertViewForTitle:nil message:err.userInfo[KKZRequestErrorMessageKey] cancelButton:@"确定"];

            }];
}

- (void)moreClubList {

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
    //    if (scrollView.contentOffset.y <= -65.0f ) {
    if (scrollView.contentOffset.y <= -65.0f) {
        //        if (!showMoreFooterView.hasNoMore) {
        [self performSelector:@selector(refreshClubList) withObject:nil afterDelay:0.2];
        //        }
    }
    //下拉刷新
    if (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentInset.bottom - scrollView.contentSize.height >= 45 && self.hasMore) {
        if (!showMoreFooterView.isLoading && refreshHeaderView.state != EGOOPullRefreshLoading) {
            [self moreClubList];
        }
    }
}

#pragma mark-- 继承自commonviewcontroller

- (BOOL)showNavBar {
    return NO;
}

- (BOOL)showBackButton {
    return NO;
}

- (BOOL)showTitleBar {
    return NO;
}

- (BOOL)setRightButton {
    return FALSE;
}

- (void)yNshowIndicatorWithTitle:(NSString *)title
                        animated:(BOOL)animated
                      fullScreen:(BOOL)fullLayout
                    overKeyboard:(BOOL)overKb
                     andAutoHide:(BOOL)autoHide {

    if (!indicatorYn) {
        indicatorYn = [[WaitIndicatorView alloc] initWithFrame:self.view.bounds];
    }
    if (fullLayout) {
        indicatorYn.frame = CGRectMake(0, 0, screentWith, screentHeight);
    } else {
        indicatorYn.frame = CGRectMake((screentWith - 90 * 1.2) / 2, (screentContentHeight - 66 - 100) / 2.0, 90 * 1.2, 66 * 1.2);
    }

    indicatorYn.title = title ? title : @"加载中";
    indicatorYn.subTitle = nil;
    indicatorYn.alpa = 0;
    indicatorYn.animated = animated;
    indicatorYn.fullScreen = fullLayout;
    [indicatorYn updateLayout];

    [self.view addSubview:indicatorYn];
    [self.view bringSubviewToFront:indicatorYn];
}

@end
