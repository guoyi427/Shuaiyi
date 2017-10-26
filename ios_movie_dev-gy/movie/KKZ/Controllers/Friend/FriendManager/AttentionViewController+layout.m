//
//  好友管理页面 layout
//
//  Created by 艾广华 on 15/12/4.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AndySwizzleMethod.h"
#import "AttentionViewController+layout.h"

@implementation AttentionViewController (layout)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod];
    });
}

+ (void)swizzleMethod {
    swizzleMethod([AttentionViewController class], @selector(viewDidLoad), @selector(newViewDidLoad));
}

- (void)newViewDidLoad {

    //重新加载
    [self newViewDidLoad];

    //加载导航条
    [self loadNarBar];
}

- (void)loadNarBar {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.kkzTitleLabel.text = @"好友管理";
    self.kkzTitleLabel.textColor = [UIColor whiteColor];
    [self.view bringSubviewToFront:self.navBarView];
}

@end
