//
//  CommonSecondWebViewController.m
//  KoMovie
//
//  Created by 艾广华 on 16/4/25.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "CommonSecondWebViewController.h"

typedef enum : NSUInteger {
    backButtonTag = 1000,
} viewButtonTag;

@interface CommonSecondWebViewController ()

@end

@implementation CommonSecondWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNavBar];
}

- (void)loadNavBar {
    self.kkzBackBtn.tag = backButtonTag;
    [self.kkzBackBtn removeTarget:self
                           action:@selector(cancelViewController)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.kkzBackBtn addTarget:self
                        action:@selector(commonBtnClick:)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)jumpFrontView {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else {
        [self cancelViewController];
    }
}

- (void)commonBtnClick:(UIButton *)sender {
    switch (sender.tag) {
        case backButtonTag:{
            [self jumpFrontView];
            break;
        }
        default:
            break;
    }
}

- (BOOL)showNavBar {
    return YES;
}

- (BOOL)showTitleBar {
    return YES;
}

- (BOOL)showBackButton {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
