//
//  PlanListViewController.m
//  CIASMovie
//
//  Created by cias on 2016/12/21.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "PlanListViewController.h"
#import "PlanDateCollectionViewCell.h"
#import "PlanTimeCollectionViewCell.h"
#import "ChooseSeatViewController.h"
#import "CinemaListViewController.h"
#import "Plan.h"
#import "PlanDate.h"
#import "PlanRequest.h"
#import <Category_KKZ/UIImage+Resize.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Movie.h"
#import "UserDefault.h"
#import "KKZTextUtility.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "TicketOutFailedViewController.h"
#import <DateEngine_KKZ/DateEngine.h>
//#import <Category_KKZ/NSDictionaryExtra.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface PlanListViewController ()

@end

@implementation PlanListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarBackgroundColor]]
                forBarPosition:UIBarPositionAny
                    barMetrics:UIBarMetricsDefault];
    
    [self setNavBarUI];
    [self setupUI];
    [self requestPlanDateList];
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)setupUI{
    
    
//    holder = [[UIView alloc] init];
//    holder.backgroundColor = [UIColor whiteColor];
//    [scrollViewHolder addSubview:holder];
//    [holder mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(scrollViewHolder.mas_top);
//        make.bottom.equalTo(@0);
//        make.width.equalTo(@(kCommonScreenWidth));
//        make.left.equalTo(scrollViewHolder.mas_left);
//    }];
    _planDateList = [[NSMutableArray alloc] initWithCapacity:0];
    _planList = [[NSMutableArray alloc] initWithCapacity:0];
    
    UICollectionViewFlowLayout *planDateFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    [planDateFlowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    planDateCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, (((kCommonScreenWidth-4*7.5-30)/5)*0.873)+20) collectionViewLayout:planDateFlowLayout];
    planDateCollectionView.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarBackgroundColor];
    planDateCollectionView.showsHorizontalScrollIndicator = NO;
    planDateCollectionView.delegate = self;
    planDateCollectionView.dataSource = self;
    [self.view addSubview:planDateCollectionView];
    [planDateCollectionView registerClass:[PlanDateCollectionViewCell class] forCellWithReuseIdentifier:@"PlanDateCollectionViewCell"];
    self.selectDateRow = 0;
    self.selectPlanTimeRow = 0;

    scrollViewHolder = [[UIScrollView alloc]initWithFrame:CGRectMake(0, (((kCommonScreenWidth-4*7.5-30)/5)*0.873)+20, kCommonScreenWidth, kCommonScreenHeight-((((kCommonScreenWidth-4*7.5-30)/5)*0.873)+20)-50)];
    scrollViewHolder.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollViewHolder];
    scrollViewHolder.backgroundColor = [UIColor whiteColor];
//    [scrollViewHolder mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset(((((kCommonScreenWidth-4*7.5-30)/5)*0.873)+20));
//        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//    }];

    UICollectionViewFlowLayout *planListCollectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    [planListCollectionViewLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //    moviePosterFlowLayout.headerReferenceSize = CGSizeMake(kCommonScreenWidth, 36);
    
    planListCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, (((kCommonScreenWidth-4*7.5-30)/5)*0.873)*3+15*4) collectionViewLayout:planListCollectionViewLayout];
    planListCollectionView.backgroundColor = [UIColor whiteColor];
    [scrollViewHolder addSubview:planListCollectionView];
    planListCollectionView.showsHorizontalScrollIndicator = NO;
    planListCollectionView.delegate = self;
    planListCollectionView.dataSource = self;
    [planListCollectionView registerClass:[PlanTimeCollectionViewCell class] forCellWithReuseIdentifier:@"PlanTimeCollectionViewCell"];
    //    [planListCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeaderView"];
    
