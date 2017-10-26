//
//  影院详情页面
//
//  Created by 艾广华 on 15/12/8.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaTableSectionView.h"
#import "ClubPost.h"
#import "ClubPostPictureViewController.h"
#import "ClubTask.h"
#import "ClubTypeOneCell.h"
#import "ClubTypeTowCell.h"
#import "DataEngine.h"
#import "KKZUser.h"
#import "KKZUtility.h"
#import "MovieDetailHeader.h"
#import "MovieHotCommentController.h"
#import "MovieStillScrollViewController.h"
#import "MovieStillsCell.h"
#import "MovieTask.h"
#import "NewCinemaDetailView.h"
#import "SpecialTableViewCell.h"
#import "StillsWaterFlowViewController.h"
#import "TaskQueue.h"
#import "UIColor+Hex.h"
#import "CinemaRequest.h"

#define wordHeight1 46
#define wordHeight2 21
#define wordH 30
#define marginX 15
#define cellHeight1 226
#define cellHeight2 201
#define wordFont 17
#define cellOnlyWordHeight1 126
#define cellOnlyWordHeight2 100

/****************热门吐槽********************/
const static CGFloat hotCommentLabelLeft = 67.0f;
const static CGFloat hotCommentLabelTop = 12.0f;
const static CGFloat hotCommentLabelRight = 20.0f;
const static CGFloat hotCommentLabelHeight = 15.0f;
const static CGFloat hotCommentLabelFont = 15.0f;

/****************查看更多********************/
const static CGFloat moreButtonHeight = 50.0f;
const static CGFloat moreButtonFont = 14.0f;

typedef enum : NSUInteger {
    hotCommentLabelTag = 1000,
    moreButtonTag,
} allButtonTag;

@interface NewCinemaDetailView () <
        UITableViewDataSource, UITableViewDelegate, CinemaTableSectionViewDelegate,
        MovieStillsCellDelegate, CinemaTableViewDelegate>

/**
 *  影院Id
 */
@property (nonatomic, copy) NSNumber *cinemaId;

/**
 *  是否有更多数据
 */
@property (nonatomic, assign) BOOL hasMore;

/**
 *  总的吐槽条数
 */
@property (nonatomic, assign) NSInteger total;

/**
 *  影院图集
 */
@property (nonatomic, strong) NSMutableArray *cinemaGalleries;

/**
 *  热门吐槽数据源
 */
@property (nonatomic, strong) NSMutableArray *clubPosts;

/**
 *  表视图顶端视图数组
 */
@property (nonatomic, strong) NSMutableArray *tableHeaderViewArr;

/**
 *  滚动条是否停止滚动
 */
@property (nonatomic, assign) BOOL scrollViewIsEndScroll;

/**
 *  是否更新过特色信息的表格
 */
@property (nonatomic, assign) BOOL cinemaSpecialUpdated;

/**
 *  是否更新过影院图集的表格
 */
@property (nonatomic, assign) BOOL cinemaGalleryUpdated;

/**
 *  热门吐槽标签
 */
@property (nonatomic, strong) UILabel *hotCommentLabel;

/**
 *  查看更多按钮
 */
@property (nonatomic, strong) UIButton *moreButton;

@end

@implementation NewCinemaDetailView

- (id)initWithFrame:(CGRect)frame withCinemaId:(NSInteger)cinemaId {

    self = [super initWithFrame:frame];
    if (self) {

        //设置影院Id
        self.cinemaId = [NSNumber numberWithInteger:cinemaId];

        //默认的滚动条视图
        _scrollViewIsEndScroll = TRUE;

        //初始化表视图
        [self addSubview:self.listTable];
    }
    return self;
}

/**
 *  开始请求数据
 */
- (void)beginRequestNet {

    //请求影院图集
    [self refreshCinemaStillsTask];

    //请求热门吐槽
    [self loadHotCinemaComment];
}

- (void)refreshCinemaStillsTask {
    MovieTask *task = [[MovieTask alloc]
            initCinemaPosterWithCinemaid:self.cinemaId.unsignedIntegerValue
                               mediaType:20
                                finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                    //影院图集请求完成
                                    [self cinemaGalleryFinished:userInfo
                                                           status:succeeded];
                                }];

    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

- (void)loadCinemaLabelList {
    CinemaRequest *request = [[CinemaRequest alloc] init];

    [request requestCinemaFeatureParams:[NSDictionary dictionaryWithObjectsAndKeys:self.cinemaId, @"cinema_id", nil]
            success:^(NSArray *_Nullable features) {
                [self cinemaSpecialListRuestfinished:features];
            }
            failure:^(NSError *_Nullable err){

            }];
}

