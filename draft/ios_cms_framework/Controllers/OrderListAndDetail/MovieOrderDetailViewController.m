//
//  MovieOrderDetailViewController.m
//  CIASMovie
//
//  Created by avatar on 2017/1/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "MovieOrderDetailViewController.h"
#import <Category_KKZ/UIBarButtonItem+GFItem.h>

@interface MovieOrderDetailViewController ()

@end

@implementation MovieOrderDetailViewController


- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.topItem.title = @"订单详情";
    [self.navigationController.view removeGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.view addGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航条
    [self setUpNavBar];
}

#pragma mark - 设置导航条
-(void)setUpNavBar
{
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem ItemWithImage:[UIImage imageNamed:@"titlebar_back1"] WithHighlighted:[UIImage imageNamed:@"titlebar_back1"] Target:self action:@selector(cancelViewController)];
    UIImage *leftBarImage = [UIImage imageNamed:@"titlebar_back1"];
    leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarBtn.frame = CGRectMake(0, 0, leftBarImage.size.width, leftBarImage.size.height);
    [leftBarBtn setImage:leftBarImage
                forState:UIControlStateNormal];
    leftBarBtn.backgroundColor = [UIColor clearColor];
    [leftBarBtn addTarget:self
                   action:@selector(cancelViewController)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    //    self.navigationItem.titleView = self.titleViewOfBar;
    
}

- (void) cancelViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