//    [scrollViewHolder mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(planListCollectionView.mas_bottom).offset(80);
//    }];
    
    timeShadowImageview = [UIImageView new];
    timeShadowImageview.backgroundColor = [UIColor clearColor];
    timeShadowImageview.contentMode = UIViewContentModeScaleAspectFill;
    timeShadowImageview.image = [UIImage imageNamed:@"time_shadow"];
    [scrollViewHolder addSubview:timeShadowImageview];
    [timeShadowImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(planListCollectionView.mas_bottom);
        make.left.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(15));
    }];
    
    cinemaPosterImageView = [UIImageView new];
    cinemaPosterImageView.backgroundColor = [UIColor colorWithHex:@"#f2f5f5"];
    cinemaPosterImageView.layer.cornerRadius = 3.5;
    cinemaPosterImageView.clipsToBounds = YES;
    [scrollViewHolder addSubview:cinemaPosterImageView];
    [cinemaPosterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeShadowImageview.mas_bottom);
        make.left.equalTo(@(15));
        make.width.equalTo(@(kCommonScreenWidth-30));
        make.height.equalTo(@(145));
        
    }];
    
    hallNameView = [UIView new];
    [cinemaPosterImageView addSubview:hallNameView];
    hallNameView.backgroundColor = [UIColor blackColor];
    hallNameView.alpha = 0.85;
    hallNameView.layer.cornerRadius = 3.5;
    [hallNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(cinemaPosterImageView);
        make.width.equalTo(@(181));
        make.height.equalTo(@(63));
    }];
    hallNameLabel = [UILabel new];
    hallNameLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
    hallNameLabel.textAlignment = NSTextAlignmentCenter;
    hallNameLabel.font = [UIFont systemFontOfSize:13];
    [hallNameView addSubview:hallNameLabel];
    [hallNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(15));
        make.left.equalTo(@(10));
        //        make.centerX.equalTo(hallNameView.mas_centerX);
        make.width.equalTo(@(161));
        make.height.equalTo(@(15));
    }];
    
    screenTypeLabel = [UILabel new];
    screenTypeLabel.textColor = [UIColor colorWithHex:@"#ffcc00"];
    screenTypeLabel.textAlignment = NSTextAlignmentCenter;
    screenTypeLabel.font = [UIFont systemFontOfSize:10];
    [hallNameView addSubview:screenTypeLabel];
    [screenTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hallNameLabel.mas_bottom).offset(5);
        make.left.equalTo(@(10));
        //        make.centerX.equalTo(hallNameView.mas_centerX);
        make.width.equalTo(@(161));
        make.height.equalTo(@(15));
    }];
    
    
    huiImageView = [UIImageView new];
    huiImageView.backgroundColor = [UIColor clearColor];
    huiImageView.image = [UIImage imageNamed:@"hui_tag2"];
    huiImageView.hidden = YES;
    huiImageView.contentMode = UIViewContentModeScaleAspectFit;
    huiImageView.clipsToBounds = YES;
    [scrollViewHolder addSubview:huiImageView];
    
    promotionLabel = [UILabel new];
    promotionLabel.textColor = [UIColor colorWithHex:@"#333333"];
    promotionLabel.textAlignment = NSTextAlignmentLeft;
    promotionLabel.hidden = YES;
    promotionLabel.font = [UIFont systemFontOfSize:13];
    [scrollViewHolder addSubview:promotionLabel];
    
    [huiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(cinemaPosterImageView.mas_bottom).offset(10);
        make.width.equalTo(@(16));
        make.height.equalTo(@(16));
    }];
    
    [promotionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(huiImageView.mas_right).offset(5);
        make.top.equalTo(cinemaPosterImageView.mas_bottom).offset(10);
        make.width.equalTo(@(kCommonScreenWidth-50));
        make.height.equalTo(@(15));
        
    }];
    
    buyTicketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyTicketBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
    [buyTicketBtn setFrame:CGRectMake(0, kCommonScreenHeight-50, kCommonScreenWidth, 50)];
    [buyTicketBtn setTitle:@"去选座" forState:UIControlStateNormal];
    buyTicketBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [buyTicketBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
    [buyTicketBtn addTarget:self action:@selector(buyTicketBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyTicketBtn];
    [self.view bringSubviewToFront:buyTicketBtn];
    [buyTicketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth));
        make.top.equalTo(self.view.mas_bottom).offset(-50);
    }];
    noPlanAlertView = [[NoPlanAlertView alloc] initWithFrame:CGRectMake(0, (((kCommonScreenWidth-4*7.5-30)/5)*0.873)+20, kCommonScreenWidth, kCommonScreenHeight-((((kCommonScreenWidth-4*7.5-30)/5)*0.873)+20))];

}