- (void)loadHotCinemaComment {
    NSInteger currentPage = 1;
    NSInteger rows = 3;
    
    ClubRequest *request = [ClubRequest new];
    [request requestCinemaHotCommentWithCinemaId:self.cinemaId currentPage:currentPage rowsNum:rows userGroup:@"1,2,3,0" success:^(NSArray * _Nullable hotComments, NSInteger total, BOOL hasMore) {
        
        //热门吐槽的个数
        self.total = total;
        if (self.total > 3) {
            self.hasMore = YES;
        } else {
            self.hasMore = NO;
        }
        
        //显示吐槽的个数
        self.hotCommentLabel.text =
        [NSString stringWithFormat:@"（%ld）", (long)self.total];
        
        //帖子列表的数据模型
        self.clubPosts = [NSMutableArray arrayWithArray:hotComments];
        
        //数据模型如果有就刷新列表
        if (self.clubPosts.count) {
            [self reloadListTableData];
        }
    } failure:^(NSError * _Nullable err) {
        
    }];
}

#pragma mark - CinemaTableViewDelegate

/**
 *  下拉刷新
 */
- (void)beginRquestData {

    //判断代理对象是否响应下拉刷新请求
    if ([self.detailDelegate
                respondsToSelector:@selector(pullRefreshBeginRequest)]) {

        // NewCinemaDetailController执行下拉刷新方法
        [self.detailDelegate pullRefreshBeginRequest];

        //刚开始下拉刷新的时候不刷新列表
        self.scrollViewIsEndScroll = FALSE;
    }
}

/**
 *  特色信息请求结果
 *
 *  @param userInfo
 *  @param succeeded
 */
- (void)cinemaSpecialListRuestfinished:(NSArray *)specialList {

    //将下拉刷新状态置为原始状态
    [self.listTable setTableViewHeaderState:tableHeaderNormalState];

    //特色信息数组
    _cinemaSpecialInfo = specialList;

    //如果请求成功并且当前状态不是用户正在拉动刷新状态
    if (self.scrollViewIsEndScroll) {

        //标注一下特色信息已经刷新过表格
        self.cinemaSpecialUpdated = TRUE;

        //刷新表格
        [self reloadSpecialInfo];

    } else {

        //标注一下特色信息没有刷新过表格
        self.cinemaSpecialUpdated = FALSE;
    }
}

/**
 *  刷新特色信息数据
 */
- (void)reloadSpecialInfo {

    //如果特色信息个数为0就不刷新表格
    if (_cinemaSpecialInfo.count > 0) {
        [self reloadListTableData];
    }
}

/**
 *  影院图集请求结果
 *
 *  @param userInfo
 *  @param succeeded
 */
- (void)cinemaGalleryFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {

    //将下拉刷新状态置为原始状态
    [self.listTable setTableViewHeaderState:tableHeaderNormalState];

    //请求成功的话就更新数据请求接口
    if (succeeded) {

        //获取影院图集的数据
        _cinemaGalleries = userInfo[@"posters"];

        if (self.scrollViewIsEndScroll) {

            //标注一下影院图集已经刷新过表格
            self.cinemaGalleryUpdated = TRUE;

            //刷新表格
            [self reloadCinemaGalleriesInfo];

        } else {

            //标注一下影院图集没有刷新过表格
            self.cinemaSpecialUpdated = FALSE;
        }
    }
}

- (void)reloadCinemaGalleriesInfo {
    if ([_cinemaGalleries count]) {
        [self reloadListTableData];
    }
}

#pragma mark - public Method

- (void)setHasMore:(BOOL)hasMore {
    _hasMore = hasMore;
    if (_hasMore) {
//        self.listTable.tableFooterView = self.moreButton;
    } else {
        self.listTable.tableFooterView = nil;
    }
}

- (void)setTableHeader:(id)tableHeader {
    if (tableHeader) {
        self.listTable.tableHeaderView = tableHeader;
    }
}

- (void)commonBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case moreButtonTag: {
            MovieHotCommentController *ctr = [[MovieHotCommentController alloc] init];
            ctr.cinemaId = self.cinemaId;
            ctr.userGroup = @"1,2,3,0";
            ctr.ctrTitle = @"热门吐槽";
            CommonViewController *common =
                    [KKZUtility getRootNavagationLastTopController];
            [common pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
            break;
        }
        default:
            break;
    }
}

