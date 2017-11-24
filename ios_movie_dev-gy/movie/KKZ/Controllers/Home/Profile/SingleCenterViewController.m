//
//  首页 - 我的
//
//  Created by 艾广华 on 15/12/3.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AccountRequest.h"

#import "AppRequest.h"
#import "ClubTask.h"
#import "DataEngine.h"
#import "EGORefreshTableHeaderView.h"
#import "KKZUser.h"
#import "KKZUtility.h"
#import "KotaTask.h"
#import "MenuConfigViewModel.h"
#import "MyPublishedPostsViewController.h"
#import "NewLoginViewModel.h"
#import "SettingViewController.h"
#import "SingleCenterListView.h"
#import "SingleCenterModel.h"
#import "SingleCenterViewController+layout.h"
#import "SingleCenterViewController.h"
#import "SingleCenterViewModel.h"
#import "TaskQueue.h"
#import "TaskQueue.h"
#import "UIActionSheet+Blocks.h"
#import "UIColor+Hex.h"
#import "UserManager.h"
#import "AccountRequest.h"
#import "AppRequest.h"
#import "UserRequest.h"
#import "SingleCenterViewModel.h"

static const NSUInteger kBottomTabbarItemHeight = 49;
static const NSUInteger kTopHeaderViewHeight = 180 - 30;

typedef enum : NSUInteger {
    attentionCountTag = 2000,
    attentionTextTag,
    attentionButtonTag,
    seeButtonTag,
    wantSeeButtonTag,
    commentButtonTag,
    setButtonTag,
    messageButtonTag,
    friendButtonTag,
    orderManagerButtonTag,
    shoppingVoucherButtonTag,
    accountMoneyButtonTag,
    couponButtonTag,
    bonusButtonTag,
    collectionsButtonTag,
} allViewTag;

@interface SingleCenterViewController () <
        UIScrollViewDelegate, UIImagePickerControllerDelegate,
        UINavigationControllerDelegate, CinemaTableViewDelegate,
        SingleCenterListViewDelegate> {
    //顶部背景视图高度
    int homeHeaderViewHeight;

    //顶部视图初始尺寸
    CGRect topViewRect;

    //下来刷新
    EGORefreshTableHeaderView *refreshHeaderView;

}

/**
 *  顶部背景视图
 */
@property (nonatomic, strong) UIImageView *homeBackgroundView;

/**
 *  滚动条顶部视图
 */
@property (nonatomic, strong) UIView *headerTopView;

/**
 *  头像视图
 */
@property (nonatomic, strong) UIImageView *avatarImageView;

/**
 *  消息视图
 */
@property (nonatomic, strong) UIView *messageView;

/**
 *  消息按钮视图
 */
@property (nonatomic, strong) UIButton *messageWhiteBg;

/**
 *  消息文字
 */
@property (nonatomic, strong) UILabel *messageLab;

/**
 *  消息未读
 */
@property (nonatomic, strong) UIImageView *noMessageReadImage;

/**
 *  好友视图
 */
@property (nonatomic, strong) UIView *findFriendView;

/**
 *  账号名称
 */
@property (nonatomic, strong) UILabel *accountTitleLabel;

/**
 *  用户的关注,看过,想看,评论视图
 */
//@property (nonatomic, strong) UIView *userDetailView;

/**
 *  存储用户电影数目标签数组(关注,看过,想看,评论)
 */
//@property (nonatomic, strong) NSMutableArray *userCountArrays;

/**
 *  用户ID
 */
@property (nonatomic, assign) unsigned int userId;

/**
 *  是否正在加载网络请求
 */
@property (nonatomic, assign) BOOL isLoading;

/**
 *  用户信息model
 */
@property (nonatomic, strong) User *user;

/**
 *  用户头像
 */
@property (nonatomic, strong) UIImage *userAvatar;

/**
 *  个人中心视图
 */
@property (nonatomic, strong) SingleCenterListView *singleView;

