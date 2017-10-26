//
//  首页 - 我的 layout
//
//  Created by 艾广华 on 15/12/3.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AndySwizzleMethod.h"
#import "SingleCenterViewController+layout.h"

@implementation SingleCenterViewController (layout)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod];
    });
}

+ (void)swizzleMethod {
    swizzleMethod([SingleCenterViewController class], @selector(viewDidLoad), @selector(newViewDidLoad));
}

- (void)newViewDidLoad {

    //重新加载
    [self newViewDidLoad];

    //加载导航条
    [self loadNarBar];

    //加载监听者
    [self loadObserver];
}

- (void)loadNarBar {
    [self.view setBackgroundColor:[UIColor r:245
                                           g:245
                                           b:245]];
    self.kkzTitleLabel.text = @"个人中心";
    self.kkzTitleLabel.textColor = [UIColor whiteColor];
    self.navBarView.backgroundColor = [UIColor clearColor];
    [self.view bringSubviewToFront:self.navBarView];
}

- (void)loadObserver {
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(renewUserDetail:)
    //                                                 name:@"RenewUserDetail"
    //                                               object:nil];

    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(refreshKotaNum)
    //                                                 name:@"refreshKotaNum"
    //                                               object:nil];

    //用户在设置页面更改昵称
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(renewNickName:)
                                                 name:@"NickName"
                                               object:nil];
    //用户在设置页面更改用户头像
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(renewChangeAvatar:)
                                                 name:@"ChangeAvatar"
                                               object:nil];
}

@end
