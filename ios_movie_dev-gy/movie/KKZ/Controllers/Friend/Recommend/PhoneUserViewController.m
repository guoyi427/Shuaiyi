//
//  新的好友 - 好友推荐
//
//  Created by 艾广华 on 15/12/16.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "KKZGetContactList.h"
#import "NewFriendTask.h"
#import "PhoneUserViewController.h"
#import "TaskQueue.h"

static const CGFloat TableViewOriginY = 15.0f;

@interface PhoneUserViewController () <RecommendCellDelegate> {
    KKZGetContactList *contactList;
}

/**
 *  数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 *  视图尺寸
 */
@property (nonatomic, assign) CGRect viewFrame;

@end

@implementation PhoneUserViewController

- (id)initWithViewFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.viewFrame = frame;
    }
    return self;
}

/**
 *  初始化通讯录
 */
- (void)loadContactList {

    //获取联系人列表
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getContactData:)
                                                 name:contactListFinished
                                               object:nil];

    //获取联系人列表失败
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getContactFail)
                                                 name:contactListFailed
                                               object:nil];

    NSLog(@"开始读取手机通讯录");
    contactList = [KKZGetContactList sharedEngine];
    [contactList getContacts];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置背景颜色
    self.view.backgroundColor = [UIColor clearColor];

    //创建推荐页面
    [self loadTableView];

    //加载联系人列表
    [self loadContactList];
}

- (void)loadTableView {

    //添加推荐视图
    [self.view addSubview:self.recommendView];
}

#pragma mark - KKZGetContactList NSNotification

/**
 *  接收联系人手机号
 *
 *  @param note
 */
- (void)getContactData:(NSNotification *)note {
    NSDictionary *dic = (NSDictionary *) [note object];
    if (dic) {
        [self performSelectorOnMainThread:@selector(loadContactRequest:)
                                 withObject:dic
                              waitUntilDone:NO];
    }
}

/**
 *  获取联系人失败
 */
- (void)getContactFail {
    self.recommendView.showDataArray = [@[] mutableCopy];
}

/**
 *  下拉刷新
 */
- (void)headerRereshing {

    //请求通讯录好友
    [self loadContactList];
}

/**
 *  开始请求手机号
 *
 *  @param dic 
 */
- (void)loadContactRequest:(NSDictionary *)dic {

    NSString *phoneString = dic[phoneListString];

    NSLog(@"获取到手机通讯录");

    //开始刷新
    [self.recommendView beginRefresh];

    NewFriendTask *task = [[NewFriendTask alloc]
            initWithPhoneUser:phoneString
                     finished:^(BOOL succeeded, NSDictionary *userInfo) {

                         DLog(@"网络请求完成");

                         [self handleNewFriendResult:succeeded data:userInfo];

                     }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
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

        //推荐页面的尺寸
        CGRect recommendFrame = CGRectMake(0,
                                           TableViewOriginY,
                                           CGRectGetWidth(self.viewFrame),
                                           CGRectGetHeight(self.viewFrame) - TableViewOriginY);

        //推荐页面
        _recommendView = [[RecommendView alloc] initWithRefrshViewFrame:recommendFrame
                                                          withTitleText:@"啊哦, 获取列表失败~"
                                                          nextResponder:self];
        _recommendView.backgroundColor = UIColor.clearColor;
    }
    return _recommendView;
}

#pragma mark - public Method

- (void)updateInventedStatusWithIndex:(NSInteger)index {
    [self.recommendView updateInventedStatusWithIndex:index];
}

- (void)updateAttentionStatusWithIndex:(NSInteger)index {
    [self.recommendView updateAttentionStatusWithIndex:index];
}

- (BOOL)showNavBar {
    return NO;
}

- (void)dealloc {
    contactList = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
