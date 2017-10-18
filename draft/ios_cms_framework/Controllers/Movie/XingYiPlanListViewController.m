//
//  XingYiPlanListViewController.m
//  CIASMovie
//
//  Created by cias on 2017/3/23.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "XingYiPlanListViewController.h"
#import "PlanRequest.h"
#import "MovieRequest.h"
#import "UserDefault.h"
#import "Plan.h"
#import "PlanDate.h"
#import <DateEngine_KKZ/DateEngine.h>
#import "ChooseSeatViewController.h"
#import "KKZTextUtility.h"
#import "Cinema.h"
#import "CinemaRequest.h"
#import "CIASAlertImageCancelView.h"
#import "VipCardRequest.h"
#import "OpenCardDetailController.h"
#import "CinemaDetailView.h"
#import "Constants.h"
#import "ZDConstants.h"
#import "HCConstants.h"
#import "NoNetWorkView.h"

#if K_BAOSHAN
    #define kPositionY  69
#else
    #define kPositionY  0
#endif

@interface XingYiPlanListViewController ()
{
    CinemaDetailView  * detailView;
#if K_BAOSHAN
    UILabel           * titleLabel;
#endif
    
}

#if K_BAOSHAN
@property (nonatomic, strong) UIView  *titleViewOfBar;
#endif

@property (nonatomic, strong) NoNetWorkView   * noNetView;

@end

@implementation XingYiPlanListViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    #if K_BAOSHAN
    
        if (Constants.isShowBackBtn) {
        } else {
            self.title = @"影院";
        }
    #else
    
    #endif
    
#if K_HENGDIAN
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
#else
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
#endif
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    Constants.isShowBackBtn = NO;
}

- (void)setNavBarUI {
    
    #if K_BAOSHAN
        if (Constants.isShowBackBtn) {
            self.hideNavigationBar = NO;
            self.title = @"选择场次";
            self.view.backgroundColor = [UIColor whiteColor];
            [Constants.rootNav.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarBackgroundColor]]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
        } else {
            self.hideNavigationBar = YES;
            self.hideBackBtn = YES;
            UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 69)];
            [bar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:@"#333333"]]
                     forBarPosition:UIBarPositionAny
                         barMetrics:UIBarMetricsDefault];
            [self.view addSubview:bar];
            bar.alpha = 1.0;
            self.navBar = bar;
            UIView *barLine = [[UIView alloc]initWithFrame:CGRectMake(0, 68.5, kCommonScreenWidth, 0.5)];
            barLine.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
            [bar addSubview:barLine];
            
            [self.view addSubview:self.titleViewOfBar];
            titleLabel.text = [NSString stringWithFormat:@"%@", @"影院"];
        }
    
    #else
        self.hideNavigationBar = NO;
        self.title = @"选择场次";
        self.view.backgroundColor = [UIColor whiteColor];
        [Constants.rootNav.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarBackgroundColor]]
                                             forBarPosition:UIBarPositionAny
                                                 barMetrics:UIBarMetricsDefault];
    #endif
    
    

}

- (void)requestCinemaListWithCityId{
    [[UIConstants sharedDataEngine] loadingAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    #if K_BAOSHAN
        [params setValue:kCityId forKey:@"cityId"];
    #else
        [params setValue:USER_CITY forKey:@"cityId"];
    #endif
    
    
    NSString *latString = [BAIDU_USER_LATITUDE length] ? BAIDU_USER_LATITUDE : USER_LATITUDE;
    NSString *lonString = [BAIDU_USER_LONGITUDE length] ? BAIDU_USER_LONGITUDE : USER_LONGITUDE;
    if (latString.length > 0) {
        [params setObject:latString forKey:@"lat"];
    }
    if (lonString.length > 0) {
        [params setObject:lonString forKey:@"lon"];
    }
    CinemaRequest *request = [[CinemaRequest alloc] init];
    __weak __typeof(self) weakSelf = self;

    [request requestCinemaListParams:params success:^(NSArray * _Nullable data) {
        if (weakSelf.noNetView.superview) {
            [weakSelf.noNetView removeFromSuperview];
        }
        //获取cinema
        DLog(@"获取cinema:%@", data);
        for (Cinema *cinema in data) {
        #if K_BAOSHAN
            localCinema = cinema;
            for (NSDictionary *dic in localCinema.serviceFeatures) {
                if ([[dic kkz_stringForKey:@"name"] isEqualToString:@"观影小吃"]) {
                    self.isShowGoodsTip = YES;
                }
            }
            [self setupUI];
        #else
            if ([weakSelf.cinemaId isEqualToString:cinema.cinemaId]) {
                localCinema = cinema;
                for (NSDictionary *dic in localCinema.serviceFeatures) {
                    if ([[dic kkz_stringForKey:@"name"] isEqualToString:@"观影小吃"]) {
                        self.isShowGoodsTip = YES;
                    }
                }
                [weakSelf setupUI];
            }
        #endif
            
        }
        [weakSelf requestMovieList];
        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
        });
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
    } failure:^(NSError * _Nullable err) {
        [weakSelf setupUI];
        [weakSelf requestMovieList];
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
        
        if (weakSelf.noNetView.superview) {
        }else {
            [weakSelf.view addSubview:self.noNetView];
        }
    }];
}

- (void)setupUI{
    
    if (Constants.isShowBackBtn) {
        planTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight - 44) style:UITableViewStylePlain];
    } else {
        planTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kPositionY, kCommonScreenWidth, kCommonScreenHeight-44-kPositionY) style:UITableViewStylePlain];
    }
    
    planTableView.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    planTableView.delegate = self;
    planTableView.dataSource = self;
    planTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:planTableView];
    [planTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    UIImage *cinemaMoreImage = [UIImage imageNamed:@"cinema_more"];
    UIImage *goodsTipImage = [UIImage imageNamed:@"snack_btn"];
    NSString *cinemaFeatureStr = @"D BOX厅";
    CGSize cinemaFeatureStrSize = [KKZTextUtility measureText:cinemaFeatureStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
#if kIsHaveCinemaDetail
    if (self.isShowGoodsTip) {
        planTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11)];
    } else {
        planTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10)];
    }
#elif kIsHaveTipLabelInCinemaList
    if (self.isShowGoodsTip) {
        planTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11)];
    } else {
        planTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10)];
    }
#else
    if (self.isShowGoodsTip) {
        planTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+goodsTipImage.size.height+11)];
    } else {
        planTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150)];
    }
#endif

    
    
    
    planTableHeaderView.backgroundColor = [UIColor whiteColor];
    planTableView.tableHeaderView = planTableHeaderView;
    
    cinemaNameLabel = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:16] textColor:[UIColor colorWithHex:@"#333333"] textAlignment:NSTextAlignmentLeft];
    [planTableHeaderView addSubview:cinemaNameLabel];
    
    UIImage *locationImage = [UIImage imageNamed:@"list_location_icon"];
    locationImageView = [UIImageView new];
    locationImageView.backgroundColor = [UIColor clearColor];
    locationImageView.clipsToBounds = YES;
    locationImageView.image = locationImage;
    locationImageView.contentMode = UIViewContentModeScaleAspectFit;
    [planTableHeaderView addSubview:locationImageView];
    
    cinemaAddressLabel = [KKZTextUtility getLabelWithText:@"" font:[UIFont systemFontOfSize:13] textColor:[UIColor colorWithHex:@"#b2b2b2"] textAlignment:NSTextAlignmentLeft];
    cinemaAddressLabel.backgroundColor = [UIColor clearColor];
    [planTableHeaderView addSubview:cinemaAddressLabel];
    
    
    [cinemaNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(@(20));
        make.width.equalTo(@(kCommonScreenWidth-70));
        make.height.equalTo(@(15));
    }];
    
    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(cinemaNameLabel.mas_bottom).offset(5);
        make.width.equalTo(@(12));
        make.height.equalTo(@(14));
    }];
    
    [cinemaAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationImageView.mas_right).offset(5);
        make.top.equalTo(cinemaNameLabel.mas_bottom).offset(5);
        make.width.equalTo(@(kCommonScreenWidth-50-locationImage.size.width-30));
        make.height.equalTo(@(15));
    }];
    
    cinemaNameLabel.text = localCinema.cinemaName;
    cinemaAddressLabel.text = localCinema.address;