/**
 *  未登陆图片
 */
@property (nonatomic, strong) UIImage *unLoginImg;

@end

@implementation SingleCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //加载顶部视图
    [self loadTopView];

    //加载主页面
    [self loadMainView];

    //加载默认配置列表
    [self loadDefaultList];

    //列表请求
    [self loadListRequest];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (appDelegate.isAuthorized) {
        self.userId = [DataEngine sharedDataEngine].userId.intValue;
        [self refreshUserDetails];
        [self refreshUserMessageCount];
    } else {
        [self changeUserDetail];
    }
    [[UIApplication sharedApplication]
            setStatusBarStyle:UIStatusBarStyleLightContent];
    [KKZAnalytics postActionWithEvent:nil action:AnalyticsActionMy];
}

- (void)loadTopView {

    //加载顶部背景视图
    [self.view addSubview:self.homeBackgroundView];
    self.kkzRightBtn.tag = setButtonTag;
}

- (void)loadMainView {

    //先加载TableView的Header视图
    self.singleView.listTable.tableHeaderView = self.headerTopView;
}

- (void)loadDefaultList {

    //获取数据字典
    NSString *dataPath =
            [[NSBundle mainBundle] pathForResource:@"homepagerMenu"
                                            ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:dataPath];

    NSError *error = nil;
    NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:kNilOptions
                                                              error:&error];
    NSMutableArray *dataArr =
            [MenuConfigViewModel getMenuModelCollectionByDic:dataDic];
    self.singleView.listData = dataArr;
    [self.view addSubview:self.singleView];
}

- (void)loadListRequest {

    AppRequest *request = [[AppRequest alloc] init];
    [request requestMenus:@0
            success:^(NSArray *_Nullable singleCenterModels) {

                [self loadListView:singleCenterModels];

            }
            failure:^(NSError *_Nullable err){
                [self.singleView.listTable setTableViewHeaderState:tableHeaderNormalState];
            }];
}

- (void)loadListView:(NSArray *)listData {

    //更新列表数据
    NSMutableArray<SingleCenterModel *> *list = [[NSMutableArray alloc] initWithArray:[SingleCenterViewModel getMenuModelCollectionByArray:listData]];
    for (int i = 0; i < list.count; i ++) {
        SingleCenterModel *model = list[i];
        if ([model.name isEqualToString:@"我的社区"] ||
            [model.name isEqualToString:@"待评价"] ||
            [model.name isEqualToString:@"购物车"]) {
            [list removeObject:model];
        } else if ([model.name isEqualToString:@"订单管理"]) {
            model.isLast = true;
        }
    }
    self.singleView.listData = list;
    [self.view addSubview:self.singleView];
}

#pragma mark - CinemaTableDelegate

- (void)beginRquestData {

    //如果登陆状态就刷新视图
    if ([appDelegate isAuthorized]) {

        //请求用户详情接口
        [self refreshUserDetails];

        //更新用户未读消息数目
        [self refreshUserMessageCount];

        //加载列表配置项
        [self loadListRequest];
    } else {

        //将下拉刷新的状态置为原始状态
        [self.singleView.listTable setTableViewHeaderState:tableHeaderNormalState];
    }
}

#pragma mark - SingleCenterListViewDelegate
- (void)listTableDidScroll:(UIScrollView *)listScrollView {
    CGRect holderRect = topViewRect;
    if (listScrollView.contentOffset.y < 0) {
        holderRect.size.height =
                homeHeaderViewHeight - listScrollView.contentOffset.y;
        holderRect.size.width = screentWith - listScrollView.contentOffset.y;
        holderRect.origin.x = listScrollView.contentOffset.y / 2.0f;
    }
    self.homeBackgroundView.frame = holderRect;
}

#pragma mark - private Method

