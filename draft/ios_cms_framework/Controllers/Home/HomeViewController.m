//
//  HomeViewController.m
//  CIASMovie
//
//  Created by cias on 2016/12/7.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "HomeViewController.h"
#import <UIViewController_ODStatusBar/UIViewController+ODStatusBar.h>
#import "MovieListPosterCollectionViewCell.h"
#import "ProductCollectionViewCell.h"
#import "CinemaCell.h"
#import "CityListViewController.h"
#import "CinemaListViewController.h"
#import "BannerRequest.h"
#import "BannerNew.h"
#import "Movie.h"
#import "MovieRequest.h"
#import "CinemaRequest.h"
#import "Cinema.h"
#import "PayViewController.h"
#import "MovieDetailViewController.h"
#import "UIViewController+SFTrainsitionExtension.h"
#import "UserDefault.h"
#import "City.h"
#import "CityListViewController.h"
#import "LocationEngine.h"
#import "UserDefault.h"
#import "KKZTextUtility.h"
#import "TicketOutFailedViewController.h"
#import "TicketWaitingViewController.h"
#import "OrderDetailViewController.h"
#import "AppConfigureRequest.h"
#import "OrderRequest.h"
#import "MovieDetailViewController.h"
#import "XingYiPlanListViewController.h"
#import "PlanListViewController.h"
#import "ProductRequest.h"
#import "Product.h"
#import "ProductListDetail.h"
#import "CityRequest.h"
#import "Constants.h"
#import "ZDConstants.h"
#import "HCConstants.h"
#import "DataEngine.h"
#import "WebNewViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:LocationUpdateSucceededNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:LocationUpdateFailedNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:AddressUpdateSucceededNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:AddressUpdateFailedNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:CityUpdateSucceededNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:CinemaChangeSucceededNotification
     object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if ([USER_CITY isKindOfClass:[NSNumber class]]) {
        NSUserDefaults *defatluts = [NSUserDefaults standardUserDefaults];
        NSDictionary *dictionary = [defatluts dictionaryRepresentation];
        for(NSString *defKey in [dictionary allKeys]){
            if ([defKey isEqualToString:@"user_city"]) {
                [defatluts removeObjectForKey:defKey];
            }
        }
        [defatluts synchronize];
    }
    
    UIImage *noHotMovieAlertImage = [UIImage imageNamed:@"movie_nodata"];
    NSString *noHotMovieAlertStr = @"准备排片中，请稍后";
    CGSize noHotMovieAlertStrSize = [KKZTextUtility measureText:noHotMovieAlertStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:15*Constants.screenWidthRate]];
    self.noMovieListAlertView = [[UIView alloc] initWithFrame:CGRectMake((kCommonScreenWidth - noHotMovieAlertImage.size.width)/2, (178 - (noHotMovieAlertStrSize.height+noHotMovieAlertImage.size.height+15*Constants.screenWidthRate))/2, noHotMovieAlertImage.size.width, noHotMovieAlertStrSize.height+noHotMovieAlertImage.size.height+15*Constants.screenWidthRate)];
    UIImageView *noOrderAlertImageView = [[UIImageView alloc] init];
    [self.noMovieListAlertView addSubview:noOrderAlertImageView];
    noOrderAlertImageView.image = noHotMovieAlertImage;
    noOrderAlertImageView.contentMode = UIViewContentModeScaleAspectFill;
    [noOrderAlertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.noMovieListAlertView);
        make.height.equalTo(@(noHotMovieAlertImage.size.height));
    }];
    UILabel *noOrderAlertLabel = [[UILabel alloc] init];
    [self.noMovieListAlertView addSubview:noOrderAlertLabel];
    noOrderAlertLabel.text = noHotMovieAlertStr;
    noOrderAlertLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    noOrderAlertLabel.textAlignment = NSTextAlignmentCenter;
    noOrderAlertLabel.textColor = [UIColor colorWithHex:@"#666666"];
    [noOrderAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.noMovieListAlertView);
        make.top.equalTo(noOrderAlertImageView.mas_bottom).offset(15*Constants.screenHeightRate);
        make.height.equalTo(@(noHotMovieAlertStrSize.height));
    }];
    
    UIImage *noGoodAlertImage = [UIImage imageNamed:@"goods_nodata"];
    NSString *noGoodAlertStr = @"商城正在备货中，请稍后";
    CGSize noGoodAlertStrSize = [KKZTextUtility measureText:noGoodAlertStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:15*Constants.screenWidthRate]];
    self.noGoodListAlertView = [[UIView alloc] initWithFrame:CGRectMake((kCommonScreenWidth - noGoodAlertImage.size.width)/2, (145 - (noGoodAlertStrSize.height+noGoodAlertImage.size.height+15*Constants.screenWidthRate))/2, noGoodAlertImage.size.width, noGoodAlertStrSize.height+noGoodAlertImage.size.height+15*Constants.screenWidthRate)];
    UIImageView *noGoodAlertImageView = [[UIImageView alloc] init];
    [self.noGoodListAlertView addSubview:noGoodAlertImageView];
    noGoodAlertImageView.image = noGoodAlertImage;
    noGoodAlertImageView.contentMode = UIViewContentModeScaleAspectFill;
    [noGoodAlertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.noGoodListAlertView);
        make.height.equalTo(@(noGoodAlertImage.size.height));
    }];
    UILabel *noGoodAlertLabel = [[UILabel alloc] init];
    [self.noGoodListAlertView addSubview:noGoodAlertLabel];
    noGoodAlertLabel.text = noGoodAlertStr;
    noGoodAlertLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    noGoodAlertLabel.textAlignment = NSTextAlignmentCenter;
    noGoodAlertLabel.textColor = [UIColor colorWithHex:@"#666666"];
    [noGoodAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.noGoodListAlertView);
        make.top.equalTo(noGoodAlertImageView.mas_bottom).offset(15*Constants.screenHeightRate);
        make.height.equalTo(@(noGoodAlertStrSize.height));
    }];
    
    
    if ([USER_CITY length] <= 0) {
        __weak __typeof(self) weakSelf = self;
        
        CityListViewController *cityListCtr = [[CityListViewController alloc] init];
        cityListCtr.selectCityBlock = ^(NSString *cityId){
            CinemaListViewController *ctr = [[CinemaListViewController alloc] init];
            ctr.selectCinemaBlock = ^(NSString *cinemaId){
                NSString *cinemaStr = USER_CINEMA_NAME;
                cinemaNameLabel.text = [NSString stringWithFormat:@"%@", ([cinemaStr length]&&(![cinemaStr isEqualToString:@"(null)"])&&(![cinemaStr isEqualToString:@"null"]))?USER_CINEMA_NAME:@""];
                //                [weakSelf requestBannerList];
                [weakSelf requestMovieList:1];
                [weakSelf requestCinemaList];
            };
            [weakSelf.navigationController pushViewController:ctr animated:YES];
        };
        [self.navigationController pushViewController:cityListCtr animated:YES];

    }
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(locationGet:)
     name:LocationUpdateSucceededNotification
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(locationGetFailed:)
     name:LocationUpdateFailedNotification
     object:nil];
    //获取定位城市成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gpsCityGetSucceeded)
                                                 name:AddressUpdateSucceededNotification
                                               object:nil];
    //获取定位城市失败
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gpsCityGetFailed)
                                                 name:AddressUpdateFailedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeCitySucceeded)
                                                 name:CityUpdateSucceededNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeCinemaSucceeded)
                                                 name:CinemaChangeSucceededNotification
                                               object:nil];
    
    self.hideNavigationBar = YES;
    isFirstInit = YES;
    _bannerList = [[NSMutableArray alloc] initWithCapacity:0];
    _movieList = [[NSMutableArray alloc] initWithCapacity:0];
    _cinemaList = [[NSMutableArray alloc] initWithCapacity:0];
    _productList = [[NSMutableArray alloc] initWithCapacity:0];
    _homeOrderDic = [[NSMutableDictionary alloc] init];