#if kIsHaveTipLabelInCinemaList
                cinemaFeatureView = [self getCinemaFeatureViewWith:localCinema.serviceFeatures];
                cinemaFeatureView.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
                [planTableHeaderView addSubview:cinemaFeatureView];
        #if kIsHaveCinemaDetail
                [cinemaFeatureView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@15);
                    make.top.equalTo(cinemaAddressLabel.mas_bottom).offset(15);
                    make.size.mas_equalTo(CGSizeMake(kCommonScreenWidth - 15 - 21 - cinemaMoreImage.size.width, cinemaFeatureStrSize.height+10));
                }];
        #else
                [cinemaFeatureView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(@15);
                    make.top.equalTo(cinemaAddressLabel.mas_bottom).offset(15);
                    make.size.mas_equalTo(CGSizeMake(kCommonScreenWidth - 15 - 21, cinemaFeatureStrSize.height+10));
                }];
        #endif
                
                
                
#endif
    
#if kIsHaveCinemaDetail
    cinemaDBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [planTableHeaderView addSubview:cinemaDBtn];
    cinemaDBtn.backgroundColor = [UIColor clearColor];
    [cinemaDBtn addTarget:self action:@selector(gotoCinemaDetail) forControlEvents:UIControlEventTouchUpInside];
    [cinemaDBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(18));
        make.left.equalTo(@(13));
        make.width.equalTo(@(kCommonScreenWidth-48-locationImage.size.width-30));
        make.height.equalTo(@(15+5+15+15+cinemaFeatureStrSize.height+10));
    }];
    
#endif
    
    UIButton *gotoMapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gotoMapBtn.frame = CGRectMake(kCommonScreenWidth-15-24, 25.5, 24, 24);
    gotoMapBtn.backgroundColor = [UIColor clearColor];
    [gotoMapBtn setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
    [gotoMapBtn addTarget:self action:@selector(gotoMapBtn) forControlEvents:UIControlEventTouchUpInside];
    gotoMapBtn.contentMode = UIViewContentModeScaleAspectFit;
    [planTableHeaderView addSubview:gotoMapBtn];
#if kIsHaveCinemaDetail
    //MARK: 点击查看影院详情
    UIButton *gotoCinemaDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [planTableHeaderView addSubview:gotoCinemaDetailBtn];
    gotoCinemaDetailBtn.backgroundColor = [UIColor clearColor];
    [gotoCinemaDetailBtn setImage:cinemaMoreImage forState:UIControlStateNormal];
    [gotoCinemaDetailBtn addTarget:self action:@selector(gotoCinemaDetail) forControlEvents:UIControlEventTouchUpInside];
    gotoCinemaDetailBtn.contentMode = UIViewContentModeScaleAspectFit;
    [gotoCinemaDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(gotoMapBtn.mas_bottom).offset(20);
        make.right.equalTo(@(-15));
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
#else
    //MARK: 点击查看影院详情
    UIButton *gotoCinemaDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [planTableHeaderView addSubview:gotoCinemaDetailBtn];
    gotoCinemaDetailBtn.backgroundColor = [UIColor clearColor];
    [gotoCinemaDetailBtn setImage:cinemaMoreImage forState:UIControlStateNormal];
    [gotoCinemaDetailBtn addTarget:self action:@selector(gotoCinemaDetail) forControlEvents:UIControlEventTouchUpInside];
    gotoCinemaDetailBtn.contentMode = UIViewContentModeScaleAspectFit;
    [gotoCinemaDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(gotoMapBtn.mas_bottom).offset(20);
        make.right.equalTo(@(-15));
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
#endif
    
    

    if (self.isShowGoodsTip) {
        //MARK: 增加卖品弹框显示
        goodsTipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [planTableHeaderView addSubview:goodsTipBtn];
        goodsTipBtn.backgroundColor = [UIColor clearColor];
        [goodsTipBtn setBackgroundImage:goodsTipImage forState:UIControlStateNormal];
        [goodsTipBtn addTarget:self action:@selector(gotoAlertView) forControlEvents:UIControlEventTouchUpInside];
        goodsTipBtn.contentMode = UIViewContentModeScaleAspectFit;
#if kIsHaveCinemaDetail
        [goodsTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(11));
            make.right.equalTo(@(-11));
            make.top.equalTo(cinemaAddressLabel.mas_bottom).offset(cinemaFeatureStrSize.height+10+11+11);
            make.size.mas_equalTo(CGSizeMake(goodsTipImage.size.width, goodsTipImage.size.height));
        }];
#elif kIsHaveTipLabelInCinemaList
        [goodsTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(11));
            make.right.equalTo(@(-11));
            make.top.equalTo(cinemaAddressLabel.mas_bottom).offset(cinemaFeatureStrSize.height+10+11+11);
            make.size.mas_equalTo(CGSizeMake(goodsTipImage.size.width, goodsTipImage.size.height));
        }];
#else
        [goodsTipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(11));
            make.right.equalTo(@(-11));
            make.top.equalTo(cinemaAddressLabel.mas_bottom).offset(11);
            make.size.mas_equalTo(CGSizeMake(goodsTipImage.size.width, goodsTipImage.size.height));
        }];