- (UIView *)getUserMovieDetailViewAndIsShowSeperator:(BOOL)isshow {

    CGRect attentionRect =
            CGRectMake(20, 0, (kCommonScreenWidth - 20 * 2) * 0.25, 35);
    UIButton *attentionRectView = [UIButton buttonWithType:0];
    attentionRectView.frame = attentionRect;
    [attentionRectView addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    [attentionRectView setBackgroundColor:[UIColor clearColor]];

    //关注数目
    UILabel *attentionLbl = [[UILabel alloc]
            initWithFrame:CGRectMake(0, 0, attentionRect.size.width, 16)];
    [attentionLbl setTextColor:[UIColor whiteColor]];
    attentionLbl.font = [UIFont systemFontOfSize:14];
    attentionLbl.text = @"--";
    attentionLbl.tag = attentionCountTag;
    [attentionLbl setBackgroundColor:[UIColor clearColor]];
    attentionLbl.textAlignment = NSTextAlignmentCenter;
    [attentionRectView addSubview:attentionLbl];

    //关注文字
    UILabel *attentionText = [[UILabel alloc]
            initWithFrame:CGRectMake(0, 16, attentionRect.size.width, 16)];
    attentionText.text = @"关注";
    attentionText.textColor = [UIColor whiteColor];
    attentionText.tag = attentionTextTag;
    attentionText.textAlignment = NSTextAlignmentCenter;
    attentionText.font = [UIFont systemFontOfSize:14];
    attentionText.backgroundColor = [UIColor clearColor];
    [attentionRectView addSubview:attentionText];

    //是否显示分割线
    if (isshow) {
        UIView *v1 = [[UIView alloc]
                initWithFrame:CGRectMake(attentionRect.size.width - 1, 13, 1, 18)];
        v1.backgroundColor = [UIColor whiteColor];
        [attentionRectView addSubview:v1];
    }

    return attentionRectView;
}

- (UIView *)drawLineWithOriginX:(CGFloat)originX withOriginY:(CGFloat)originY {
    UIView *bottomDivider = [[UIView alloc]
            initWithFrame:CGRectMake(originX, originY, screentWith - originX,
                                     kDimensDividerHeight)];
    bottomDivider.backgroundColor = kUIColorDivider;
    return bottomDivider;
}

- (void)refreshUserDetails {

    //如果当前登陆
    if (appDelegate.isAuthorized) {

        //如果用户当前头像是未登录状态
        if (self.avatarImageView.image == self.unLoginImg) {

            //设置默认头像
            self.avatarImageView.image = [UIImage imageNamed:@"avatarRImg"];
        }
    }

    //如果网络没有连接或者是当前正在加载中
    if (![self checkNetConnectState] || self.isLoading) {
        [self.singleView.listTable setTableViewHeaderState:tableHeaderNormalState];
        return;
    }

    self.isLoading = YES;

    //用户详情接口
//    KotaTask *kotaTask = [[KotaTask alloc]
//            initFriendUserDetail:self.userId
//                        finished:^(BOOL succeeded, NSDictionary *userInfo) {
//                            [self userInfoFinished:userInfo status:succeeded];
//                        }];
//    [[TaskQueue sharedTaskQueue] addTaskToQueue:kotaTask];
    UserRequest *request = [[UserRequest alloc] init];
    [request requestUserDetail:^(User * _Nullable user) {
        self.user = user;
        [self updateLayout];
        self.isLoading = NO;
    } failure:^(NSError * _Nullable err) {
        self.isLoading = NO;
    }];
}

/**
 *  当用户未登录状态
 */
- (void)changeUserDetail {
    self.userAvatar = nil;
    self.avatarImageView.image = self.unLoginImg;
//    for (int i = 0; i < self.userCountArrays.count; i++) {
//        UILabel *label = (UILabel *) self.userCountArrays[i];
//        label.text = @"--";
//    }
    self.accountTitleLabel.text = @"";
    self.noMessageReadImage.hidden = YES;

    //将优惠劵和待评价个数清空
    NSArray *dataArray = self.singleView.listData;
    for (int i = 0; i < dataArray.count; i++) {
        SingleCenterModel *model = dataArray[i];
        if ([model.iosUrl
                    isEqualToString:
                            @"ZhangYu://app/page?name=EvaluationViewController"]) {
            model.waitEvalueCount = 0;
        }
        if ([model.iosUrl
                    isEqualToString:@"ZhangYu://app/page?name=ECardViewController"]) {
            model.waitEvalueCount = 0;
        }
    }
    self.singleView.listData = dataArray;
}

//- (void)userInfoFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
//
//    [self.singleView.listTable setTableViewHeaderState:tableHeaderNormalState];
//    self.isLoading = NO;
//
//    if (succeeded) {
//        self.user = userInfo[@"user"];
//        self.userId = self.user.userId;
//        if (self.userId == [DataEngine sharedDataEngine].userId.intValue) {
//            [self updateLayout];
//        }
//    }
//}

- (void)updateLayout {

    //用户头像
    if ([self.user.detail.headImg isEqualToString:@"(null)"]) {
        self.avatarImageView.image = [UIImage imageNamed:@"avatarRImg"];
    } else {
        if ([self.user.detail.headImg length]) {
            if (self.userAvatar) {
                self.avatarImageView.image = self.userAvatar;
            } else {
                [self.avatarImageView loadImageWithURL:self.user.detail.headImg
                                               andSize:ImageSizeMiddle
                                        imgNameDefault:@"avatarRImg"];
            }
        } else {
            self.avatarImageView.image = [UIImage imageNamed:@"avatarRImg"];
        }
    }

    //用户姓名
    self.accountTitleLabel.hidden = NO;
    if ([self.user.nickName isEqualToString:@"(null)"]) {

        self.accountTitleLabel.hidden = YES;
    } else {
        if ([self.user.nickName length]) {
            self.accountTitleLabel.text =
                    [NSString stringWithFormat:@"%@", self.user.nickName];
        } else {
            self.accountTitleLabel.hidden = YES;
        }
    }

    //顶部背景视图
    self.homeBackgroundView.image = [UIImage imageNamed:@"user_bg_header_default.jpg"];
//    if (self.user.homeImagePath && self.user.homeImagePath.length > 0) {
//        [self.homeBackgroundView loadImageWithURL:self.user.homeImagePath
//                                          andSize:ImageSizeMiddle
//                                   imgNameDefault:@"user_bg_header_default.jpg"];
//    }

    //@[@"关注",@"看过",@"想看",@"评论"];
    /*
    NSArray *countArr =
            @[ self.user.favoriteCount, self.user.collectCount, self.user.likeCount ];

    for (int i = 0; i < countArr.count; i++) {
        UILabel *label = (UILabel *) self.userCountArrays[i];
        if ([self isEmptyString:countArr[i]]) {
            label.text = @"0";
        } else {
            label.text = [NSString stringWithFormat:@"%@", countArr[i]];
        }
    }
     */
}

/**
 *  上传用户头像
 */
- (void)avatarDoneWithImage:(UIImage *)image {
    AccountRequest *request = [[AccountRequest alloc] init];
    [request startHeadimg:image
            Sucuess:^() {
                [appDelegate hideIndicator];
            }
            Fail:^(NSError *o) {
                [appDelegate hideIndicator];
                [KKZUtility showAlertTitle:@"提示"
                                    detail:@"头像上传失败"
                                    cancel:@"确定"
                                 clickCall:nil
                                    others:nil];
            }];
}

/**
 *  判断输入的是不是空对象
 *
 *  @param inputNumber
 *
 *  @return TRUE代表是空字符串,FALSE代表不是空字符串
 */
- (BOOL)isEmptyString:(NSNumber *)inputNumber {
    if ([inputNumber isEqual:[NSNull null]] ||
        [[NSString stringWithFormat:@"%@", inputNumber]
                isEqualToString:@"(null)"]) {
        return TRUE;
    }
    return FALSE;
}

/**
 *  更新用户未读消息数目
 */
- (void)refreshUserMessageCount {

    if (![self checkNetConnectState]) {
        return;
    }
    WeakSelf
    UserRequest *request = [UserRequest new];
    [request requestMessageCount:[NSNumber numberWithLong:self.userId] success:^(NSNumber * _Nullable inviteMovieCount, NSNumber * _Nullable availableCouponCount, NSNumber * _Nullable needCommentOrderCount, NSNumber * _Nullable articleCount) {
        //待评价个数
        //优惠劵个数
        
        NSArray *dataArray = self.singleView.listData;
        for (int i = 0; i < dataArray.count; i++) {
            SingleCenterModel *model = dataArray[i];
            if ([model.iosUrl
                 isEqualToString:
                 @"ZhangYu://app/page?name=EvaluationViewController"]) {
                model.waitEvalueCount = needCommentOrderCount.intValue;
            }
            if ([model.iosUrl
                 isEqualToString:@"ZhangYu://app/page?name=ECardViewController"]) {
                model.waitEvalueCount = availableCouponCount.intValue;
            }
        }
        weakSelf.singleView.listData = dataArray;
    } failure:^(NSError * _Nullable err) {
        
    }];
}

#pragma mark - NSNotification

/**
 *  用户昵称修改通知
 *
 *  @param notification
 */
- (void)renewNickName:(NSNotification *)notification {
    NSDictionary *dic = (NSDictionary *) [notification object];
    self.accountTitleLabel.text = dic[@"nicknameY"];
    [NewLoginViewModel updateLoginModelKey:@"nickName"
                                modelValue:dic[@"nicknameY"]];
    [DataEngine sharedDataEngine].userName = self.accountTitleLabel.text;
}

/**
 *   用户头像修改通知
 *
 *  @param notification
 */
- (void)renewChangeAvatar:(NSNotification *)notification {
    NSDictionary *dic = (NSDictionary *) [notification object];
    self.userAvatar = dic[@"avatarPathY"];
    self.avatarImageView.image = self.userAvatar;
}

#pragma mark - getter Method

- (SingleCenterListView *)singleView {

    if (!_singleView) {

        CGRect singleFrame = CGRectMake(
                0, CGRectGetMaxY(self.navBarView.frame), kCommonScreenWidth,
                self.KCommonContentHeight - CGRectGetMaxY(self.navBarView.frame) -
                        kBottomTabbarItemHeight);
        _singleView = [[SingleCenterListView alloc] initWithFrame:singleFrame
                                                    withResponder:self];

        //下拉刷新代理
        _singleView.cinemaDelegate = self;

        //滚动条滚动代理
        _singleView.singleDelegate = self;
    }
    return _singleView;
}

- (UIImageView *)homeBackgroundView {
    if (!_homeBackgroundView) {
        homeHeaderViewHeight = (runningOniOS7 ? 20 : 0) + 287;
        _homeBackgroundView = [[UIImageView alloc]
                initWithFrame:CGRectMake(0, 0, screentWith, homeHeaderViewHeight)];
        _homeBackgroundView.backgroundColor = [UIColor clearColor];
        _homeBackgroundView.contentMode = UIViewContentModeScaleAspectFill;
        _homeBackgroundView.clipsToBounds = YES;
        _homeBackgroundView.image =
                [UIImage imageNamed:@"user_bg_header_default.jpg"];

        //遮罩层
        UIView *coverV = [[UIView alloc]
                initWithFrame:CGRectMake(0, 0, screentWith, homeHeaderViewHeight)];
        coverV.backgroundColor =
                [[UIColor colorWithHex:@"#2d1202"] colorWithAlphaComponent:0.5f];
        coverV.autoresizingMask =
                UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_homeBackgroundView addSubview:coverV];
        topViewRect = _homeBackgroundView.frame;
    }
    return _homeBackgroundView;
}

