//
//  ChargeSuceessViewController.m
//  CIASMovie
//
//  Created by avatar on 2017/3/6.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "ChargeSuceessViewController.h"
#import "KKZTextUtility.h"

@interface ChargeSuceessViewController ()
{
    UILabel        *titleLabel;
}
@property (nonatomic, strong) UIView  *titleViewOfBar;

@end

@implementation ChargeSuceessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.hideNavigationBar = YES;
    self.hideBackBtn = YES;
    [self setNavBarUI];
    
    //MARK: 如果不动XIB上面的设置，什么都不加，若要改动，再进行调整
    self.goBuyTicketBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
    self.goBuyTicketBtn.titleLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor];
}



- (IBAction)gotoBuyTicketBtnClick:(UIButton *)sender {
    //MARK: 跳转首页
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

- (void)setNavBarUI{
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 69)];
    [bar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarBackgroundColor]]
             forBarPosition:UIBarPositionAny
                 barMetrics:UIBarMetricsDefault];
    [self.view addSubview:bar];
    bar.alpha = 1.0;
    self.navBar = bar;
    UIView *barLine = [[UIView alloc]initWithFrame:CGRectMake(0, 68.5, kCommonScreenWidth, 0.5)];
    barLine.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [bar addSubview:barLine];
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(13.5, 27.5, 28, 28);
    [backButton setImage:[UIImage imageNamed:@"titlebar_close"]
                forState:UIControlStateNormal];
    //    [backButton setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9, 29)];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self
                   action:@selector(backItemClick)
         forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backButton];
    //    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    //    self.navigationItem.leftBarButtonItem = backItem;
    
//    UIView * customTitleView = [[UIView alloc] initWithFrame:CGRectMake(70, 20, kCommonScreenWidth-140, 44)];
//    customTitleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.titleViewOfBar];
    titleLabel.text = [NSString stringWithFormat:@"%@", @"充值成功"];
    //    self.navigationItem.titleView = customTitleView;
//    cinemaTitleLabel = [UILabel new];
//    cinemaTitleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
//    cinemaTitleLabel.textAlignment = NSTextAlignmentCenter;
//    cinemaTitleLabel.text = @"充值成功";
//    cinemaTitleLabel.font = [UIFont systemFontOfSize:16];
//    [customTitleView addSubview:cinemaTitleLabel];
//    [cinemaTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@(7));
//        make.left.equalTo(@(0));
//        make.right.equalTo(customTitleView.mas_right).offset(0);
//        make.height.equalTo(@(15));
//    }];
    
}

/**
 *  MARK: 返回按钮
 */
- (void)backItemClick {
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
        titleLabel = [[UILabel alloc] init];
        [_titleViewOfBar addSubview:titleLabel];
        
        titleLabel.font = [UIFont systemFontOfSize:18*Constants.screenWidthRate];
        titleLabel.text = titleStr;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
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
