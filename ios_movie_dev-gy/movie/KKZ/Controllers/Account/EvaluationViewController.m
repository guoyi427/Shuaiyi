//
//  我的 - 待评价页面
//
//  Created by 艾广华 on 15/12/10.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//


#import "EvaluationView.h"
#import "EvaluationViewController.h"
#import "KKZUtility.h"
#import "MovieSelectHeader.h"
#import "TaskQueue.h"
#import "UIColor+Hex.h"
#import "OrderRequest.h"

/***************顶部提示文字*****************/
static const CGFloat topViewHeight = 30.0f;

typedef enum : NSUInteger {
    cancelButtonTag = 1000,
} evalueAllButtonTag;

@interface EvaluationViewController () <EvalueTableViewDelegate> {
    //请求的页数
    int currentPage;
}

/**
 *  顶部提示文字
 */
@property (nonatomic, strong) UILabel *topTipLbl;

/**
 *  列表页面
 */
@property (nonatomic, strong) EvaluationView *evalueView;

/**
 *  待评价数组
 */
@property (nonatomic, strong) NSMutableArray *evalueArray;

/**
 *  正在加载数据
 */
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation EvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //加载导航栏
    [self loadNavBar];

    //加载顶部视图
    [self loadTopView];

    //加载列表视图
    [self loadListView];

    //加载通知
    [self loadNotification];

    //加载网络
    [self loadRequest];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [KKZAnalytics postActionWithEvent:nil action:AnalyticsActionStay_comment_list];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - Private Method

- (void)loadNavBar {
    self.view.backgroundColor = [UIColor colorWithHex:@"#f5f5f5"];
    self.statusView.backgroundColor = self.navBarView.backgroundColor;
    self.kkzTitleLabel.text = @"待评价";
    self.kkzBackBtn.tag = cancelButtonTag;
    [self.kkzBackBtn addTarget:self
                        action:@selector(commonBtnClick:)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadTopView {

    //将当前请求的页数设置为1
    currentPage = 1;
}

- (void)loadListView {

    //添加列表视图
    [self.view addSubview:self.evalueView];
}

- (void)loadRequest {

    if (self.isLoading) {
        return;
    }

    self.isLoading = TRUE;

    //通知待评价页面即将开始刷新
    [self.evalueView beginRequestData];
    
    
    OrderRequest *request = [OrderRequest new];
    [request requestOrderComment:currentPage success:^(NSArray * _Nullable orderComments, BOOL hasMore) {
        [self requestFinished:orderComments hasMore:hasMore];
        [self endLoadingData];
        
    } failure:^(NSError * _Nullable err) {
        self.evalueView.listData = [NSMutableArray new];
        [self endLoadingData];
    }];

}

- (void)loadNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(commentFinishedReloadRequest)
                                                 name:movieCommentSuccessCompleteNotification
                                               object:nil];
}

- (void)endLoadingData {
    [self.evalueView endRequestData];
    self.isLoading = FALSE;
}

- (void)requestFinished:(NSArray *)orders hasMore:(BOOL)hasMore{

    if (orders.count > 0) {
        if (hasMore) {
            self.evalueView.hasMoreDta = TRUE;
        } else {
            self.evalueView.hasMoreDta = FALSE;
        }
    }

    //如果请求的页数为1就清除掉所有数据
    if (currentPage == 1) {
        [self.evalueArray removeAllObjects];
    }
    [self.evalueArray addObjectsFromArray:orders];
    CGFloat evalueOriginY;

    [_topTipLbl removeFromSuperview];
    evalueOriginY = CGRectGetMaxY(self.navBarView.frame);

    CGRect evalueFrame = _evalueView.frame;
    evalueFrame.origin.y = evalueOriginY;
    evalueFrame.size.height = kCommonScreenHeight - evalueOriginY;
    _evalueView.frame = evalueFrame;
    self.evalueView.listData = self.evalueArray;
}

#pragma mark - getter Method
- (UILabel *)topTipLbl {

    if (!_topTipLbl) {
        _topTipLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navBarView.frame), kCommonScreenWidth, topViewHeight)];
        _topTipLbl.backgroundColor = [UIColor colorWithHex:@"#fff8d0"];
        [_topTipLbl setTextColor:[UIColor colorWithHex:@"#87815f"]];
        _topTipLbl.font = [UIFont systemFontOfSize:12.0f];
        [_topTipLbl setTextAlignment:NSTextAlignmentCenter];
    }
    return _topTipLbl;
}

- (EvaluationView *)evalueView {

    if (!_evalueView) {
        CGFloat evalueOriginY = CGRectGetMaxY(self.navBarView.frame);
        _evalueView = [[EvaluationView alloc] initWithFrame:CGRectMake(0, evalueOriginY, kCommonScreenWidth, self.KCommonContentHeight - evalueOriginY)];
        _evalueView.cellDelegate = self;
    }
    return _evalueView;
}

- (NSMutableArray *)evalueArray {

    if (!_evalueArray) {
        _evalueArray = [[NSMutableArray alloc] init];
    }
    return _evalueArray;
}

#pragma mark - EvalueTableViewDelegate

- (void)commentFinishedReloadRequest {

    //刷新请求网络
    [self pullDownRefreshData];
}

- (void)reloadMoreData {

    //将当前请求页数＋1
    currentPage += 1;

    //加载下一页数据
    [self loadRequest];
}

- (void)pullDownRefreshData {

    //将当前请求的页数置为1
    currentPage = 1;

    //加载请求
    [self loadRequest];
}

#pragma mark - View pulic Method

- (void)commonBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case cancelButtonTag: {
            [self popViewControllerAnimated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
