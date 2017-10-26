//
//  UnbindViewController.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/23.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "UnbindViewController.h"

#import "AccountBindHeader.h"
#import "AccountBindLoadingView.h"
#import "KKZTextField.h"
#import "KKZUtility.h"
#import "TaskQueue.h"
#import "UIColor+Hex.h"
#import "UIConstants.h"
#import "UserRequest.h"
#import "UIViewController+HideKeyboard.h"

/*******************cell视图*************************/
static const CGFloat kListCellTop = 15.0f;
static const CGFloat kListCellHeight = 50.0f;

/*******************cell图标*************************/
static const CGFloat kIconOriginX = 15.0f;

/*******************cell标签*************************/
static const CGFloat kLabelLeft = 18.0f;
static const CGFloat kDetailLabelLeft = 15.0f;
static const CGFloat kDetailLabelRight = 15.0f;

/*******************解除绑定按钮***********************/
static const CGFloat kBindButtonHeight = 44.0f;
static const CGFloat kBindButtonOriginX = 15.0f;
static const CGFloat kBindButtonTop = 50.0f;

typedef enum : NSUInteger {
    UnbindButtonTag = 1000,
} allViewTag;

@interface UnbindViewController () {

    //公共工具
    KKZUtility *kkzUtility;

    //密码输入框
    UITextField *detailField;
}
/**
 *  子标题标签
 */
@property (nonatomic, strong) UILabel *detailLabel;

/**
 *  绑定按钮
 */
@property (nonatomic, strong) UIButton *bindButton;

/**
 *  成功弹框
 */
@property (nonatomic, strong) AccountBindLoadingView *successLoading;

/**
 *  内容滚动条
 */
@property (nonatomic, strong) UIScrollView *contentScroll;

@end

@implementation UnbindViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //初始化工具
    [self initWithTools];

    //加载导航条
    [self loadNavBar];

    //加载主页面
    [self loadMainView];

    [self setupHideKeyboardForTapAnywhere];
}

- (void)initWithTools {
    kkzUtility = [[KKZUtility alloc] init];
}

- (void)loadNavBar {
    self.view.backgroundColor = [UIColor colorWithHex:@"#f5f5f5"];
    self.kkzTitleLabel.text = [NSString stringWithFormat:@"绑定%@", [BindPhoneViewModel getTypeNameByUnbindType:self.unbindType]];
    self.statusView.backgroundColor = self.navBarView.backgroundColor;
}

