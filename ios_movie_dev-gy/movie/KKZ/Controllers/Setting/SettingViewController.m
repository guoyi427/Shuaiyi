//
//  SettingViewController.m
//  KoMovie
//
//  Created by 艾广华 on 16/1/25.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "BDMultiDownloader.h"
#import "CacheEngine.h"
#import "CommonWebViewController.h"
#import "EditProfileViewController.h"
#import "FeedBackViewController.h"
#import "HobbyAddressViewController.h"
#import "ImageEngine.h"
#import "ImageEngineNew.h"
#import "KKZUtility.h"
#import "NotificationName.h"
#import "SettingViewController.h"
#import "SingleCenterControllerModel.h"
#import "SocialAuthViewController.h"
#import "UIConstants.h"
#import <GoogleMobileAds/GADBannerView.h>
#import "UserManager.h"

typedef enum : NSUInteger {
    editSingleInfoTag = 1000,
//    deliveryAddressTag,
    authorizationTag,
    clearCacheTag,
    feedBackTag,
    evalueTag,
    phoneServiceTag,
    kkzBackButtonTag,
    logoutButtonTag,
} allButtonTag;

#define kAcountTextColor [UIColor r:181 g:181 b:181]
#define kAcountTextFont 14

/*****************Cell上的布局*******************/
static const CGFloat settingCellHeight = 54.0f;
static const CGFloat settingSectionHeight = 54.0f;

/*****************广告视图的布局*******************/
static const CGFloat settingBannerHeight = 50.0f;

@interface SettingViewController () <LoginViewControllerDelegate> {
    //广告视图
    GADBannerView *bannerView;
}

/**
 *  当前视图的纵坐标
 */
@property (nonatomic, assign) CGFloat position;

/**
 *  登录按钮
 */
@property (nonatomic, strong) UIButton *loginBtn;

/**
 *  缓存大小标签
 */
@property (nonatomic, strong) UILabel *cacheSizeView;


@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //加载导航条
    [self loadNavBar];

    //加载主页面
    [self loadMainView];

    //初始化事件
    [self loadEvent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //修改缓存数据的大小
    long cacheSizeMB = [[CacheEngine sharedCacheEngine] diskCacheSizeMB];
    if (cacheSizeMB == 0) {
        self.cacheSizeView.text = @"0M";
    } else {
        self.cacheSizeView.text = [NSString stringWithFormat:@"%.2fM", (CGFloat) cacheSizeMB];
    }

    //用户授权情况
    if (appDelegate.isAuthorized) {
        [_loginBtn setTitle:@"退出登录"
                   forState:UIControlStateNormal];
    } else { // 未登录
        BOOKING_PHONE_WRITE(nil);
        BINDING_PHONE_WRITE(nil);
        [_loginBtn setTitle:@"登录"
                   forState:UIControlStateNormal];
    }
}

- (void)loadEvent {
    //接收页面返回事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(popToCurrentViewController)
                                                 name:changePasswordSuccessNotification
                                               object:nil];
}