//    [_productList addObjectsFromArray:[NSArray arrayWithObjects:@"全部",@"2017年1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月", nil]];
    
    [self setUpUI];
    [self setUpNavBar];
    
    if (!USER_HASLAUNCHED) {
        USER_HASLAUNCHED_WRITE(YES);
        
    }else{
        if ([USER_GPS_CITY length]>0) {
            City *city = [[CityManager shareInstance]  getCityWithName:USER_GPS_CITY];

            if ([city.cityid isEqualToString:USER_CITY]) {
                
            }else{
                [[UIConstants sharedDataEngine] loadingAnimation];
                
                CityRequest *request = [[CityRequest alloc] init];
                __weak __typeof(self) weakSelf = self;
                [request requestCityListSuccess:^(NSDictionary * _Nullable cities, NSArray * _Nullable cityIndexes) {
                    weakSelf.cities = cities;
                    weakSelf.cityIndexes = cityIndexes;
                    NSMutableArray *cityArr = [[NSMutableArray alloc] init];
                    for (int i = 0; i < weakSelf.cityIndexes.count; i++) {
                        NSString *index = [weakSelf.cityIndexes objectAtIndex:i];
                        NSArray *groupCities = [weakSelf.cities kkz_objForKey:index];
                        for (int j = 0; j < groupCities.count; j++) {
                            [cityArr addObject: [groupCities objectAtIndex:j]];
                        }
                    }
                    DLog(@"%@", cityArr);
                    for (City *tmpCity in cityArr) {
                        if (tmpCity.cityid == city.cityid) {
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                                   style:UIAlertActionStyleCancel
                                                                                 handler:^(UIAlertAction *_Nonnull action){
                                                                                 }];
                            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"好的"
                                                                                 style:UIAlertActionStyleDefault
                                                                               handler:^(UIAlertAction *_Nonnull action) {
                                                                                   USER_CITY_WRITE(city.cityid);
                                                                                   USER_CITY_NAME_WRITE(city.cityname);
                                                                                   USER_CINEMAID_WRITE(nil);
                                                                                   USER_CINEMA_NAME_WRITE(nil);
                                                                                   [[NSUserDefaults standardUserDefaults] synchronize];
                                                                                   NSNotification *notification = [NSNotification notificationWithName:CityUpdateSucceededNotification
                                                                                                                                                object:self
                                                                                                                                              userInfo:nil];
                                                                                   
                                                                                   [self selectCinemaBtn];
                                                                                   dispatch_async(dispatch_get_main_queue(), ^{
                                                                                       [[NSNotificationCenter defaultCenter] postNotification:notification];
                                                                                       
                                                                                   });
                                                                                   
                                                                               }];
                            
                            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"系统检测到您当前的所在城市是%@，是否切换？", USER_GPS_CITY] preferredStyle:UIAlertControllerStyleAlert];
                            [alertVC addAction:cancelAction];
                            [alertVC addAction:sureAction];
                            
                            [self presentViewController:alertVC
                                               animated:YES
                                             completion:^{
                                             }];
                        }
                    }
                    [[UIConstants sharedDataEngine] stopLoadingAnimation];
                    
                } failure:^(NSError * _Nullable err) {
                    [[UIConstants sharedDataEngine] stopLoadingAnimation];
                    
                    [CIASPublicUtility showAlertViewForTaskInfo:err];
                    
                }];
                
            }
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [self.navigationController.view removeGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    
    
    /*
     if (!USER_HASLAUNCHED) {
     if ([USER_GPS_CITY length]) {
     //APP第一次安装
     //经纬度反编译城市成功
     City *city = [[CityManager shareInstance]  getCityWithName:USER_GPS_CITY];
     if (city) {
     [self requestBannerList];
     [self requestMovieList:1];
     [self requestCinemaList];
     USER_HASLAUNCHED_WRITE(YES);
     
     }else{
     __weak __typeof(self) weakSelf = self;
     
     CityListViewController *ctr = [[CityListViewController alloc] init];
     ctr.selectCityBlock = ^(NSString *cityId){
     CinemaListViewController *ctr = [[CinemaListViewController alloc] init];
     ctr.selectCinemaBlock = ^(NSString *cinemaId){
     cinemaNameLabel.text = [NSString stringWithFormat:@"附近影院：%@", USER_CINEMA_NAME];
     [weakSelf requestBannerList];
     [weakSelf requestMovieList:1];
     [weakSelf requestCinemaList];
     };
     [weakSelf.navigationController pushViewController:ctr animated:YES];
     };
     [weakSelf.navigationController pushViewController:ctr animated:YES];
     
     USER_HASLAUNCHED_WRITE(YES);
     
     }
     
     }else{
     __weak __typeof(self) weakSelf = self;
     
     CityListViewController *ctr = [[CityListViewController alloc] init];
     ctr.selectCityBlock = ^(NSString *cityId){
     CinemaListViewController *ctr = [[CinemaListViewController alloc] init];
     ctr.selectCinemaBlock = ^(NSString *cinemaId){
     cinemaNameLabel.text = [NSString stringWithFormat:@"附近影院：%@", USER_CINEMA_NAME];
     [weakSelf requestBannerList];
     [weakSelf requestMovieList:1];
     [weakSelf requestCinemaList];
     };
     [weakSelf.navigationController pushViewController:ctr animated:YES];
     };
     [weakSelf.navigationController pushViewController:ctr animated:YES];
     
     USER_HASLAUNCHED_WRITE(YES);
     
     }
     }
     */
    
    NSString *cinemaStr = USER_CINEMA_NAME;
    cinemaNameLabel.text = [NSString stringWithFormat:@"%@", ([cinemaStr length]&&(![cinemaStr isEqualToString:@"(null)"])&&(![cinemaStr isEqualToString:@"null"]))?USER_CINEMA_NAME:@""];
    DLog(@"%@", cinemaStr);
#if kIsHaveOrderInHome
    if (Constants.isAuthorized) {
        [self requestHomeOrder];
    } else {
        [self.homeOrderDic removeAllObjects];
    #if kIsHaveGoodsInHome
        if (self.productList.count > 0) {
            headerTableView.frame = CGRectMake(0, 0, kCommonScreenWidth, (K_BANNER_HEIGHT+125+158+20+105+40+43));
        } else {
            headerTableView.frame = CGRectMake(0, 0, kCommonScreenWidth, (K_BANNER_HEIGHT+125+158+20+105+40+43));
        }
    #else
        headerTableView.frame = CGRectMake(0, 0, kCommonScreenWidth, (K_BANNER_HEIGHT+125+158+20));
    #endif
        
        [gotoOrderDetailBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(headerTableView);
            make.top.equalTo(bannerView.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [gotoOrderImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [gotoOrderTipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
        [gotoOrderTipImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(0, 0));
        }];
    }
#endif
    
#if kIsHaveGoodsInHome
    if ([USER_CINEMAID intValue] > 0) {
        [self requestProductList];
    }
#endif
    
    if (isFirstInit) {
        
        [self requestMovieList:1];
        [self requestCinemaList];
        [self requestAPPConfig];
        //    [self requestAPPTemplate];//暂时没用到，屏蔽一下
//        [self requestBannerList];
    }
//    if (self.bannerList.count > 0) {
//        
//    } else {
        [self requestBannerList];
//    }
    


    
    // 遍历获取字体名称
    //    for(NSString *fontFamilyName in [UIFont familyNames])
    //    {
    //        NSLog(@"family:'%@'",fontFamilyName);
    //        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontFamilyName])
    //        {
    //            NSLog(@"\tfont:'%@'",fontName);
    //        }
    //        DLog(@"-------------");
    //    }
    
    

//    [self refreshPayOrderDetail];

}


//卖品列表数据接口
- (void)requestProductList{
    [[UIConstants sharedDataEngine] loadingAnimation];
    ProductRequest *requtest = [[ProductRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [requtest requestProductListParams:nil success:^(NSDictionary * _Nullable data) {
        DLog(@"首页请求卖品列表信息：%@", data);
        ProductListDetail *detail = (ProductListDetail *)data;
        //        self.productType = [detail.goodsType isEqualToString:@"2"]?YES:NO;//这里不做区分
        if (weakSelf.productList.count > 0) {
            [weakSelf.productList removeAllObjects];
        }
        [weakSelf.productList addObjectsFromArray:detail.list];
        if (weakSelf.productList.count > 0) {
            if (weakSelf.noGoodListAlertView.superview) {
                [weakSelf.noGoodListAlertView removeFromSuperview];
            }
            
            headerTableView.frame = CGRectMake(0, 0, kCommonScreenWidth, (K_BANNER_HEIGHT+125+158+20+105+40+43));
            if (weakSelf.homeOrderDic) {
                NSString *status = [weakSelf.homeOrderDic kkz_stringForKey:@"status"];
                if ([status isEqualToString:@"0"]) {
                    headerTableView.frame = CGRectMake(0, 0, kCommonScreenWidth, (K_BANNER_HEIGHT+125+158+20+105+40+43+55));
                }
            }
            
            [yellowView1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(13));//13
            }];
            [sectionLabel1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(14));//14
            }];
            [gotoProductBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(40));
            }];
            [productCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(105+40));//105+40
            }];
            homeTableView.tableHeaderView = headerTableView;
        }else{
            /*
            if (weakSelf.noGoodListAlertView.superview) {
            } else {
                [productCollectionView addSubview:weakSelf.noGoodListAlertView];
            }*/
            //  无商品，隐藏页面
            
            [yellowView1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(0));//13
            }];
            [sectionLabel1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(0));//14
            }];
            [gotoProductBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(0));
            }];
            [productCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(0));//105+40
            }];
            
            headerTableView.frame = CGRectMake(0, 0, kCommonScreenWidth, (K_BANNER_HEIGHT+125+158));
            if (weakSelf.homeOrderDic) {
                NSString *status = [weakSelf.homeOrderDic kkz_stringForKey:@"status"];
                if ([status isEqualToString:@"0"]) {
                    headerTableView.frame = CGRectMake(0, 0, kCommonScreenWidth, (K_BANNER_HEIGHT+125+158+55));
                }
            }
            homeTableView.tableHeaderView = headerTableView;
        }
        
        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
            [productCollectionView reloadData];
            [homeTableView reloadData];
        });
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
    } failure:^(NSError * _Nullable err) {
        if (weakSelf.productList.count > 0) {
            if (weakSelf.noGoodListAlertView.superview) {
                [weakSelf.noGoodListAlertView removeFromSuperview];
            }
        }else {
            if (weakSelf.noGoodListAlertView.superview) {
            } else {
                [productCollectionView addSubview:weakSelf.noGoodListAlertView];
            }
        }
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
}

