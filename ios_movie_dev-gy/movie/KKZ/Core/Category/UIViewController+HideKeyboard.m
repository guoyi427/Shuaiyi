//
//  扩展UIWebController添加点击页面关闭键盘的功能
//
//  Created by wuzhen on 16/8/18.
//  Copyright (c) 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "UIViewController+HideKeyboard.h"

@implementation UIViewController (HideKeyboard)

- (void)setupHideKeyboardForTapAnywhere {
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];

    __weak UIViewController *weakSelf = self;

    NSOperationQueue *mainQuene = [NSOperationQueue mainQueue];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note) {
                    
                    [weakSelf.view addGestureRecognizer:tapRecognizer];
                }];
    
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note) {
                    
                    [weakSelf.view removeGestureRecognizer:tapRecognizer];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    // 将 self.view 里所有子控件的 first responder 都 resign 掉
    [self.view endEditing:YES];
}

@end
