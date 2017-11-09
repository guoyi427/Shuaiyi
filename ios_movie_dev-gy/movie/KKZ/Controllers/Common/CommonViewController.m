//
//  CommonViewController.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/3.
//  Copyright (c) 2015年 kokozu. All rights reserved.
//

#import "CommonViewController.h"
#import "TaskQueue.h"

#define MASMethodNotImplemented()                                                       \
    @throw [NSException                                                                 \
            exceptionWithName:NSInternalInconsistencyException                          \
                       reason:[NSString stringWithFormat:                               \
                                                @"You must override %@ in a subclass.", \
                                                NSStringFromSelector(_cmd)]             \
                     userInfo:nil]

/******************************布局修改*******************************/
#define kkzNavBarBackgroundColor [UIColor whiteColor] // 白色
#define kkzTitleBarHeight 44;
#define kkzTitleBarLabelColor [UIColor whiteColor] // 白色

#define kkzTitleBarDivider            \
    [UIColor colorWithRed:229 / 255.0 \
                    green:229 / 255.0 \
                     blue:229 / 255.0 \
                    alpha:1.0] // 分割线的颜色

const static CGFloat rightButtonRight = 15.0f;

static NSString *oldPushControllerName;

@interface CommonViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:kkzNavBarBackgroundColor];
    [self setStatusBarLightStyle];
    self.contentPositionY = (runningOniOS7 ? 20 : 0);
    self.KCommonContentHeight = kCommonScreenHeight - 20;
    if (runningOniOS7) {
        self.KCommonContentHeight = kCommonScreenHeight;
    }
    if ([self showNavBar]) {
        [self.view addSubview:self.navBarView];
    }

    if ([self isNavMainColor] && [self showNavBar]) {
        //设置导航栏背景色
        self.navBarView.backgroundColor = appDelegate.kkzBlack;//appDelegate.kkzBlue;
        self.statusView.backgroundColor = appDelegate.kkzBlack;//appDelegate.kkzBlue;
    }

    self.firstAppear = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //统计事件：进入页面
    [StatisticsComponent pageViewBeginEvent:NSStringFromClass([self class])];
    NSString *enterEvent = [NSString stringWithFormat:@"enter_%@", [self class]];
    StatisEvent(enterEvent);

    [self setStatusBarLightStyle];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_navBarView) {
        [self.view bringSubviewToFront:_navBarView];
        [self.view bringSubviewToFront:_statusView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    //统计事件：退出页面
    [StatisticsComponent pageViewEndEvent:NSStringFromClass([self class])];
    NSString *enterEvent = [NSString stringWithFormat:@"exit_%@", [self class]];
    StatisEvent(enterEvent);

    [appDelegate hideIndicator];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - UIViewController切换

- (void)pushViewController:(UIViewController *)controller
                 animation:(CommonSwitchAnimation)animation {

    //存储动画的类型
    controller.switchAnimation = animation;

    // NSString *className = NSStringFromClass([controller class]);
    //切换动画基类状态
    [[NSNotificationCenter defaultCenter]
            postNotificationName:@"changeSwitchAnimation"
                          object:@(animation)];

    // PUSH进入页面
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)popViewControllerAnimated:(BOOL)animated {

    //切换动画
    [[NSNotificationCenter defaultCenter]
            postNotificationName:@"changeSwitchAnimation"
                          object:@(self.switchAnimation)];

    //返回上一个页面
    [self.navigationController popViewControllerAnimated:animated];
}

- (void)popToViewControllerAnimated:(BOOL)animated {

    //返回到根视图
    [self.navigationController popToRootViewControllerAnimated:animated];
}

#pragma mark - getter Method
- (UIView *)changeStatusView {

    if (!_changeStatusView) {
        _changeStatusView =
                [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth,
                                                         44 + self.contentPositionY)];
        [self.view addSubview:_changeStatusView];

        //导航条标题
        if ([self changeNavBarTitle]) {
            self.changeTitleLabel.text = [self changeNavBarTitle];
            [_changeStatusView addSubview:self.changeTitleLabel];
        }

        //返回按钮
        [_changeStatusView addSubview:self.kkzBackBtn];
        CGRect backFrame = self.kkzBackBtn.frame;
        backFrame.origin.y = self.contentPositionY + backFrame.origin.y;
        self.kkzBackBtn.frame = backFrame;

        //右边按钮
        if ([self changeRightButtonImage]) {
            [_changeStatusView addSubview:self.changeRightBtn];
            UIImage *rightImg = [UIImage imageNamed:[self changeRightButtonImage]];
            self.changeRightBtn.frame = CGRectMake(
                    screentWith - rightImg.size.width - rightButtonRight * 2,
                    0 + self.contentPositionY, rightImg.size.width + rightButtonRight * 2,
                    rightImg.size.height + 18);
        }

        //分割线
        UIView *titleBarDivider = [[UIView alloc]
                initWithFrame:CGRectMake(0, CGRectGetMaxY(_changeStatusView.frame) - 1,
                                         screentWith, 1)];
        titleBarDivider.backgroundColor = kkzTitleBarDivider;
        [_changeStatusView addSubview:titleBarDivider];
    }
    return _changeStatusView;
}

- (UIImageView *)navBarView {
    if (!_navBarView) {

        //导航条背景
        _navBarView = [[UIImageView alloc]
                initWithFrame:CGRectMake(0, 20, kCommonScreenWidth, 44)];
        _navBarView.backgroundColor = kkzNavBarBackgroundColor;

        //分割线
        if ([self showNavBarLine]) {
            UIView *titleBarDivider = [[UIView alloc]
                    initWithFrame:CGRectMake(0, CGRectGetHeight(_navBarView.frame) - 1,
                                             kCommonScreenWidth, 1)];
            titleBarDivider.backgroundColor = kkzTitleBarDivider;
            [_navBarView addSubview:titleBarDivider];
        }

        //如果是大于iOS7系统的加上导航栏
        if (runningOniOS7) {
            _statusView = [[UIView alloc]
                    initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 20)];
            _statusView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:_statusView];
        }

        //导航条标题
        if (self.showTitleBar) {
            [_navBarView addSubview:self.kkzTitleLabel];
        }

        //导航条返回按钮
        if (self.showBackButton) {
            [_navBarView addSubview:self.kkzBackBtn];
        }

        //导航条右边按钮
        if ([self setRightButton] && [self rightButtonImageName]) {
            [_navBarView addSubview:self.kkzRightBtn];
        }
    }
    return _navBarView;
}

