//
//  修改昵称页面
//
//  Created by 艾广华 on 16/2/24.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "KKZTextField.h"
#import "KKZUtility.h"
#import "NickNameViewController.h"
#import "RoundCornersButton.h"
#import "UIConstants.h"
#import "AccountRequest.h"

/****************昵称的背景视图*************/
static const CGFloat nickNameViewHeight = 45.0f;
static const CGFloat nickNameViewTop = 15.0f;

/****************昵称输入框*************/
static const CGFloat nickNameFieldLeft = 15.0f;

static const CGFloat roundCornersButtonTop = 25.0f;

static const NSInteger kNickNameMaxLength = 20;
static const NSInteger kSignatureMaxLength = 140;

@interface NickNameViewController () <UITextFieldDelegate>

/**
 *  标题数组
 */
@property (nonatomic, strong) NSMutableArray *titleArray;

/**
 *  滚动条
 */
@property (nonatomic, strong) UIScrollView *holder;

/**
 *  昵称的背景视图
 */
@property (nonatomic, strong) UIView *nickNameView;

/**
 *  上分割线
 */
@property (nonatomic, strong) UIView *topDivider;

/**
 *  下分割线
 */
@property (nonatomic, strong) UIView *bottomDivider;

/**
 *  文本输入框
 */
@property (nonatomic, strong) KKZTextField *textField;

/**
 *  圆角按钮
 */
@property (nonatomic, strong) RoundCornersButton *roundCornersButton;

@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //导航条
    [self loadNavBar];

    //添加滚动条
    [self.view addSubview:self.holder];

    //添加昵称背景
    [self.holder addSubview:self.nickNameView];

    //添加上分割线
    [self.nickNameView addSubview:self.topDivider];

    //添加下分割线
    [self.nickNameView addSubview:self.bottomDivider];

    //添加输入框
    [self.nickNameView addSubview:self.textField];
    self.textField.delegate = self;

    //添加确认提交按钮
    [self.holder addSubview:self.roundCornersButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField becomeFirstResponder];
    self.kkzTitleLabel.text = self.titleArray[_viewType];
}

- (void)loadNavBar {

    //导航条
    self.statusView.backgroundColor = self.navBarView.backgroundColor;
}

- (UIScrollView *)holder {

    if (!_holder) {
        _holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navBarView.frame), kCommonScreenWidth, kCommonScreenHeight - CGRectGetMaxY(self.navBarView.frame))];
        [_holder setBackgroundColor:kUIColorGrayBackground];
        _holder.alwaysBounceVertical = YES;
    }
    return _holder;
}

- (UIView *)nickNameView {
    if (!_nickNameView) {
        _nickNameView = [[UIView alloc] initWithFrame:CGRectMake(0, nickNameViewTop, kCommonScreenWidth, nickNameViewHeight)];
        _nickNameView.backgroundColor = [UIColor whiteColor];
        _nickNameView.userInteractionEnabled = YES;
    }
    return _nickNameView;
}

- (UIView *)topDivider {
    if (!_topDivider) {
        _topDivider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kDimensDividerHeight)];
        _topDivider.backgroundColor = kUIColorDivider;
    }
    return _topDivider;
}

- (UIView *)bottomDivider {
    if (!_bottomDivider) {
        _bottomDivider = [[UIView alloc] initWithFrame:CGRectMake(0, nickNameViewHeight - kDimensDividerHeight, kCommonScreenWidth, kDimensDividerHeight)];
        _bottomDivider.backgroundColor = kUIColorDivider;
    }
    return _bottomDivider;
}

- (KKZTextField *)textField {
    if (!_textField) {
        CGRect frame = CGRectMake(nickNameFieldLeft, kDimensDividerHeight, kCommonScreenWidth - nickNameFieldLeft * 2, nickNameViewHeight - kDimensDividerHeight * 2);

        _textField = [[KKZTextField alloc] initWithFrame:frame andFieldType:KKZTextFieldWithClear];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.secureTextEntry = NO;
        _textField.textColor = [UIColor blackColor];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.returnKeyType = UIReturnKeySend;
    }
    return _textField;
}

