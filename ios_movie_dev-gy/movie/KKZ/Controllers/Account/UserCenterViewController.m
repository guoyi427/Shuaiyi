//
//  UserCenterViewController.m
//  KoMovie
//
//  Created by kokozu on 26/10/2017.
//  Copyright © 2017 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "UserCenterViewController.h"

//  View
#import "UserCenterCell.h"

//  Data
#import "UserManager.h"
#import "UserRequest.h"

//  ViewController
#import "UserCenterMovieViewController.h"
#import "CouponViewController.h"
#import "EditUserInfoViewController.h"
#import "AboutViewController.h"
#import "FeedBackViewController.h"

@interface UserCenterViewController () <UITableViewDelegate, UITableViewDataSource>
{
    //  UI
    UITableView *_tableView;
    UIView *_headerView;
    UIImageView *_userImageView;
    UILabel *_nickNameLabel;
    UILabel *_wantSeeCountLabel;
    UILabel *_scoreCountLabel;
    UIView *_vipView;
    UIButton *_loginButton;
    
    //  Data
    NSArray<NSArray *> *_menuTitleList;
    NSInteger _couponCount;
    NSInteger _coupon2Count;
}
@end

static NSString *UserCenterCell_Identifier = @"userCenterCell";

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _menuTitleList = @[@[@"章鱼卡", @"章鱼券", @"章鱼码"],@[@"资料修改"],@[@"意见反馈", @"关于章鱼电影", @"注销账号"]];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = appDelegate.kkzLine;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    [_tableView registerClass:[UserCenterCell class] forCellReuseIdentifier:UserCenterCell_Identifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, kAppScreenWidth/375.0*145 + 80)];
    _headerView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = _headerView;
    
    UIImageView *pinkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screentWith, kAppScreenWidth/375.0*145)];
    pinkView.image = [UIImage imageNamed:@"NaviBar_backgroud@2x.jpg"];
    pinkView.contentMode = UIViewContentModeScaleAspectFill;
    [_headerView addSubview:pinkView];
    
    _userImageView = [[UIImageView alloc] init];
    _userImageView.userInteractionEnabled = true;
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:[DataEngine sharedDataEngine].headImg] placeholderImage:[UIImage imageNamed:@"avatarRImg"]];
    _userImageView.layer.cornerRadius = 32.5;
    _userImageView.layer.masksToBounds = true;
    [pinkView addSubview:_userImageView];
    [_userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    
    UITapGestureRecognizer *tapUserImageGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapUserImageAction)];
    [_userImageView addGestureRecognizer:tapUserImageGR];
    
    _nickNameLabel = [[UILabel alloc] init];
    if ([DataEngine sharedDataEngine].userName.length > 0) {
        _nickNameLabel.text = [DataEngine sharedDataEngine].userName;
    } else {
        _nickNameLabel.text = [DataEngine sharedDataEngine].phoneNum;
    }
    _nickNameLabel.textColor = [UIColor whiteColor];
    _nickNameLabel.font = [UIFont systemFontOfSize:15];
    [pinkView addSubview:_nickNameLabel];
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userImageView.mas_right).offset(10);
        make.top.equalTo(_userImageView).offset(20);
    }];
    
    //  vip
    _vipView = [[UIView alloc] init];
    _vipView.hidden = true;
    [pinkView addSubview:_vipView];
    
    UILabel *vipLabel = [[UILabel alloc] init];
    vipLabel.text = @"金牌会员";
    vipLabel.textColor = [UIColor whiteColor];
    vipLabel.font = [UIFont systemFontOfSize:12];
    [_vipView addSubview:vipLabel];
    
    UIImageView *vipIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UserCenter_vipIcon"]];
    [_vipView addSubview:vipIconView];
    
    [_vipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nickNameLabel);
        make.top.equalTo(_nickNameLabel.mas_bottom).offset(2);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
    [vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_vipView);
        make.top.equalTo(_vipView);
    }];
    
    [vipIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(vipLabel.mas_right).offset(5);
        make.centerY.equalTo(vipLabel);
    }];
    
    //  login button
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton setTitle:@"点击登录" forState:UIControlStateNormal];
    [_loginButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    _loginButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_loginButton addTarget:self action:@selector(loginButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [pinkView addSubview:_loginButton];
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nickNameLabel);
        make.centerY.equalTo(_userImageView);
        make.size.mas_equalTo(CGSizeMake(80, 40));
    }];
    
    //  bottom
    
    UIView *leftBottomView = [[UIView alloc] init];
    leftBottomView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:leftBottomView];
    [leftBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(_headerView);
        make.right.equalTo(_headerView.mas_centerX);
        make.height.mas_equalTo(80);
    }];
    
    UITapGestureRecognizer *tapLeftViewGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRelationViewAction)];
    [leftBottomView addGestureRecognizer:tapLeftViewGR];
    
    UIView *rightBottomView = [[UIView alloc] init];
    rightBottomView.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:rightBottomView];
    [rightBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(_headerView);
        make.left.equalTo(_headerView.mas_centerX);
        make.height.equalTo(leftBottomView);
    }];
    
    UITapGestureRecognizer *tapRightViewGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScoreViewAction)];
    [rightBottomView addGestureRecognizer:tapRightViewGR];
    
    _wantSeeCountLabel = [[UILabel alloc] init];
    _wantSeeCountLabel.textColor = appDelegate.kkzPink;
    _wantSeeCountLabel.text = @"0";
    _wantSeeCountLabel.font = [UIFont systemFontOfSize:16];
    [leftBottomView addSubview:_wantSeeCountLabel];
    [_wantSeeCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftBottomView);
        make.centerY.equalTo(leftBottomView).offset(-15);
    }];
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.text = @"想看";
    leftLabel.font = [UIFont systemFontOfSize:14];
    leftLabel.textColor = [UIColor blackColor];
    [leftBottomView addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(leftBottomView);
        make.centerY.equalTo(leftBottomView).offset(15);
    }];
    
    //  评分
    _scoreCountLabel = [[UILabel alloc] init];
    _scoreCountLabel.textColor = appDelegate.kkzPink;
    _scoreCountLabel.text = @"0";
    _scoreCountLabel.font = [UIFont systemFontOfSize:16];
    [rightBottomView addSubview:_scoreCountLabel];
    [_scoreCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightBottomView);
        make.centerY.equalTo(rightBottomView).offset(-15);
    }];
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.text = @"评分";
    rightLabel.font = [UIFont systemFontOfSize:14];
    rightLabel.textColor = [UIColor blackColor];
    [rightBottomView addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(rightBottomView);
        make.centerY.equalTo(rightBottomView).offset(15);
    }];
    
    UIView *verticalLine = [[UIView alloc] init];
    verticalLine.backgroundColor = appDelegate.kkzLine;
    [_headerView addSubview:verticalLine];
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_headerView);
        make.width.mas_equalTo(0.5);
        make.top.equalTo(leftBottomView).offset(10);
        make.bottom.equalTo(leftBottomView).offset(-10);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadUserinfo];
}

