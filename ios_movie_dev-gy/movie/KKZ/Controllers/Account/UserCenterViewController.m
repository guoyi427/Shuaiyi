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

@interface UserCenterViewController () <UITableViewDelegate, UITableViewDataSource>
{
    //  UI
    UITableView *_tableView;
    UIView *_headerView;
    UIImageView *_userImageView;
    UILabel *_nickNameLabel;
    UILabel *_wantSeeCountLabel;
    UILabel *_scoreCountLabel;
    
    //  Data
    NSArray<NSArray *> *_menuTitleList;
}
@end

static NSString *UserCenterCell_Identifier = @"userCenterCell";

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _menuTitleList = @[@[@"优惠券", @"兑换码"],@[@"资料修改"],@[@"关于章鱼电影", @"注销账号"]];
    
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
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kAppScreenWidth, 220)];
    _headerView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = _headerView;
    
    UIImageView *pinkView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 140)];
    pinkView.backgroundColor = appDelegate.kkzPink;
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
    
    _nickNameLabel = [[UILabel alloc] init];
    _nickNameLabel.text = [DataEngine sharedDataEngine].userName;
    _nickNameLabel.textColor = [UIColor whiteColor];
    _nickNameLabel.font = [UIFont systemFontOfSize:15];
    [pinkView addSubview:_nickNameLabel];
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_userImageView.mas_right).offset(10);
        make.top.equalTo(_userImageView).offset(20);
    }];
    
    UILabel *vipLabel = [[UILabel alloc] init];
    vipLabel.text = @"金牌会员";
    vipLabel.textColor = [UIColor whiteColor];
    vipLabel.font = [UIFont systemFontOfSize:12];
    [pinkView addSubview:vipLabel];
    [vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nickNameLabel);
        make.top.equalTo(_nickNameLabel.mas_bottom).offset(2);
    }];
    
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
    UserRequest *request = [[UserRequest alloc] init];
    [request requestUserDetail:^(User * _Nullable user) {
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:user.headImg] placeholderImage:[UIImage imageNamed:@"avatarRImg"]];
        _nickNameLabel.text = user.nickName;
        _wantSeeCountLabel.text = [NSString stringWithFormat:@"%@", user.loveMovieCount];
        _scoreCountLabel.text = [NSString stringWithFormat:@"%@", user.pointMovieCount];
    } failure:^(NSError * _Nullable err) {
        
    }];
}

#pragma mark - UIButton - Action

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

#pragma mark - UITableView - Delegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuTitleList[section].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _menuTitleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:UserCenterCell_Identifier];
    
    [cell updateTitle:_menuTitleList[indexPath.section][indexPath.row]];
    [cell updateRightTitle:@""];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //  优惠券
            CouponViewController *vc = [[CouponViewController alloc] init];
            vc.type = CouponType_coupon;
            [self.navigationController pushViewController:vc animated:true];
        } else {
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
            //  关于章鱼
            
        } else {
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