- (void)setNavBarUI{
    customTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth-140, 44)];
    customTitleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = customTitleView;
    cinemaTitleLabel = [UILabel new];
    cinemaTitleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
    cinemaTitleLabel.textAlignment = NSTextAlignmentCenter;
    cinemaTitleLabel.font = [UIFont systemFontOfSize:16];
    [customTitleView addSubview:cinemaTitleLabel];
    [cinemaTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(7));
        make.left.equalTo(@(0));
        make.right.equalTo(customTitleView.mas_right).offset(-19);
        make.height.equalTo(@(15));
    }];
    
    movieTitleLabel = [UILabel new];
    movieTitleLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor];
    movieTitleLabel.textAlignment = NSTextAlignmentCenter;
    movieTitleLabel.font = [UIFont systemFontOfSize:13];
    [customTitleView addSubview:movieTitleLabel];
    [movieTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cinemaTitleLabel.mas_bottom).offset(5);
        make.left.equalTo(@(0));
        make.right.equalTo(customTitleView.mas_right).offset(0);
        make.height.equalTo(@(13));
    }];
    
    arrowImageView = [UIImageView new];
    arrowImageView.backgroundColor = [UIColor clearColor];
    arrowImageView.clipsToBounds = YES;
    arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    arrowImageView.image = [UIImage imageNamed:@"home_location_arrow2"];
    [customTitleView addSubview:arrowImageView];
    
    UIButton *selectCinemaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectCinemaBtn.frame = CGRectMake(0, 0, customTitleView.frame.size.width, 44);
    selectCinemaBtn.backgroundColor = [UIColor clearColor];
    [selectCinemaBtn addTarget:self action:@selector(gotoCinemaBtn) forControlEvents:UIControlEventTouchUpInside];
    [customTitleView addSubview:selectCinemaBtn];
    
    UIButton *gotoMapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gotoMapBtn.frame = CGRectMake(10, kCommonScreenWidth-15-28, 28, 28);
    gotoMapBtn.backgroundColor = [UIColor clearColor];
    [gotoMapBtn setImage:[UIImage imageNamed:@"titlebar_map"] forState:UIControlStateNormal];
    [gotoMapBtn addTarget:self action:@selector(gotoMapBtn) forControlEvents:UIControlEventTouchUpInside];
    gotoMapBtn.contentMode = UIViewContentModeScaleAspectFit;
    //    gotoMapBtn
    UIBarButtonItem *mapItem = [[UIBarButtonItem alloc] initWithCustomView:gotoMapBtn];
    self.navigationItem.rightBarButtonItem = mapItem;
//    self.cinemaName = @"北京金逸朝阳大悦城店北京金逸朝阳大悦城店";
    cinemaTitleLabel.text = self.cinemaName;
    movieTitleLabel.text = self.movieName;
    CGSize cinemaNameSize = [KKZTextUtility measureText:self.cinemaName size:CGSizeMake(MAXFLOAT, 15) font:[UIFont systemFontOfSize:16]];
    NSInteger cinemaNamelabelWidth = (kCommonScreenWidth-140-15)>cinemaNameSize.width?cinemaNameSize.width:(kCommonScreenWidth-140-15);
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(cinemaNamelabelWidth+5));
        make.right.equalTo(customTitleView.mas_right);
        make.top.equalTo(@(13));
        make.width.equalTo(@(10));
        make.height.equalTo(@(6));
    }];

}

