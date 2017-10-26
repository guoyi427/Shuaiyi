//
//  输入验证码的页面
//
//  Created by KKZ on 15/11/5.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"

@interface VerificationCodeController : CommonViewController <UIGestureRecognizerDelegate> {

    UIButton *backBtn;
    UITextField *pinField;
    UIImageView *pinImgV;
    UIButton *getPinImgBtn;
}

@property (nonatomic, copy) NSString *codeKey;
@property (nonatomic, copy) NSString *codeUrl;
@property (nonatomic, copy) NSString *actionName;

@end
