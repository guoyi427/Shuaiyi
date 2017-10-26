//
//  修改个人资料页面
//
//  Created by 艾广华 on 16/2/22.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "EditProfileView.h"
#import "EditProfileViewController.h"
#import "UIColor+Hex.h"
#import "AccountRequest.h"

@interface EditProfileViewController ()

/**
 *  个人资料视图
 */
@property (nonatomic, strong) EditProfileView *editProfileView;

/**
 *  控制器和视图之间的VM对象
 */
@property (nonatomic, strong) ProfileViewModel *profileViewModel;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //加载导航条
    [self loadNavBar];

    //加载编辑资料视图
    [self loadEditProfileView];

    //加载网络请求
    [self loadNet];
}

- (void)loadNavBar {
    self.view.backgroundColor = CELL_BACKGROUND_COLOR;
    self.kkzTitleLabel.text = @"修改资料";
    self.statusView.backgroundColor = self.navBarView.backgroundColor;
}

- (void)loadEditProfileView {
    [self.view addSubview:self.editProfileView];
    self.editProfileView.profileViewModel = self.profileViewModel;
}

- (void)loadNet {
    
    
    AccountRequest *request = [[AccountRequest alloc] init];
    
    [request requestUser:[NSNumber numberWithLongLong:[DataEngine sharedDataEngine].userId.longLongValue] success:^(User * _Nullable user) {
        self.editProfileView.userInfo = user.detail;
    } failure:^(NSError * _Nullable err) {
        DLog(@"err %@", err);
    }];
    

}

- (EditProfileView *)editProfileView {
    if (!_editProfileView) {
        CGRect frame = CGRectMake(0, CGRectGetMaxY(self.navBarView.frame), kCommonScreenWidth, kCommonScreenHeight - CGRectGetMaxY(self.navBarView.frame));
        _editProfileView = [[EditProfileView alloc] initWithFrame:frame
                                                   withController:self];
    }
    return _editProfileView;
}

- (ProfileViewModel *)profileViewModel {
    if (!_profileViewModel) {
        _profileViewModel = [[ProfileViewModel alloc] initWithController:self
                                                                withView:_editProfileView];
    }
    return _profileViewModel;
}

@end