- (void)requestPlanDateList {

    PlanRequest *request = [[PlanRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.cinemaId,@"cinemaId", self.movieId, @"filmId", nil];
    [request requestPlanDateListParams:pagrams success:^(NSArray * _Nullable movies) {
        [weakSelf.planDateList removeAllObjects];
        [weakSelf.planDateList addObjectsFromArray:movies];

        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
            [planDateCollectionView reloadData];
        });
        
        NSDate *today = [NSDate date];
        
        NSDate *dateD = nil;
        
        if (weakSelf.planDateList.count>0) {
            PlanDate *lastDate = [weakSelf.planDateList lastObject];
            today = [[DateEngine sharedDateEngine] dateFromStringY:lastDate.showDate];
            NSInteger planCount = [weakSelf.planDateList count];
            for (int i=1; i<=5-planCount; i++) {
                DLog(@"i=%d", i);
                double timeIntervalNum = [today timeIntervalSince1970] + i*24*60*60;
                dateD = [NSDate dateWithTimeIntervalSince1970:timeIntervalNum];
                PlanDate *aModel = [[PlanDate alloc] init];
                aModel.planCount = [NSNumber numberWithInteger:0];
                aModel.showDate = [[DateEngine sharedDateEngine] stringFromDateYYYYMMDD:dateD];
                [weakSelf.planDateList addObject:aModel];
                DLog(@"i=%d, count=%ld", i, (5-weakSelf.planDateList.count));
            }
        }else{
            for (int i=0; i<5; i++) {
                double timeIntervalNum = [today timeIntervalSince1970] + i*24*60*60;
                dateD = [NSDate dateWithTimeIntervalSince1970:timeIntervalNum];
                PlanDate *aModel = [[PlanDate alloc] init];
                aModel.planCount = [NSNumber numberWithInteger:0];
                aModel.showDate = [[DateEngine sharedDateEngine] stringFromDateYYYYMMDD:dateD];
                [weakSelf.planDateList addObject:aModel];
            }
        }
        PlanDate *lastDate = [weakSelf.planDateList objectAtIndex:0];
        if ([lastDate.planCount integerValue]>0) {
            self.selectDateRow = 0;
            [weakSelf requestPlanList:0];
        }else{
            if (noPlanAlertView.superview) {
                
            }else{
                [self.view addSubview:noPlanAlertView];
            }

            self.selectDateRow = -1;

            [weakSelf.planList removeAllObjects];
            [planDateCollectionView reloadData];
            [planListCollectionView reloadData];
        }

    } failure:^(NSError * _Nullable err) {
        [CIASPublicUtility showAlertViewForTaskInfo:err];
        if (noPlanAlertView.superview) {
            
        }else{
            [self.view addSubview:noPlanAlertView];
        }

    }];
    
}