- (BOOL)showNavBar {
    return false;
}

- (BOOL)showBackButton {
    return false;
}

#pragma mark - Network - Request

- (void)loadUserinfo {
    if ([UserManager shareInstance].isUserAuthorized) {
        _vipView.hidden = false;
        _loginButton.hidden = true;
    } else {
        _vipView.hidden = true;
        _loginButton.hidden = false;
    }
    [_tableView reloadData];
    
    UserRequest *request = [[UserRequest alloc] init];
    [request requestUserDetail:^(User * _Nullable user) {
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:user.headImg] placeholderImage:[UIImage imageNamed:@"avatarRImg"]];
        if (user.nickName && user.nickName.length > 0) {
            _nickNameLabel.text = user.nickName;
        } else {
            _nickNameLabel.text = [DataEngine sharedDataEngine].phoneNum;
        }
        _wantSeeCountLabel.text = [NSString stringWithFormat:@"%@", user.loveMovieCount];
        _scoreCountLabel.text = [NSString stringWithFormat:@"%@", user.pointMovieCount];
    } failure:^(NSError * _Nullable err) {
        
    }];
    /*
    MovieRequest *request2 = [[MovieRequest alloc] init];
    [request2 queryCouponListWithGroupId:4 success:^(NSArray * _Nullable couponList) {
        NSInteger count = couponList.count;
        _couponCount = count;
        [_tableView reloadData];
    } failure:^(NSError * _Nullable err) {
        
    }];
    
    MovieRequest *request3 = [[MovieRequest alloc] init];
    [request3 queryCouponListWithGroupId:3 success:^(NSArray * _Nullable couponList) {
        NSInteger count = couponList.count;
        _coupon2Count = count;
        [_tableView reloadData];
    } failure:^(NSError * _Nullable err) {
        
    }];
     */
}