- (UIView *)headerTopView {
    if (!_headerTopView) {
        _headerTopView = [[UIView alloc]
                initWithFrame:CGRectMake(0, 0, screentWith, kTopHeaderViewHeight)];
        _headerTopView.backgroundColor = [UIColor clearColor];

        //头像
        [_headerTopView addSubview:self.avatarImageView];

        // 我的私信
//        [_headerTopView addSubview:self.messageView];

        //我的好友
//        [_headerTopView addSubview:self.findFriendView];

        //用户名称
        [_headerTopView addSubview:self.accountTitleLabel];

        //用户电影详情
//        [_headerTopView addSubview:self.userDetailView];
    }
    return _headerTopView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc]
                initWithFrame:CGRectMake((screentWith - 65) * 0.5, 16, 65, 65)];
        [_avatarImageView setBackgroundColor:[UIColor whiteColor]];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        _avatarImageView.clipsToBounds = YES;
        _avatarImageView.image = self.unLoginImg;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.layer.cornerRadius = 32.5;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                initWithTarget:self
                        action:@selector(changeUserAvatar)];
        [_avatarImageView addGestureRecognizer:tap];
    }
    return _avatarImageView;
}

- (UIView *)messageView {
    if (!_messageView) {
        _messageView = [[UIView alloc] initWithFrame:CGRectMake(60, 23, 45, 64)];
        _messageView.backgroundColor = [UIColor clearColor];

        //添加背景视图
        [_messageView addSubview:self.messageWhiteBg];

        // 红色未读消息提示
        [_messageView addSubview:self.noMessageReadImage];
    }
    return _messageView;
}