#pragma mark - private Method

- (void)reloadListTableData {

    //设置表视图顶部视图
    [self setTableViewHeaderView];

    //更新表视图
    [self.listTable reloadData];
}

- (void)setTableViewHeaderView {

    //如果顶部数组里面有数据就直接返回
    if (self.tableHeaderViewArr.count) {
        return;
    }

    // table section视图初始化
    NSArray *titleArr = @[ @"特色信息", @"影院图集"];//, @"热门吐槽" ];
    NSArray *hidenArr = @[ @TRUE, @FALSE, @TRUE];//, @TRUE ];

    for (int i = 0; i < titleArr.count; i++) {

        //每个section的顶部视图
        CinemaTableSectionView *header = [[CinemaTableSectionView alloc] init];
        header.sectionNum = i;
        header.titleStr = titleArr[i];
        header.delegate = self;
        header.BtnHidden = [hidenArr[i] boolValue];
        [header updateLayout];

        //给热门吐槽增加一个标签
        if (i == 2) {
            [header addSubview:self.hotCommentLabel];
        }

        //将顶部视图加到数组里面
        [self.tableHeaderViewArr addObject:header];
    }
}

- (void)configureStyleOneCell:(ClubTypeOneCell *)cell
                  atIndexPath:(NSIndexPath *)indexPath {

    ClubPost *clubPost = [self.clubPosts objectAtIndex:indexPath.row];

    cell.post = clubPost;
    cell.supportNum = clubPost.upNum;
    cell.commentNum = clubPost.replyNum;
    cell.postDate = clubPost.publishTime;
    cell.postWord = clubPost.title;

    if (clubPost.type.integerValue == 2) {
        cell.postImgPath = clubPost.author.head;
    } else
        cell.postImgPath = clubPost.filesImage[0];

    if (clubPost.type.integerValue == 2) {
        cell.postType = 2; //音频
    } else if (clubPost.type.integerValue == 3) {
        cell.postType = 1; //视频
    } else if (clubPost.type.integerValue == 1 || clubPost.type.integerValue == 4) {
        cell.postType = 3; //图文
    }
    [cell upLoadData];
}

- (void)configureStyleTwoCell:(ClubTypeTowCell *)cell
                  atIndexPath:(NSIndexPath *)indexPath {
    ClubPost *clubPost = [self.clubPosts objectAtIndex:indexPath.row];

    cell.post = clubPost;
    cell.supportNum = clubPost.upNum;
    cell.commentNum = clubPost.replyNum;
    cell.postDate = clubPost.publishTime;
    cell.postWord = clubPost.title;
    cell.postImgPaths = clubPost.filesImage;
    [cell upLoadData];
}