- (RoundCornersButton *)roundCornersButton {
    if (!_roundCornersButton) {
        _roundCornersButton = [[RoundCornersButton alloc] init];
        _roundCornersButton.frame = CGRectMake(0, CGRectGetMaxY(self.nickNameView.frame) + roundCornersButtonTop, kCommonScreenWidth, kDimensButtonHeightLarge);
        _roundCornersButton.cornerNum = 0;
        _roundCornersButton.titleName = @"确定修改";
        _roundCornersButton.titleFont = [UIFont systemFontOfSize:kTextSizeButtonLarge];
        _roundCornersButton.titleColor = [UIColor whiteColor];
        _roundCornersButton.backgroundColor = appDelegate.kkzBlue;
        [_roundCornersButton addTarget:self
                                action:@selector(commonBtnClick:)
                      forControlEvents:UIControlEventTouchUpInside];
    }
    return _roundCornersButton;
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] initWithObjects:@"修改昵称", @"修改常去影院", @"修改签名", nil];
    }
    return _titleArray;
}

- (void)setUserName:(NSString *)userName {
    _userName = userName;
    self.textField.text = userName;
}

- (void)setViewType:(ViewType)viewType {
    _viewType = viewType;
    if (_viewType == NickNameViewType) {
        self.textField.placeholder = @"请输入您的昵称";
        self.textField.maxWordCount = kNickNameMaxLength;
    } else if (_viewType == TheaterViewType) {
        self.textField.placeholder = @"请输入常去的影院名称";
    } else if (_viewType == SignatureViewType) {
        self.textField.placeholder = @"请输入签名";
        self.textField.maxWordCount = kSignatureMaxLength;
    }
}

- (void)commonBtnClick:(UIButton *)sender {

    //取消键盘
    [self.textField resignFirstResponder];

    NSString *inputText = self.textField.text;
    if ([inputText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        [UIAlertView showAlertView:@"请输入内容" buttonText:@"确定" buttonTapped:nil];
        return;
    }

    if ([inputText isEqualToString:self.userName]) { // 未修改
        [self cancelViewController];
        return;
    }

    //加载框
    [KKZUtility showIndicatorWithTitle:@"正在提交,请稍候"
                                atView:self.view];

    //网络请求
    AccountRequest *request = [[AccountRequest alloc] init];
    if (self.viewType == SignatureViewType) {
        [request startPostSigature:self.textField.text
                Sucuess:^() {
                    [self requestSuccess];
                }
                Fail:^(NSError *o) {
                    [self requestFail:o];
                }];
    } else if (self.viewType == TheaterViewType) {
        [request startPostOftenCinema:self.textField.text
                Sucuess:^() {
                    [self requestSuccess];
                }
                Fail:^(NSError *o) {
                    [self requestFail:o];
                }];
    } else if (self.viewType == NickNameViewType) {
        [request startNickName:self.textField.text
                Sucuess:^() {
                    [self requestSuccess];
                }
                Fail:^(NSError *o) {
                    [self requestFail:o];
                }];
    }
}

- (void)requestFail:(NSError *)err {
    NSString *msg = err.userInfo[KKZRequestErrorMessageKey];
    if (err.code == KKZ_REQUEST_STATUS_NETWORK_ERROR) {
        msg = KNET_FAULT_MSG;
    }
    [KKZUtility hidenIndicator];
    [UIAlertView showAlertView:msg buttonText:@"确定" buttonTapped:nil];
}

- (void)requestSuccess {
    [KKZUtility hidenIndicator];
    if (self.changeFinished) {
        self.changeFinished(self.textField.text);
    }
    if (self.viewType == NickNameViewType) {
        NSString *inputText = self.textField.text;
        NSDictionary *dic = [NSDictionary dictionaryWithObject:inputText
                                                        forKey:@"nicknameY"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NickName"
                                                            object:dic];
    }
    [self popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *tmpStr = textField.text;
    tmpStr = [tmpStr stringByReplacingCharactersInRange:range
                                             withString:string];
    if (range.length > 0) {
        return YES;
    }
    if (tmpStr.length > 20) {
        return NO;
    }
    return YES;
}

- (void)showMaxInputWordAlertView {
    [self resignFirstResponder];
    NSString *detailMessage = [NSString stringWithFormat:@"最多输入%d个字符", 20];
    [UIAlertView showAlertView:detailMessage buttonText:@"确定" buttonTapped:nil];
}

@end
