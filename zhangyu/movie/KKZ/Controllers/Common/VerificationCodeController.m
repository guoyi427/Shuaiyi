//
//  输入验证码的页面
//
//  Created by KKZ on 15/11/5.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "VerificationCodeController.h"

#import "KKZKeyboardTopView.h"
#import "RIButtonItem.h"
#import "RoundCornersButton.h"
#import "TaskQueue.h"
#import "UIAlertView+Blocks.h"
#import "VerificationCodeTask.h"

@implementation VerificationCodeController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.kkzTitleLabel.text = @"验证码"; // 标题

    self.kkzBackBtn.frame = CGRectMake(screentWith - 50, 3, 60, 38);
    [self.kkzBackBtn setImage:[UIImage imageNamed:@"closeBtnWhite"]
                     forState:UIControlStateNormal];

    UIView *holder = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentHeight - 44 - self.contentPositionY)];
    [self.view addSubview:holder];

    holder.backgroundColor = [UIColor r:245 g:245 b:245];

    CGFloat top = 35;

    UIView *pinFieldBgV = [[UIView alloc] initWithFrame:CGRectMake(15, top, screentWith - 50 - 100 - 50, 45)];
    [pinFieldBgV setBackgroundColor:[UIColor whiteColor]];
    [holder addSubview:pinFieldBgV];

    pinField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, screentWith - 50 - 100 - 50 - 10, 45)];
    [pinField setBackgroundColor:[UIColor whiteColor]];
    pinField.placeholder = @"请输入验证码";
    pinField.textColor = [UIColor lightGrayColor];
    pinField.font = [UIFont systemFontOfSize:14];
    pinField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [pinFieldBgV addSubview:pinField];

    KKZKeyboardTopView *topView = [[KKZKeyboardTopView alloc] initWithFrame:CGRectMake(0, 0, pinField.frame.size.width, 38)];
    [pinField setInputAccessoryView:topView];

    pinImgV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pinFieldBgV.frame) + 10, top, 100, 45)];
    [holder addSubview:pinImgV];
    [pinImgV loadImageWithURL:@"" andSize:ImageSizeSmall];
    [pinImgV loadImageWithURL:self.codeUrl andSize:ImageSizeSmall];
    pinImgV.clipsToBounds = YES;
    pinImgV.layer.cornerRadius = 3;

    getPinImgBtn = [[UIButton alloc] initWithFrame:CGRectMake(screentWith - 15 - 50, top, 50, 45)];
    [holder addSubview:getPinImgBtn];
    [getPinImgBtn addTarget:self action:@selector(doValidateReset) forControlEvents:UIControlEventTouchUpInside];

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [getPinImgBtn addSubview:lab];
    lab.textColor = appDelegate.kkzBlue;
    [lab setBackgroundColor:[UIColor clearColor]];
    lab.text = @"看不清";
    lab.font = [UIFont systemFontOfSize:14];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 15, 43, 1)];
    [line setBackgroundColor:appDelegate.kkzBlue];
    [getPinImgBtn addSubview:line];

    top += 20 + 45;

    // 确定提交
    RoundCornersButton *validateBtn = [[RoundCornersButton alloc] initWithFrame:CGRectMake(15, top, screentWith - 15 * 2, 45)];
    validateBtn.backgroundColor = appDelegate.kkzBlue;
    validateBtn.cornerNum = 3;
    validateBtn.titleName = @"验证";
    validateBtn.titleColor = [UIColor whiteColor];
    validateBtn.titleFont = [UIFont systemFontOfSize:15];
    [validateBtn addTarget:self action:@selector(doValidate) forControlEvents:UIControlEventTouchUpInside];
    [holder addSubview:validateBtn];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;

    [getPinImgBtn addGestureRecognizer:tap];
}

- (void)doValidate {
    [pinField resignFirstResponder];

    NSString *codeText = @"";

    if ([pinField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        [UIAlertView showAlertView:@"请输入验证码" buttonText:@"确定" buttonTapped:nil];

        //        [appDelegate showAlertViewForTitle:@"提示" message:@"请填写验证码" cancelButton:@"重新填写"];
        return;
    } else {
        codeText = [pinField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }

    VerificationCodeTask *task = [[VerificationCodeTask alloc] initVerificationCodeWithCodeKey:self.codeKey
                                                                                   andCodeText:codeText
                                                                                 andActionName:self.actionName
                                                                                      finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                                                          if (succeeded) {

                                                                                              [UIAlertView showAlertView:@"验证成功"
                                                                                                              buttonText:@"确定"
                                                                                                            buttonTapped:^{

                                                                                                                [self cancelViewController];
                                                                                                            }];

                                                                                              //            RIButtonItem *done = [RIButtonItem itemWithLabel:@"好的"];
                                                                                              //            done.action = ^{
                                                                                              //                [self popViewControllerAnimated:NO];
                                                                                              //            };
                                                                                              //
                                                                                              //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                                              //                                                            message:@"验证成功"
                                                                                              //                                                   cancelButtonItem:done
                                                                                              //                                                   otherButtonItems:nil];
                                                                                              //            [alert show];

                                                                                          } else {
                                                                                              [self doValidateReset];

                                                                                              [UIAlertView showAlertView:@"验证码错误，请您重新输入" buttonText:@"确定" buttonTapped:nil];

                                                                                              //            [appDelegate showAlertViewForTitle:@"" message:@"验证码错误" cancelButton:@"好的"];
                                                                                          }
                                                                                      }];

    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

//重新获取验证码
- (void)doValidateReset {
    [pinField resignFirstResponder];

    VerificationCodeTask *task = [[VerificationCodeTask alloc] initResetVerificationCodeFinished:^(BOOL succeeded, NSDictionary *userInfo) {
        if (succeeded) {
            self.codeKey = userInfo[@"codeKeyCurrent"];
            self.codeUrl = userInfo[@"codeUrl"];
            [pinImgV loadImageWithURL:self.codeUrl andSize:ImageSizeSmall];
        } else {
            [UIAlertView showAlertView:@"验证码获取失败，请您重新获取～" buttonText:@"确定" buttonTapped:nil];

            //            [appDelegate showAlertViewForTitle:@"" message:@"验证码获取失败" cancelButton:@"好的"];
        }
    }];

    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

- (void)singleTap:(UITapGestureRecognizer *)gesture {

    CGPoint point = [gesture locationInView:getPinImgBtn];
    if (CGRectContainsPoint(getPinImgBtn.frame, point)) {
        DLog(@"重新请求新的图片");
    }
}

- (void)dismissKeyBoard {
    [pinField resignFirstResponder];
}

@end
