//
//  XingYiPlanListViewController.h
//  CIASMovie
//
//  Created by cias on 2017/3/23.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Plan.h"
#import "Movie.h"
#import "Cinema.h"
#import "NoPlanAlertView.h"
#import "PlanTimeCell.h"
#import "CardTypeDetail.h"
#import "XingYiPlanDateCollectionViewCell.h"
#import "SwitchMovieView.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
//#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "PlanPromotionListView.h"

@interface XingYiPlanListViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource, BMKLocationServiceDelegate, SwitchMovieDelegate, PlanTimeCellDelegate>{
    SwitchMovieView  *switchMovieView;
    
    UILabel          *movieNameLabel, *movieDurationLabel, *scoreLabel;
    
    UITableView      *planTableView;
    UICollectionView *dateCollectionView;
    UIView           *planTableHeaderView;
    UILabel          *cinemaNameLabel;
    UILabel          *cinemaAddressLabel;
    UIView           *cinemaFeatureView;
    UIImageView      *locationImageView;
    UIView           *openCardTipView;
    UICollectionView *planDateCollectionView;
    
    BMKLocationService*    _locService;
    CLLocationCoordinate2D cc2d;
    CLLocationCoordinate2D cc3d;
    NoPlanAlertView        *noPlanAlertView;
    
    UIImageView            *cardTipImageView,*goImageView;
    UILabel                *cardTitleLabel,*gotitleLabel;
    UIControl              *openCardBtn;
    Cinema                 *localCinema;
    CardTypeDetail         *localCardTypeDetail;
    
    UIView                 *line;
    UIView                 *cinemaDetailView;
    UIButton               *cinemaDBtn;
    UIButton               *goodsTipBtn;
    UILabel                *tipsLabel;
    UILabel                *tipsLabel1;
    UIButton               *gotoMovieDetailBtn;
    BOOL                   isFirstInit;

}

@property (nonatomic, copy) NSString         *movieId;
@property (nonatomic, copy) NSString         *cinemaId;

@property (nonatomic, strong) NSMutableArray *movieList;
@property (nonatomic, strong) NSMutableArray *planDateList;
@property (nonatomic, strong) NSMutableArray *planTimeList;
@property (nonatomic, strong) NSMutableArray *eventList;
@property (nonatomic, strong) NSMutableArray *openCardList;
@property (nonatomic, assign) NSInteger      selectDateRow;
@property (nonatomic, assign) NSInteger      selectPlanTimeRow;
/**
 *  影片的海报地址
 */
@property (nonatomic, strong) NSMutableArray *movieURLs;
@property (nonatomic, strong) NSMutableArray *movieHasPromotions;

@property (nonatomic, strong) PlanPromotionListView *promotionListView;

@property (nonatomic, assign) NSInteger             currentIndex;
@property (nonatomic, strong) Movie                 *movie;
//是否为第一次切换到一部影片 如果多次点击同一部影片 不会多次刷新
@property (nonatomic, assign) BOOL                  isFirstLoad;
@property (nonatomic, assign) BOOL                  isFromBanner;
@property (nonatomic, assign) BOOL                  isFromHome;
@property (nonatomic, assign) BOOL                  isShowGoodsTip;
@property (nonatomic, assign) BOOL                  isFromPush;

@property (nonatomic, strong) UINavigationBar *navBar;


@end
