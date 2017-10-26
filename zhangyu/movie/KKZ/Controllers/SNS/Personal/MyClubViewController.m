//
//  我的社区页面
//
//  Created by KKZ on 16/2/17.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "MyClubViewController.h"
#import "MyCollectionPostsViewController.h"
#import "MyPublishedPostsViewController.h"
#import "MyReplyPostsViewController.h"
#import "MySubscribesController.h"

#define navBackgroundColor appDelegate.kkzBlue
#define functionBtnheight 70
#define iconWidth 30
#define marginX 15
#define marginY 20
#define titleFont 14
#define marginIconToTitle 18
#define arrowVWidth 8.5
#define arrowVHeight 15.5

@interface MyClubViewController ()

@end

@implementation MyClubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:navBackgroundColor];
    //加载导航栏
    [self addNavBar];
    //加载ScrollView
    [self addScrollView];
    functionArr = [[NSMutableArray alloc] initWithObjects:@"我发表的帖子", @"我回复的帖子", @"我收藏的帖子", @"我的订阅", nil];
    //加载功能模块儿
    [self addFunctionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setStatusBarLightStyle];
}

/**
 * 加载功能模块儿
 */
- (void)addFunctionView {
    for (int i = 0; i < functionArr.count; i++) {
        [self addFunctionBtnWithTitle:functionArr[i] andIndex:i];
    }
}

- (void)addFunctionBtnWithTitle:(NSString *)title andIndex:(NSInteger)index {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, index * functionBtnheight, screentWith, functionBtnheight)];
    btn.tag = index + 400;
    [btn addTarget:self action:@selector(functionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(marginX, marginY, iconWidth, iconWidth)];
    [btn addSubview:icon];

    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame) + marginIconToTitle, marginY, screentWith, iconWidth)];
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.font = [UIFont systemFontOfSize:titleFont];
    [btn addSubview:titleLbl];

    titleLbl.text = title;

    switch (index) {
        case 0:
            icon.image = [UIImage imageNamed:@"sns_my_publish"];
            break;
        case 1:
            icon.image = [UIImage imageNamed:@"sns_my_comment"];
            break;
        case 2:
            icon.image = [UIImage imageNamed:@"sns_my_favor"];
            break;
        case 3:
            icon.image = [UIImage imageNamed:@"sns_my_subscribe"];
            break;

        default:
            break;
    }

    UIImageView *arrowV = [[UIImageView alloc] initWithFrame:CGRectMake(screentWith - marginX - arrowVWidth, (functionBtnheight - arrowVHeight) * 0.5, arrowVWidth, arrowVHeight)];
    [btn addSubview:arrowV];

    arrowV.image = [UIImage imageNamed:@"arrowGray"];

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLbl.frame), functionBtnheight - 1, screentWith - CGRectGetMinX(titleLbl.frame), 0.5)];
    [line setBackgroundColor:[UIColor r:216 g:216 b:216]];

    [btn addSubview:line];

    [holder addSubview:btn];
}

- (void)functionBtnClicked:(UIButton *)btn {

    DLog(@"functionBtnClicked");
    switch (btn.tag - 400) {
        case 0: {
            MyPublishedPostsViewController *ctr = [[MyPublishedPostsViewController alloc] init];
            [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
        }

        break;
        case 1: {
            MyReplyPostsViewController *ctr = [[MyReplyPostsViewController alloc] init];
            [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
        }

        break;
        case 2: {
            MyCollectionPostsViewController *ctr = [[MyCollectionPostsViewController alloc] init];
            [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
        }

        break;
        case 3: {
            MySubscribesController *ctr = [[MySubscribesController alloc] init];
            [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
        }

        break;

        default:
            break;
    }
}

//加载ScrollView
- (void)addScrollView {
    holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentHeight - (self.contentPositionY + 44))];
    [self.view addSubview:holder];
    [holder setBackgroundColor:[UIColor whiteColor]];
}

//加载导航栏
- (void)addNavBar {
    [self.navBarView setBackgroundColor:navBackgroundColor];
    self.kkzTitleLabel.text = @"我的社区";
    self.kkzTitleLabel.textColor = [UIColor whiteColor];
}

@end