- (UIButton *)messageWhiteBg {

    if (!_messageWhiteBg) {
        _messageWhiteBg = [UIButton buttonWithType:0];
        _messageWhiteBg.frame = CGRectMake(0, 0, 45, 64);
        [_messageWhiteBg setImage:[UIImage imageNamed:@"messageY"]
                         forState:UIControlStateNormal];
        _messageWhiteBg.contentMode = UIViewContentModeScaleAspectFit;
        _messageWhiteBg.tag = messageButtonTag;
        [_messageWhiteBg addTarget:self
                            action:@selector(commonBtnClick:)
                  forControlEvents:UIControlEventTouchUpInside];

        //添加文字
        [_messageWhiteBg addSubview:self.messageLab];
    }
    return _messageWhiteBg;
}

- (UILabel *)messageLab {

    if (!_messageLab) {
        _messageLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 45, 20)];
        [_messageLab setBackgroundColor:[UIColor clearColor]];
        _messageLab.text = @"消息";
        _messageLab.textColor = [UIColor whiteColor];
        _messageLab.font = [UIFont systemFontOfSize:12];
        _messageLab.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLab;
}

- (UIImageView *)noMessageReadImage {

    if (!_noMessageReadImage) {
        _noMessageReadImage =
                [[UIImageView alloc] initWithFrame:CGRectMake(35, 10, 7, 7)];
        [_noMessageReadImage setBackgroundColor:[UIColor redColor]];
        _noMessageReadImage.layer.masksToBounds = YES;
        _noMessageReadImage.layer.cornerRadius = 3.5;
        _noMessageReadImage.hidden = YES;
    }
    return _noMessageReadImage;
}