#endif
        
        NSString *tipStr = @"影院小吃上线了！";
        CGSize tipStrSize = [KKZTextUtility measureText:tipStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:15]];
        NSString *tipStr1 = @"本影院支持线上购买观影小吃";
        CGSize tipStrSize1 = [KKZTextUtility measureText:tipStr1 size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
        tipsLabel = [[UILabel alloc] init];
        tipsLabel.text = tipStr;
        tipsLabel.font = [UIFont systemFontOfSize:15];
        tipsLabel.textColor = [UIColor colorWithHex:@"#333333"];
        [goodsTipBtn addSubview:tipsLabel];
        tipsLabel.userInteractionEnabled = NO;
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(goodsTipBtn.mas_left).offset(70);
            make.top.equalTo(goodsTipBtn.mas_top).offset(18);
            make.size.mas_equalTo(CGSizeMake(tipStrSize.width+5, tipStrSize.height));
        }];
        
        tipsLabel1 = [[UILabel alloc] init];
        tipsLabel1.text = tipStr1;
        tipsLabel1.font = [UIFont systemFontOfSize:10];
        tipsLabel1.textColor = [UIColor colorWithHex:@"#b2b2b2"];
        [goodsTipBtn addSubview:tipsLabel1];
        tipsLabel1.userInteractionEnabled = NO;
        [tipsLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(goodsTipBtn.mas_left).offset(70);
            make.top.equalTo(tipsLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(tipStrSize1.width+5, tipStrSize1.height));
        }];
    } else {
        
    }
    
    //MARK: 位置因为加入标签和跳转详情按钮而改变
    if (self.isShowGoodsTip) {
        #if kIsHaveCinemaDetail
            switchMovieView = [[SwitchMovieView alloc] initWithFrame:CGRectMake(0, 75+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 150)];
        #elif kIsHaveTipLabelInCinemaList
            switchMovieView = [[SwitchMovieView alloc] initWithFrame:CGRectMake(0, 75+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 150)];
        #else
            switchMovieView = [[SwitchMovieView alloc] initWithFrame:CGRectMake(0, 75+goodsTipImage.size.height+11, kCommonScreenWidth, 150)];
        #endif
    } else {
        #if kIsHaveCinemaDetail
            switchMovieView = [[SwitchMovieView alloc] initWithFrame:CGRectMake(0, 75+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 150)];
        #elif kIsHaveTipLabelInCinemaList
            switchMovieView = [[SwitchMovieView alloc] initWithFrame:CGRectMake(0, 75+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 150)];
        #else
            switchMovieView = [[SwitchMovieView alloc] initWithFrame:CGRectMake(0, 75, kCommonScreenWidth, 150)];
        #endif
    }
    
    switchMovieView.currentMovieSize = CGSizeMake(90, 135);
    switchMovieView.normalMovieSize = CGSizeMake(73, 110);
    switchMovieView.backgroundColor = [UIColor clearColor];
    switchMovieView.delegate = self;
    switchMovieView.currentIndex = self.currentIndex;
    [planTableHeaderView addSubview:switchMovieView];
    
    movieNameLabel = [UILabel new];
    movieNameLabel.font = [UIFont systemFontOfSize:18];
    movieNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    movieNameLabel.backgroundColor = [UIColor clearColor];
    movieNameLabel.textAlignment = NSTextAlignmentRight;
    [planTableHeaderView addSubview:movieNameLabel];
    [movieNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.width.equalTo(@(60));
        make.top.equalTo(switchMovieView.mas_bottom).offset(13);
        make.height.equalTo(@(15));
    }];
    
    scoreLabel = [UILabel new];
    scoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:23];
    scoreLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].planBtnColor];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.textAlignment = NSTextAlignmentLeft;
    [planTableHeaderView addSubview:scoreLabel];
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(movieNameLabel.mas_right).offset(10);
        make.width.equalTo(@(40));
        make.top.equalTo(switchMovieView.mas_bottom).offset(9);
        make.height.equalTo(@(18));
    }];

    movieDurationLabel = [UILabel new];
    movieDurationLabel.font = [UIFont systemFontOfSize:12];
    movieDurationLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    movieDurationLabel.backgroundColor = [UIColor clearColor];
    movieDurationLabel.textAlignment = NSTextAlignmentCenter;
    [planTableHeaderView addSubview:movieDurationLabel];
    [movieDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.width.equalTo(@(kCommonScreenWidth-30));
        make.top.equalTo(movieNameLabel.mas_bottom).offset(8);
        make.height.equalTo(@(15));
    }];
    
    gotoMovieDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    if (self.isShowGoodsTip) {
        #if kIsHaveCinemaDetail
            gotoMovieDetailBtn.frame = CGRectMake(0, 75+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 60);
        #elif kIsHaveTipLabelInCinemaList
            gotoMovieDetailBtn.frame = CGRectMake(0, 75+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 60);
        #else
            gotoMovieDetailBtn.frame = CGRectMake(0, 75+150+goodsTipImage.size.height+11, kCommonScreenWidth, 60);
        #endif
    } else {
        #if kIsHaveCinemaDetail
            gotoMovieDetailBtn.frame = CGRectMake(0, 75+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 60);
        #elif kIsHaveTipLabelInCinemaList
            gotoMovieDetailBtn.frame = CGRectMake(0, 75+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 60);
        #else
            gotoMovieDetailBtn.frame = CGRectMake(0, 75+150, kCommonScreenWidth, 60);
        #endif
    }
    
    gotoMovieDetailBtn.backgroundColor = [UIColor clearColor];
    [gotoMovieDetailBtn addTarget:self action:@selector(gotoMovieDetailBtn) forControlEvents:UIControlEventTouchUpInside];
    [planTableHeaderView addSubview:gotoMovieDetailBtn];
    
    line = [UIView new];
    line.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [planTableHeaderView addSubview:line];
#if kIsHaveOpenCardXinchengPlanList
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(planTableHeaderView);
        make.top.equalTo(planTableHeaderView.mas_bottom).offset(-86);
        make.height.equalTo(@(0.5));
    }];
#else
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(planTableHeaderView);
        make.top.equalTo(planTableHeaderView.mas_bottom).offset(-46);
        make.height.equalTo(@(0.5));
    }];
#endif
    
    
    __weak __typeof(self) weakSelf = self;
    planTableView.mj_header = [CPRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf requestMovieList];
        
    }];
    UICollectionViewFlowLayout *planDateFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [planDateFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    if (self.isShowGoodsTip) {
        #if kIsHaveCinemaDetail
            planDateCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 45) collectionViewLayout:planDateFlowLayout];
        #elif kIsHaveTipLabelInCinemaList
            planDateCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 45) collectionViewLayout:planDateFlowLayout];
        #else
            planDateCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,  75+0.5+60+150+goodsTipImage.size.height+11, kCommonScreenWidth, 45) collectionViewLayout:planDateFlowLayout];
        #endif
    } else {
        #if kIsHaveCinemaDetail
            planDateCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 45) collectionViewLayout:planDateFlowLayout];
        #elif kIsHaveTipLabelInCinemaList
            planDateCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 45) collectionViewLayout:planDateFlowLayout];
        #else
            planDateCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,  75+0.5+60+150, kCommonScreenWidth, 45) collectionViewLayout:planDateFlowLayout];
        #endif
    }
    planDateCollectionView.backgroundColor = [UIColor whiteColor];
    planDateCollectionView.showsHorizontalScrollIndicator = NO;
    planDateCollectionView.delegate = self;
    planDateCollectionView.dataSource = self;
    [planTableHeaderView addSubview:planDateCollectionView];
    [planDateCollectionView registerClass:[XingYiPlanDateCollectionViewCell class] forCellWithReuseIdentifier:@"XingYiPlanDateCollectionViewCell"];
    
    UIView *line1 = [UIView new];
    line1.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [planTableHeaderView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(planTableHeaderView);
        make.height.equalTo(@(0.5));
    }];
    
    //MARK: 办卡提示view，高度改变后，整个header的高度也应该改变
    openCardTipView = [[UIView alloc] init];
    openCardTipView.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    [planTableHeaderView addSubview:openCardTipView];
    [openCardTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(planTableHeaderView);
        make.top.equalTo(planDateCollectionView.mas_bottom).offset(1);
    }];
    
    self.selectDateRow = 0;
    self.selectPlanTimeRow = 0;


}


//MARK: 卖品弹框
- (void) gotoAlertView {
    [[CIASAlertImageCancelView new] show:@"影院小吃上线了！" message:@"本影院支持线上购买观影小吃\n可与电影票一同下单购买" image:[UIImage imageNamed:@"pop_snack"] cancleTitle:@"确定" callback:^(BOOL confirm) {
        
    }];
}


