//
//  MPTabBarController.m
//  MobilePrint
//
//  Created by GuoYi on 15/4/9.
//  Copyright (c) 2015年 GuoYi. All rights reserved.
//

#import "MPTabBarController.h"

//      ViewController
#import "MPHomeViewController.h"
#import "MPDrawBoardViewController.h"
#import "MPPhysicsWorldViewController.h"

@interface MPTabBarController ()

@end

@implementation MPTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /// homeVC
    MPHomeViewController * homeVC = [[MPHomeViewController alloc] init];
    homeVC.title = @"首页";
    UINavigationController * homeNavi = [[UINavigationController alloc] initWithRootViewController:homeVC];
    
    /// 3D sceneKit
    MPDrawBoardViewController * drawBoardVC = [[MPDrawBoardViewController alloc] init];
    drawBoardVC.title = @"画板";
    UINavigationController * drawBoardNavi = [[UINavigationController alloc] initWithRootViewController:drawBoardVC];
    /// physicsWorld
    MPPhysicsWorldViewController * physicsWorldVC = [[MPPhysicsWorldViewController alloc] init];
    physicsWorldVC.title = @"物理世界";
    UINavigationController * physicsWorldNavi = [[UINavigationController alloc] initWithRootViewController:physicsWorldVC];
    
    self.viewControllers = @[homeNavi,drawBoardNavi,physicsWorldNavi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
