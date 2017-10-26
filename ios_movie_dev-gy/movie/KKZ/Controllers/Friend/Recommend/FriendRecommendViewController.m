//
//  新的好友页面
//
//  Created by 艾广华 on 15/12/7.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "DataEngine.h"
#import "FriendRecommendViewController+layout.h"
#import "FriendRecommendViewController.h"
#import "KKZUserTask.h"
#import "TaskQueue.h"
#import "UIColor+Hex.h"

/**************顶部选择****************/
static const CGFloat chooseWidth = 80.0f;
static const CGFloat chooseHeight = 40.0f;

@interface FriendRecommendViewController () <RecommendCellDelegate, MFMessageComposeViewControllerDelegate> {
    //table的顶部视图
    UIView *sectionHeader;

    //顶部背景视图
    CGFloat topViewHeight;

    //邀请用户
    NSString *invitedUser;

    //消息发送者
    MFMessageComposeViewController *picker;
}

/**
 *  当前选择器索引值
 */
@property (nonatomic, strong) UIButton *currentSelectButton;

/**
 *  活跃用户
 */
@property (nonatomic, strong) ActivityUserViewController *acitivityController;

/**
 *  手机好友
 */
@property (nonatomic, strong) PhoneUserViewController *phoneUserController;

/**
 *  附近的人
 */
@property (nonatomic, strong) NearByViewController *nearByUserController;

/**
 *  选择的视图
 */
@property (nonatomic, strong) UIView *selectView;

/**
 *  已经选择过的按钮
 */
@property (nonatomic, strong) UIButton *oldChooseBtn;

/**
 *   当前邀请的是第几个cell的索引
 */
@property (nonatomic, assign) NSInteger currentInventIndex;

/**
 *   当前关注的是第几个cell的索引
 */
@property (nonatomic, assign) NSInteger currentAttentIndex;

/**
 *  取消按钮点击block
 */
@property (nonatomic, strong) ClickCancel cancelBlock;

@end

@implementation FriendRecommendViewController

- (id)initWithClickCancel:(ClickCancel)block {

    self = [super init];
    if (self) {
        self.cancelBlock = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化通知
    [self loadObserver];

    //加载背景视图
    [self loadBackView];

    //加载顶部视图
    [self loadTopView];
}

- (void)loadObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getInvitedFriend:)
                                             taskType:TaskTypeInvitedFriend];
}

- (void)loadBackView {

    //背景图片
    UIImage *bgImg = [UIImage imageNamed:@"newFriend_bg.jpg"];
    UIImageView *bgImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight)];
    bgImgV.image = bgImg;
    [self.view addSubview:bgImgV];
}

- (void)loadTopView {

    UIImage *topImg = [UIImage imageNamed:@"newFriend_bg_Top"];
    topViewHeight = topImg.size.height;
    UIImageView *topImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, topViewHeight)];
    topImgV.image = topImg;
    topImgV.userInteractionEnabled = YES;
    [self.view addSubview:topImgV];

    //初始化选择视图
    NSArray *titleArr = @[ @"好友推荐", @"活跃用户", @"附近的人" ];
    NSInteger count = titleArr.count;
    CGFloat chooseMargin = (kCommonScreenWidth - count * chooseWidth) / (count + 1);
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *chooseBtn = [UIButton buttonWithType:0];
        chooseBtn.frame = CGRectMake(chooseMargin * (i + 1) + chooseWidth * i, topImgV.frame.size.height - chooseHeight, chooseWidth, chooseHeight);
        [chooseBtn setTitleColor:[UIColor colorWithHex:@"#788970"]
                        forState:UIControlStateNormal];
        [chooseBtn setTitleColor:[UIColor colorWithHex:@"#ff6900"]
                        forState:UIControlStateSelected];
        [chooseBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        chooseBtn.tag = chooseFriendButtonTag + i;
        chooseBtn.backgroundColor = [UIColor clearColor];
        [chooseBtn setTitle:titleArr[i]
                   forState:UIControlStateNormal];
        [chooseBtn addTarget:self
                          action:@selector(commonBtnClick:)
                forControlEvents:UIControlEventTouchUpInside];
        [topImgV addSubview:chooseBtn];

        //默认选择视图
        if (i == 0) {
            self.oldChooseBtn = chooseBtn;
            self.currentSelectButton = chooseBtn;
        }
    }
}

