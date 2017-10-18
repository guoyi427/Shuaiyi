//
//  TicketViewController.m
//  CIASMovie
//
//  Created by cias on 2016/12/7.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "TicketViewController.h"
#import "UIColor+Hex.h"



#import "KKZTextUtility.h"
#import "MovieRequest.h"
#import "Movie.h"
#import "MovieDetailViewController.h"
#import "PlanListViewController.h"
#import "CityListViewController.h"
#import "CinemaListViewController.h"
#import "CinemaRequest.h"
#import "Cinema.h"

#import "UserDefault.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface TicketViewController ()
@end

@implementation TicketViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:CityUpdateSucceededNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:CinemaChangeSucceededNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
}
#pragma mark 添加事件通知
- (void)addNotification {
    //城市更换成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeCitySucceeded)
                                                 name:CityUpdateSucceededNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeCinemaSucceeded)
                                                 name:CinemaChangeSucceededNotification
                                               object:nil];

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.hideNavigationBar = YES;
    initFirst = YES;
    [self setNavBarUI];//navbar相关控件
    //电影界面
    _movieChildViewController = [[MovieChildViewController alloc] init];
    [self addChildViewController:self.movieChildViewController];
    [self.view addSubview:_movieChildViewController.view];
    //影院界面
    _movieCinemaChildViewController = [[MovieCinemaChildViewController alloc] init];
    [self addChildViewController:self.movieCinemaChildViewController];
    [self.view addSubview:_movieCinemaChildViewController.view];
    
    self.movieCinemaChildViewController.view.hidden = YES;
    self.movieChildViewController.view.hidden = NO;
    
    [self.view bringSubviewToFront:self.navBar];
    [self addNotification];
}

- (void)setNavBarUI{
    self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 64)];
    self.navBar.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarBackgroundColor];
    [self.view addSubview:self.navBar];
    UIView *barLine = [[UIView alloc]initWithFrame:CGRectMake(0, 63, kCommonScreenWidth, 1)];
    barLine.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
    [self.navBar addSubview:barLine];

    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"影片",@"影院",nil];
    segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    //    segmentedControl.frame = CGRectMake(100.0, 25.0, kCommonScreenWidth-200, 27.0);
    segmentedControl.frame = CGRectMake((kCommonScreenWidth-160)/2, 25.0, 160, 27.0);
    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
    segmentedControl.tintColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarTitleColor];
    [self.navBar addSubview:segmentedControl];
    [segmentedControl addTarget:self action:@selector(segmentedControlClick) forControlEvents:UIControlEventValueChanged];

    arrowImageView = [UIImageView new];
    arrowImageView.backgroundColor = [UIColor clearColor];
    arrowImageView.clipsToBounds = YES;
    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    arrowImageView.image = [UIImage imageNamed:@"home_location_arrow2"];
    [self.navBar addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.navBar.mas_right).offset(-15);
        make.top.equalTo(@(37));
        make.width.equalTo(@(10));
        make.height.equalTo(@(6));
    }];
    
    cityNameLabel = [UILabel new];
    cityNameLabel.text = USER_CITY_NAME;
    cityNameLabel.backgroundColor = [UIColor clearColor];
#if K_HENGDIAN
    cityNameLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
#else
    cityNameLabel.textColor = [UIColor whiteColor];
#endif
    cityNameLabel.textAlignment = NSTextAlignmentRight;
    cityNameLabel.font = [UIFont systemFontOfSize:14];
    [self.navBar addSubview:cityNameLabel];
    [cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(segmentedControl.mas_right).offset(5);
        make.top.equalTo(@(33));
        make.right.equalTo(self.navBar.mas_right).offset(-30);
        make.height.equalTo(@(15));
    }];
    
    selectCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navBar addSubview:selectCityBtn];
    selectCityBtn.backgroundColor = [UIColor clearColor];
    [selectCityBtn addTarget:self action:@selector(selectCityBtn) forControlEvents:UIControlEventTouchUpInside];
    [selectCityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(segmentedControl.mas_right).offset(15);
        make.top.equalTo(@(30));
        make.right.equalTo(self.navBar.mas_right);
        make.height.equalTo(@(22));
    }];
   
    
//    arrowImageView.hidden = YES;
//    cityNameLabel.hidden = YES;
//    selectCityBtn.hidden = YES;
}





- (void)setSelectedTabAtTicketIndex:(NSInteger)index{
    [segmentedControl setSelectedSegmentIndex:index];
    
    if (index==1) {
        
    }else{
        self.movieChildViewController.isReying = YES;
    }
    [self segmentedControlClick];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#if K_HENGDIAN
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
#endif
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.view removeGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
#if K_HENGDIAN
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
#endif
    if (Constants.segmentIndex==0) {
        [self setSelectedTabAtTicketIndex:0];
        Constants.segmentIndex=-1;
    }else if (Constants.segmentIndex==1){
        [self setSelectedTabAtTicketIndex:1];
        Constants.segmentIndex=-1;
    }else{
        Constants.segmentIndex=-1;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.view addGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
}

- (void)segmentedControlClick{
    [self.movieCinemaChildViewController textFieldResignFirstResponder];
    DLog(@"segmentedControl == %ld", segmentedControl.selectedSegmentIndex);
    if (segmentedControl.selectedSegmentIndex==0) {
//        arrowImageView.hidden = YES;
//        cityNameLabel.hidden = YES;
//        selectCityBtn.hidden = YES;

        self.movieCinemaChildViewController.view.hidden = YES;
        self.movieChildViewController.view.hidden = NO;
        [self.movieChildViewController segmentedControlSelectMovie];
        
    }else if(segmentedControl.selectedSegmentIndex==1){
//        arrowImageView.hidden = NO;
//        cityNameLabel.hidden = NO;
//        selectCityBtn.hidden = NO;

        self.movieChildViewController.view.hidden = YES;
        self.movieCinemaChildViewController.view.hidden = NO;
        [self.movieCinemaChildViewController requestCinemaList];
    }
    
}

- (void)selectCityBtn{
    CityListViewController *ctr = [[CityListViewController alloc] init];
    ctr.selectCityBlock = ^(NSString *cityId){
        CinemaListViewController *ctr = [[CinemaListViewController alloc] init];
        ctr.selectCinemaBlock = ^(NSString *cinemaId){
            [self.movieCinemaChildViewController requestCinemaList];
        };
        [self.navigationController pushViewController:ctr animated:YES];
    };
    [self.navigationController pushViewController:ctr animated:YES];
    
}

- (void)changeCitySucceeded{

}

- (void)changeCinemaSucceeded{
    DLog(@"cityId = %@, cityName=%@", USER_CITY, USER_CITY_NAME);
    cityNameLabel.text = USER_CITY_NAME;
    self.movieCinemaChildViewController.selectCinemaRow = 0;

    if (segmentedControl.selectedSegmentIndex==1) {
        [self.movieCinemaChildViewController scrollTop];
        [self.movieCinemaChildViewController.searchCinemaList removeAllObjects];
    }
    [self segmentedControlClick];
}


@end