//MARK: 根据标签的数量进行显示，最大4个
- (UIView *)getCinemaFeatureViewWith:(NSArray *)cinemaFeatures {
    NSString *cinemaFeatureStr = @"D BOX厅";
    CGSize cinemaFeatureStrSize = [KKZTextUtility measureText:cinemaFeatureStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
    CGFloat leftGap = 0.0;
    UIView *featureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, cinemaFeatureStrSize.height+10)];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithCapacity:0];
    if (cinemaFeatures.count > 4) {
        for (int i = 0; i < 4; i++) {
            [tmpArr addObject:[cinemaFeatures objectAtIndex:i]];
        }
    } else {
        [tmpArr addObjectsFromArray:cinemaFeatures];
    }
    for (NSDictionary *dic in tmpArr) {
        NSString *featureStr = [dic kkz_stringForKey:@"name"];
        CGSize featureStrSize = [KKZTextUtility measureText:featureStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
        UILabel *featureLabel = [[UILabel alloc] init];
        featureLabel.text = featureStr;
        featureLabel.font = [UIFont systemFontOfSize:10];
        featureLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].planBtnColor];
        featureLabel.layer.borderColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].planBtnColor].CGColor;
        featureLabel.layer.borderWidth = 1.0f;
        featureLabel.layer.cornerRadius = 2.0;
        featureLabel.clipsToBounds = YES;
        [featureView addSubview:featureLabel];
        featureLabel.textAlignment = NSTextAlignmentCenter;
        [featureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(featureView.mas_left).offset(leftGap);
            make.centerY.equalTo(featureView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(featureStrSize.width+5, featureStrSize.height+5));
        }];
        leftGap += featureStrSize.width+10;
    }
    
    
    return featureView;
}
//MARK: 点击弹出影院详情浮层页面，先请求详情数据，然后创建视图进行展示
- (void) gotoCinemaDetail {
    DLog(@"点击弹出影院详情浮层页面，localCinema，创建视图进行展示");
#if kIsHaveCinemaDetail
    if (localCinema.cinemaId.intValue > 0) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
            detailView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
            [detailView setViewLabelWithCinema:localCinema];
            [[UIApplication sharedApplication].keyWindow addSubview:detailView];
        } completion:^(BOOL finished) {
            [detailView reloadData];
        }];
    } else {
        [self getCinemaModelForDetaiView];
    }
#endif
    
    
    
}

- (void) getCinemaModelForDetaiView {
    [[UIConstants sharedDataEngine] loadingAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
#if K_BAOSHAN
    [params setValue:kCityId forKey:@"cityId"];

#else
    [params setValue:USER_CITY forKey:@"cityId"];

#endif
    
    NSString *latString = [BAIDU_USER_LATITUDE length] ? BAIDU_USER_LATITUDE : USER_LATITUDE;
    NSString *lonString = [BAIDU_USER_LONGITUDE length] ? BAIDU_USER_LONGITUDE : USER_LONGITUDE;
    if (latString.length > 0) {
        [params setObject:latString forKey:@"lat"];
    }
    if (lonString.length > 0) {
        [params setObject:lonString forKey:@"lon"];
    }
    CinemaRequest *request = [[CinemaRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    
    [request requestCinemaListParams:params success:^(NSArray * _Nullable data) {
        //获取cinema
        DLog(@"获取cinema:%@", data);
        for (Cinema *cinema in data) {
        #if K_BAOSHAN
            localCinema = cinema;
            [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
                detailView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
                [detailView setViewLabelWithCinema:localCinema];
                [[UIApplication sharedApplication].keyWindow addSubview:detailView];
            } completion:^(BOOL finished) {
                [detailView reloadData];
            }];
        #else
            if (weakSelf.cinemaId == cinema.cinemaId) {
                localCinema = cinema;
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
                    detailView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
                    [detailView setViewLabelWithCinema:localCinema];
                    [[UIApplication sharedApplication].keyWindow addSubview:detailView];
                } completion:^(BOOL finished) {
                    [detailView reloadData];
                }];
            }
        #endif
            
        }
        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
        });
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarUI];
    
    _movieList = [[NSMutableArray alloc] initWithCapacity:0];
    _planDateList = [[NSMutableArray alloc] initWithCapacity:0];
    _planTimeList = [[NSMutableArray alloc] initWithCapacity:0];
    _eventList = [[NSMutableArray alloc] initWithCapacity:0];
    _movieURLs = [[NSMutableArray alloc] initWithCapacity:0];
    _openCardList = [[NSMutableArray alloc] initWithCapacity:0];
    _movieHasPromotions = [[NSMutableArray alloc] initWithCapacity:0];
    
#if kIsHaveCinemaDetail
    detailView = [[[NSBundle mainBundle] loadNibNamed:@"CinemaDetailView" owner:self options:nil] firstObject];
    [detailView setViewLabelWithCinema:localCinema];
    detailView.frame = CGRectMake(0, 0 - kCommonScreenHeight, kCommonScreenWidth, kCommonScreenHeight);
#endif
    
    [self requestCinemaListWithCityId];
    
    //创建网络监听管理者对象 开始监听
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                DLog(@"未知网络");
                break;
            case 0:
                DLog(@"网络不可达");
                break;
            case 1:
                DLog(@"GPRS网络");
                break;
            case 2:
                DLog(@"wifi网络");
                break;
            default:
                break;
        }
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
            DLog(@"有网");
            //进行数据请求
