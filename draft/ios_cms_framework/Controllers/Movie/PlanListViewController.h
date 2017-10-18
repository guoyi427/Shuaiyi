//
//  PlanListViewController.h
//  CIASMovie
//
//  Created by cias on 2016/12/21.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Plan.h"
#import "Movie.h"
#import "Cinema.h"
#import "NoPlanAlertView.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
//#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

@interface PlanListViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, BMKLocationServiceDelegate>{
    UIView *customTitleView;
    UILabel *cinemaTitleLabel, *movieTitleLabel;
    UIScrollView *scrollViewHolder;
    UIView *holder;
    UICollectionView *planDateCollectionView, *planListCollectionView;
    UIButton *buyTicketBtn;
    UIImageView *timeShadowImageview, *cinemaPosterImageView;
    UIView *hallNameView;
    UILabel *hallNameLabel;
    UILabel *screenTypeLabel;
    UIImageView *huiImageView;
    UILabel *promotionLabel;
    UIImageView *arrowImageView;
    
    BMKLocationService* _locService;
    CLLocationCoordinate2D cc2d;
    CLLocationCoordinate2D cc3d;
    NoPlanAlertView *noPlanAlertView;
}

@property (nonatomic, strong) NSMutableArray *planDateList;
@property (nonatomic, strong) NSMutableArray *planList;
@property (nonatomic, assign) NSInteger selectDateRow;
@property (nonatomic, assign) NSInteger selectPlanTimeRow;

@property (nonatomic, strong) Plan *selectPlan;
@property (nonatomic, copy) NSString *movieId;
@property (nonatomic, copy) NSString *cinemaId;
@property (nonatomic, copy) NSString *movieName;
@property (nonatomic, copy) NSString *cinemaName;

@end