//请求首页未领取的订单
/*
 data =     {
 cinemaId = 560;
 cinemaName = "指点总部";
 count = 3;
 createTime = 1492683373000;
 filmId = 364;
 filmName = "赏金猎人";
 orderCode = 170400014537102785;
 planBeginTime = 1492961700000;
 seatInfo = "9排8座,9排9座,9排10座";
 };
 error = "成功";
 status = 0;
 */
- (void) requestHomeOrder {
    [[UIConstants sharedDataEngine] loadingAnimation];
    OrderRequest *requtest = [[OrderRequest alloc] init];
//    __weak __typeof(self) weakSelf = self;
    [requtest requestHomeOrderParams:nil success:^(NSDictionary * _Nullable data) {
        DLog(@"首页未领取订单信息：%@", data);
        
        NSString *status = [data kkz_stringForKey:@"status"];
        if ([status isEqualToString:@"0"]) {
            //status 为0   有可能返回的数据为空
            if ([data kkz_objForKey:@"data"]) {
                self.homeOrderDic = [NSMutableDictionary dictionaryWithDictionary:data];
                NSDictionary *orderDic = [self.homeOrderDic kkz_objForKey:@"data"];
#if kIsHaveGoodsInHome
                if (self.productList.count > 0) {
                    headerTableView.frame = CGRectMake(0, 0, kCommonScreenWidth, (K_BANNER_HEIGHT+125+158+20+105+40+43+55));
                } else {
                    headerTableView.frame = CGRectMake(0, 0, kCommonScreenWidth, (K_BANNER_HEIGHT+125+158+20+105+40+43+55));
                }
#else
                    headerTableView.frame = CGRectMake(0, 0, kCommonScreenWidth, (K_BANNER_HEIGHT+125+158+20+55));
#endif
                
                
                [gotoOrderDetailBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(kCommonScreenWidth, 55));
                }];
                UIImage *gotoOrderImage = [UIImage imageNamed:@"push_icon"];
                [gotoOrderImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(gotoOrderImage.size.width, gotoOrderImage.size.height));
                }];
                int countNum = [[orderDic kkz_intNumberForKey:@"count"] intValue];
                NSString *tipLabelStr = [NSString stringWithFormat:@"亲，您有%d张影票还未领取！", countNum];
                CGSize tipLabelStrSize = [KKZTextUtility measureText:tipLabelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14]];
                gotoOrderTipLabel.attributedText = [KKZTextUtility getAttributeStr:tipLabelStr withStartRangeStr:@"有" withEndRangeStr:@"张" withFormalColor:[UIColor colorWithHex:@"#333333"] withSpecialColor:[UIColor colorWithHex:@"#ff9900"] withFont:[UIFont systemFontOfSize:14*Constants.screenWidthRate]];
                [gotoOrderTipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(tipLabelStrSize.width+5, tipLabelStrSize.height));
                }];
                
                UIImage *gotoOrderTipImage = [UIImage imageNamed:@"home_more"];
                [gotoOrderTipImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(gotoOrderTipImage.size.width, gotoOrderTipImage.size.height));
                }];
                
                homeTableView.tableHeaderView = headerTableView;
            }
            
        }
        
        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
            [homeTableView reloadData];
        });
        [[UIConstants sharedDataEngine] stopLoadingAnimation];

    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showMyAlertViewForTaskInfo:err];
    }];
    
}

- (void)refreshPayOrderDetail{
    OrderRequest *request = [[OrderRequest alloc] init];
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:@"170285000001660017",@"orderCode",ciasTenantId,@"tenantId", nil];
    
    [request requestOrderDetailParams:pagrams success:^(id _Nullable data) {
    } failure:^(NSError * _Nullable err) {
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.view addGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    isFirstInit = NO;
}

- (void)setUpNavBar{
    _navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 69)];
    _navBar.backgroundColor = [UIColor whiteColor];
    _navBar.alpha = 0.0;
    UIView *barLine = [[UIView alloc]initWithFrame:CGRectMake(0, 68.5, kCommonScreenWidth, 0.5)];
    barLine.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [_navBar addSubview:barLine];
    
    cinemaNameView = [[UIView alloc] initWithFrame:CGRectMake((kCommonScreenWidth-255)/2, 29, 255, 28)];
    cinemaNameView.backgroundColor = [UIColor blackColor];
    cinemaNameView.alpha = 0.5;
    cinemaNameView.layer.cornerRadius = 14;
    
    cinemaNameLabel = [UILabel new];
    
    
    NSString *cinemaStr = USER_CINEMA_NAME;
    cinemaNameLabel.text = [NSString stringWithFormat:@"%@", ([cinemaStr length]&&(![cinemaStr isEqualToString:@"(null)"])&&(![cinemaStr isEqualToString:@"null"]))?USER_CINEMA_NAME:@""];
    DLog(@"%@", USER_CINEMA_NAME);
    cinemaNameLabel.backgroundColor = [UIColor clearColor];
    cinemaNameLabel.textColor = [UIColor whiteColor];
    cinemaNameLabel.textAlignment = NSTextAlignmentCenter;
    cinemaNameLabel.font = [UIFont systemFontOfSize:14];
    [cinemaNameView addSubview:cinemaNameLabel];
    [cinemaNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(@(5));
        make.right.equalTo(cinemaNameView.mas_right).offset(-40);
        //        make.width.equalTo(@(255-60));
        make.height.equalTo(@(18));
    }];
    arrowImageView = [UIImageView new];
    arrowImageView.backgroundColor = [UIColor clearColor];
    arrowImageView.clipsToBounds = YES;
    arrowImageView.contentMode = UIViewContentModeCenter;
    arrowImageView.image = [UIImage imageNamed:@"home_location_arrow1"];
    [cinemaNameView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cinemaNameView.mas_right).offset(-15);
        make.top.equalTo(@(10));
        make.width.equalTo(@(15));
        make.height.equalTo(@(10));
    }];
    
    selectCinemaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectCinemaBtn setFrame:CGRectMake(0, 0, 255, 28)];
    [cinemaNameView addSubview:selectCinemaBtn];
    selectCinemaBtn.backgroundColor = [UIColor clearColor];
    [selectCinemaBtn addTarget:self action:@selector(selectCinemaBtn) forControlEvents:UIControlEventTouchUpInside];
    [cinemaNameView addSubview:selectCinemaBtn];
    
    [self.view addSubview:_navBar];
    [self.view addSubview:cinemaNameView];
    
}

- (void)setUpUI{
    homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight-49) style:UITableViewStylePlain];
    homeTableView.showsVerticalScrollIndicator = NO;
    homeTableView.backgroundColor = [UIColor colorWithHex:@"f2f5f5"];
    homeTableView.delegate = self;
    homeTableView.dataSource = self;
    homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:homeTableView];
    
    [homeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
        //        make.top.equalTo(self.view.mas_top).offset(64);
        //        make.left.equalTo(self.view.mas_left);
        //        make.right.equalTo(self.view.mas_right);
        //        make.bottom.equalTo(self.view.mas_bottom);
    }];
    if (@available(iOS 11.0, *)) {
        homeTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        homeTableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        homeTableView.scrollIndicatorInsets = homeTableView.contentInset;
    }
    __weak __typeof(self) weakSelf = self;
    homeTableView.mj_header = [CPRefreshHeader headerWithRefreshingBlock:^{
//        [weakSelf requestBannerList];
        [weakSelf requestMovieList:1];
        [weakSelf requestCinemaList];
        [self requestAPPConfig];
        //    [self requestAPPTemplate];//暂时没用到，屏蔽一下

        
        [self requestBannerList];
#if kIsHaveGoodsInHome
        if ([USER_CINEMAID intValue] > 0) {
            [self requestProductList];
        }
#endif
    }];