- (void)loadMainView {

    //添加滚动条
    [self.view addSubview:self.contentScroll];

    //手机账号背景视图
    UIView *settingLayout = [[UIButton alloc] initWithFrame:CGRectMake(0, kListCellTop, kCommonScreenWidth, kListCellHeight)];
    settingLayout.backgroundColor = [UIColor whiteColor];
    [self.contentScroll addSubview:settingLayout];

    //icon图标
    CGFloat maxHeight = CGRectGetHeight(settingLayout.frame);
    UIImage *icon = [UIImage imageNamed:[BindPhoneViewModel getTypeImageByUnbindType:self.unbindType]];
    CGSize iconSize = icon.size;
    CGRect iconFrame = CGRectMake(kIconOriginX, (maxHeight - iconSize.height) / 2.0f, iconSize.width, iconSize.height);
    UIImageView *ivIcon = [[UIImageView alloc] initWithFrame:iconFrame];
    ivIcon.image = icon;
    [settingLayout addSubview:ivIcon];

    //Cell标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelLeft + CGRectGetMaxX(iconFrame), 0, 60, maxHeight)];
    titleLabel.text = [BindPhoneViewModel getTypeNameByUnbindType:self.unbindType];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textColor = [UIColor colorWithHex:@"#666666"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [settingLayout addSubview:titleLabel];

    //Cell子标题
    CGFloat detailOriginX = CGRectGetMaxX(titleLabel.frame) + kDetailLabelLeft;
    CGFloat detailWidth = CGRectGetWidth(settingLayout.frame) - detailOriginX - kDetailLabelRight;
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(detailOriginX, 0, detailWidth, maxHeight)];
    _detailLabel.textColor = [UIColor colorWithHex:@"#333333"];
    _detailLabel.font = [UIFont systemFontOfSize:13.0f];
    _detailLabel.text = self.accountName;
    [_detailLabel setTextAlignment:NSTextAlignmentRight];
    [settingLayout addSubview:_detailLabel];

    //cell的最大y坐标
    CGFloat cellOriginY = CGRectGetMaxY(settingLayout.frame);

    //手机密码视图
    if (self.unbindType == UnbindTypePhone) {

        //密码背景视图
        UIView *passwordLayout = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(settingLayout.frame), kCommonScreenWidth, kListCellHeight)];
        passwordLayout.backgroundColor = [UIColor whiteColor];
        [self.contentScroll addSubview:passwordLayout];

        //分割线
        UIView *passwordDivider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(passwordLayout.frame), kDimensDividerHeight)];
        passwordDivider.backgroundColor = kUIColorDivider;
        [passwordLayout addSubview:passwordDivider];

        //图标
        CGFloat passMaxHeight = CGRectGetHeight(passwordLayout.frame);
        UIImage *passIcon = [UIImage imageNamed:[BindPhoneViewModel getTypeImageByUnbindType:self.unbindType]];
        CGSize passIconSize = passIcon.size;
        CGRect passIconFrame = CGRectMake(kIconOriginX, (passMaxHeight - passIconSize.height) / 2.0f, passIconSize.width, passIconSize.height);
        UIImageView *passIvIcon = [[UIImageView alloc] initWithFrame:passIconFrame];
        passIvIcon.image = passIcon;
        [passwordLayout addSubview:passIvIcon];

        //子标题输入框
        CGFloat detailOriginX = kLabelLeft + CGRectGetMaxX(passIconFrame);
        CGFloat detailWidth = CGRectGetWidth(passwordLayout.frame) - detailOriginX - kLabelLeft;

        detailField = [[KKZTextField alloc] initWithFrame:CGRectMake(detailOriginX, 0, detailWidth, CGRectGetHeight(passwordLayout.frame))];
        detailField.font = [UIFont systemFontOfSize:13.0f];
        detailField.textColor = [UIColor colorWithHex:@"#333333"];
        detailField.placeholder = @"请输入密码";
        detailField.secureTextEntry = TRUE;
        detailField.textAlignment = NSTextAlignmentLeft;
        detailField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        detailField.keyboardType = UIKeyboardTypeDefault;
        detailField.backgroundColor = [UIColor clearColor];
        [passwordLayout addSubview:detailField];

        //cell的最大距离
        cellOriginY = CGRectGetMaxY(passwordLayout.frame);
    }

    //绑定按钮
    _bindButton = [UIButton buttonWithType:0];
    _bindButton.backgroundColor = [UIColor colorWithHex:@"#00a0e9"];
    _bindButton.frame = CGRectMake(kBindButtonOriginX, kBindButtonTop + cellOriginY, CGRectGetWidth(self.view.frame) - 2 * kBindButtonOriginX, kBindButtonHeight);
    [_bindButton setTitle:@"解除绑定"
                 forState:UIControlStateNormal];
    _bindButton.tag = UnbindButtonTag;
    _bindButton.layer.cornerRadius = 5.0f;
    _bindButton.layer.masksToBounds = YES;
    [_bindButton addTarget:self
                      action:@selector(commonBtnClick:)
            forControlEvents:UIControlEventTouchUpInside];
    [_bindButton setTitleColor:[UIColor whiteColor]
                      forState:UIControlStateNormal];
    [self.contentScroll addSubview:_bindButton];

    //设置滚动条滚动区域
    [self.contentScroll setContentSize:CGSizeMake(kCommonScreenWidth, CGRectGetMaxY(self.bindButton.frame) + 10)];
}

#pragma mark - getter Method