- (void)loadNavBar {
    self.view.backgroundColor = [UIColor whiteColor];
    self.kkzTitleLabel.text = @"设置";
    self.kkzBackBtn.tag = kkzBackButtonTag;
    [self.kkzBackBtn addTarget:self
                        action:@selector(commonBtnClick:)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)loadMainView {

    //初始化滚动条
    CGRect holderFrame = CGRectMake(0, CGRectGetMaxY(self.navBarView.frame), kCommonScreenWidth, kCommonScreenHeight - CGRectGetMaxY(self.navBarView.frame));
    UIScrollView *holder = [[UIScrollView alloc] initWithFrame:holderFrame];
    holder.backgroundColor = kUIColorGrayBackground;
    [self.view addSubview:holder];

    //添加设置视图到页面
    NSArray *titleArr = [SingleCenterControllerModel getSettingCellTitleString];
    NSArray *isShowDetail = [SingleCenterControllerModel getSettingCellDetailShowOrHiden];
    NSArray *isShowArrow = [SingleCenterControllerModel getSettingCellArrowShowOrHiden];
    NSArray *showBtmSection = [SingleCenterControllerModel getSettingCellSectionShowOrHiden];
    NSArray *showSectionTitle = [SingleCenterControllerModel getSettingCellSectionTitleString];
    NSArray *showRight = [SingleCenterControllerModel getSettingCellRightTitleShowOrHiden];
    NSArray *showLine = [SingleCenterControllerModel getSettingCellSeprateLineShowOrHiden];
    self.position = 0.0f;
    for (int i = 0; i < titleArr.count; i++) {
        CGRect cellFrame = CGRectMake(0, self.position, kCommonScreenWidth, settingCellHeight);
        UIButton *btn = [self getSingleCellViewWithFrame:cellFrame
                                               withTitle:titleArr[i]
                                          withShowDetail:[isShowDetail[i] boolValue]
                                           withShowArrow:[isShowArrow[i] intValue]
                                          withRightTitle:[showRight[i] boolValue]
                                              isShowLine:[showLine[i] boolValue]];
        btn.tag = editSingleInfoTag + i;
        [holder addSubview:btn];
        self.position += settingCellHeight;

        //添加视图的标题
        if ([showBtmSection[i] boolValue]) {
            CGRect sectionFrame = CGRectMake(15, self.position, 120, settingSectionHeight);
            [holder addSubview:[self getSectionViewWithFrame:sectionFrame
                                                     withTitle:showSectionTitle[i]]];
            self.position += settingSectionHeight;
        }
    }

    //广告视图
    if (appDelegate.idfaUrl.length) {

        // 在屏幕底部创建标准尺寸的视图。
        CGRect bannerFrame = CGRectMake(0.0, kCommonScreenHeight - settingBannerHeight,
                                        kCommonScreenWidth, settingBannerHeight);
        bannerView = [[GADBannerView alloc] initWithFrame:bannerFrame];
        [bannerView setBackgroundColor:[UIColor clearColor]];

        // 指定广告的“单元标识符”，也就是您的 AdMob 发布商 ID。
        bannerView.adUnitID = @"ca-app-pub-3735471458330180/9382695352";

        // 告知运行时文件，在将用户转至广告的展示位置之后恢复哪个 UIViewController
        // 并将其添加至视图层级结构。
        bannerView.rootViewController = self;
        [self.view addSubview:bannerView];

        // 启动一般性请求并在其中加载广告。
        [bannerView loadRequest:[GADRequest request]];
    }

    //修改视图的起始坐标
    self.position += 30;

    //注销账号按钮
    [holder addSubview:self.loginBtn];

    //修改视图的起始坐标
    self.position += 42 + 15;

    //设置感谢的背景视图
    [holder addSubview:[self getBottomViewWithOrigin:self.position]];

    //修改UIScrollView的内容尺寸
    self.position += 120;
    holder.contentSize = CGSizeMake(kCommonScreenWidth, self.position);
}

- (void)popToCurrentViewController {
    [self.navigationController popToViewController:self
                                          animated:YES];
}

#pragma mark - public Method

- (void)commonBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case editSingleInfoTag: { //修改个人资料
            if ([[UserManager shareInstance] isUserAuthorizedWithController:self]) {
                EditProfileViewController *ctr = [[EditProfileViewController alloc] init];
                [self pushViewController:ctr
                               animation:CommonSwitchAnimationBounce];
            }
            break;
        }
//        case deliveryAddressTag: { //收货地址
//            if ([[UserManager shareInstance] isUserAuthorizedWithController:self]) {
//                HobbyAddressViewController *ctr = [[HobbyAddressViewController alloc] init];
//                [self pushViewController:ctr
//                               animation:CommonSwitchAnimationBounce];
//            }
//            break;
//        }
        case authorizationTag: { //第三方授权管理
            SocialAuthViewController *ctr = [[SocialAuthViewController alloc] init];
            [self pushViewController:ctr
                           animation:CommonSwitchAnimationBounce];
            break;
        }
        case clearCacheTag: { //清除缓存

            [UIAlertView showAlertView:@"清除掉图片缓存下次将会重新从网络下载图片，确定要清空吗？"
                            cancelText:@"取消"
                          cancelTapped:nil
                                okText:@"确定"
                              okTapped:^() {
                              
                                  [[CacheEngine sharedCacheEngine] resetCache];
                                  [[ImageEngine sharedImageEngine] resetCache];
                                  [[ImageEngineNew sharedImageEngineNew] resetCache];
                                  [[BDMultiDownloader shared] clearDiskCache];
                                  
                                  self.cacheSizeView.text = @"0M";
                                  
                                  [self showHint:@"已清除缓存"];
                              }];
            break;
        }
        case feedBackTag: { //意见反馈
            FeedBackViewController *feedController = [[FeedBackViewController alloc] init];
            [self pushViewController:feedController
                           animation:CommonSwitchAnimationBounce];
            break;
        }
        case evalueTag: { //评价
            NSURL *appUrl = [NSURL URLWithString:kAppUrl];
            [[UIApplication sharedApplication] openURL:appUrl];
            break;
        }
        case phoneServiceTag: {
            
            [UIAlertView showAlertView:@"拨打免费客服热线吗？"
                            cancelText:@"取消"
                          cancelTapped:nil
                                okText:@"确定"
                              okTapped:^{
                                  
                                  [appDelegate makePhoneCallWithTel:kHotLine];
                              }];
            break;
        }
            
        case kkzBackButtonTag: {
            [self popViewControllerAnimated:YES];
            break;
        }
            
        case logoutButtonTag: {
            if (appDelegate.isAuthorized) {
                [UIAlertView showAlertView:@"确定要注销账号吗？"
                                cancelText:@"取消"
                              cancelTapped:nil
                                    okText:@"确定"
                                  okTapped:^{
                                      
                                      [self logout];
                                  }];
            }
            else {
                [[UserManager shareInstance] gotoLoginControllerFrom:self];
            }
            break;
        }
        default:
            break;
    }
}