#if kIsHaveGoodsInHome
    headerTableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, (K_BANNER_HEIGHT+125+158+20+105+40+43))];
#else
    headerTableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, (K_BANNER_HEIGHT+125+158+20))];
#endif
    
    
//    headerTableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, (K_BANNER_HEIGHT+125+158+20+105+40+43))];
    

    headerTableView.backgroundColor = [UIColor colorWithHex:@"f2f5f5"];
    headerTableView.userInteractionEnabled = YES;
    homeTableView.tableHeaderView = headerTableView;
    //    [headerTableView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.left.right.equalTo(homeTableView);
    //        make.height.equalTo(@(K_BANNER_HEIGHT+125+158+20+105+40));
    //    }];
    UIImageView *bannerViewBg = [UIImageView new];
    bannerViewBg.userInteractionEnabled = YES;
    [headerTableView addSubview:bannerViewBg];
    bannerViewBg.image = [UIImage imageNamed:@"home_banner"];
    [bannerViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(K_BANNER_HEIGHT));
        make.left.top.right.equalTo(@0);
    }];

    bannerView = [CPBannerView new];
    bannerView.backgroundColor = [UIColor clearColor];
    [headerTableView addSubview:bannerView];
    [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(K_BANNER_HEIGHT));
        make.left.top.right.equalTo(@0);
    }];
    
    [bannerView setSelectCallback:^(NSInteger index) {
        if (weakSelf.bannerList.count > 0) {
            BannerNew *banner = [weakSelf.bannerList objectAtIndex:index];
            NSString *linkUrlStr = [NSString stringWithFormat:@"%@", banner.slideUrl];
            DLog(@"linkUrl:%@", linkUrlStr);
            if([linkUrlStr hasPrefix:@"http://"]||[linkUrlStr hasPrefix:@"https://"]){
                WebNewViewController *webVc = [[WebNewViewController alloc] init];
                webVc.webViewTitle = banner.slideTitle;
                webVc.requestURL = banner.slideUrl;
                [weakSelf.navigationController pushViewController:webVc animated:YES];
            } else if([linkUrlStr containsString:@"/app/page?name="]){
                //MARK: --区分是影片详情，还是排期列表
                NSArray *paramsTmp = [linkUrlStr componentsSeparatedByString:@"?"];
                NSArray *params = [paramsTmp[1] componentsSeparatedByString:@"&"];
                DLog(@"linkUrl中的参数:%@", params);
                NSString *linkUrlName = @"";
                NSString *linkUrl_isHot = @"";
                NSString *linkUrl_movieId = @"";
                NSString *linkUrl_cinemaId = @"";
                NSArray *nameArr = [[NSArray alloc] init];
                //根据name区分是影片详情还是排期列表
                if (params.count > 0) {
                    nameArr = [params[0] componentsSeparatedByString:@"="];
                    linkUrlName = nameArr[1];
                }
                if ([linkUrlName isEqualToString:@"movieDetail"]) {
                    //影片详情
                    for (NSString *contentStr in params) {
                        NSArray *contentArr = [contentStr componentsSeparatedByString:@"="];
                        if ([contentArr[0] isEqualToString:@"movie_id"]) {
                            linkUrl_movieId = contentArr[1];
                        } else if ([contentArr[0] isEqualToString:@"is_hot"]) {
                            linkUrl_isHot = contentArr[1];
                        } else if ([contentArr[0] isEqualToString:@"cinema_id"]) {
                            linkUrl_cinemaId = contentArr[1];
                        }
                    }
                    if (linkUrl_movieId.intValue>0) {
                        //请求影片详情
                        if ([linkUrl_isHot isEqualToString:@"0"]) {
                            //热映，需考虑影院id是否有，且是否一致
                            if (linkUrl_cinemaId.intValue > 0) {
                                if ([linkUrl_cinemaId isEqualToString:USER_CINEMAID]) {
                                    //一致，则跳转
                                    [[UIConstants sharedDataEngine] loadingAnimation];
                                    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:linkUrl_cinemaId, @"cinemaId",linkUrl_movieId, @"filmId", nil];
                                    MovieRequest *request = [[MovieRequest alloc] init];
                                    [request requestMovieDetailParams:pagrams success:^(Movie * _Nullable movie) {
                                        if (movie.movieId.intValue > 0) {
                                            MovieDetailViewController *ctr = [[MovieDetailViewController alloc] init];
                                            ctr.isReying = [linkUrl_isHot isEqualToString:@"0"]?YES:NO;
                                            ctr.isHiddenAnimation = YES;
                                            Constants.isHidAnimation = YES;
                                            ctr.myMovie = movie;
                                            [weakSelf.navigationController pushViewController:ctr animated:YES];
                                        }
                                        
                                        [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                        
                                    } failure:^(NSError * _Nullable err) {
                                        
                                        [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                        [CIASPublicUtility showAlertViewForTaskInfo:err];
                                        
                                    }];
                                } else {
                                    //影院不一致，不给跳转
                                }
                            } else {
                                //url没有影院id，则传入用户选择的影院，有排期，则跳转
                                [[UIConstants sharedDataEngine] loadingAnimation];
                                NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:USER_CINEMAID, @"cinemaId",linkUrl_movieId, @"filmId", nil];
                                MovieRequest *request = [[MovieRequest alloc] init];
                                [request requestMovieDetailParams:pagrams success:^(Movie * _Nullable movie) {
                                    if (movie.movieId.intValue > 0) {
                                        MovieDetailViewController *ctr = [[MovieDetailViewController alloc] init];
                                        ctr.isReying = [linkUrl_isHot isEqualToString:@"0"]?YES:NO;
                                        ctr.isHiddenAnimation = YES;
                                        Constants.isHidAnimation = YES;
                                        ctr.myMovie = movie;
                                        [weakSelf.navigationController pushViewController:ctr animated:YES];
                                    }
                                    
                                    [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                    
                                } failure:^(NSError * _Nullable err) {
                                    
                                    [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                    [CIASPublicUtility showAlertViewForTaskInfo:err];
                                    
                                }];
                            }
                            
                        } else {
                            //即将上映，不可购票，随便跳转
                            [[UIConstants sharedDataEngine] loadingAnimation];
                            NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:linkUrl_movieId, @"filmId", nil];
                            MovieRequest *request = [[MovieRequest alloc] init];
                            [request requestMovieDetailParams:pagrams success:^(Movie * _Nullable movie) {
                                MovieDetailViewController *ctr = [[MovieDetailViewController alloc] init];
                                ctr.isReying = [linkUrl_isHot isEqualToString:@"0"]?YES:NO;
                                ctr.myMovie = movie;
                                ctr.isHiddenAnimation = YES;
                                Constants.isHidAnimation = YES;
                                [weakSelf.navigationController pushViewController:ctr animated:YES];
                                [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                
                            } failure:^(NSError * _Nullable err) {
                                
                                [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                [CIASPublicUtility showAlertViewForTaskInfo:err];
                                
                            }];
                        }
                        
                        
                    }else{
                        //movieid为空，不跳转
                    }
                    
                } else if ([linkUrlName isEqualToString:@"moviePlan"]) {
                    //排期列表
                    for (NSString *contentStr in params) {
                        NSArray *contentArr = [contentStr componentsSeparatedByString:@"="];
                        if ([contentArr[0] isEqualToString:@"movie_id"]) {
                            linkUrl_movieId = contentArr[1];
                        } else if ([contentArr[0] isEqualToString:@"cinema_id"]) {
                            linkUrl_cinemaId = contentArr[1];
                        }
                    }
                    if (linkUrl_movieId.intValue>0) {
                        //请求影片详情,是否有影院id
                        if (linkUrl_cinemaId.intValue > 0) {
                            //有影院id，相等跳转
                            if ([linkUrl_cinemaId isEqualToString:USER_CINEMAID]) {
                                [[UIConstants sharedDataEngine] loadingAnimation];
                                NSString *cinema_id = linkUrl_cinemaId;
                                NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:cinema_id, @"cinemaId",linkUrl_movieId, @"filmId", nil];
                                DLog(@"movieid:%@", linkUrl_movieId);
                                MovieRequest *request = [[MovieRequest alloc] init];
                                [request requestMovieDetailParams:pagrams success:^(Movie * _Nullable movie) {
                                    DLog(@"%@", movie);
                                    if (movie.movieId.intValue > 0) {
                                        XingYiPlanListViewController *ctr = [[XingYiPlanListViewController alloc] init];
                                        ctr.movieId = linkUrl_movieId;
                                        ctr.cinemaId = cinema_id;
                                        ctr.isFromBanner = YES;
                                        Constants.isShowBackBtn = YES;
                                        [weakSelf.navigationController pushViewController:ctr animated:YES];
                                    }
                                    [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                    
                                } failure:^(NSError * _Nullable err) {
                                    
                                    [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                    [CIASPublicUtility showAlertViewForTaskInfo:err];
                                    
                                }];
                            } else {
                                //有影院id，不相等，不跳转
                                
                            }
                            
                        } else {
                            //没有影院，根据用户选择的来跳转
                            [[UIConstants sharedDataEngine] loadingAnimation];
                            NSString *cinema_id = USER_CINEMAID;
                            NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:cinema_id, @"cinemaId",linkUrl_movieId, @"filmId", nil];
                            DLog(@"movieid:%@", linkUrl_movieId);
                            MovieRequest *request = [[MovieRequest alloc] init];
                            [request requestMovieDetailParams:pagrams success:^(Movie * _Nullable movie) {
                                DLog(@"%@", movie);
                                if (movie.movieId.intValue > 0) {
                                    XingYiPlanListViewController *ctr = [[XingYiPlanListViewController alloc] init];
                                    ctr.movieId = linkUrl_movieId;
                                    ctr.cinemaId = cinema_id;
                                    ctr.isFromBanner = YES;
                                    Constants.isShowBackBtn = YES;
                                    [weakSelf.navigationController pushViewController:ctr animated:YES];
                                }
                                [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                
                            } failure:^(NSError * _Nullable err) {
                                
                                [[UIConstants sharedDataEngine] stopLoadingAnimation];
                                [CIASPublicUtility showAlertViewForTaskInfo:err];
                                
                            }];
                        }
                        
                    }
                }
            }
        }
    }];
    
    //MARK: 加入影票未领取通知，点击跳转票根页
    
    gotoOrderDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerTableView addSubview:gotoOrderDetailBtn];
    gotoOrderDetailBtn.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    [gotoOrderDetailBtn addTarget:self action:@selector(gotoOrderDetailClick) forControlEvents:UIControlEventTouchUpInside];
    gotoOrderDetailBtn.contentMode = UIViewContentModeScaleAspectFit;
    [gotoOrderDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(headerTableView);
        make.top.equalTo(bannerView.mas_bottom).offset(0);
        make.size.mas_equalTo(CGSizeMake(kCommonScreenWidth, 0));
    }];
    
    UIImage *gotoOrderImage = [UIImage imageNamed:@"push_icon"];
    gotoOrderImageView = [[UIImageView alloc] init];
    [gotoOrderDetailBtn addSubview:gotoOrderImageView];
    gotoOrderImageView.image = gotoOrderImage;
    gotoOrderImageView.contentMode = UIViewContentModeScaleAspectFit;
    [gotoOrderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gotoOrderDetailBtn.mas_left).offset(15);
        make.top.equalTo(gotoOrderDetailBtn.mas_top).offset(8);
        make.size.mas_equalTo(CGSizeMake(gotoOrderImage.size.width, 0));
    }];
    
    NSString *tipLabelStr = @"亲，您有30张影票还未领取！";
    CGSize tipLabelStrSize = [KKZTextUtility measureText:tipLabelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:14]];
    gotoOrderTipLabel = [[UILabel alloc] init];
    [gotoOrderDetailBtn addSubview:gotoOrderTipLabel];
    gotoOrderTipLabel.text = @"";
    gotoOrderTipLabel.font = [UIFont systemFontOfSize:14];
    gotoOrderTipLabel.textColor = [UIColor colorWithHex:@"#333333"];
    [gotoOrderTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gotoOrderImageView.mas_right).offset(15);
        make.centerY.equalTo(gotoOrderDetailBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(tipLabelStrSize.width+5, 0));
    }];
    
    UIImage *gotoOrderTipImage = [UIImage imageNamed:@"home_more"];
    gotoOrderTipImageView = [[UIImageView alloc] init];
    [gotoOrderDetailBtn addSubview:gotoOrderTipImageView];
    gotoOrderTipImageView.image = gotoOrderTipImage;
    gotoOrderTipImageView.contentMode = UIViewContentModeScaleAspectFit;
    [gotoOrderTipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(gotoOrderDetailBtn.mas_right).offset(-15);
        make.centerY.equalTo(gotoOrderDetailBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(gotoOrderTipImage.size.width, 0));
    }];
    
    
    UIView *yellowView = [UIView new];
    yellowView.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
    [headerTableView addSubview:yellowView];
    [yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(gotoOrderDetailBtn.mas_bottom).offset(25);
        make.width.equalTo(@(4));
        make.height.equalTo(@(13));
    }];
    UILabel *sectionLabel = [UILabel new];
    sectionLabel.text = @"热映影片";
    sectionLabel.backgroundColor = [UIColor clearColor];
    sectionLabel.textColor = [UIColor colorWithHex:@"333333"];
    sectionLabel.font = [UIFont systemFontOfSize:14];
    [headerTableView addSubview:sectionLabel];
    [sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yellowView.mas_right).offset(5);
        make.top.equalTo(gotoOrderDetailBtn.mas_bottom).offset(25);
        make.width.equalTo(@(80));
        make.height.equalTo(@(14));
    }];
    
