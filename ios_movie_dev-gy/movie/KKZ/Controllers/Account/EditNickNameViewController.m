//
//  EditNickNameViewController.m
//  KoMovie
//
//  Created by kokozu on 30/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "EditNickNameViewController.h"

#import "AccountRequest.h"
#import "KKZUtility.h"
#import "UserRequest.h"

@interface EditNickNameViewController ()
{
    UITextField *_nickNameTextField;
}
@end

@implementation EditNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.kkzTitleLabel.text = @"修改昵称";
    
    self.view.backgroundColor = appDelegate.kkzLine;
    
    _nickNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 64 + 20, kAppScreenWidth - 30, 44)];
    _nickNameTextField.backgroundColor = [UIColor whiteColor];
    _nickNameTextField.textColor = [UIColor blackColor];
    _nickNameTextField.placeholder = @"请输入昵称";
    _nickNameTextField.text = [DataEngine sharedDataEngine].userName;
    _nickNameTextField.font = [UIFont systemFontOfSize:14];
//    _nickNameTextField.layer.cornerRadius = CGRectGetHeight(_nickNameTextField.frame)/2.0;
//    _nickNameTextField.layer.masksToBounds = true;
    [self.view addSubview:_nickNameTextField];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(kAppScreenWidth - 44, 0, 44, 44);
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    commitButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.navBarView addSubview:commitButton];
}


- (BOOL)showNavBar {
    return true;
}

- (BOOL)showTitleBar {
    return true;
}

- (BOOL)showBackButton {
    return true;
}

#pragma mark - UIButton - Action

- (void)commitButtonAction {
    
    //取消键盘
    [_nickNameTextField resignFirstResponder];
    
    NSString *inputText = _nickNameTextField.text;
    if ([inputText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        [UIAlertView showAlertView:@"请输入内容" buttonText:@"确定" buttonTapped:nil];
        return;
    }
    
    if ([inputText isEqualToString:[DataEngine sharedDataEngine].userName]) { // 未修改
        [self cancelViewController];
        return;
    }
    
    //加载框
    [KKZUtility showIndicatorWithTitle:@"正在提交,请稍候"
                                atView:self.view];
    __weak typeof(self) weakSelf = self;
    //网络请求
    UserRequest *request = [[UserRequest alloc] init];
    [request editNickname:inputText success:^{
        [KKZUtility hidenIndicator];
        [DataEngine sharedDataEngine].userName = inputText;
        [weakSelf.navigationController popViewControllerAnimated:true];
    } failure:^(NSError * _Nullable err) {
        [KKZUtility hidenIndicator];
    }];
}

@end
