//
//  RecommendView.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/7.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "RecommendView.h"
#import "friendRecommendModel.h"
#import "MJRefresh.h"
#import "AlertViewY.h"
#import "NoDataViewY.h"
#import "RequestLoadingView.h"
#import "ErrorDataView.h"
#import "RecommendLayout.h"
#import <objc/runtime.h>

@interface RecommendView () <UITableViewDataSource, UITableViewDelegate, RecommendCellDelegate> {
    //正在加载
    RequestLoadingView *loadingView;

    //无数据视图
    ErrorDataView *errorDataView;
}

/**
 *  cell的尺寸数组
 */
@property (nonatomic, strong) NSMutableArray *cellLayoutArr;

/**
 *  下一个响应者对象
 */
@property (nonatomic, weak) id a_nextResponder;

/**
 *  当前记载框是否正在加载中
 */
@property (nonatomic, assign) BOOL isRefreshLoading;

@end

@implementation RecommendView
@synthesize listTable;

- (id)initWithRefrshViewFrame:(CGRect)frame
                withTitleText:(NSString *)titleText
                nextResponder:(id)nextResponder {

    self = [super initWithFrame:frame];
    if (self) {

        //存储下一个响应者链对象
        self.a_nextResponder = nextResponder;

        //初始化表视图
        listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)
                                                 style:UITableViewStylePlain];
        listTable.delegate = self;
        listTable.dataSource = self;
        listTable.backgroundColor = [UIColor clearColor];
        listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:listTable];

        NSString *className = [NSString stringWithCString:object_getClassName(nextResponder)
                                                 encoding:NSUTF8StringEncoding];
        if ([className isEqualToString:@"ActivityUserViewController"]) {
            //footer
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 50.0f)];
            v.backgroundColor = [UIColor clearColor];
            listTable.tableFooterView = v;
        }

        //下拉刷新控件
        [listTable addHeaderWithTarget:self
                                action:@selector(headerRereshing)
                               dateKey:@"table"];
        listTable.headerPullToRefreshText = @"下拉可以刷新";
        listTable.headerReleaseToRefreshText = @"松开马上刷新";
        listTable.headerRefreshingText = @"数据加载中...";

        //提示正在刷新视图
        loadingView = [[RequestLoadingView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)
                                                      withTitle:@"获取列表中"];

        loadingView.centerLblColor = [UIColor whiteColor];

        //未找到数据的视图
        errorDataView = [[ErrorDataView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)
                                                   withTitle:titleText];

        //是否能刷新刷新
        self.canPullRefresh = TRUE;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
      withTitleText:(NSString *)titleText {
    self = [super initWithFrame:frame];
    if (self) {

        //初始化表视图
        listTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)
                                                 style:UITableViewStylePlain];
        listTable.delegate = self;
        listTable.dataSource = self;
        listTable.backgroundColor = [UIColor clearColor];
        listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:listTable];

        //提示正在刷新视图
        loadingView = [[RequestLoadingView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) withTitle:@"获取列表中"];
        loadingView.backgroundColor = [UIColor clearColor];
        [loadingView setCenterLblColor:[UIColor whiteColor]];

        //未找到数据的视图
        errorDataView = [[ErrorDataView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) withTitle:titleText];
        errorDataView.backgroundColor = [UIColor clearColor];

        //是否能刷新刷新
        self.canPullRefresh = FALSE;
    }
    return self;
}

#pragma mark - public Method

- (void)beginRefresh {

    //开始刷新
    if (self.canPullRefresh) {
        self.isRefreshLoading = TRUE;
        [listTable headerBeginRefreshing];
    }

    //移除掉错误页面
    [errorDataView removeFromSuperview];

    //数据源个数为0的时候就显示加载框
    if (_showDataArray.count == 0) {
        [listTable addSubview:loadingView];
        [loadingView startAnimation];
    } else {
        [loadingView stopAnimation];
        [loadingView removeFromSuperview];
    }
}

- (void)endRefresh {

    //停止刷新
    if (self.canPullRefresh) {
        self.isRefreshLoading = FALSE;
        [listTable headerEndRefreshing];
    }

    //移除掉加载框
    [loadingView stopAnimation];
    [loadingView removeFromSuperview];
}

- (void)headerRereshing {
    if (!self.isRefreshLoading) {
        if ([self.a_nextResponder respondsToSelector:@selector(headerRereshing)]) {
            [self.a_nextResponder headerRereshing];
        }
    }
}

- (void)updateInventedStatusWithIndex:(NSInteger)index {
    friendRecommendModel *model = self.showDataArray[index];
    model.status = PlatFormInvitedUserFriend;
    [self reloadListTableData];
}

- (void)updateAttentionStatusWithIndex:(NSInteger)index {
    friendRecommendModel *model = self.showDataArray[index];
    if ([model.modelType isEqualToString:modelTypePhoneUser]) {
        model.status = PlatFormUserFriend;
    } else if ([model.modelType isEqualToString:modelTypeActivityUser] || [model.modelType isEqualToString:modelTypeNearByUser]) {
        model.isFriend = TRUE;
    }
    [self reloadListTableData];
}

#pragma mark - private Method

- (void)reloadListTableData {

    if (self.showDataArray.count == 0) {
        [listTable addSubview:errorDataView];
    } else {
        [errorDataView removeFromSuperview];
    }
    [listTable reloadData];
}

#pragma mark - RecommendCell Delegate

- (void)clickInventButton:(id)inventObject {
    if ([self.cellDelegate respondsToSelector:@selector(clickInventButton:)]) {
        if ([inventObject isKindOfClass:[NSDictionary class]]) {
            [self.cellDelegate clickInventButton:inventObject];
        }
    }
}

- (void)clickAttentionButton:(id)inventObject {
    if ([self.cellDelegate respondsToSelector:@selector(clickAttentionButton:)]) {
        if ([inventObject isKindOfClass:[NSDictionary class]]) {
            [self.cellDelegate clickAttentionButton:inventObject];
        }
    }
}

#pragma mark - Table view data source

- (void)configureCell:(RecommendCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    friendRecommendModel *model = self.showDataArray[indexPath.row];
    RecommendLayout *layout = self.cellLayoutArr[indexPath.row];
    cell.model = model;
    cell.layout = layout;
    cell.cellIndex = indexPath.row;
    [cell updateLayout];
}

#pragma mark - Table view data source && delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";

    RecommendCell *cell = (RecommendCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RecommendCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:CellIdentifier];
        cell.cellDelegate = self;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = self.showDataArray.count;
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - setter Method
- (void)setShowDataArray:(NSMutableArray *)showDataArray {
    if (showDataArray != _showDataArray) {
        _showDataArray = showDataArray;
        [self.cellLayoutArr removeAllObjects];
        for (int i = 0; i < _showDataArray.count; i++) {
            friendRecommendModel *model = self.showDataArray[i];
            RecommendLayout *layout = [[RecommendLayout alloc] init];
            [layout calculateCellLayout:model];
            [self.cellLayoutArr addObject:layout];
        }
        [self reloadListTableData];
    }
}

- (NSMutableArray *)cellLayoutArr {

    if (!_cellLayoutArr) {
        _cellLayoutArr = [[NSMutableArray alloc] init];
    }
    return _cellLayoutArr;
}

@end
