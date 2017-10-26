//
//  新的好友页面 layout
//
//  Created by 艾广华 on 15/12/7.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "AndySwizzleMethod.h"
#import "FriendRecommendViewController+layout.h"

@implementation FriendRecommendViewController (layout)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod];
    });
}

+ (void)swizzleMethod {
    swizzleMethod([FriendRecommendViewController class], @selector(viewDidLoad), @selector(newViewDidLoad));
}

- (void)newViewDidLoad {

    //重新加载
    [self newViewDidLoad];

    //加载导航条
    [self loadNarBar];

    //加载监听者
    //    [self loadObserver];
}

- (void)loadNarBar {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.kkzTitleLabel.text = @"新的好友";
    self.navBarView.backgroundColor = [UIColor clearColor];
    self.kkzBackBtn.tag = closeButtonTag;
    [self.view bringSubviewToFront:self.navBarView];
}

@end