- (UIView *)findFriendView {
    if (!_findFriendView) {

        //好友视图
        _findFriendView = [[UIView alloc]
                initWithFrame:CGRectMake(screentWith - 105, 23, 45, 64)];
        _findFriendView.backgroundColor = [UIColor clearColor];
        _findFriendView.hidden = NO;

        //好友图标
        UIButton *findFriendBg = [UIButton buttonWithType:0];
        findFriendBg.frame = CGRectMake(0, 0, 45, 64);
        [findFriendBg setImage:[UIImage imageNamed:@"friendY"]
                      forState:UIControlStateNormal];
        findFriendBg.contentMode = UIViewContentModeScaleAspectFit;
        findFriendBg.tag = friendButtonTag;
        [findFriendBg addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
        [_findFriendView addSubview:findFriendBg];

        //好友文字
        UILabel *findFriendLab =
                [[UILabel alloc] initWithFrame:CGRectMake(0, 45, 45, 20)];
        findFriendLab.text = @"好友";
        findFriendLab.textColor = [UIColor whiteColor];
        findFriendLab.font = [UIFont systemFontOfSize:12];
        findFriendLab.textAlignment = NSTextAlignmentCenter;
        [findFriendLab setBackgroundColor:[UIColor clearColor]];
        [findFriendBg addSubview:findFriendLab];
    }
    return _findFriendView;
}

- (UILabel *)accountTitleLabel {

    if (!_accountTitleLabel) {
        _accountTitleLabel = [[UILabel alloc]
                initWithFrame:CGRectMake((screentWith - 190) * 0.5, 100, 190, 30.0)];
        _accountTitleLabel.font = [UIFont boldSystemFontOfSize:19];
        _accountTitleLabel.textColor = [UIColor whiteColor];
        _accountTitleLabel.backgroundColor = [UIColor clearColor];
        _accountTitleLabel.textAlignment = NSTextAlignmentCenter;
        _accountTitleLabel.text = @"----";
    }
    return _accountTitleLabel;
}
/*
- (UIView *)userDetailView {

    if (!_userDetailView) {
        int factor = 20;
        _userDetailView = [[UIView alloc]
                initWithFrame:CGRectMake(0, 119 + factor, kCommonScreenWidth, 35)];
        _userDetailView.backgroundColor = [UIColor clearColor];

        //加载用户详情
        NSArray *titleArr = @[ @"关注", @"看过", @"想看", @"帖子" ];
        for (int i = 0; i < titleArr.count; i++) {
            UIView *view;
            BOOL isShow = TRUE;
            if (i == titleArr.count - 1) {
                isShow = FALSE;
            }
            view = [self getUserMovieDetailViewAndIsShowSeperator:isShow];
            view.tag = attentionButtonTag + i;

            CGRect viewFrame = view.frame;
            viewFrame.origin.x = 20 + i * viewFrame.size.width;
            view.frame = viewFrame;

            //设置文本标题
            UILabel *label = (UILabel *) [view viewWithTag:attentionTextTag];
            label.text = titleArr[i];

            //存储文本数目
            [self.userCountArrays addObject:[view viewWithTag:attentionCountTag]];

            [_userDetailView addSubview:view];
        }
    }
    return _userDetailView;
}
 */
/*
- (NSMutableArray *)userCountArrays {
    if (!_userCountArrays) {
        _userCountArrays = [[NSMutableArray alloc] init];
    }
    return _userCountArrays;
}
*/
- (UIImage *)unLoginImg {

    if (!_unLoginImg) {
        _unLoginImg = [UIImage imageNamed:@"unLoginY"];
    }
    return _unLoginImg;
}

#pragma mark - UIImagePickerControllerDelagate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[@"UIImagePickerControllerEditedImage"];
    self.userAvatar = image;
    [self dismissViewControllerAnimated:NO completion:nil];
    [self avatarDoneWithImage:image];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UITapGesture
- (void)changeUserAvatar {
    if (![[UserManager shareInstance] isUserAuthorizedWithController:self]) {
        return;
    }

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    UIImagePickerController *imageController = [[UIImagePickerController alloc] init];
    imageController.editing = YES;
    imageController.allowsEditing = YES;
    imageController.delegate = self;

    RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
    cancel.action = ^{
        [[UIApplication sharedApplication]
                setStatusBarStyle:UIStatusBarStyleLightContent];
    };
    
    RIButtonItem *camera = [RIButtonItem
            itemWithLabel:@"相册"
                   action:^{
                       
                       if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                           
                               imageController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                               [self presentViewController:imageController
                                                  animated:NO
                                                completion:nil];
                           }
                       }];

    RIButtonItem *album = [RIButtonItem
                itemWithLabel:@"相机"
                       action:^{

                           if ([UIImagePickerController
                                       isSourceTypeAvailable:
                                               UIImagePickerControllerSourceTypeCamera]) {
                               imageController.sourceType =
                                       UIImagePickerControllerSourceTypeCamera;
                               [self presentViewController:imageController
                                                    animated:NO
                                                  completion:nil];
                           }
                       }];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIActionSheet *actionSheet =
                [[UIActionSheet alloc] initWithTitle:@"设置头像?"
                                    cancelButtonItem:cancel
                               destructiveButtonItem:nil
                                    otherButtonItems:camera, album, nil];
        [actionSheet showInView:appDelegate.window];
    } else {
        UIActionSheet *actionSheet =
                [[UIActionSheet alloc] initWithTitle:@"设置头像?"
                                    cancelButtonItem:cancel
                               destructiveButtonItem:nil
                                    otherButtonItems:album, nil];
        [actionSheet showInView:self.view];
    }
}