#pragma mark - handle notifications

- (void)getInvitedFriend:(NSNotification *)notification {

    NSDictionary *userInfo = [notification userInfo];

    if ([notification succeeded]) {

        if (self.currentSelectButton.tag == chooseFriendButtonTag) {

            //开始刷新联系人列表里已邀请字段
            [self.phoneUserController updateInventedStatusWithIndex:self.currentInventIndex];
        }
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

- (void)addFriendFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {

    //隐藏加载框
    [appDelegate hideIndicator];

    //如果请求成功
    if (succeeded) {

        if (self.currentSelectButton.tag == chooseFriendButtonTag) {

            //开始请求联系人列表
            [self.phoneUserController updateAttentionStatusWithIndex:self.currentAttentIndex];

        } else if (self.currentSelectButton.tag == chooseActivityButtonTag) {

            //开始请求活跃用户列表
            [self.acitivityController updateAttentionStatusWithIndex:self.currentAttentIndex];

        } else if (self.currentSelectButton.tag == chooseNearByButtonTag) {

            //开始请求活跃用户列表
            [self.nearByUserController updateAttentionStatusWithIndex:self.currentAttentIndex];
        }

        [appDelegate showAlertViewForTitle:@""
                                   message:@"已关注该用户"
                              cancelButton:@"确定"];
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

#pragma mark - RecommendDelegate

- (void)clickAttentionButton:(id)inventObject {

    if ([inventObject isKindOfClass:[NSDictionary class]]) {

        //关注用户信息
        NSDictionary *dic = (NSDictionary *) inventObject;

        //用户ID
        NSString *kId = dic[cellUidKey];
        //        NSLog(@"kId===%@",[DataEngine sharedDataEngine].userId); //83419

        //用户cell索引
        self.currentAttentIndex = [dic[cellIndexKey] integerValue];

        if ([kId isEqualToString:[DataEngine sharedDataEngine].userId]) {
            [appDelegate showAlertViewForTitle:@"" message:@"自己不能关注自己" cancelButton:@"确定"];
            return;
        }

        //添加关注的请求
        KKZUserTask *task = [[KKZUserTask alloc] initAddFriend:kId.intValue
                                                      finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                          [self addFriendFinished:userInfo status:succeeded];
                                                      }];
        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
            [appDelegate showIndicatorWithTitle:@"正在添加..."
                                       animated:YES
                                     fullScreen:NO
                                   overKeyboard:YES
                                    andAutoHide:NO];
        }
    }
}

- (void)clickInventButton:(id)inventObject {

    if ([inventObject isKindOfClass:[NSDictionary class]]) {

        //邀请用户信息
        NSDictionary *dic = (NSDictionary *) inventObject;
        invitedUser = dic[cellPhoneNumKey];
        self.currentInventIndex = [dic[cellIndexKey] integerValue];

        //调取手机短信
        [self showMessageView:[NSArray arrayWithObjects:invitedUser, nil]
                          title:nil
                           body:[NSString stringWithFormat:@"全国在线选座,约会购影票,尽在抠电影~下载地址：%@", kAppHTML5Url]];
    }
}

#pragma mark - getter Method

- (ActivityUserViewController *)acitivityController {

    if (!_acitivityController) {
        CGRect viewFrame = CGRectMake(0, topViewHeight, kCommonScreenWidth, self.KCommonContentHeight - topViewHeight);
        _acitivityController = [[ActivityUserViewController alloc] initWithViewFrame:viewFrame];
        _acitivityController.recommendView.cellDelegate = self;
        _acitivityController.view.frame = viewFrame;

        [self addChildViewController:_acitivityController];
        [self.view addSubview:_acitivityController.view];
    }
    return _acitivityController;
}

- (PhoneUserViewController *)phoneUserController {

    if (!_phoneUserController) {
        CGRect viewFrame = CGRectMake(0, topViewHeight, kCommonScreenWidth, self.KCommonContentHeight - topViewHeight);
        _phoneUserController = [[PhoneUserViewController alloc] initWithViewFrame:viewFrame];
        _phoneUserController.recommendView.cellDelegate = self;
        _phoneUserController.view.frame = viewFrame;
        _phoneUserController.view.backgroundColor = [UIColor clearColor];

        [self addChildViewController:_phoneUserController];
        [self.view addSubview:_phoneUserController.view];
    }
    return _phoneUserController;
}

- (NearByViewController *)nearByUserController {

    if (!_nearByUserController) {
        CGRect viewFrame = CGRectMake(0, topViewHeight, kCommonScreenWidth, self.KCommonContentHeight - topViewHeight);
        _nearByUserController = [[NearByViewController alloc] initWithViewFrame:viewFrame];
        _nearByUserController.recommendView.cellDelegate = self;
        _nearByUserController.view.frame = viewFrame;
        _nearByUserController.view.backgroundColor = [UIColor clearColor];

        [self addChildViewController:_nearByUserController];
        [self.view addSubview:_nearByUserController.view];
    }
    return _nearByUserController;
}

- (UIView *)selectView {

    if (!_selectView) {
        _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, chooseHeight - 2, chooseWidth, 2)];
        _selectView.backgroundColor = [UIColor colorWithHex:@"#ff6900"];
    }
    return _selectView;
}