- (void)requestPlanList:(NSInteger)index {
  
    [[UIConstants sharedDataEngine] loadingAnimation];

    PlanRequest *request = [[PlanRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    PlanDate *plandate = [self.planDateList objectAtIndex:self.selectDateRow];
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.cinemaId,@"cinemaId", self.movieId,@"filmId",plandate.showDate,@"showDate", nil];

    [request requestPlanListParams:pagrams success:^(NSArray * _Nullable plans) {
        [self.planList removeAllObjects];
        [self.planList addObjectsFromArray:plans];
        [SVProgressHUD dismiss];
        for (int i=0; i<self.planList.count; i++) {
            Plan *aplan = [self.planList objectAtIndex:i];
            if ([aplan.isSale isEqualToString:@"1"]) {
                self.selectPlanTimeRow = i;
                break;
            }
        }
        DLog(@"number == %ld",_planList.count);
        
        DLog(@"_planList.count= %ld", _planList.count%5<=0?_planList.count/5:_planList.count/5+1);
        NSInteger rowNum =  _planList.count%5<=0?_planList.count/5:_planList.count/5+1;
        DLog(@"floor= %f", (floor(((kCommonScreenWidth-4*7.5-30)/5)*0.873)));

        [planListCollectionView setFrame:CGRectMake(0, 0, kCommonScreenWidth, (floor(((kCommonScreenWidth-4*7.5-30)/5)*0.873))*rowNum+30+(rowNum-1)*15)];
        [scrollViewHolder setContentSize:CGSizeMake(kCommonScreenWidth,  (floor(((kCommonScreenWidth-4*7.5-30)/5)*0.873))*rowNum+30+(rowNum-1)*15+50+15+145+30+30)];
        
        if (self.planList.count<=0) {
            if (noPlanAlertView.superview) {
                
            }else{
                [self.view addSubview:noPlanAlertView];
            }
        }else{
            if (noPlanAlertView.superview) {
                [noPlanAlertView removeFromSuperview];
            }
        }

        [weakSelf updateLayout];
        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
            [planListCollectionView reloadData];
        });
        [[UIConstants sharedDataEngine] stopLoadingAnimation];

    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
    
}

- (void)buyTicketBtnClick{
    
    if (self.planList.count) {
        buyTicketBtn.backgroundColor = [UIColor colorWithHex:@"#ffcc00"];
        PlanDate *plandate = [self.planDateList objectAtIndex:self.selectDateRow];
//        TicketOutFailedViewController *ctr = [[TicketOutFailedViewController alloc] init];
        
        NSComparisonResult result; //是否过期
        int lockTime = [klockTime intValue];
        
        NSDate *lateDate = [[NSDate date] dateByAddingTimeInterval:lockTime*60];
        NSDate *startTimeDate = [[DateEngine sharedDateEngine] dateFromString:self.selectPlan.startTime];
        result= [startTimeDate compare:lateDate];
        if (result == NSOrderedDescending) {
            
        }else{
            [CIASPublicUtility showAlertViewForTitle:@"" message:[NSString stringWithFormat:@"请在开场前%d分钟购票", lockTime] cancelButton:@"确定"];
            return;
        }
        ChooseSeatViewController *ctr = [[ChooseSeatViewController alloc] init];
        ctr.planList = self.planList;
        ctr.selectPlanDate = plandate;
        ctr.planDateString = self.selectPlan.startTime;
        ctr.selectPlanTimeRow = self.selectPlanTimeRow;
        ctr.movieId = self.movieId;
        ctr.cinemaId = self.cinemaId;
        ctr.movieName = self.movieName;
        ctr.cinemaName = self.cinemaName;
        [self.navigationController pushViewController:ctr animated:YES];
    }else{
        buyTicketBtn.backgroundColor = [UIColor colorWithHex:@"#ffcc00"];
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


- (void)gotoCinemaBtn{
    CinemaListViewController *ctr = [[CinemaListViewController alloc] init];
    ctr.selectCinemaBlock = ^(NSString *cinemaId){
        self.cinemaId = cinemaId;
        cinemaTitleLabel.text = USER_CINEMA_NAME;
        self.cinemaName = USER_CINEMA_NAME;
        CGSize cinemaNameSize = [KKZTextUtility measureText:self.cinemaName size:CGSizeMake(MAXFLOAT, 15) font:[UIFont systemFontOfSize:16]];
        NSInteger cinemaNamelabelWidth = (kCommonScreenWidth-140-15)>cinemaNameSize.width?cinemaNameSize.width:(kCommonScreenWidth-140-15);
        [arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(cinemaNamelabelWidth+5));
            make.right.equalTo(customTitleView.mas_right);
            make.top.equalTo(@(13));
            make.width.equalTo(@(10));
            make.height.equalTo(@(6));
        }];
        [self requestPlanDateList];
    };
    [self.navigationController pushViewController:ctr animated:YES];
}

- (void)updateLayout{
    if (self.planList.count>0) {
        self.selectPlan = [self.planList objectAtIndex:self.selectPlanTimeRow];
    }
    if ([self.selectPlan.isDiscount isEqualToString:@"1"]) {
         huiImageView.hidden = NO;
        promotionLabel.hidden = NO;
        promotionLabel.text = self.selectPlan.discount;

    } else {
         huiImageView.hidden = YES;
        promotionLabel.hidden = YES;

    }
//    if ([self.selectPlan.wx_issale integerValue] > 0) {
//        huiImageView.hidden = NO;
//        promotionLabel.hidden = NO;
////        promotionLabel.text = @"火星营救立减10元|微信支付随机减";
//        promotionLabel.text = self.selectPlan.wx_saleTielt;
//    }
    UIImage *placeHolderImage = [UIImage centerResizeFrom:[UIImage imageNamed:@"movie_nopic_s"] newSize:cinemaPosterImageView.frame.size bgColor:[UIColor colorWithHex:@"#f2f5f5"]];
    [cinemaPosterImageView sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:self.selectPlan.screenImage] placeholderImage:placeHolderImage];
    hallNameLabel.text = self.selectPlan.screenName;
    if (self.selectPlan.filmInfo.count>0) {
        Movie *amovie = [self.selectPlan.filmInfo objectAtIndex:0];
        screenTypeLabel.text = [NSString stringWithFormat:@"%@  %@", amovie.filmType, amovie.language];
    }else{
        screenTypeLabel.text = @"";
    }

}


#pragma mark --UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio{
    if (collectionView==planDateCollectionView) {
        return self.planDateList.count;
    }else if (collectionView==planListCollectionView){
        return self.planList.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    //    if (collectionView==incomingDateCollectionView) {
    //        return 1;
    //    }
    return 1;
}

