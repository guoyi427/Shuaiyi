//
//  SingleCenterListView.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/21.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "SingleCenterListView.h"
#import "SingleCenterTableViewCell.h"
#import "SingleCenterModel.h"
#import "UrlOpenUtility.h"
#import "SingleCenterHandleUrl.h"
#import "UserManager.h"

@interface SingleCenterListView () <UITableViewDataSource, UITableViewDelegate>

/**
 *  是否已经更新过数据
 */
@property (nonatomic, assign) BOOL isReloadedData;

/**
 *  滚动条是否停止滚动
 */
@property (nonatomic, assign) BOOL scrollViewIsEndScroll;

/**
 *  获取响应者对象
 */
@property (nonatomic, weak) id responder;

@end

@implementation SingleCenterListView

@synthesize listTable;

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {

        //默认滚动条停止滚动
        _scrollViewIsEndScroll = TRUE;

        //初始化表视图
        listTable = [[CinemaTableView alloc] initWithOnlyRefreshFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)
                                                                style:UITableViewStylePlain];
        listTable.delegate = self;
        listTable.dataSource = self;
        listTable.cinemaDelegate = self;
        listTable.backgroundColor = [UIColor clearColor];
        listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:listTable];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
      withResponder:(id)responder {
    SingleCenterListView *object = [self initWithFrame:frame];
    object.responder = responder;
    return object;
}

#pragma mark - UITableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"StarCellIdentifier";
    //个人用户中心
    SingleCenterTableViewCell *cell = (SingleCenterTableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SingleCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    [cell updateModel:self.listData[indexPath.row]
            modelLayout:self.layoutData[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.listData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SingleCenterModel *model = self.listData[indexPath.row];
    if (model.isLast) {
        return TABLEVIEW_CELL_HEIGHT + TABLEVIEW_FOOTER_HEIGHT;
    }
    return TABLEVIEW_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SingleCenterModel *model = self.listData[indexPath.row];
    //    if ([model.name isEqualToString:@"购物车"]) {
    //        NSString *url = model.iosUrl;
    //        [SingleCenterHandleUrl handleWithUrl:[NSURL URLWithString:url]
    //                                    withName:model.name
    //                               withResponder:self.responder];
    //        return;
    //    }
    if (![[UserManager shareInstance] isUserAuthorizedWithController:self.responder]) {
        return;
    }
    
    NSString *url = model.iosUrl;
    [SingleCenterHandleUrl handleWithUrl:[NSURL URLWithString:url]
                                withName:model.name
                           withResponder:self.responder];
}

#pragma mark - CinemaTableView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    //执行TableView的滚动代理方法
    if ([listTable respondsToSelector:@selector(cinemeScrollViewDidScroll:)]) {
        [listTable cinemeScrollViewDidScroll:scrollView];
    }

    //告诉代理对象正在滚动中
    if ([self.singleDelegate respondsToSelector:@selector(listTableDidScroll:)]) {
        [self.singleDelegate listTableDidScroll:scrollView];
    }

    //当开始滚动的时候
    if (self.scrollViewIsEndScroll == FALSE) {

        const float EPSINON = 0.000001;
        if (scrollView.contentOffset.y >= -EPSINON) {

            //下拉刷新结束滚动的状态
            self.scrollViewIsEndScroll = TRUE;

            //如果数据还没有更新就更新
            if (!self.isReloadedData) {

                //将更新过的标志置为TRUE
                self.isReloadedData = TRUE;

                //刷新表格
                [self refreshTableData];
            }
        }
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

    const float EPSINON = 0.000001;
    if ((scrollView.contentOffset.y >= -EPSINON) && (scrollView.contentOffset.y <= EPSINON)) {

        //告诉代理滚动条回归到原点
        if ([self.singleDelegate respondsToSelector:@selector(listTableDidEndScroll:)]) {
            [self.singleDelegate listTableDidEndScroll:listTable];
        }
    }

    if ([listTable respondsToSelector:@selector(cinemaScrollViewDidEndDecelerating:)]) {
        [listTable cinemaScrollViewDidEndDecelerating:scrollView];
    }
}

#pragma mark - CinemaTableViewDelegate

- (void)beginRquestData {

    //下拉刷新代理方法
    if ([self.cinemaDelegate respondsToSelector:@selector(beginRquestData)]) {

        //滚动条开始滚动
        self.scrollViewIsEndScroll = FALSE;

        //让代理执行下拉刷新的方法
        [self.cinemaDelegate beginRquestData];
    }
}

- (void)refreshTableData {

    //更新表格数据
    [listTable reloadData];
}

#pragma mark - setter Method

- (void)setListData:(NSArray *)listData {

    //设置数据源数组
    _listData = listData;

    //每次赋新值时，清空掉布局数组
    [self.layoutData removeAllObjects];

    //遍历数据源数组,得到布局后的数组
    for (int i = 0; i < _listData.count; i++) {
        SingleCenterLayout *layout = [[SingleCenterLayout alloc] init];
        [layout updateLayoutModel:(SingleCenterModel *) _listData[i]];
        [self.layoutData addObject:layout];
    }

    //如果滚动条没有结束滚动的话就不更新数据
    if (self.scrollViewIsEndScroll) {

        //将更新过的标志置为TRUE
        self.isReloadedData = TRUE;

        //更新表格
        [self refreshTableData];

    } else {

        //将更新过的标志置为FALSE
        self.isReloadedData = FALSE;
    }
}

#pragma mark - UITableView delegate

- (NSMutableArray *)layoutData {

    if (!_layoutData) {
        _layoutData = [[NSMutableArray alloc] init];
    }
    return _layoutData;
}

@end
