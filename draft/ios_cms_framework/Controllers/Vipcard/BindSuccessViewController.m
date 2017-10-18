//
//  BindSuccessViewController.m
//  CIASMovie
//
//  Created by avatar on 2017/2/27.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "BindSuccessViewController.h"
#import "KKZTextUtility.h"
#import "CinemaListViewController.h"
#import "VipCardRechargeController.h"

@interface BindSuccessViewController ()
{
    UILabel        *titleLabel;
}
@property (nonatomic, strong) UIView  *titleViewOfBar;
@property (nonatomic, strong)      UIView *bindSuccessAlertView;
@property (nonatomic, strong)    UIButton *gotoRechargeBtn;
@property (nonatomic, strong)    UIButton *gotoBuyTicketBtn;

@end

@implementation BindSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    self.hideNavigationBar = NO;
    self.hideBackBtn = YES;
    [self setUpNavBar];
    titleLabel.text = [NSString stringWithFormat:@"%@", @"绑卡成功"];
    
    
    
    UIImage *noOrderAlertImage = [UIImage imageNamed:@"addcard_success"];
    NSString *noOrderAlertStr = @"您的会员卡已绑定成功";
    CGSize noOrderAlertStrSize = [KKZTextUtility measureText:noOrderAlertStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:15*Constants.screenWidthRate]];
    self.bindSuccessAlertView = [[UIView alloc] initWithFrame:CGRectMake(0.247*kCommonScreenWidth, 0.210*kCommonScreenHeight, noOrderAlertImage.size.width, noOrderAlertStrSize.height+noOrderAlertImage.size.height+15*Constants.screenWidthRate)];
    [self.view addSubview:self.bindSuccessAlertView];
    
    
    UIImageView *noOrderAlertImageView = [[UIImageView alloc] init];
    [self.bindSuccessAlertView addSubview:noOrderAlertImageView];
    noOrderAlertImageView.image = noOrderAlertImage;
    noOrderAlertImageView.contentMode = UIViewContentModeScaleAspectFill;
    [noOrderAlertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.bindSuccessAlertView);
        make.height.equalTo(@(noOrderAlertImage.size.height));
    }];
    
    
    UILabel *noOrderAlertLabel = [KKZTextUtility getLabelWithText:noOrderAlertStr font:[UIFont systemFontOfSize:15*Constants.screenWidthRate] textColor:[UIColor colorWithHex:@"#b2b2b2"] textAlignment:NSTextAlignmentCenter];
    
    [self.bindSuccessAlertView addSubview:noOrderAlertLabel];
    
    [noOrderAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bindSuccessAlertView);
        make.top.equalTo(noOrderAlertImageView.mas_bottom).offset(15*Constants.screenWidthRate);
        make.height.equalTo(@(noOrderAlertStrSize.height));
    }];
    
    self.gotoRechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.gotoRechargeBtn setTitle:@"马上充值" forState:UIControlStateNormal];
    self.gotoRechargeBtn.backgroundColor = [UIColor colorWithHex:@"#333333"];
    [self.gotoRechargeBtn setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
    self.gotoRechargeBtn.titleLabel.font = [UIFont systemFontOfSize:18*Constants.screenWidthRate];
    [self.view addSubview:self.gotoRechargeBtn];
    self.gotoRechargeBtn.frame = CGRectMake(15*Constants.screenWidthRate, kCommonScreenHeight - 64 - 10  - 65*Constants.screenHeightRate - 50*Constants.screenHeightRate, kCommonScreenWidth - 30*Constants.screenWidthRate, 50*Constants.screenHeightRate);
    [self.gotoRechargeBtn addTarget:self action:@selector(gotoRechargeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.gotoBuyTicketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.gotoBuyTicketBtn setTitle:@"马上购票" forState:UIControlStateNormal];
    self.gotoBuyTicketBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
    [self.gotoBuyTicketBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];

    self.gotoBuyTicketBtn.titleLabel.font = [UIFont systemFontOfSize:18*Constants.screenWidthRate];
    [self.view addSubview:self.gotoBuyTicketBtn];
    self.gotoBuyTicketBtn.frame = CGRectMake(15*Constants.screenWidthRate, kCommonScreenHeight-64-65*Constants.screenHeightRate, kCommonScreenWidth - 30*Constants.screenWidthRate, 50*Constants.screenHeightRate);
    [self.gotoBuyTicketBtn addTarget:self action:@selector(gotoBuyTicketBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

//MARK: 跳转充值页面
- (void)gotoRechargeBtnClick:(id)sender {
    VipCardRechargeController *rechargeVC = [[VipCardRechargeController alloc] init];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

- (void)gotoBuyTicketBtnClick:(id)sender {
    
    #if kIsHuaChenTmpTabbarStyle
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:0];
    #endif
    
    #if kIsSingleCinemaTabbarStyle
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:0];
    #endif
    
    
    #if kIsXinchengTmpTabbarStyle
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:0];
    #endif
    
    if ([kIsXinchengTabbarStyle isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:2];
    }
    if ([kIsCMSStandardTabbarStyle isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:0];
    }
    
}

#pragma mark - 设置导航条
-(void)setUpNavBar
{
    UIImage *leftBarImage = [UIImage imageNamed:@"titlebar_close"];
    leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarBtn.frame = CGRectMake(0, 0, leftBarImage.size.width*Constants.screenWidthRate, leftBarImage.size.height*Constants.screenHeightRate);
    [leftBarBtn setImage:leftBarImage
                forState:UIControlStateNormal];
    leftBarBtn.backgroundColor = [UIColor clearColor];
    [leftBarBtn addTarget:self
                   action:@selector(cancelViewController)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    self.navigationItem.titleView = self.titleViewOfBar;
}

- (void) cancelViewController {
//    DLog(@"%lu", self.navigationController.viewControllers.count);
    if (self.navigationController.viewControllers.count >= 4) {
        UIViewController *targetController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-4];
        [self.navigationController popToViewController:targetController animated:YES];
    }
}


//MARK: 初始化导航栏标题
- (UIView *)titleViewOfBar {
    if (!_titleViewOfBar) {
        NSString *titleStr = @"绑定未来影院通州北苑...";
        CGSize titleStrSize = [KKZTextUtility measureText:titleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18*Constants.screenWidthRate]];
        _titleViewOfBar = [[UIView alloc] initWithFrame:CGRectMake(60*Constants.screenWidthRate, 35*Constants.screenHeightRate, kCommonScreenWidth - 60*2*Constants.screenWidthRate, titleStrSize.height)];
        
        titleLabel = [KKZTextUtility getLabelWithText:titleStr font:[UIFont systemFontOfSize:18*Constants.screenWidthRate] textColor:[UIColor colorWithHex:@"#ffffff"] textAlignment:NSTextAlignmentCenter];
        [_titleViewOfBar addSubview:titleLabel];
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleViewOfBar.mas_left).offset((kCommonScreenWidth - 60*2*Constants.screenWidthRate - titleStrSize.width)/2);
            make.top.bottom.equalTo(_titleViewOfBar);
            make.size.mas_offset(CGSizeMake(titleStrSize.width+5, titleStrSize.height));
        }];
    }
    return _titleViewOfBar;
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