- (void)logout {
    //统计事件：退出登录
    StatisEvent(EVENT_USER_LOGOUT);
    
    [appDelegate signout];
    
    [[UserManager shareInstance] logout:nil failure:nil];
    
    [self popViewControllerAnimated:YES];
}

- (void)authSwitchChangeHandler:(UISwitch *)sender {
    NSInteger index = sender.tag;
    if (index == 101) {
        if (sender.on) {
            USER_KOTA_TICKET_WRITE(YES);
        } else {
            USER_KOTA_TICKET_WRITE(NO);
        }
    }
}

#pragma mark - View private Method

- (UIView *)getBottomViewWithOrigin:(CGFloat)position {

    //底部的感谢视图
    UIView *thankImgV = [[UIView alloc] initWithFrame:CGRectMake(0, position, kCommonScreenWidth, 80)];
    [thankImgV setBackgroundColor:[UIColor clearColor]];

    //添加标签
    UILabel *thankTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 15)];
    [thankTitle setBackgroundColor:[UIColor clearColor]];
    thankTitle.text = @"感谢使用抠电影";
    thankTitle.textColor = [UIColor lightGrayColor];
    thankTitle.textAlignment = NSTextAlignmentCenter;
    thankTitle.font = [UIFont systemFontOfSize:12];
    [thankImgV addSubview:thankTitle];

    //添加版本信息标签
    UILabel *versionTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kCommonScreenWidth, 15)];
    [versionTitle setBackgroundColor:[UIColor clearColor]];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleVersion"];
    versionTitle.text = [NSString stringWithFormat:@"V%@", version];
    versionTitle.textColor = thankTitle.textColor;
    versionTitle.textAlignment = thankTitle.textAlignment;
    versionTitle.font = thankTitle.font;
    [thankImgV addSubview:versionTitle];

    return thankImgV;
}