//            [self requestCinemaListWithCityId];
        } else {
            DLog(@"没有网");
            //展示无网络页面
            if (self.noNetView.superview) {
            }else {
                [self.view addSubview:self.noNetView];
            }
            [[CIASAlertCancleView new] show:@"" message:@"哟呵，网络正在开小差~" cancleTitle:@"我知道了" callback:^(BOOL confirm) {
            }];
        }
    }];
    
    
    
    
    
}
//MARK: 请求提示开卡信息
- (void) requestOpenCard {
    [[UIConstants sharedDataEngine] loadingAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:self.cinemaId forKey:@"cinemaId"];
    
    VipCardRequest *requtest = [[VipCardRequest alloc] init];
    [requtest requestCanOpenCardListParams:params success:^(NSDictionary * _Nullable data) {
 
        UIImage *goodsTipImage = [UIImage imageNamed:@"snack_btn"];
        NSString *cinemaFeatureStr = @"D BOX厅";
        CGSize cinemaFeatureStrSize = [KKZTextUtility measureText:cinemaFeatureStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
//        DLog(@"排期页开卡信息：%@", data);
        if (data) {
            localCardTypeDetail = (CardTypeDetail *)data;
            if (localCardTypeDetail.cardId.intValue > 0) {
                //MARK: 创建开卡提示view，并展现
                if (cardTipImageView) {
                    [cardTipImageView removeFromSuperview];
                    cardTipImageView = nil;
                }
                if (goImageView) {
                    [goImageView removeFromSuperview];
                    goImageView = nil;
                }
                if (cardTitleLabel) {
                    [cardTitleLabel removeFromSuperview];
                    cardTitleLabel = nil;
                }
                if (gotitleLabel) {
                    [gotitleLabel removeFromSuperview];
                    gotitleLabel = nil;
                }
                if (openCardBtn) {
                    [openCardBtn removeFromSuperview];
                    openCardBtn = nil;
                }
                UIImage *cardTipImage = [UIImage imageNamed:@"vipcard_icon"];
                cardTipImageView = [[UIImageView alloc] init];
                [openCardTipView addSubview:cardTipImageView];
                cardTipImageView.image = cardTipImage;
                [cardTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(openCardTipView.mas_left).offset(14);
                    make.top.equalTo(openCardTipView.mas_top).offset(8);
                    make.size.mas_equalTo(CGSizeMake(cardTipImage.size.width, cardTipImage.size.height));
                }];
                NSString *cardTitleStr = @"会员卡购票享低价";
                CGSize cardTitleStrSize = [KKZTextUtility measureText:cardTitleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
                cardTitleLabel = [[UILabel alloc] init];
                [openCardTipView addSubview:cardTitleLabel];
                cardTitleLabel.text = cardTitleStr;
                cardTitleLabel.font = [UIFont systemFontOfSize:13];
                cardTitleLabel.textColor = [UIColor colorWithHex:@"#333333"];
                [cardTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cardTipImageView.mas_right).offset(8);
                    make.centerY.equalTo(cardTipImageView.mas_centerY);
                    make.size.mas_equalTo(CGSizeMake(cardTitleStrSize.width+5, cardTitleStrSize.height));
                }];
                UIImage *moreImage = [UIImage imageNamed:@"home_more"];
                NSString *goTitleStr = @"立即办卡";
                CGSize goTitleStrSize = [KKZTextUtility measureText:goTitleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
                gotitleLabel = [[UILabel alloc] init];
                [openCardTipView addSubview:gotitleLabel];
                gotitleLabel.text = goTitleStr;
                gotitleLabel.font = [UIFont systemFontOfSize:13];
                gotitleLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].planBtnColor];
                [gotitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(openCardTipView.mas_right).offset(-(moreImage.size.width+15+10));
                    make.centerY.equalTo(cardTipImageView.mas_centerY);
                    make.size.mas_equalTo(CGSizeMake(goTitleStrSize.width+5, goTitleStrSize.height));
                }];
                
                goImageView = [[UIImageView alloc] init];
                [openCardTipView addSubview:goImageView];
                goImageView.image = moreImage;
                [goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(openCardTipView.mas_right).offset(-15);
                    make.centerY.equalTo(cardTipImageView.mas_centerY);
                    make.size.mas_equalTo(CGSizeMake(moreImage.size.width, moreImage.size.height));
                }];
                
                UIView *lineView = [[UIView alloc] init];
                [openCardTipView addSubview:lineView];
                lineView.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(openCardTipView);
                    make.bottom.equalTo(openCardTipView.mas_bottom).offset(0);
                    make.height.equalTo(@0.5);
                }];
                
                openCardBtn = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
                openCardBtn.backgroundColor = [UIColor clearColor];
                openCardBtn.alpha = 0.8;
                [openCardBtn addTarget:self
                                action:@selector(gotoOpenCard)
                      forControlEvents:UIControlEventTouchUpInside];
                [openCardTipView addSubview:openCardBtn];
                [openCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(openCardTipView);
                }];
               
                if (self.planTimeList.count>0) {

                    if (self.isShowGoodsTip) {
                        #if kIsHaveCinemaDetail
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11+40);
                        #elif kIsHaveTipLabelInCinemaList
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11+40);
                        #else
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+goodsTipImage.size.height+11+40);
                        #endif
                    } else {
                        #if kIsHaveCinemaDetail
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10+40);
                        #elif kIsHaveTipLabelInCinemaList
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10+40);
                        #else
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+40);
                        #endif
                    }
                    [line mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(planTableHeaderView.mas_bottom).offset(-86);
                    }];

                    if (self.isShowGoodsTip) {
                        #if kIsHaveCinemaDetail
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 45);
                        #elif kIsHaveTipLabelInCinemaList
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 45);
                        #else
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+goodsTipImage.size.height+11, kCommonScreenWidth, 45);
                        #endif
                    } else {
                        #if kIsHaveCinemaDetail
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 45);
                        #elif kIsHaveTipLabelInCinemaList
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 45);
                        #else
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150, kCommonScreenWidth, 45);
                        #endif
                    }
                    
                    [openCardTipView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.right.equalTo(planTableHeaderView);
                        make.top.equalTo(planDateCollectionView.mas_bottom).offset(1);
                        make.height.equalTo(@40);
                    }];

                    
                } else {
                    
                    [line mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(planTableHeaderView.mas_bottom).offset(-41);
                    }];

                    
                    if (self.isShowGoodsTip) {
                        #if kIsHaveCinemaDetail
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 0);
                        #elif kIsHaveTipLabelInCinemaList
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 0);
                        #else
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+goodsTipImage.size.height+11, kCommonScreenWidth, 0);
                        #endif
                    } else {
                        #if kIsHaveCinemaDetail
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 0);
                        #elif kIsHaveTipLabelInCinemaList
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 0);
                        #else
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150, kCommonScreenWidth, 0);
                        #endif
                    }
                    [openCardTipView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.right.equalTo(planTableHeaderView);
                        make.top.equalTo(planDateCollectionView.mas_bottom).offset(1);
                        make.height.equalTo(@40);
                    }];

                    if (self.isShowGoodsTip) {
                        #if kIsHaveCinemaDetail
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11+40);
                        #elif kIsHaveTipLabelInCinemaList
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11+40);
                        #else
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+goodsTipImage.size.height+11+40);
                        #endif
                    } else {
                        #if kIsHaveCinemaDetail
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+cinemaFeatureStrSize.height+10+10+40);
                        #elif kIsHaveTipLabelInCinemaList
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+cinemaFeatureStrSize.height+10+10+40);
                        #else
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+40);
                        #endif
                    }
                }
                
                planTableView.tableHeaderView = planTableHeaderView;
//                [planDateCollectionView reloadData];
//                [planTableView reloadData];
            } else {
                if (self.planTimeList.count>0) {
                    
                    [line mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(planTableHeaderView.mas_bottom).offset(-41);
                    }];

                    if (self.isShowGoodsTip) {
                        #if kIsHaveCinemaDetail
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 45);
                        #elif kIsHaveTipLabelInCinemaList
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 45);
                        #else
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+goodsTipImage.size.height+11, kCommonScreenWidth, 45);
                        #endif
                    } else {
                        #if kIsHaveCinemaDetail
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 45);
                        #elif kIsHaveTipLabelInCinemaList
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 45);
                        #else
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150, kCommonScreenWidth, 45);
                        #endif
                    }
                    
                    [openCardTipView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.right.equalTo(planTableHeaderView);
                        make.top.equalTo(planDateCollectionView.mas_bottom).offset(1);
                        make.height.equalTo(@0);
                    }];

                    if (self.isShowGoodsTip) {
                        #if kIsHaveCinemaDetail
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11);
                        #elif kIsHaveTipLabelInCinemaList
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11);
                        #else
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+goodsTipImage.size.height+11);
                        #endif
                    } else {
                        #if kIsHaveCinemaDetail
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10);
                        #elif kIsHaveTipLabelInCinemaList
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10);
                        #else
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150);
                        #endif
                    }
                } else {
                    
                    [line mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(planTableHeaderView.mas_bottom).offset(0);
                    }];

                    if (self.isShowGoodsTip) {
                        #if kIsHaveCinemaDetail
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 0);
                        #elif kIsHaveTipLabelInCinemaList
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 0);
                        #else
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+goodsTipImage.size.height+11, kCommonScreenWidth, 0);
                        #endif
                    } else {
                        #if kIsHaveCinemaDetail
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 0);
                        #elif kIsHaveTipLabelInCinemaList
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 0);
                        #else
                            planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150, kCommonScreenWidth, 0);
                        #endif
                    }
                    
                    [openCardTipView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.left.right.equalTo(planTableHeaderView);
                        make.top.equalTo(planDateCollectionView.mas_bottom).offset(1);
                        make.height.equalTo(@0);
                    }];

                    if (self.isShowGoodsTip) {
                        #if kIsHaveCinemaDetail
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11);
                        #elif kIsHaveTipLabelInCinemaList
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11);
                        #else
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+goodsTipImage.size.height+11);
                        #endif
                    } else {
                        #if kIsHaveCinemaDetail
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+cinemaFeatureStrSize.height+10+10);
                        #elif kIsHaveTipLabelInCinemaList
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+cinemaFeatureStrSize.height+10+10);
                        #else
                            planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150);
                        #endif
                    }
                }
            }
        } else {
            if (self.planTimeList.count>0) {
                
                [line mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(planTableHeaderView.mas_bottom).offset(-46);
                }];

                if (self.isShowGoodsTip) {
                    #if kIsHaveCinemaDetail
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 45);
                    #elif kIsHaveTipLabelInCinemaList
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 45);
                    #else
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+goodsTipImage.size.height+11, kCommonScreenWidth, 45);
                    #endif
                } else {
                    #if kIsHaveCinemaDetail
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 45);
                    #elif kIsHaveTipLabelInCinemaList
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 45);
                    #else
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150, kCommonScreenWidth, 45);
                    #endif
                }
                
                [openCardTipView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(planTableHeaderView);
                    make.top.equalTo(planDateCollectionView.mas_bottom).offset(1);
                    make.height.equalTo(@0);
                }];

                if (self.isShowGoodsTip) {
                    #if kIsHaveCinemaDetail
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11);
                    #elif kIsHaveTipLabelInCinemaList
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11);
                    #else
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+goodsTipImage.size.height+11);
                    #endif
                } else {
                    #if kIsHaveCinemaDetail
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10);
                    #elif kIsHaveTipLabelInCinemaList
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10);
                    #else
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150);
                    #endif
                }
            } else {
                
                [line mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(planTableHeaderView.mas_bottom).offset(0);
                }];

                if (self.isShowGoodsTip) {
                    #if kIsHaveCinemaDetail
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 0);
                    #elif kIsHaveTipLabelInCinemaList
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 0);
                    #else
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+goodsTipImage.size.height+11, kCommonScreenWidth, 0);
                    #endif
                } else {
                    #if kIsHaveCinemaDetail
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 0);
                    #elif kIsHaveTipLabelInCinemaList
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 0);
                    #else
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150, kCommonScreenWidth, 0);
                    #endif
                }
                
                [openCardTipView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(planTableHeaderView);
                    make.top.equalTo(planDateCollectionView.mas_bottom).offset(1);
                    make.height.equalTo(@0);
                }];

                if (self.isShowGoodsTip) {
                    #if kIsHaveCinemaDetail
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11);
                    #elif kIsHaveTipLabelInCinemaList
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11);
                    #else
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+goodsTipImage.size.height+11);
                    #endif
                } else {
                    #if kIsHaveCinemaDetail
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+cinemaFeatureStrSize.height+10+10);
                    #elif kIsHaveTipLabelInCinemaList
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+cinemaFeatureStrSize.height+10+10);
                    #else
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150);
                    #endif
                }
            }
        }
        
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
    
}