#pragma mark - setter Method

- (void)setCurrentSelectButton:(UIButton *)currentSelectButton {

    //修改按钮的状态
    _currentSelectButton = currentSelectButton;
    _oldChooseBtn.selected = NO;
    _currentSelectButton.selected = YES;
    [_currentSelectButton addSubview:self.selectView];
    _oldChooseBtn = _currentSelectButton;

    //视图切换
    if (currentSelectButton.tag == chooseFriendButtonTag) {

        //好友推荐
        self.phoneUserController.view.hidden = NO;

        //活跃用户
        if (_acitivityController) {
            _acitivityController.view.hidden = YES;
        }

        //附近的人
        if (_nearByUserController) {
            _nearByUserController.view.hidden = YES;
        }

    } else if (currentSelectButton.tag == chooseActivityButtonTag) {

        //好友推荐
        if (_phoneUserController) {
            _phoneUserController.view.hidden = YES;
        }

        //活跃用户
        self.acitivityController.view.hidden = NO;

        //附近的人
        if (_nearByUserController) {
            _nearByUserController.view.hidden = YES;
        }

    } else if (currentSelectButton.tag == chooseNearByButtonTag) {

        //好友推荐
        if (_phoneUserController) {
            _phoneUserController.view.hidden = YES;
        }

        //活跃用户
        if (_acitivityController) {
            _acitivityController.view.hidden = YES;
        }

        //附近的人
        self.nearByUserController.view.hidden = NO;
    }
}

#pragma mark - public Method

- (void)commonBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case rightButtonTag: {
            [self popViewControllerAnimated:NO];
            if (self.cancelBlock) {
                self.cancelBlock();
            }
            break;
        }
        case chooseFriendButtonTag:
        case chooseActivityButtonTag:
        case chooseNearByButtonTag: {
            self.currentSelectButton = sender;
            break;
        }
        default:
            break;
    }
}

#pragma mark msg delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {

    //页面下降
    [self dismissViewControllerAnimated:YES completion:nil];

    switch (result) {

        case MessageComposeResultCancelled: {
            //点击取消按钮
            [appDelegate showAlertViewForTitle:@"" message:@"短信发送已取消" cancelButton:@"确定"];

            break;
        }

        case MessageComposeResultFailed: // send failed
        {
            [appDelegate showAlertViewForTitle:@"" message:@"短信发送失败" cancelButton:@"确定"];

            break;
        }
        case MessageComposeResultSent: {

            if (invitedUser.length != 0) {
                KKZUserTask *task = [[KKZUserTask alloc] initGetInvitedFriend:[DataEngine sharedDataEngine].sessionId
                                                                     username:invitedUser];
                [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
            }

            break;
        }

        default:
            break;
    }

    //    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title]; //修改短信界面标题
    } else {
        [appDelegate showAlertViewForTitle:@""
                                   message:@"这台设备不支持信息功能"
                              cancelButton:@"好的"];
    }
}

- (BOOL)setRightButton {
    return TRUE;
}

- (NSString *)rightButtonImageName {
    return @"loginCloseButton";
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                taskType:TaskTypeInvitedFriend];
}

- (BOOL)showBackButton {
    return FALSE;
}

- (BOOL)isNavMainColor {
    return NO;
}

@end