//    gotoOrderTipImage
    
    UILabel *moreFilmLabel = [[UILabel alloc] init];
    moreFilmLabel.textColor = [UIColor colorWithHex:@"#333333"];
    moreFilmLabel.font = [UIFont systemFontOfSize:13];
    moreFilmLabel.text = @"更多";
    [headerTableView addSubview:moreFilmLabel];
    [moreFilmLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerTableView.mas_right).offset(-(5+15+gotoOrderTipImage.size.width));
        make.size.mas_equalTo(CGSizeMake(28, 13));
        make.centerY.equalTo(sectionLabel.mas_centerY);
    }];
    
    UIImageView *moreFilmImageView = [[UIImageView alloc] init];
    moreFilmImageView.image = gotoOrderTipImage;
    [headerTableView addSubview:moreFilmImageView];
    [moreFilmImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerTableView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(gotoOrderTipImage.size.width, gotoOrderTipImage.size.height));
        make.centerY.equalTo(sectionLabel.mas_centerY);
    }];
    
    UIButton *gotoMovieBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gotoMovieBtn.backgroundColor = [UIColor clearColor];
    [headerTableView addSubview:gotoMovieBtn];
    [gotoMovieBtn addTarget:self action:@selector(gotoMovieListBtn) forControlEvents:UIControlEventTouchUpInside];
    [gotoMovieBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.top.equalTo(gotoOrderDetailBtn.mas_bottom).offset(5);
        make.height.equalTo(@(40));
    }];
    
    UICollectionViewFlowLayout *movieFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [movieFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    movieCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:movieFlowLayout];
    movieCollectionView.backgroundColor = [UIColor clearColor];
    [headerTableView addSubview:movieCollectionView];
    movieCollectionView.showsHorizontalScrollIndicator = NO;
    movieCollectionView.delegate = self;
    movieCollectionView.dataSource = self;
    [movieCollectionView registerClass:[MovieListPosterCollectionViewCell class] forCellWithReuseIdentifier:@"MovieListPosterCollectionViewCell"];
    [movieCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(yellowView.mas_bottom).offset(15);
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(158+20));
    }];
    
    
#if kIsHaveGoodsInHome
    //MARK: 判断商品有无
    yellowView1 = [UIView new];
    yellowView1.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
    [headerTableView addSubview:yellowView1];
    [yellowView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(movieCollectionView.mas_bottom).offset(25);
        make.width.equalTo(@(4));
        make.height.equalTo(@(13));//13
    }];
    sectionLabel1 = [UILabel new];
    sectionLabel1.text = @"热卖商城";
    sectionLabel1.backgroundColor = [UIColor clearColor];
    sectionLabel1.textColor = [UIColor colorWithHex:@"333333"];
    sectionLabel1.font = [UIFont systemFontOfSize:14];
    [headerTableView addSubview:sectionLabel1];
    [sectionLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yellowView1.mas_right).offset(5);
        make.top.equalTo(movieCollectionView.mas_bottom).offset(25);
        make.width.equalTo(@(80));
        make.height.equalTo(@(14));//14
    }];
    gotoProductBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gotoProductBtn.backgroundColor = [UIColor clearColor];
    [headerTableView addSubview:gotoProductBtn];
    //    [gotoProductBtn addTarget:self action:@selector(gotoCinemaListBtn) forControlEvents:UIControlEventTouchUpInside];
    [gotoProductBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.top.equalTo(movieCollectionView.mas_bottom).offset(5);
        make.height.equalTo(@(40));//40
    }];
    
    UICollectionViewFlowLayout *productFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [productFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    productCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:productFlowLayout];
    productCollectionView.backgroundColor = [UIColor clearColor];
    [headerTableView addSubview:productCollectionView];
    productCollectionView.showsHorizontalScrollIndicator = NO;
    productCollectionView.delegate = self;
    productCollectionView.dataSource = self;
    [productCollectionView registerClass:[ProductCollectionViewCell class] forCellWithReuseIdentifier:@"ProductCollectionViewCell"];

    [productCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(yellowView1.mas_bottom).offset(15);
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(105+40));//105+40
    }];