- (UILabel *)kkzTitleLabel {
    if (!_kkzTitleLabel) {
        CGFloat height = kkzTitleBarHeight;
        _kkzTitleLabel = [[UILabel alloc]
                initWithFrame:CGRectMake(60, 0.0, screentWith - 60 - 60, height)];
        _kkzTitleLabel.font = [UIFont boldSystemFontOfSize:16];
        _kkzTitleLabel.backgroundColor = [UIColor clearColor];
        _kkzTitleLabel.textAlignment = NSTextAlignmentCenter;
        _kkzTitleLabel.textColor = kkzTitleBarLabelColor;
    }
    return _kkzTitleLabel;
}

- (UIButton *)kkzBackBtn {
    if (!_kkzBackBtn) {
        _kkzBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _kkzBackBtn.frame = CGRectMake(0, 3, 60, 38);
        [_kkzBackBtn setImage:[UIImage imageNamed:@"white_back"]
                     forState:UIControlStateNormal];
        [_kkzBackBtn setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9, 29)];
        _kkzBackBtn.backgroundColor = [UIColor clearColor];
        [_kkzBackBtn addTarget:self
                          action:@selector(cancelViewController)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _kkzBackBtn;
}

- (UIButton *)kkzRightBtn {
    if (!_kkzRightBtn) {
        CGFloat height = kkzTitleBarHeight;
        _kkzRightBtn = [UIButton buttonWithType:0];
        UIImage *rightImg = [UIImage imageNamed:[self rightButtonImageName]];
        CGFloat topEdge = (height - rightImg.size.height) / 2.0f;
        CGFloat leftEdge = 17.0f;
        _kkzRightBtn.frame =
                CGRectMake(screentWith - rightImg.size.width - leftEdge * 2, 0,
                           rightImg.size.width + leftEdge * 2, height);

        [_kkzRightBtn setImage:rightImg forState:UIControlStateNormal];
        [_kkzRightBtn setImageEdgeInsets:UIEdgeInsetsMake(topEdge, leftEdge,
                                                          topEdge, leftEdge)];
        _kkzRightBtn.tag = rightButtonTag;
        _kkzRightBtn.backgroundColor = [UIColor clearColor];
        [_kkzRightBtn addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _kkzRightBtn;
}

- (UIButton *)changeRightBtn {
    if (!_changeRightBtn) {
        _changeRightBtn = [UIButton buttonWithType:0];
        UIImage *rightImg = [UIImage imageNamed:[self changeRightButtonImage]];
        CGFloat buttonWidth = 2 * rightButtonRight + rightImg.size.width;
        _changeRightBtn.frame =
                CGRectMake(screentWith - rightImg.size.width - rightButtonRight * 2, 0,
                           buttonWidth, 44.0f);
        [_changeRightBtn setImage:rightImg forState:UIControlStateNormal];
        _changeRightBtn.tag = rightButtonTag;
        [_changeRightBtn addTarget:self
                            action:@selector(commonBtnClick:)
                  forControlEvents:UIControlEventTouchUpInside];
        _changeRightBtn.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _changeRightBtn;
}

- (UILabel *)changeTitleLabel {
    if (!_changeTitleLabel) {
        CGFloat height = kkzTitleBarHeight;
        _changeTitleLabel = [[UILabel alloc]
                initWithFrame:CGRectMake(60, 0.0 + self.contentPositionY,
                                         screentWith - 60 - 60, height)];
        _changeTitleLabel.font = [UIFont boldSystemFontOfSize:16];
        _changeTitleLabel.backgroundColor = [UIColor clearColor];
        _changeTitleLabel.textAlignment = NSTextAlignmentCenter;
        _changeTitleLabel.textColor = [UIColor whiteColor];
    }
    return _changeTitleLabel;
}

- (void)callApiDidSucceed:(id)responseData {
}

- (void)callApiDidFailed:(id)responseData {
}

#pragma mark - View pulic Method
- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return TRUE;
}

- (BOOL)showTitleBar {
    return TRUE;
}

- (BOOL)setRightButton {
    return FALSE;
}

- (BOOL)showNavBarLine {
    return FALSE;
}

- (BOOL)enableScrollToBack {
    return NO;
}

- (BOOL)isNavMainColor {
    return YES;
}

- (NSString *)rightButtonImageName {
    MASMethodNotImplemented();
    return nil;
}

- (NSString *)changeRightButtonImage {
    MASMethodNotImplemented();
    return nil;
}

- (NSString *)changeNavBarTitle {
    MASMethodNotImplemented();
    return nil;
}

- (void)cancelViewController {
    [self popViewControllerAnimated:YES];
}

- (void)commonBtnClick:(UIButton *)sender {
    MASMethodNotImplemented();
}

- (void)commonBtnDownClick:(UIButton *)sender {
    MASMethodNotImplemented();
}

- (void)commonBtnCancelClick:(UIButton *)sender {
    MASMethodNotImplemented();
}

- (BOOL)checkNetConnectState {
    if (![[NetworkUtil me] reachable]) {
        return FALSE;
    }
    return TRUE;
}

- (CGSize)customTextSize:(UIFont *)font
                    text:(NSString *)inputString
                    size:(CGSize)inputSize {

    NSDictionary *dic = [NSDictionary
            dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    CGRect rect1 =
            [inputString boundingRectWithSize:inputSize
                                      options:NSStringDrawingUsesLineFragmentOrigin |
                                              NSStringDrawingUsesFontLeading
                                   attributes:dic
                                      context:nil];
    CGSize result = rect1.size;
    return result;
}

- (void)setColorfulStatusBar:(UIColor *)changeColor {
    self.changeStatusView.hidden = NO;
    self.navBarView.hidden = YES;
    self.changeStatusView.backgroundColor = changeColor;
    [self setStatusBarLightStyle];
}

- (void)setNormalStatusBar:(UIColor *)normalColor {
    self.changeStatusView.hidden = YES;
    self.navBarView.hidden = NO;
    self.navBarView.backgroundColor = normalColor;
    [self setStatusBarLightStyle];
}

/**
 *  设置状态的样式
 */
- (void)setStatusBarLightStyle {
    if (runningOniOS7) {
        [[UIApplication sharedApplication]
                setStatusBarStyle:UIStatusBarStyleLightContent
                         animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    //[[TaskQueue sharedTaskQueue] cancelAllTasks];
}

@end