- (AccountBindLoadingView *)successLoading {

    if (!_successLoading) {
        _successLoading = [[AccountBindLoadingView alloc] initWithSucessFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _successLoading.backgroundColor = [UIColor clearColor];
    }
    return _successLoading;
}

- (UIScrollView *)contentScroll {

    if (!_contentScroll) {
        _contentScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navBarView.frame), kCommonScreenWidth, self.KCommonContentHeight - CGRectGetMaxY(self.navBarView.frame))];
        _contentScroll.showsHorizontalScrollIndicator = FALSE;
        _contentScroll.showsVerticalScrollIndicator = FALSE;
        _contentScroll.alwaysBounceVertical = TRUE;
    }
    return _contentScroll;
}

#pragma mark - private Method

- (void)dismissKeyBoard {
    if (detailField) {
        [detailField resignFirstResponder];
    }
}

- (void)showSuccessLoading {

    //显示成功的加载框
    [self.view addSubview:self.successLoading];

    __weak UnbindViewController *weak_self = self;

    //显示成功计时
    [self.successLoading beginShowSuccessView:^{

        //关闭页面
        [weak_self cancelViewController];

        //开始刷新数据
        [[NSNotificationCenter defaultCenter] postNotificationName:ReciveUnbindNotification
                                                            object:nil];
    }];
}

- (void)beginUnbindRequest {

    //显示加载框
    [KKZUtility showIndicatorWithTitle:nil];

    //移除键盘
    [self dismissKeyBoard];

    //解除绑定的请求
    if (self.unbindType == UnbindTypePhone) {

        //手机号绑定请求
        
        UserRequest *request = [UserRequest new];
        [request unbindAccount:SiteTypeKKZ password:detailField.text success:^{
            //去除加载框
            [KKZUtility hidenIndicator];
            //在主线程执行
            [self performSelectorOnMainThread:@selector(unbindAccountRequestFinished)
                                   withObject:nil
                                waitUntilDone:NO];
            
        } failure:^(NSError * _Nullable err) {
            //去除加载框
            [KKZUtility hidenIndicator];
            //在主线程执行
            [self performSelectorOnMainThread:@selector(unbindAccountRequestFail:)
                                   withObject:err.userInfo[KKZRequestErrorMessageKey]
                                waitUntilDone:NO];
        }];


    } else {

        //移除第三方类型
        SiteType type;
        if (self.unbindType == UnbindTypeQQ) {
            type = SiteTypeQQ;
        } else if (self.unbindType == UnbindTypeWeibo) {
            type = SiteTypeSina;
        } else {
            type = SiteTypeWX;
        }
        
        UserRequest *request = [UserRequest new];
        
        [request unbindAccount:type password:nil success:^{
            //去除加载框
            [KKZUtility hidenIndicator];
            //在主线程执行
            [self performSelectorOnMainThread:@selector(unbindAccountRequestFinished)
                                   withObject:nil
                                waitUntilDone:NO];
            
        } failure:^(NSError * _Nullable err) {
            //去除加载框
            [KKZUtility hidenIndicator];
            //在主线程执行
            [self performSelectorOnMainThread:@selector(unbindAccountRequestFail:)
                                   withObject:err.userInfo[KKZRequestErrorMessageKey]
                                waitUntilDone:NO];
        }];

    }
}

- (void)unbindAccountRequestFinished {

    //移除键盘
    [self dismissKeyBoard];

    //显示操作成功页面
    [self showSuccessLoading];

    if (self.unbindType == UnbindTypePhone) {
        BINDING_PHONE_WRITE(nil);
    }
}

- (void)unbindAccountRequestFail:(NSString *)title {

    //显示失败的加载框
    [KKZUtility showAlert:title];
}

#pragma mark - public Method

- (void)commonBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case UnbindButtonTag: {

            //如果是手机解绑
            if (self.unbindType == UnbindTypePhone) {
                if (detailField.text.length == 0) {
                    [KKZUtility showAlert:@"密码不能为空"];
                    return;
                }
            }

            //提示框
            __weak UnbindViewController *weak_self = self;
            [kkzUtility showAlertTitle:@"确定要解除绑定吗 ?"
                                detail:@"解除后将不能使用该方式登录账号"
                                other1:@"确定"
                                other2:@"放弃"
                             clickCall:^(NSString *title) {
                                 if ([title intValue] == 0) {
                                     [weak_self beginUnbindRequest];
                                 }
                             }];
            break;
        }
        default:
            break;
    }
}

@end