#pragma mark - View pulic Method

- (void)commonBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case setButtonTag: {
            SettingViewController *set = [[SettingViewController alloc] init];
            [self pushViewController:set animation:CommonSwitchAnimationBounce];
            break;
        }
            
        case messageButtonTag: {
            if (![[UserManager shareInstance] isUserAuthorizedWithController:self]) {
                return;
            }
            break;
        }
            
        case friendButtonTag: {
            if (![[UserManager shareInstance] isUserAuthorizedWithController:self]) {
                return;
            }

            AttentionViewController *ctr = [[AttentionViewController alloc] init];
            ctr.userId = [DataEngine sharedDataEngine].userId;
            [self pushViewController:ctr animation:CommonSwitchAnimationBounce];
            break;
        }
            
        case attentionButtonTag: {
            if (![[UserManager shareInstance] isUserAuthorizedWithController:self]) {
                return;
            }

            AttentionViewController *ctr = [[AttentionViewController alloc] init];
            ctr.userId = [NSString stringWithFormat:@"%d", self.userId];
            [self pushViewController:ctr animation:CommonSwitchAnimationBounce];
            break;
        }
            
        case seeButtonTag: {

            if (![[UserManager shareInstance] isUserAuthorizedWithController:self]) {
                return;
            }

            //看了
            CollectedMovieViewController *ctr = [[CollectedMovieViewController alloc]
                    initWithUser:[NSString stringWithFormat:@"%d", self.userId]];
            ctr.isCollect = YES;
            [self pushViewController:ctr animation:CommonSwitchAnimationBounce];
            break;
        }
            
        case wantSeeButtonTag: {

            if (![[UserManager shareInstance] isUserAuthorizedWithController:self]) {
                return;
            }

            //想看
            CollectedMovieViewController *ctr = [[CollectedMovieViewController alloc]
                    initWithUser:[NSString stringWithFormat:@"%d", self.userId]];
            ctr.isCollect = NO;
            [self pushViewController:ctr animation:CommonSwitchAnimationBounce];
            break;
        }
            
        case commentButtonTag: {

            if (![[UserManager shareInstance] isUserAuthorizedWithController:self]) {
                return;
            }

            //评论
            MyPublishedPostsViewController *ctr =
                    [[MyPublishedPostsViewController alloc] init];
            [self pushViewController:ctr animation:CommonSwitchAnimationBounce];
            break;
        }
        default:
            break;

    }
}

- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return FALSE;
}

- (BOOL)showTitleBar {
    return TRUE;
}

- (BOOL)setRightButton {
    return TRUE;
}

- (BOOL)isNavMainColor {
    return NO;
}

- (NSString *)rightButtonImageName {
    return @"setting";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