#else 
    //MARK: 判断商品有无
    yellowView1 = [UIView new];
    yellowView1.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
    [headerTableView addSubview:yellowView1];
    [yellowView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(movieCollectionView.mas_bottom).offset(25);
        make.width.equalTo(@(4));
        make.height.equalTo(@(0));//13
    }];
    sectionLabel1 = [UILabel new];
    sectionLabel1.text = @"热卖商城";
    sectionLabel1.backgroundColor = [UIColor clearColor];
    sectionLabel1.textColor = [UIColor colorWithHex:@"333333"];
    sectionLabel1.font = [UIFont systemFontOfSize:14];
    [headerTableView addSubview:sectionLabel1];
    [sectionLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yellowView1.mas_right).offset(5);
        make.top.equalTo(movieCollectionView.mas_bottom).offset(25);
        make.width.equalTo(@(80));
        make.height.equalTo(@(0));//14
    }];
    gotoProductBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gotoProductBtn.backgroundColor = [UIColor clearColor];
    [headerTableView addSubview:gotoProductBtn];
    //    [gotoProductBtn addTarget:self action:@selector(gotoCinemaListBtn) forControlEvents:UIControlEventTouchUpInside];
    [gotoProductBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.top.equalTo(movieCollectionView.mas_bottom).offset(5);
        make.height.equalTo(@(0));//40
    }];
    
    UICollectionViewFlowLayout *productFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [productFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    productCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:productFlowLayout];
    productCollectionView.backgroundColor = [UIColor clearColor];
    [headerTableView addSubview:productCollectionView];
    productCollectionView.showsHorizontalScrollIndicator = NO;
    productCollectionView.delegate = self;
    productCollectionView.dataSource = self;
    [productCollectionView registerClass:[ProductCollectionViewCell class] forCellWithReuseIdentifier:@"ProductCollectionViewCell"];
    
    [productCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(yellowView1.mas_bottom).offset(15);
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(0));//105+40
    }];
#endif
    
    UIView *cinemaSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 43)];
    cinemaSectionView.backgroundColor = [UIColor whiteColor];
    [headerTableView addSubview:cinemaSectionView];
    [cinemaSectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(headerTableView.mas_bottom).offset(-43);
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(43));
    }];
    
    UIView *yellowView3 = [UIView new];
    yellowView3.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
    [cinemaSectionView addSubview:yellowView3];
    [yellowView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(@(15));
        make.width.equalTo(@(4));
        make.height.equalTo(@(13));
    }];
    UILabel *sectionLabel3 = [UILabel new];
#if K_XINGYI
    sectionLabel3.text = @"星轶影城";
#elif K_ZHONGDU
    sectionLabel3.text = @"中都国际影城";
#elif K_HUACHEN
    sectionLabel3.text = @"华臣影业";
#elif K_BAOSHAN
    sectionLabel3.text = @"指点未来影院";
#elif K_HENGDIAN
    sectionLabel3.text = @"横店";
#else
    sectionLabel3.text = @"指点未来影院";
#endif

    sectionLabel3.backgroundColor = [UIColor clearColor];
    sectionLabel3.textColor = [UIColor colorWithHex:@"000000"];
    sectionLabel3.font = [UIFont systemFontOfSize:14];
    [cinemaSectionView addSubview:sectionLabel3];
    [sectionLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yellowView.mas_right).offset(5);
        make.top.equalTo(@(15));
        make.width.equalTo(@(150));
        make.height.equalTo(@(14));
    }];
    
    UILabel *moreLabel = [[UILabel alloc] init];
    moreLabel.textColor = [UIColor colorWithHex:@"#333333"];
    moreLabel.font = [UIFont systemFontOfSize:13];
    moreLabel.text = @"更多";
    [cinemaSectionView addSubview:moreLabel];
    [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerTableView.mas_right).offset(-(5+15+gotoOrderTipImage.size.width));
        make.size.mas_equalTo(CGSizeMake(28, 13));
        make.centerY.equalTo(sectionLabel3.mas_centerY);
    }];
    
    UIImageView *moreImageView = [[UIImageView alloc] init];
    moreImageView.image = gotoOrderTipImage;
    [cinemaSectionView addSubview:moreImageView];
    [moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerTableView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(gotoOrderTipImage.size.width, gotoOrderTipImage.size.height));
        make.centerY.equalTo(sectionLabel3.mas_centerY);
    }];
    
    
    
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [cinemaSectionView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(cinemaSectionView);
        make.top.equalTo(cinemaSectionView.mas_bottom).offset(-0.5);
        make.height.equalTo(@(0.5));
    }];
    
    
    
    UIButton *gotoCinemaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gotoCinemaBtn.backgroundColor = [UIColor clearColor];
    [cinemaSectionView addSubview:gotoCinemaBtn];
    [gotoCinemaBtn addTarget:self action:@selector(gotoCinemaListBtn) forControlEvents:UIControlEventTouchUpInside];
    [gotoCinemaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@(0));
        make.top.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth));
//        make.top.equalTo(productCollectionView.mas_bottom).offset(5);
        make.height.equalTo(@(40));
    }];
    
}

- (void)requestBannerList {
    AppConfigureRequest *request = [[AppConfigureRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *pagrams = [[NSDictionary alloc] init];
    pagrams = [NSDictionary dictionaryWithObjectsAndKeys:USER_CINEMAID,@"cinemaId", nil];
    [request requestQueryBannerParams:pagrams success:^(NSArray * _Nullable data) {

        [weakSelf.bannerList removeAllObjects];
        if (data.count > 0) {
            [weakSelf.bannerList addObjectsFromArray:data];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [bannerView loadContenWithArr:weakSelf.bannerList];
            [homeTableView reloadData];
        });
    } failure:^(NSError * _Nullable err) {
        NSLog(@"%@", err);
    }];
//    [request requestQueryBannerTemplateParams:nil success:^(NSArray * _Nullable data) {
//        if (data.count > 0) {
//            [weakSelf.bannerList removeAllObjects];
//            [weakSelf.bannerList addObjectsFromArray:data];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [bannerView loadContenWithArr:weakSelf.bannerList];
//            [homeTableView reloadData];
//        });
//                           
//    } failure:^(NSError * _Nullable err) {
//        
//    }];
}

//MARK:-- 跳转票根页
- (void) gotoOrderDetailClick {
    DLog(@"跳转票根页展示");
    NSDictionary *orderDic = [self.homeOrderDic kkz_objForKey:@"data"];
    OrderDetailViewController *mpVC = [[OrderDetailViewController alloc] init];
    mpVC.orderNo = [orderDic kkz_stringForKey:@"orderCode"];
    [self.navigationController pushViewController:mpVC animated:YES];
    
}
//MARK: --请求影片列表
- (void)requestMovieList:(NSUInteger)page {
    MovieRequest *request = [[MovieRequest alloc] init];
    
    __weak __typeof(self) weakSelf = self;
    NSDictionary *pagrams = [[NSDictionary alloc] init];
    pagrams = [NSDictionary dictionaryWithObjectsAndKeys:USER_CINEMAID,@"cinemaId", USER_CITY, @"cityId", nil];
    [request requestMovieListParams:pagrams success:^(NSArray * _Nullable movies) {
        [weakSelf.movieList removeAllObjects];
        [weakSelf.movieList addObjectsFromArray:movies];
        if (weakSelf.movieList.count>0) {
            if (weakSelf.noMovieListAlertView.superview) {
                [weakSelf.noMovieListAlertView removeFromSuperview];
            }
        }else {
            if (weakSelf.noMovieListAlertView.superview) {
            } else {
                [movieCollectionView addSubview:weakSelf.noMovieListAlertView];
            }
        }
        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
            [movieCollectionView reloadData];
            [homeTableView reloadData];
        });
    } failure:^(NSError * _Nullable err) {
        if (weakSelf.movieList.count>0) {
            if (weakSelf.noMovieListAlertView.superview) {
                [weakSelf.noMovieListAlertView removeFromSuperview];
            }
        }else {
            if (weakSelf.noMovieListAlertView.superview) {
            } else {
                [movieCollectionView addSubview:weakSelf.noMovieListAlertView];
            }
        }
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
    
}

- (void)requestCinemaList{
    [[UIConstants sharedDataEngine] loadingAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    
    if ([USER_CITY length]>0) {
        [params setObject:USER_CITY forKey:@"cityId"];
    }
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
        [weakSelf endRefreshing];
        [weakSelf.cinemaList removeAllObjects];
        [weakSelf.cinemaList addObjectsFromArray:data];
//        if (isFirstInit && weakSelf.cinemaList.count && [USER_CINEMAID length]<=0) {
//            Cinema *cinema = [self.cinemaList objectAtIndex:0];
//            USER_CINEMAID_WRITE(cinema.cinemaId);
//            USER_CINEMA_NAME_WRITE(cinema.cinemaName);
//            USER_CINEMA_ADDRESS_WRITE(cinema.address);
//            CINEMA_LATITUDE_WRITE(cinema.lat);
//            CINEMA_LONGITUDE_WRITE(cinema.lon);
//            cinemaNameLabel.text = [NSString stringWithFormat:@"附近影院：%@", [USER_CINEMA_NAME length]?USER_CINEMA_NAME:@""];
//        }else{
        
//        }
        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
            [homeTableView reloadData];
        });
        [[UIConstants sharedDataEngine] stopLoadingAnimation];

    } failure:^(NSError * _Nullable err) {
        [weakSelf endRefreshing];
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];

    }];
    
}