//MARK: 跳转开卡详情页
- (void) gotoOpenCard {
    DLog(@"赶快跑去开卡吧");
    if (localCardTypeDetail.cardId.intValue > 0) {
        [[UIConstants sharedDataEngine] loadingAnimation];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
        [params setValue:[NSString stringWithFormat:@"%d",localCardTypeDetail.cardId.intValue] forKey:@"cardProductId"];
        
        VipCardRequest *requtest = [[VipCardRequest alloc] init];
        __weak __typeof(self) weakSelf = self;
        [requtest requestVipCardTypeDetailParams:params success:^(NSDictionary * _Nullable data) {
            CardTypeDetail *bCardType = (CardTypeDetail *)data;
            //        if (_cardCinemaListCount.count > 0) {
            //            [_cardCinemaListCount removeAllObjects];
            //        }
            //        [_cardCinemaListCount addObjectsFromArray:bCardType.cinemas];
            [[UIConstants sharedDataEngine] stopLoadingAnimation];
            
            OpenCardDetailController *openCardVc = [[OpenCardDetailController alloc] init];
            openCardVc.cinemaId = self.cinemaId;
            openCardVc.cinemaName = localCinema.cinemaName;
            openCardVc.cardTypeDetail = bCardType;
            openCardVc.cardCinemaList = bCardType.cinemas;
            [weakSelf.navigationController pushViewController:openCardVc animated:YES];
        } failure:^(NSError * _Nullable err) {
            [[UIConstants sharedDataEngine] stopLoadingAnimation];
            [CIASPublicUtility showMyAlertViewForTaskInfo:err];
        }];
        
    }
    
}

- (void)updateLayout{
    CGSize movieNameSize = [KKZTextUtility measureText:self.movie.filmName font:[UIFont systemFontOfSize:18]];
    
    [movieNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@((kCommonScreenWidth-(movieNameSize.width+50))/2));
        make.width.equalTo(@(movieNameSize.width+5));
        make.top.equalTo(switchMovieView.mas_bottom).offset(11);
        make.height.equalTo(@(15));
    }];
    

    movieNameLabel.text = self.movie.filmName;
    scoreLabel.text = self.movie.point;
    movieDurationLabel.text = [NSString stringWithFormat:@"时长：%@分钟", self.movie.duration.length?self.movie.duration:@""];
}

- (void)requestMovieList {
    
    [[UIConstants sharedDataEngine] loadingAnimation];
    
    MovieRequest *request = [[MovieRequest alloc] init];
    NSDictionary *pagrams = [[NSDictionary alloc] init];
    //MARK: 如果是banner进来的
    #if K_BAOSHAN
        if (self.isFromBanner) {
            pagrams = [NSDictionary dictionaryWithObjectsAndKeys:kCinemaId,@"cinemaId", kCityId, @"cityId", nil];
        } else if(self.isFromHome) {
            pagrams = [NSDictionary dictionaryWithObjectsAndKeys:kCinemaId,@"cinemaId", kCityId, @"cityId", nil];
        } else {
            pagrams = [NSDictionary dictionaryWithObjectsAndKeys:kCinemaId,@"cinemaId", kCityId, @"cityId", nil];
        }
    #else
        if (self.isFromBanner) {
            pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.cinemaId.length>0?self.cinemaId:USER_CINEMAID,@"cinemaId", USER_CITY, @"cityId", nil];
        } else if(self.isFromHome) {
            pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.cinemaId.length>0?self.cinemaId:USER_CINEMAID,@"cinemaId", USER_CITY, @"cityId", nil];
        } else {
            pagrams = [NSDictionary dictionaryWithObjectsAndKeys:USER_CINEMAID,@"cinemaId", USER_CITY, @"cityId", nil];
        }
    #endif
    
    __weak __typeof(self) weakSelf = self;
    [request requestMovieListParams:pagrams success:^(NSArray * _Nullable movies) {
        [weakSelf endRefreshing];

        if (movies.count > 0) {
            [weakSelf.movieList removeAllObjects];
            [weakSelf.movieList addObjectsFromArray:movies];
            //主线程刷新，防止闪烁
            dispatch_async(dispatch_get_main_queue(), ^{
            });
            [self upLoadWithMovieList:self.movieList];
            [planTableView reloadData];
        }else{
            //没有更多
        }
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
    } failure:^(NSError * _Nullable err) {
        [weakSelf endRefreshing];

        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
        
    }];
    
}

- (void)requestPlanDateList {
    [[UIConstants sharedDataEngine] loadingAnimation];

    PlanRequest *request = [[PlanRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *pagrams = [[NSDictionary alloc] init];
    #if K_BAOSHAN
        pagrams = [NSDictionary dictionaryWithObjectsAndKeys:kCinemaId,@"cinemaId", self.movieId, @"filmId", nil];
    #else
        pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.cinemaId,@"cinemaId", self.movieId, @"filmId", nil];
    #endif
    
    DLog(@"movieid:%@", self.movieId);
    [request requestPlanDateListParams:pagrams success:^(NSArray * _Nullable movies) {
        [weakSelf.planDateList removeAllObjects];
        [weakSelf.planDateList addObjectsFromArray:movies];
        
        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
            [planDateCollectionView reloadData];
        });
        if (weakSelf.planDateList.count) {
            weakSelf.selectDateRow = 0;
            [weakSelf requestPlanList];
        }else{
            [weakSelf.planTimeList removeAllObjects];
            [planTableView reloadData];
#if kIsHaveOpenCardXinchengPlanList
            //请求开卡 提示列表
            [self requestOpenCard];
#endif
            
        }
        
        [[UIConstants sharedDataEngine] stopLoadingAnimation];

    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];

        [CIASPublicUtility showAlertViewForTaskInfo:err];
        if (noPlanAlertView.superview) {
            
        }else{
            [weakSelf.view addSubview:noPlanAlertView];
        }
        
    }];
    
}

