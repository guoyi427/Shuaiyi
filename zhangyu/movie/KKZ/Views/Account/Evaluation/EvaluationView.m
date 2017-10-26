//
//  我的 - 待评价列表页面
//
//  Created by 艾广华 on 15/12/21.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CinemaTableView.h"
#import "ErrorDataView.h"
#import "EvaluationView.h"
#import "MJRefresh.h"
#import "RequestLoadingView.h"

@interface EvaluationView () <UITableViewDataSource, UITableViewDelegate, CinemaTableViewDelegate> {

    //列表视图
    CinemaTableView *listTable;
}

/**
 *  加载视图
 */
@property (nonatomic, strong) RequestLoadingView *loadingView;

/**
 *  无数据的视图
 */
@property (nonatomic, strong) ErrorDataView *errorDataView;

@end

@implementation EvaluationView

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {

        //初始化表视图
        listTable = [[CinemaTableView alloc] initWithOnlyMoreFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)
                                                             style:UITableViewStylePlain];
        listTable.delegate = self;
        listTable.dataSource = self;
        listTable.cinemaDelegate = self;
        listTable.backgroundColor = [UIColor whiteColor];
        listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:listTable];

        //下拉刷新视图
        [listTable addHeaderWithTarget:self
                                action:@selector(headerRereshing)
                               dateKey:@"table"];
        listTable.headerPullToRefreshText = @"下拉可以刷新";
        listTable.headerReleaseToRefreshText = @"松开马上刷新";
        listTable.headerRefreshingText = @"数据加载中...";
    }
    return self;
}

- (void)layoutSubviews {
    listTable.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"StarCellIdentifier";
    EvalueTableViewCell *cell = (EvalueTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[EvalueTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.cellDelegate = self;
    }
    cell.dataSource = self.listData[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 111.0f;
}

#pragma mark - setter Method
- (void)setListData:(NSMutableArray *)listData {

    //设置显示数据
    if (_listData != listData) {
        _listData = listData;
    }

    //判断一下加载的数据源个数是多少
    if (_listData.count == 0) {
        [listTable setTableViewFooterHidden:TRUE];
        [listTable addSubview:self.errorDataView];
    } else {
        [listTable setTableViewFooterHidden:FALSE];
        [listTable setTableViewFooterHasMore:!self.hasMoreDta];
        [self.errorDataView removeFromSuperview];
    }

    [listTable reloadData];
}

#pragma mark - getter Method
- (RequestLoadingView *)loadingView {

    if (!_loadingView) {
        _loadingView = [[RequestLoadingView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) withTitle:@"正在请求列表,请稍侯..."];
    }
    return _loadingView;
}

- (ErrorDataView *)errorDataView {

    if (!_errorDataView) {
        _errorDataView = [[ErrorDataView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) withTitle:@"未获取到待评价信息"];
    }
    return _errorDataView;
}

#pragma mark - EvalueTableViewDelegate

- (void)commentFinishedReloadRequest {
    if ([self.cellDelegate respondsToSelector:@selector(commentFinishedReloadRequest)]) {
        [self.cellDelegate commentFinishedReloadRequest];
    }
}

#pragma mark - CinemaTableView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([listTable respondsToSelector:@selector(cinemeScrollViewDidScroll:)]) {
        [listTable cinemeScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([listTable respondsToSelector:@selector(cinemaScrollViewDidEndDragging:
                                                                willDecelerate:)]) {
        [listTable cinemaScrollViewDidEndDragging:scrollView
                                   willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([listTable respondsToSelector:@selector(cinemaScrollViewDidEndDecelerating:)]) {
        [listTable cinemaScrollViewDidEndDecelerating:scrollView];
    }
}

- (void)reloaNextPageData {
    if ([self.cellDelegate respondsToSelector:@selector(reloadMoreData)]) {
        [self.cellDelegate reloadMoreData];
    }
}

- (void)headerRereshing {
    if ([self.cellDelegate respondsToSelector:@selector(pullDownRefreshData)]) {
        [self.cellDelegate pullDownRefreshData];
    }
}

- (void)beginRequestData {

    //先移除掉错误页面
    [self.errorDataView removeFromSuperview];

    //再根据当前TableView的数据源个数来决定显示加载框
    if (_listData.count > 0) {
        [self.loadingView stopAnimation];
        [self.loadingView removeFromSuperview];
    } else {
        [listTable addSubview:self.loadingView];
        [self.loadingView startAnimation];
    }
}

- (void)endRequestData {

    //移除掉加载框
    [self.loadingView stopAnimation];
    [self.loadingView removeFromSuperview];

    //停止下拉刷新状态
    [listTable headerEndRefreshing];
}

@end
