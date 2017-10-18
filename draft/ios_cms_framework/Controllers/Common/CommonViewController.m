//
//  CommonViewController.m
//  CIASMovie
//
//  Created by cias on 2016/12/7.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:ciasNavBarBackgroundColor];
    if ([self showNavBar]) {
        [self.view addSubview:self.navBarView];
        self.navBarView.backgroundColor = ciasNavBarBackgroundColor;
        self.statusView.backgroundColor = ciasNavBarBackgroundColor;
    }
    
    self.firstAppear = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_navBarView) {
        [self.view bringSubviewToFront:_navBarView];
        [self.view bringSubviewToFront:_statusView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


- (UIImageView *)navBarView {
    if (!_navBarView) {
        
        //导航条背景
        _navBarView = [[UIImageView alloc]
                       initWithFrame:CGRectMake(0, 20, kCommonScreenWidth, 44)];
        _navBarView.backgroundColor = ciasNavBarBackgroundColor;
        
        //分割线
        if ([self showNavBarLine]) {
            UIView *titleBarDivider = [[UIView alloc]
                                       initWithFrame:CGRectMake(0, CGRectGetHeight(_navBarView.frame) - 1,
                                                                kCommonScreenWidth, 1)];
            titleBarDivider.backgroundColor = ciasTitleBarDivider;
            [_navBarView addSubview:titleBarDivider];
        }
        
        _statusView = [[UIView alloc]
                       initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 20)];
        _statusView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_statusView];
        
        //导航条标题
        if (self.showTitleBar) {
            [_navBarView addSubview:self.kkzTitleLabel];
        }
        
        //导航条返回按钮
        if (self.showBackButton) {
            [_navBarView addSubview:self.kkzBackBtn];
        }
        
    
    }
    return _navBarView;
}

- (UILabel *)kkzTitleLabel {
    if (!_kkzTitleLabel) {
        CGFloat height = 40;
        _kkzTitleLabel = [[UILabel alloc]
                          initWithFrame:CGRectMake(60, 0.0, kCommonScreenWidth - 60 - 60, height)];
        _kkzTitleLabel.font = [UIFont boldSystemFontOfSize:16];
        _kkzTitleLabel.backgroundColor = [UIColor clearColor];
        _kkzTitleLabel.textAlignment = NSTextAlignmentCenter;
        _kkzTitleLabel.textColor = ciasTitleBarLabelColor;
    }
    return _kkzTitleLabel;
}

- (UIButton *)kkzBackBtn {
    if (!_kkzBackBtn) {
        _kkzBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _kkzBackBtn.frame = CGRectMake(0, 3, 60, 38);
        [_kkzBackBtn setImage:[UIImage imageNamed:@"white_back"]
                     forState:UIControlStateNormal];
        [_kkzBackBtn setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9, 29)];
        _kkzBackBtn.backgroundColor = [UIColor clearColor];
        [_kkzBackBtn addTarget:self
                        action:@selector(cancelViewController)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _kkzBackBtn;
}

#pragma mark - View pulic Method
- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return TRUE;
}

- (BOOL)showTitleBar {
    return TRUE;
}

- (BOOL)setRightButton {
    return FALSE;
}

- (BOOL)showNavBarLine {
    return FALSE;
}

- (void)cancelViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