- (void)requestPlanList {
    
    [[UIConstants sharedDataEngine] loadingAnimation];
    
    PlanRequest *request = [[PlanRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    PlanDate *plandate = [self.planDateList objectAtIndex:self.selectDateRow];
    NSDictionary *pagrams = [[NSDictionary alloc] init];
    #if K_BAOSHAN
        pagrams = [NSDictionary dictionaryWithObjectsAndKeys:kCinemaId,@"cinemaId", self.movieId,@"filmId",plandate.showDate,@"showDate", nil];
    #else
        pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.cinemaId,@"cinemaId", self.movieId,@"filmId",plandate.showDate,@"showDate", nil];
    #endif
    
    [request requestPlanListParams:pagrams success:^(NSArray * _Nullable plans) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        DLog(@"排期日期：%@", plans);
        [weakSelf.planTimeList removeAllObjects];
        [weakSelf.planTimeList addObjectsFromArray:plans];
//        for (int i=0; i<self.planTimeList.count; i++) {
//            Plan *aplan = [self.planTimeList objectAtIndex:i];
//            if ([aplan.isSale isEqualToString:@"1"]) {
//                self.selectPlanTimeRow = i;
//                break;
//            }
//        }
        UIImage *goodsTipImage = [UIImage imageNamed:@"snack_btn"];
        NSString *cinemaFeatureStr = @"D BOX厅";
        CGSize cinemaFeatureStrSize = [KKZTextUtility measureText:cinemaFeatureStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
        if (weakSelf.planTimeList.count<=0) {
            if (noPlanAlertView.superview) {
            }else{
                [planTableView addSubview:noPlanAlertView];
            }
            if (localCardTypeDetail.cardId.intValue > 0) {
                
            } else {
                [line mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(planTableHeaderView.mas_bottom).offset(0);
                }];

                if (weakSelf.isShowGoodsTip) {
                    #if kIsHaveCinemaDetail
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 0);
                    #elif kIsHaveTipLabelInCinemaList
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 0);
                    #else
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+goodsTipImage.size.height+11, kCommonScreenWidth, 0);
                    #endif
                } else {
                    #if kIsHaveCinemaDetail
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 0);
                    #elif kIsHaveTipLabelInCinemaList
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 0);
                    #else
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150, kCommonScreenWidth, 0);
                    #endif

                }
                
                [openCardTipView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(planTableHeaderView);
                    make.top.equalTo(planDateCollectionView.mas_bottom).offset(1);
                    make.height.equalTo(@0);
                }];

                if (weakSelf.isShowGoodsTip) {
                    #if kIsHaveCinemaDetail
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11);
                    #elif kIsHaveTipLabelInCinemaList
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11);
                    #else
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+goodsTipImage.size.height+11);
                    #endif
                } else {
                    #if kIsHaveCinemaDetail
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+cinemaFeatureStrSize.height+10+10);
                    #elif kIsHaveTipLabelInCinemaList
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150+cinemaFeatureStrSize.height+10+10);
                    #else
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+1+60+150);
                    #endif

                }
            }
        }else{
            if (noPlanAlertView.superview) {
                [noPlanAlertView removeFromSuperview];
            }
            if (localCardTypeDetail.cardId.intValue > 0) {
            } else {
                [line mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(planTableHeaderView.mas_bottom).offset(-46);
                }];

                if (weakSelf.isShowGoodsTip) {
                    #if kIsHaveCinemaDetail
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 45);
                    #elif kIsHaveTipLabelInCinemaList
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11, kCommonScreenWidth, 45);
                    #else
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+goodsTipImage.size.height+11, kCommonScreenWidth, 45);
                    #endif
                } else {
                    #if kIsHaveCinemaDetail
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 45);
                    #elif kIsHaveTipLabelInCinemaList
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150+cinemaFeatureStrSize.height+10+10, kCommonScreenWidth, 45);
                    #else
                        planDateCollectionView.frame = CGRectMake(0,  75+0.5+60+150, kCommonScreenWidth, 45);
                    #endif

                }
                [openCardTipView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(planTableHeaderView);
                    make.top.equalTo(planDateCollectionView.mas_bottom).offset(1);
                    make.height.equalTo(@0);
                }];

                if (weakSelf.isShowGoodsTip) {
                    #if kIsHaveCinemaDetail
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11);
                    #elif kIsHaveTipLabelInCinemaList
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10+goodsTipImage.size.height+11);
                    #else
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+goodsTipImage.size.height+11);
                    #endif
                } else {
                    #if kIsHaveCinemaDetail
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10);
                    #elif kIsHaveTipLabelInCinemaList
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150+cinemaFeatureStrSize.height+10+10);
                    #else
                        planTableHeaderView.frame = CGRectMake(0, 0, kCommonScreenWidth, 75+45+1+60+150);
                    #endif

                }
            }
            
        }
        
        [weakSelf updateLayout];
        [planDateCollectionView reloadData];
        [planTableView reloadData];
        
#if kIsHaveOpenCardXinchengPlanList
        //请求开卡 提示列表
        [weakSelf requestOpenCard];
#endif
        
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        //请求开卡 提示列表
#if kIsHaveOpenCardXinchengPlanList
        [weakSelf requestOpenCard];
#endif
        
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
    
}


/**
 *  更新影片列表
 */
- (void)upLoadWithMovieList:(NSArray *)movieList {
    
    [self.movieURLs removeAllObjects];
    [self.movieHasPromotions removeAllObjects];

    self.currentIndex = 0;
    
    Movie *currentMovie = [[Movie alloc] init];
    
    for (int i = 0; i < movieList.count; i++) {
        Movie *movie = movieList[i];
        if (self.movieId > 0) {
            if ([movie.movieId integerValue] == [self.movieId integerValue]) {
                self.currentIndex = i;
                currentMovie = movie;
            }
        }
        if ([movie.isDiscount isEqualToString:@"1"]) {
            [self.movieHasPromotions addObject:@"1"];
        }else{
            [self.movieHasPromotions addObject:@"0"];
        }
        if (movie.filmPoster.length) {
            [self.movieURLs addObject:movie.filmPoster];
        } else {
            [self.movieURLs addObject:@""];
        }
    }
    
    if (self.movieId <= 0 && movieList.count) {
        self.currentIndex = 0;
        currentMovie = movieList[0];
        Movie *movie = currentMovie;
        self.movieId = movie.movieId;
    }
    self.movie = currentMovie;
    self.isFirstLoad = YES;
    
    [self updateLayout];
    switchMovieView.currentIndex = self.currentIndex;
    //是否看过
//    NSArray *sawList = [movieList valueForKeyPath:@"@unionOfObjects.saw"];
    [switchMovieView loadImagesWithUrl:self.movieURLs saw:self.movieHasPromotions];
    [self requestPlanDateList];
}

/**
 *  更新电影信息
 */
- (void)upLoadMovieInfoWithMovie:(Movie *)movie {

}

/**
 *  选中的电影
 *
 */
- (void)switchMovieDidSelectIndex:(NSInteger)index {
    if (!index) {
        index = 0;
    }
    if (index && index >= self.movieList.count) {
        return;
    }
    
    Movie *movie = self.movieList[index];
    
    if (self.movieId > 0 && movie.movieId == self.movieId && !self.isFirstLoad) {
        return;
    }
    
    self.isFirstLoad = NO;
    
    if (movie) {
        switchMovieView.currentIndex = index;
        self.movieId = movie.movieId;
        self.movie = movie;
#if K_BAOSHAN
        [self updateLayout];
#endif
        
        //请求cinema_id下的影片排期
        [self requestPlanDateList];
    }
}