//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView==planDateCollectionView) {
        return UIEdgeInsetsMake(10, 15, 10, 15);
    }else if (collectionView==planListCollectionView){
        if (Constants.isIphone5) {
            return UIEdgeInsetsMake(10, 15, 10, 15);
        }else{
            return UIEdgeInsetsMake(15, 15, 10, 15);
        }
    }
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView==planDateCollectionView) {
        return 7.5;
    }else if (collectionView==planListCollectionView) {
        return 10;
    }
    return 0;
}
//定义每个UICollectionView 横向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (collectionView==planDateCollectionView) {
        return 10;
    }else if (collectionView==planListCollectionView) {
        return 7.5;
    }
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==planDateCollectionView) {
        NSString *content = [self.planDateList objectAtIndex:indexPath.row];
        //        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        //        attributes[NSFontAttributeName] = [UIFont systemFontOfSize:14];
//        CGSize s = [KKZTextUtility measureText:content font:[UIFont systemFontOfSize:14]];
        
//        return CGSizeMake(63, 55);
        return CGSizeMake(floor((kCommonScreenWidth-4*7.5-30)/5), floor(((kCommonScreenWidth-4*7.5-30)/5)*0.873));

    }else if (collectionView==planListCollectionView) {
        if (Constants.isIphone5) {
            return CGSizeMake(floor((kCommonScreenWidth-4*7.5-30)/5), floor(((kCommonScreenWidth-4*7.5-30)/5)*0.873)+5);
        }else{
            return CGSizeMake(floor((kCommonScreenWidth-4*7.5-30)/5), floor(((kCommonScreenWidth-4*7.5-30)/5)*0.873));
        }
    }
    return CGSizeZero;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==planDateCollectionView) {
        static NSString *identify = @"PlanDateCollectionViewCell";
        PlanDateCollectionViewCell *cell = (PlanDateCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
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
        
    }else if (collectionView==planListCollectionView) {
        static NSString *identify = @"PlanTimeCollectionViewCell";
        PlanTimeCollectionViewCell *cell = (PlanTimeCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
        [cell sizeToFit];
        if (!cell) {
            NSLog(@"无法创建PlanTimeCollectionViewCell时打印，自定义的cell就不可能进来了。");
        }
        Plan *plan = [self.planList objectAtIndex:indexPath.row];
        cell.selectPlan = plan;
//        Movie *movie = [self.movieList objectAtIndex:indexPath.row];
//        cell.movieName = movie.filmName;
//        cell.imageUrl = movie.filmPoster;
//        cell.point = movie.point;
//        cell.availableScreenType = movie.availableScreenType;
        if (indexPath.row == self.selectPlanTimeRow) {
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
    if (collectionView==planDateCollectionView) {
        PlanDate *planDate = [self.planDateList objectAtIndex:indexPath.row];
        if ([planDate.planCount integerValue]>0) {
            self.selectDateRow = indexPath.row;
            [self requestPlanList:1];
            [collectionView reloadData];
        } else {
            
        }
        
    }else if (collectionView==planListCollectionView) {
        Plan *plan = [self.planList objectAtIndex:indexPath.row];
        if ([plan.isSale isEqualToString:@"1"]) {
            NSComparisonResult result; //是否过期
            int lockTime = [klockTime intValue];
    
            NSDate *lateDate = [[NSDate date] dateByAddingTimeInterval:lockTime*60];
            NSDate *startTimeDate = [[DateEngine sharedDateEngine] dateFromString:plan.startTime];
            result= [startTimeDate compare:lateDate];
            if (result == NSOrderedDescending) {
    
            }else{
                [CIASPublicUtility showAlertViewForTitle:@"" message:[NSString stringWithFormat:@"请在开场前%d分钟购票", lockTime] cancelButton:@"确定"];
                return;
            }

            self.selectPlanTimeRow = indexPath.row;
            self.selectPlan = plan;
            [self updateLayout];
            
            [collectionView reloadData];
        }
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
//           viewForSupplementaryElementOfKind:(NSString *)kind
//                                 atIndexPath:(NSIndexPath *)indexPath {
//    if (collectionView==movieCollectionView) {
//        if (isReying) {
//            return nil;
//        }else{
//            
//            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
//                                                    UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionHeaderView" forIndexPath:indexPath];
//            
//            [headerView addSubview:incomingDateCollectionViewBg];//头部广告栏
//            return headerView;
//            
//        }
//    }else
//    {
//        return nil;
//    }
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    if (collectionView==movieCollectionView) {
//        if (isReying) {
//            return CGSizeZero;
//        }else{
//            
//            CGSize size={kCommonScreenWidth,60};
//            return size;
//            
//        }
//    }
//    return CGSizeZero;
//}





@end