- (UIButton *)getSingleCellViewWithFrame:(CGRect)viewFrame
                               withTitle:(NSString *)title
                          withShowDetail:(BOOL)isShowDetail
                           withShowArrow:(BOOL)isShowArrow
                          withRightTitle:(BOOL)isRight
                              isShowLine:(BOOL)isLine {

    //初始化cell点击视图
    UIButton *editAccount = [[UIButton alloc] initWithFrame:viewFrame];
    editAccount.backgroundColor = [UIColor whiteColor];
    [editAccount addTarget:self
                      action:@selector(commonBtnClick:)
            forControlEvents:UIControlEventTouchUpInside];

    //分割线
    if (isLine) {
        UIView *divider = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetHeight(viewFrame) - kDimensDividerHeight, CGRectGetWidth(viewFrame), kDimensDividerHeight)];
        divider.backgroundColor = kUIColorDivider;
        [editAccount addSubview:divider];
    }

    //初始化cell的标题视图
    if (isShowDetail) {
    } else {

        //只有一个主标题
        UILabel *editAccountLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(viewFrame) - 120, CGRectGetHeight(viewFrame))];
        editAccountLabel.text = title;
        editAccountLabel.backgroundColor = [UIColor clearColor];
        editAccountLabel.textAlignment = NSTextAlignmentLeft;
        editAccountLabel.textColor = appDelegate.kkzTextColor;
        editAccountLabel.font = [UIFont systemFontOfSize:kAcountTextFont];
        [editAccount addSubview:editAccountLabel];

        //箭头
        if (isShowArrow) {
            UIImageView *arrowImgAccount = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(viewFrame) - 23, editAccountLabel.frame.size.height / 2 - 8, 8, 14)];
            arrowImgAccount.image = [UIImage imageNamed:@"arrowRightGray"];
            [editAccount addSubview:arrowImgAccount];
        }

        //是否显示右边的详细标题
        if (isRight) {
            self.cacheSizeView.frame = CGRectMake(CGRectGetWidth(viewFrame) - 15 - 100, CGRectGetHeight(viewFrame) / 2 - 8, 100, 15);
            [editAccount addSubview:self.cacheSizeView];
        }
    }

    return editAccount;
}

- (UIView *)getSectionViewWithFrame:(CGRect)viewFrame
                          withTitle:(NSString *)title {

    UILabel *otherEdit = [[UILabel alloc] initWithFrame:viewFrame];
    otherEdit.text = title;
    otherEdit.backgroundColor = [UIColor clearColor];
    otherEdit.textAlignment = NSTextAlignmentLeft;
    otherEdit.textColor = kAcountTextColor;
    otherEdit.font = [UIFont systemFontOfSize:14];
    return otherEdit;
}

- (UIButton *)loginBtn {

    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.frame = CGRectMake(0, self.position, kCommonScreenWidth, 42);
        _loginBtn.backgroundColor = [UIColor r:251 g:61 b:47];
        _loginBtn.tag = logoutButtonTag;
        [_loginBtn setTintColor:[UIColor whiteColor]];
        [_loginBtn addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UILabel *)cacheSizeView {

    if (!_cacheSizeView) {
        _cacheSizeView = [[UILabel alloc] init];
        _cacheSizeView.backgroundColor = [UIColor clearColor];
        _cacheSizeView.textAlignment = NSTextAlignmentRight;
        _cacheSizeView.textColor = appDelegate.kkzGray;
        _cacheSizeView.text = @"0M";
        _cacheSizeView.font = [UIFont systemFontOfSize:kAcountTextFont];
    }
    return _cacheSizeView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
