//
//  新的好友 - 附近的人
//
//  Created by 艾广华 on 15/12/18.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "DataEngine.h"
#import "KKZUser.h"
#import "NearByViewController.h"
#import "NewFriendTask.h"
#import "TaskQueue.h"
#import "UIColor+Hex.h"
#import "UserDefault.h"
#import "friendRecommendModel.h"

static const CGFloat TableViewOriginY = 15.0f;

/************刷新按钮************/
static const CGFloat refreshBtnOriginX = 40.0f;
static const CGFloat refreshBtnHeight = 35.0f;
static const CGFloat refreshBtnBottom = 15.0f;

typedef enum : NSUInteger {
    refreshButtonTag = 1000,
} allButtonTag;

@interface NearByViewController ()

/**
 *  视图尺寸
 */
@property (nonatomic, assign) CGRect viewFrame;

/**
 *  当前页数
 */
@property (nonatomic, assign) int currentPage;

/**
 *  刷新按钮
 */
@property (nonatomic, strong) UIButton *refresBtn;

@end

@implementation NearByViewController

- (id)initWithViewFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.viewFrame = frame;
        self.currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];

    //加载表视图
    [self loadTableView];

    //开始请求
    [self loadRequest];
}

- (void)loadTableView {

    //添加推荐视图
    [self.view addSubview:self.recommendView];
}

- (void)headerRereshing {

    //请求活跃用户的请求
    [self loadRequest];
}

- (void)loadRequest {

    if (USER_LATITUDE && USER_LONGITUDE) {

        //开始刷新
        [self.recommendView beginRefresh];

        //请求数据
        NewFriendTask *task = [[NewFriendTask alloc]
                initWithNearByLatitude:USER_LATITUDE
                         withLongitude:USER_LONGITUDE
                          withPageSize:20
                              finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                  [self handleNewFriendResult:succeeded data:userInfo];
                              }];
        [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
    } else {
        if (self.recommendView.showDataArray.count == 0) {
            self.recommendView.showDataArray = [@[] mutableCopy];
        }
        [self.recommendView endRefresh];
    }
}

- (void)handleNewFriendResult:(BOOL)succeed data:(NSDictionary *)userInfo {
    if (succeed) {
        [self requestFinished:userInfo[requestDataSource]];
    } else {
        if (self.recommendView.showDataArray.count == 0) {
            self.recommendView.showDataArray = [@[] mutableCopy];
        }
    }
    [self.recommendView endRefresh];
}

#pragma mark - private Method

/**
 *  接受通讯录请求完成
 *
 *  @param dataArr
 */
- (void)requestFinished:(NSMutableArray *)dataArr {
    self.recommendView.showDataArray = dataArr;
}

#pragma mark - getter Method
- (RecommendView *)recommendView {

    if (!_recommendView) {
        CGRect recommendFrame = CGRectMake(0,
                                           TableViewOriginY,
                                           CGRectGetWidth(self.viewFrame),
                                           CGRectGetHeight(self.viewFrame) - TableViewOriginY);
        _recommendView = [[RecommendView alloc] initWithRefrshViewFrame:recommendFrame
                                                          withTitleText:@"啊哦, 获取列表失败~"
                                                          nextResponder:self];
        _recommendView.backgroundColor = UIColor.clearColor;
    }
    return _recommendView;
}

- (UIButton *)refresBtn {

    if (!_refresBtn) {
        _refresBtn = [UIButton buttonWithType:0];
        UIImage *refresh = [UIImage imageNamed:@"newFriend_refresh"];
        _refresBtn.frame = CGRectMake(refreshBtnOriginX, CGRectGetHeight(self.viewFrame) - refreshBtnBottom - refreshBtnHeight, CGRectGetWidth(self.viewFrame) - refreshBtnOriginX * 2, refreshBtnHeight);
        [_refresBtn setImage:refresh forState:UIControlStateNormal];
        [_refresBtn setTitle:@"换一换" forState:UIControlStateNormal];
        [_refresBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_refresBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15.0f)];
        _refresBtn.tag = refreshButtonTag;
        _refresBtn.backgroundColor = [UIColor colorWithHex:@"#c7c7c7"];
        _refresBtn.layer.cornerRadius = refreshBtnHeight / 2.0f;
        [_refresBtn addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _refresBtn;
}

#pragma mark - View pulic Method

- (BOOL)showNavBar {
    return FALSE;
}

- (void)updateAttentionStatusWithIndex:(NSInteger)index {
    [self.recommendView updateAttentionStatusWithIndex:index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