#pragma mark - UIButton - Action

- (void)tapUserImageAction {
    //  资料修改
    if ([UserManager shareInstance].isUserAuthorized) {
        EditUserInfoViewController *vc = [[EditUserInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:true];
    } else {
        [self loginButtonAction];
    }
}

- (void)tapRelationViewAction {
    UserCenterMovieViewController *relationVC = [[UserCenterMovieViewController alloc] init];
    relationVC.type = UserCenterMovieType_WantSee;
    [self.navigationController pushViewController:relationVC animated:true];
}

- (void)tapScoreViewAction {
    UserCenterMovieViewController *scoreVC = [[UserCenterMovieViewController alloc] init];
    scoreVC.type = UserCenterMovieType_Score;
    [self.navigationController pushViewController:scoreVC animated:true];
}

- (void)loginButtonAction {
    WeakSelf
    [[UserManager shareInstance] gotoLoginControllerFrom:weakSelf];
}

#pragma mark - UITableView - Delegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![UserManager shareInstance].isUserAuthorized && section == 2) {
        return _menuTitleList[section].count - 1;
    }
    return _menuTitleList[section].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _menuTitleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCenterCell_Identifier];
    
    [cell updateTitle:_menuTitleList[indexPath.section][indexPath.row]];
//    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {
//            [cell updateRightTitle:[NSString stringWithFormat:@"%ld", _couponCount]];
//        } else if (indexPath.row == 1) {
//            [cell updateRightTitle:[NSString stringWithFormat:@"%ld", _coupon2Count]];
//        }
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //  章鱼卡
            CouponViewController *vc = [[CouponViewController alloc] init];
            vc.type = CouponType_Stored;
            [self.navigationController pushViewController:vc animated:true];
        } else if (indexPath.row == 1) {
            //  优惠券
            CouponViewController *vc = [[CouponViewController alloc] init];
            vc.type = CouponType_coupon;
            [self.navigationController pushViewController:vc animated:true];
        } else if (indexPath.row == 2) {
            //  兑换码
            CouponViewController *vc = [[CouponViewController alloc] init];
            vc.type = CouponType_Redeem;
            [self.navigationController pushViewController:vc animated:true];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //  资料修改
            EditUserInfoViewController *vc = [[EditUserInfoViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        } else {
            //  密码设置
            
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //  意见反馈
            FeedBackViewController *vc = [[FeedBackViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        } else if (indexPath.row == 1) {
            //  关于章鱼
            AboutViewController *vc = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:vc animated:true];
        } else if (indexPath.row == 2) {
            //  注销账号
            [UIAlertView showAlertView:@"是否确定注销账号" cancelText:@"取消" cancelTapped:^{
                
            } okText:@"确定" okTapped:^{
                //统计事件：退出登录
                StatisEvent(EVENT_USER_LOGOUT);
                
                [appDelegate signout];
                
                _userImageView.image = [UIImage imageNamed:@"avatarRImg"];
                _nickNameLabel.text = @"";
                _wantSeeCountLabel.text = @"0";
                _scoreCountLabel.text = @"0";
                __weak typeof(self) weakSelf = self;
                [[UserManager shareInstance] logout:^{
                } failure:^(NSError * _Nullable err) {
                    
                }];
                [[UserManager shareInstance] gotoLoginControllerFrom:weakSelf];
            }];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 5)];
    grayView.backgroundColor = appDelegate.kkzLine;
    return grayView;
}
@end