- (void)requestAPPConfig{
    AppConfigureRequest *request = [[AppConfigureRequest alloc] init];
    [request requestQueryConfigParams:nil success:^(AppConfig * _Nullable data) {
        
    } failure:^(NSError * _Nullable err) {
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
}

- (void)requestAPPTemplate{
    AppConfigureRequest *request = [[AppConfigureRequest alloc] init];
    [request requestQueryTemplateParams:nil success:^(NSDictionary * _Nullable data) {
        
    } failure:^(NSError * _Nullable err) {
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
}

- (void) selectBanner:(void (^)(NSInteger index))a_block
{
    [bannerView setSelectCallback:a_block];
}

- (void)selectCinemaBtn{
    CinemaListViewController *ctr = [[CinemaListViewController alloc] init];
    ctr.selectCinemaBlock = ^(NSString *cinemaId){
//        cinemaNameLabel.text = [NSString stringWithFormat:@"附近影院：%@", [USER_CINEMA_NAME length]?USER_CINEMA_NAME:@""];
//        __weak __typeof(self) weakSelf = self;
//        [weakSelf requestBannerList];
//        [weakSelf requestMovieList:1];
//        [weakSelf requestCinemaList];
#if kIsHaveGoodsInHome
        [self requestProductList];
#endif
    };
    [self.navigationController pushViewController:ctr animated:YES];
}

- (void)gotoMovieListBtn{
#if kIsHuaChenTmpTabbarStyle
    Constants.segmentIndex = 0;
    [Constants.appDelegate setHomeSelectedTabAtIndex:1];
#else
    Constants.segmentIndex = 0;
    [Constants.appDelegate setHomeSelectedTabAtIndex:1];
#endif
    
}

- (void)gotoCinemaListBtn{
#if kIsHuaChenTmpTabbarStyle
    Constants.segmentIndex = 1;
    [Constants.appDelegate setHomeSelectedTabAtIndex:1];
#else
    Constants.segmentIndex = 1;
    [Constants.appDelegate setHomeSelectedTabAtIndex:1];
#endif
    
}


- (void)changeCitySucceeded{
}

- (void)changeCinemaSucceeded{
    DLog(@"cityId = %@, cityName=%@", USER_CITY, USER_CITY_NAME);
    DLog(@"cinemaId = %@, cinemaName=%@", USER_CINEMAID, USER_CINEMA_NAME);

    NSString *cinemaStr = USER_CINEMA_NAME;
    cinemaNameLabel.text = [NSString stringWithFormat:@"%@", ([cinemaStr length]&&(![cinemaStr isEqualToString:@"(null)"])&&(![cinemaStr isEqualToString:@"null"]))?USER_CINEMA_NAME:@""];
    
    //    [self requestBannerList];
    [self requestMovieList:1];
    [self requestCinemaList];

}


#pragma mark --UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio{
    if (collectionView==productCollectionView) {
        return self.productList.count;
    }else if (collectionView==movieCollectionView){
        return self.movieList.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    //    if (collectionView==incomingDateCollectionView) {
    //        return 1;
    //    }
    return 1;
}

//定义此UICollectionView在父类上面的位置
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView==productCollectionView) {
        return UIEdgeInsetsMake(0, 15, 0, 0);
    }else if (collectionView==movieCollectionView){
        return UIEdgeInsetsMake(0, 15, 0, 0);
    }
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView==productCollectionView) {
        return 8;
    }else if (collectionView==movieCollectionView) {
        return 8;
    }
    
    return 0;
}
//定义每个UICollectionView 横向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView==productCollectionView) {
        return 0;
    }else if (collectionView==movieCollectionView) {
        return 0;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==productCollectionView) {
        return CGSizeMake(105, 105+40);
    }else if (collectionView==movieCollectionView) {
        return CGSizeMake(105, 158+20);
    }
    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==productCollectionView) {
        static NSString *identify = @"ProductCollectionViewCell";
        ProductCollectionViewCell *cell = (ProductCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell sizeToFit];
        if (!cell) {
            NSLog(@"无法创建MovieListPosterCollectionViewCell时打印，自定义的cell就不可能进来了。");
        }
        if (self.productList.count>0) {
            Product *product = [self.productList objectAtIndex:indexPath.row];
            NSString *urlStr = @"";
            if ([product.showPictureUrl hasPrefix:@"http://"]||[product.showPictureUrl hasPrefix:@"https://"]) {
                urlStr = product.showPictureUrl;
            }
            
            cell.imageUrl = urlStr;
            cell.productName = [NSString stringWithFormat:@"%@", product.couponName];
            cell.productPrice = [product.saleChannel kkz_stringForKey:@"salePrice"];
            cell.backgroundColor = [UIColor clearColor];
            [cell updateLayout];
        }
        
        return cell;
        
    }else if (collectionView==movieCollectionView) {
        static NSString *identify = @"MovieListPosterCollectionViewCell";
        MovieListPosterCollectionViewCell *cell = (MovieListPosterCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell sizeToFit];
        if (!cell) {
            NSLog(@"无法创建MovieListPosterCollectionViewCell时打印，自定义的cell就不可能进来了。");
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.posterImageBackColor = @"ffffff";
        Movie *movie = [self.movieList objectAtIndex:indexPath.row];
        cell.movieName = movie.filmName;
        cell.imageUrl = movie.filmPoster;
        cell.point = movie.point;
        cell.availableScreenType = movie.availableScreenType;
        cell.isSale = [movie.isDiscount boolValue];
        cell.isPresell = [movie.isPresell boolValue];
        [cell updateLayout];
        
        return cell;
        
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==productCollectionView) {
//        PayViewController *ctr = [[PayViewController alloc] init];
//        TicketOutFailedViewController *ctr = [[TicketOutFailedViewController alloc] init];
//        OrderDetailViewController *ctr = [[OrderDetailViewController alloc] init];
        //ctr.amovie = movie;
//        [self.navigationController pushViewController:ctr animated:YES];

    }else if (collectionView==movieCollectionView) {
        Movie *movie = [self.movieList objectAtIndex:indexPath.row];
        MovieDetailViewController *ctr = [[MovieDetailViewController alloc] init];
        ctr.myMovie = movie;
        ctr.isReying = YES;
        MovieListPosterCollectionViewCell *cell = (MovieListPosterCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
        self.sf_targetView = cell.moviePosterImage;
        [self.navigationController pushViewController:ctr animated:YES];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}




#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CinemaCell";
    Cinema *managerment = [self.cinemaList objectAtIndex:indexPath.row];
    CinemaCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CinemaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.cinemaName = managerment.cinemaName;
    cell.cinemaAddress = managerment.address;
    cell.distance = managerment.distance;
    cell.isCome = managerment.isCome;
    cell.isnear = managerment.isNear;
#if kIsHaveTipLabelInCinemaList
    DLog(@"%@", managerment.serviceFeatures);
    if (managerment.serviceFeatures.count > 0) {
        cell.featureArr = managerment.serviceFeatures;
    }else {
        cell.featureArr = [NSArray array];
    }
#endif
    
    [cell updateLayout];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cinemaList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeight = 0.0;
#if kIsHaveTipLabelInCinemaList
    Cinema *cinema = [self.cinemaList objectAtIndex:indexPath.row];
    
    NSString *cinemaFeatureStr = @"D BOX厅";
    CGSize cinemaFeatureStrSize = [KKZTextUtility measureText:cinemaFeatureStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:10]];
    
    if (cinema.serviceFeatures.count>0) {
        cellHeight = 67+cinemaFeatureStrSize.height+10+7+15;
    } else {
        cellHeight = 67;
    }
#else
    cellHeight = 67;
#endif
    
    return cellHeight*Constants.screenHeightRate;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Cinema *cinema = [self.cinemaList objectAtIndex:indexPath.row];
    
    if ([kIsXinchengPlanListStyle isEqualToString:@"1"]) {
        XingYiPlanListViewController *ctr = [[XingYiPlanListViewController alloc] init];
        ctr.movieId = @"";
        ctr.cinemaId = cinema.cinemaId;
        ctr.isFromHome = YES;
        Constants.isShowBackBtn = YES;
        [self.navigationController pushViewController:ctr animated:YES];
    }
    if ([kIsCMSStandardPlanListStyle isEqualToString:@"1"]) {
        PlanListViewController *ctr = [[PlanListViewController alloc] init];
        ctr.movieId = @"";
        ctr.cinemaId = cinema.cinemaId;
        ctr.cinemaName = cinema.cinemaName;
        [self.navigationController pushViewController:ctr animated:YES];
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 43)];
    sectionView.backgroundColor = [UIColor whiteColor];
    //    [sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(@(0));
    //        make.top.equalTo(@(0));
    //        make.width.equalTo(@(kCommonScreenWidth));
    //        make.height.equalTo(@(43));
    //    }];
    
    UIView *yellowView = [UIView new];
    yellowView.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].withColor];
    [sectionView addSubview:yellowView];
    [yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(@(15));
        make.width.equalTo(@(4));
        make.height.equalTo(@(13));
    }];
    UILabel *sectionLabel = [UILabel new];
    