- (void)selctCellWithIndex:(NSInteger)selectIndexRow{
    Plan *plan = [self.planTimeList objectAtIndex:selectIndexRow];
    NSComparisonResult result; //是否过期
    int lockTime = [klockTime intValue];
    
    NSDate *lateDate = [[NSDate date] dateByAddingTimeInterval:lockTime*60];
    NSDate *startTimeDate = [[DateEngine sharedDateEngine] dateFromString:plan.startTime];
    result= [startTimeDate compare:lateDate];
    if (result == NSOrderedDescending) {
        
    }else{
//        [CIASPublicUtility showAlertViewForTitle:@"" message:[NSString stringWithFormat:@"请在开场前%d分钟购票", lockTime] cancelButton:@"确定"];
        [[CIASAlertCancleView new] show:@"" message:[NSString stringWithFormat:@"请在开场前%d分钟购票", lockTime] cancleTitle:@"确定" callback:^(BOOL confirm) {
            if (!confirm) {
                [self requestMovieList];
            }
        }];
        
        return;
    }

    ChooseSeatViewController *ctr = [[ChooseSeatViewController alloc] init];
    ctr.planList = self.planTimeList;
    ctr.selectPlanDate = [self.planDateList objectAtIndex:self.selectDateRow];
    ctr.planDateString = plan.startTime;
    ctr.selectPlanTimeRow = selectIndexRow;
    ctr.movieId = self.movieId;
    #if K_BAOSHAN
        ctr.cinemaId = kCinemaId;
    #else
        ctr.cinemaId = self.cinemaId;
    #endif
    ctr.movieName = self.movie.filmName;
    ctr.cinemaName = plan.cinemaName;
    [self.navigationController pushViewController:ctr animated:YES];

}



#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"PlanTimeCell";
    Plan *plan = [self.planTimeList objectAtIndex:indexPath.row];
    PlanTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[PlanTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectIndexRow = indexPath.row;
    cell.delegate = self;
    cell.selectPlan = plan;
    [cell updateLayout];

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.planTimeList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Plan *plan = [self.planTimeList objectAtIndex:indexPath.row];
    if ([plan.isDiscount isEqualToString:@"1"]) {
        return 93.5;

    }else{
        return 65.5;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Plan *plan = [self.planTimeList objectAtIndex:indexPath.row];
    NSArray *arr = [plan.discount componentsSeparatedByString:@"|"];
    if ([plan.isDiscount isEqualToString:@"1"] && arr.count>0) {
        [self.promotionListView show];
        [_promotionListView.promotionList removeAllObjects];
        [_promotionListView.promotionList addObjectsFromArray:arr];
        [_promotionListView updateLayout];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

}



#pragma mark --UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio{
    if (collectionView==planDateCollectionView) {
        return self.planDateList.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

//定义每个UICollectionView相对于父类位置的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 0);
}

//定义每个UICollectionViewCell 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}
//定义每个UICollectionViewCell 横向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(floor(100), floor(45));
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==planDateCollectionView) {
        static NSString *identify = @"XingYiPlanDateCollectionViewCell";
        XingYiPlanDateCollectionViewCell *cell = (XingYiPlanDateCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell sizeToFit];
        if (!cell) {
            NSLog(@"无法创建PlanDateCollectionViewCell时打印，自定义的cell就不可能进来了。");
        }
        PlanDate *date = [self.planDateList objectAtIndex:indexPath.row];
        cell.dateString = date.showDate;
        cell.planNum = date.planCount;
        cell.selectIndexRow = indexPath.row;
        if (indexPath.row == self.selectDateRow) {
            cell.isSelect = YES;
        }else{
            cell.isSelect = NO;
        }
        
        [cell updateLayout];
        return cell;
        
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.selectDateRow = indexPath.row;
    [self requestPlanList];
    [collectionView reloadData];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}



/**
 *  结束刷新
 */
- (void)endRefreshing {
    if ([planTableView.mj_header isRefreshing]) {
        [planTableView.mj_header endRefreshing];
    }
}


- (void)gotoMapBtn{
    
    cc2d.latitude = [CINEMA_LATITUDE length] ? [CINEMA_LATITUDE doubleValue] : 0.0;
    cc2d.longitude = [CINEMA_LONGITUDE length] ? [CINEMA_LONGITUDE doubleValue] : 0.0;
    
    BMKOpenPoiNearbyOption *opt = [[BMKOpenPoiNearbyOption alloc] init];
    opt.appScheme = @"CIASMovie://mapsdk.baidu.com";
    opt.location = cc2d;
    opt.keyword = USER_CINEMA_NAME;
    opt.radius = 1000;
    BMKOpenErrorCode code = [BMKOpenPoi openBaiduMapPoiNearbySearch:opt];
    DLog(@"BMKOpenErrorCode %d", code);
    if (code==0 || code==1) {
        
    }else
    {
        [self showSelfMap];
    }
}

- (void)showSelfMap{
    // 直接调用ios自己带的apple map
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    [clGeoCoder geocodeAddressString:[USER_CINEMA_ADDRESS length]?USER_CINEMA_ADDRESS:USER_CINEMA_NAME
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       DLog(@"placemarks===%@", placemarks);
                       DLog(@"error===%@", error);
                       
                       if ([placemarks count]) {
                           CLPlacemark *placemark = [placemarks objectAtIndex:0];
                           
                           CLLocationCoordinate2D coordinate = placemark.location.coordinate;
                           NSDictionary *address = placemark.addressDictionary;
                           
                           // MKPlacemark是地图上的地标类，CLPlacemark是定位使用的地标类
                           MKPlacemark *place = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:address];
                           
                           MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:place];
                           toLocation.name = USER_CINEMA_NAME;
                           [toLocation openInMapsWithLaunchOptions:@{MKLaunchOptionsMapSpanKey:@YES}];
                           
                       }else{
                           [CIASPublicUtility showAlertViewForTitle:@"" message:@"位置获取错误" cancelButton:@"知道了"];
                       }
                       
                   }];
}

- (void)gotoMovieDetailBtn{
    
}

- (PlanPromotionListView*)promotionListView {
    if(!_promotionListView) {
        _promotionListView = [[PlanPromotionListView alloc] initWithFrame:CGRectMake(0, kCommonScreenHeight-55-36.5*6, kCommonScreenWidth, 55+36.5*6)];
    }
    return _promotionListView;
}

#if K_BAOSHAN
//MARK: 初始化导航栏标题
- (UIView *)titleViewOfBar {
    if (!_titleViewOfBar) {
        NSString *titleStr = @"绑定未来影院通州北苑...";
        CGSize titleStrSize = [KKZTextUtility measureText:titleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18]];
        _titleViewOfBar = [[UIView alloc] initWithFrame:CGRectMake(60, 30, kCommonScreenWidth - 60*2, titleStrSize.height)];
        titleLabel = [[UILabel alloc] init];
        [_titleViewOfBar addSubview:titleLabel];
        
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = titleStr;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleViewOfBar.mas_left).offset((kCommonScreenWidth - 60*2 - titleStrSize.width)/2);
            make.top.bottom.equalTo(_titleViewOfBar);
            make.size.mas_offset(CGSizeMake(titleStrSize.width+5, titleStrSize.height));
        }];
    }
    return _titleViewOfBar;
}
#endif





- (NoNetWorkView *)noNetView {
    if (!_noNetView) {
        _noNetView = [[NoNetWorkView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight - 69)];
        __weak __typeof(self) weakSelf = self;
        [_noNetView setRefreshCallback:^{
            if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus <= 0) {
                [[CIASAlertCancleView new] show:@"" message:@"哟呵，网络正在开小差~" cancleTitle:@"我知道了" callback:^(BOOL confirm) {
                }];
            } else {
                if (weakSelf.noNetView.superview) {
                    [weakSelf.noNetView removeFromSuperview];
                }
                [weakSelf requestCinemaListWithCityId];
            }
            
        }];
    }
    return _noNetView;
}


@end