#pragma mark - Table view data source && delegate

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"StarCellIdentifier";
        //特色信息
        SpecialTableViewCell *cell = (SpecialTableViewCell *) [tableView
                dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SpecialTableViewCell alloc]
                      initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.dataSource = _cinemaSpecialInfo;
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"MovieStillsCellIdentifier";
        //电影
        MovieStillsCell *cell = (MovieStillsCell *) [tableView
                dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[MovieStillsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        if (self.cinemaGalleries.count) {
            cell.isMovie = NO;
            cell.stills = self.cinemaGalleries;
            [cell updateLayout];
        }
        return cell;
    } else if (indexPath.section == 2) {
        //热门吐槽
        ClubPost *clubPost = [self.clubPosts objectAtIndex:indexPath.row];
        if (clubPost.type.integerValue == 2 || clubPost.type.integerValue == 3 ||
            (clubPost.type.integerValue == 4 && clubPost.filesImage.count == 1) ||
            (clubPost.type.integerValue == 1 && clubPost.filesImage.count == 1)) {
            static NSString *cellStyleOneID5 = @"clubstyleonecell5";
            ClubTypeOneCell *cell =
                    [tableView dequeueReusableCellWithIdentifier:cellStyleOneID5];
            if (cell == nil) {
                cell =
                        [[ClubTypeOneCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:cellStyleOneID5];
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            }

            [self configureStyleOneCell:cell atIndexPath:indexPath];
            return cell;
        } else if ((clubPost.type.integerValue == 1 && (clubPost.filesImage.count == 0 ||
                                                        clubPost.filesImage.count > 1)) ||
                   clubPost.type.integerValue == 4) {
            static NSString *cellStyleTwoID5 = @"clubstyletowcell5";
            ClubTypeTowCell *cell =
                    [tableView dequeueReusableCellWithIdentifier:cellStyleTwoID5];
            if (cell == nil) {
                cell =
                        [[ClubTypeTowCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:cellStyleTwoID5];
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            }
            [self configureStyleTwoCell:cell atIndexPath:indexPath];
            return cell;
        }
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableHeaderViewArr.count;
}

- (UIView *)tableView:(UITableView *)tableView
        viewForHeaderInSection:(NSInteger)section {
    if (section < self.tableHeaderViewArr.count) {
        if (section == 0 && !_cinemaSpecialInfo.count) {
            return nil;
        } else if (section == 1 && !_cinemaGalleries.count) {
            return nil;
        } else if (section == 2 && !_clubPosts.count) {
            return nil;
        }
        return self.tableHeaderViewArr[section];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView
        heightForHeaderInSection:(NSInteger)section {
    if (section < self.tableHeaderViewArr.count) {
        UIView *view = self.tableHeaderViewArr[section];
        if (!_cinemaSpecialInfo.count && section == 0) {
            return 0;
        } else if (!_cinemaGalleries.count && section == 1) {
            return 0;
        } else if (!_clubPosts.count && section == 2) {
            return 0;
        }
        return view.frame.size.height;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return self.clubPosts.count;
    } else if (section == 0) {
        if (_cinemaSpecialInfo.count) {
            return 1;
        }
        return 0;
    } else if (section == 1) {
        if (_cinemaGalleries.count) {
            return 1;
        }
        return 0;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView
        heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 93.0f;
    } else if (indexPath.section == 1) {
        return 100.0f;
    } else if (indexPath.section == 2) {
        ClubPost *clubPost = [self.clubPosts objectAtIndex:indexPath.row];
        if (clubPost.type.integerValue == 2 || clubPost.type.integerValue == 3 ||
            (clubPost.type.integerValue == 4 && clubPost.filesImage.count == 1) ||
            (clubPost.type.integerValue == 1 && clubPost.filesImage.count == 1)) {
            return 165;
        } else if ((clubPost.type.integerValue == 1 && (clubPost.filesImage.count == 0 ||
                                                        clubPost.filesImage.count > 1)) ||
                   clubPost.type.integerValue == 4) {
            //            CGSize s = [KKZUtility customTextSize:[UIFont
            //            systemFontOfSize:wordFont]
            //                                             text:clubPost.title
            //                                             size:CGSizeMake(screentWith
            //                                             - marginX * 2,
            //                                             CGFLOAT_MAX)];

            //设置行间距
            NSMutableParagraphStyle *paragraphStyle =
                    [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 5;

            NSDictionary *attributes = @{
                NSFontAttributeName : [UIFont systemFontOfSize:wordFont],
                NSParagraphStyleAttributeName : paragraphStyle
            };

            CGFloat contentW = screentWith - marginX * 2;

            CGRect tmpRect = [clubPost.title
                    boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                                 options:NSStringDrawingUsesLineFragmentOrigin
                              attributes:attributes
                                 context:nil];

            CGSize s = tmpRect.size;

            if (clubPost.filesImage.count) {
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
    }
    return 150.0f;
}

- (void)tableView:(UITableView *)tableView
        didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        ClubPost *clubPost = [self.clubPosts objectAtIndex:indexPath.row];
        ClubPostPictureViewController *postDetail =
                [[ClubPostPictureViewController alloc] init];
        postDetail.articleId = clubPost.articleId;
        postDetail.postType = clubPost.type.integerValue;
        CommonViewController *common =
                [KKZUtility getRootNavagationLastTopController];
        [common pushViewController:postDetail
                         animation:CommonSwitchAnimationSwipeR2L];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - MovieStillsCellDelegate

- (void)didSelectedStillWithIndex:(int)index {
    CommonViewController *controller =
            [KKZUtility getRootNavagationLastTopController];
    MovieStillScrollViewController *ctr =
            [[MovieStillScrollViewController alloc] init];
    ctr.index = index;
    ctr.isMovie = NO;
    ctr.gallerys = self.cinemaGalleries;
    [controller pushViewController:ctr animation:CommonSwitchAnimationBounce];
}

#pragma mark - CinemaTableSectionViewDelegate
- (void)CinemaDetailShowMore:(NSInteger)sectionNum {
    if (sectionNum == 1) {
        CommonViewController *controller =
                [KKZUtility getRootNavagationLastTopController];
        StillsWaterFlowViewController *swf =
                [[StillsWaterFlowViewController alloc] init];
        swf.isCinema = YES;
        swf.movieId = self.cinemaId;
        swf.titleStr = self.cinemaName;
        swf.mediaType = 20;
        [controller pushViewController:swf animation:CommonSwitchAnimationBounce];
        KKZAnalyticsEvent *event = [[KKZAnalyticsEvent alloc] init];
        event.cinema_id = self.cinemaId.stringValue;
        event.cinema_name = self.cinemaName;
        [KKZAnalytics postActionWithEvent:event action:AnalyticsActionCinema_photo];
    }
}

#pragma mark - CinemaTableView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.listTable
                respondsToSelector:@selector(cinemeScrollViewDidScroll:)]) {
        [self.listTable cinemeScrollViewDidScroll:scrollView];
    }

    //告诉代理对象当前视图正在滚动中
    if ([self.detailDelegate respondsToSelector:@selector(listTableDidScroll:)]) {
        [self.detailDelegate listTableDidScroll:scrollView];
    }

    if (self.scrollViewIsEndScroll == FALSE) {
        const float EPSINON = 0.000001;
        if (scrollView.contentOffset.y >= -EPSINON) {

            //下拉刷新结束滚动的状态
            self.scrollViewIsEndScroll = TRUE;

            //如果影院特色，影院图集,评论列表其中有一个没有更新过
            if (!self.cinemaGalleryUpdated || !self.cinemaSpecialUpdated) {

                //将更新状态更新
                self.cinemaGalleryUpdated = TRUE;
                self.cinemaSpecialUpdated = TRUE;

                //将表格视图更新
                [self reloadListTableData];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    if ([self.listTable
                respondsToSelector:@selector(cinemaScrollViewDidEndDragging:
                                                             willDecelerate:)]) {
        [self.listTable cinemaScrollViewDidEndDragging:scrollView
                                        willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    //告诉代理对象当前视图停止滚动
    if ([self.detailDelegate
                respondsToSelector:@selector(listTableDidEndScroll:)]) {
        [self.detailDelegate listTableDidEndScroll:scrollView];
    }

    //执行滚动条底层方法
    if ([self.listTable
                respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.listTable cinemaScrollViewDidEndDecelerating:scrollView];
    }
}

#pragma mark - setter Method
- (void)setCinemaSpecialInfo:(NSArray *)cinemaSpecialInfo {
    _cinemaSpecialInfo = cinemaSpecialInfo;
    if (!_cinemaSpecialInfo) {
        [self loadCinemaLabelList];
    } else {
        [self reloadSpecialInfo];
    }
}

#pragma mark - getter Method

- (NSMutableArray *)tableHeaderViewArr {
    if (!_tableHeaderViewArr) {
        _tableHeaderViewArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _tableHeaderViewArr;
}

- (CinemaTableView *)listTable {
    if (!_listTable) {
        _listTable = [[CinemaTableView alloc]
                initWithFrame:CGRectMake(0, 0, self.frame.size.width,
                                         self.frame.size.height)
                        style:UITableViewStylePlain];
        _listTable.delegate = self;
        _listTable.dataSource = self;
        _listTable.cinemaDelegate = self;
        _listTable.backgroundColor = [UIColor clearColor];
        _listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _listTable;
}

- (UILabel *)hotCommentLabel {
    if (!_hotCommentLabel) {
        _hotCommentLabel = [[UILabel alloc]
                initWithFrame:CGRectMake(hotCommentLabelLeft, hotCommentLabelTop,
                                         kCommonScreenWidth - hotCommentLabelLeft -
                                                 hotCommentLabelRight,
                                         hotCommentLabelHeight)];
        _hotCommentLabel.textColor = [UIColor lightGrayColor];
        _hotCommentLabel.font = [UIFont systemFontOfSize:hotCommentLabelFont];
        _hotCommentLabel.tag = hotCommentLabelTag;
    }
    return _hotCommentLabel;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:0];
        _moreButton.frame = CGRectMake(0, 0, kCommonScreenWidth, moreButtonHeight);
        _moreButton.titleLabel.font = [UIFont systemFontOfSize:moreButtonFont];
        _moreButton.tag = moreButtonTag;
        _moreButton.backgroundColor = [UIColor whiteColor];
        [_moreButton setTitleColor:[UIColor colorWithHex:@"#008cff"]
                          forState:UIControlStateNormal];
        [_moreButton addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
        [_moreButton setTitle:[NSString stringWithFormat:@"查看更多吐槽"]
                     forState:UIControlStateNormal];
    }
    return _moreButton;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