#if K_XINGYI
    sectionLabel.text = @"星轶影城";
#elif K_ZHONGDU
    sectionLabel.text = @"中都国际影城";
#elif K_HUACHEN
    sectionLabel.text = @"华臣影业";
#elif K_BAOSHAN
    sectionLabel.text = @"指点未来影院";
#elif K_HENGDIAN
    sectionLabel.text = @"横店";
#else
    sectionLabel.text = @"指点未来影院";
#endif
    sectionLabel.backgroundColor = [UIColor clearColor];
    sectionLabel.textColor = [UIColor colorWithHex:@"000000"];
    sectionLabel.font = [UIFont systemFontOfSize:14];
    [sectionView addSubview:sectionLabel];
    [sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(yellowView.mas_right).offset(5);
        make.top.equalTo(@(15));
        make.width.equalTo(@(150));
        make.height.equalTo(@(14));
    }];
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [sectionView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(sectionView);
        make.top.equalTo(sectionView.mas_bottom).offset(-1);
        make.height.equalTo(@(1));
    }];
    
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;//43;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 69) {
        CGFloat alpha = scrollView.contentOffset.y / 69;
        if (alpha>0.5) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            cinemaNameView.alpha = 1.0;
            [cinemaNameView setBackgroundColor:[UIColor whiteColor]];
            cinemaNameView.layer.borderColor = [UIColor colorWithHex:@"e0e0e0"].CGColor;
            cinemaNameView.layer.borderWidth = 0.5;
            arrowImageView.image = [UIImage imageNamed:@"home_location_arrow2"];
            cinemaNameLabel.textColor = [UIColor colorWithHex:@"333333"];
//            NSString *cinemaStr = USER_CINEMA_NAME;
//            NSMutableAttributedString *cinemaString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%@", ([cinemaStr length]&&(![cinemaStr isEqualToString:@"(null)"])&&(![cinemaStr isEqualToString:@"null"]))?USER_CINEMA_NAME:@""]]];
//            NSRange redRange = NSMakeRange([[cinemaString string] rangeOfString:@"附近影院："].location, [[cinemaString string] rangeOfString:@""].length);
//            //需要设置的位置
//            [cinemaString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"b2b2b2"] range:redRange];
//            //设置颜色
//            [cinemaNameLabel setAttributedText:cinemaString];
        }else{
            //            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            cinemaNameView.alpha = 0.5;
            [cinemaNameView setBackgroundColor:[UIColor blackColor]];
            cinemaNameView.layer.borderWidth = 0.0;
            arrowImageView.image = [UIImage imageNamed:@"home_location_arrow1"];
            cinemaNameLabel.textColor = [UIColor colorWithHex:@"ffffff"];
        }
        if (alpha>0.7) {
            self.navBar.alpha = 0.8;
        }else{
            self.navBar.alpha = alpha;
        }
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        self.navBar.alpha = 0.8;
    }
}


/**
 *  结束刷新
 */
- (void)endRefreshing {
    if ([homeTableView.mj_header isRefreshing]) {
        [homeTableView.mj_header endRefreshing];
    }
}

- (void)gpsCityGetSucceeded {
    /*
    DLog(@"USER_GPS_CITY ==%@", USER_GPS_CITY);
    DLog(@"USER_HASLAUNCHED ==%d", USER_HASLAUNCHED);
    //经纬度解析城市成功
    //定位成功
    if (!USER_HASLAUNCHED) {
        //APP第一次安装
        //经纬度反编译城市成功
        City *city = [[CityManager shareInstance]  getCityWithName:USER_GPS_CITY];
        if (city) {
//            [self requestBannerList];
            [self requestMovieList:1];
            [self requestCinemaList];
            USER_HASLAUNCHED_WRITE(YES);
            
        }else{
            __weak __typeof(self) weakSelf = self;
            
            CityListViewController *cityCtr = [[CityListViewController alloc] init];
            cityCtr.selectCityBlock = ^(NSString *cityId){
                CinemaListViewController *ctr = [[CinemaListViewController alloc] init];
                ctr.selectCinemaBlock = ^(NSString *cinemaId){
                    cinemaNameLabel.text = [NSString stringWithFormat:@"附近影院：%@", [USER_CINEMA_NAME length]?USER_CINEMA_NAME:@""];
//                    [weakSelf requestBannerList];
                    [weakSelf requestMovieList:1];
                    [weakSelf requestCinemaList];
                };
                [weakSelf.navigationController pushViewController:ctr animated:YES];
            };
            [weakSelf.navigationController pushViewController:cityCtr animated:YES];
            
            USER_HASLAUNCHED_WRITE(YES);
            
        }
        
        
        if (isFirstInit) {
            
            //应用第一次启动
            if ([USER_GPS_CITY length]>0) {
                
            }else{
                //经纬度反编译城市失败或者暂时没有解析成功
                
            }
            
        }
        
    }
     */
}

- (void)gpsCityGetFailed {
    DLog(@"gpsCityGetFailed USER_GPS_CITY ==%@", USER_GPS_CITY);
    DLog(@"gpsCityGetFailed USER_HASLAUNCHED ==%d", USER_HASLAUNCHED);
    /*
    if (!USER_HASLAUNCHED) {
        __weak __typeof(self) weakSelf = self;
        
        CityListViewController *cityListCtr = [[CityListViewController alloc] init];
        cityListCtr.selectCityBlock = ^(NSString *cityId){
            CinemaListViewController *ctr = [[CinemaListViewController alloc] init];
            ctr.selectCinemaBlock = ^(NSString *cinemaId){
                cinemaNameLabel.text = [NSString stringWithFormat:@"附近影院：%@", [USER_CINEMA_NAME length]?USER_CINEMA_NAME:@""];
//                [weakSelf requestBannerList];
                [weakSelf requestMovieList:1];
                [weakSelf requestCinemaList];
            };
            [weakSelf.navigationController pushViewController:ctr animated:YES];
        };
        
        [weakSelf.navigationController pushViewController:cityListCtr animated:YES];
        USER_HASLAUNCHED_WRITE(YES);
        
    }
    */
}

- (void)locationGet:(NSNotification *)notification {
    DLog(@"USER_GPS_CITY ==%@", USER_GPS_CITY);
    DLog(@"USER_HASLAUNCHED ==%d", USER_HASLAUNCHED);
    
}

- (void)locationGetFailed:(NSNotification *)notification {
    DLog(@"locationGetFailed USER_GPS_CITY ==%@", USER_GPS_CITY);
    DLog(@"USER_HASLAUNCHED ==%d", USER_HASLAUNCHED);
}

@end
