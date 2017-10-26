//
//  首页 - 影院列表
//
//  Created by KKZ on 16/1/26.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "BannerPlayerView.h"
#import "CityListNewViewController.h"
#import "CommonViewController.h"
#import "VerticalCinemaPickerView.h"

@class EGORefreshTableHeaderView;
@class AlertViewY;
@class NoDataViewY;
@class GPSLocationView;

@interface CinemasNewViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate,
                                                            CityListViewControllerDelegate, UIGestureRecognizerDelegate,
                                                            VerticalCinemaPickerViewDelegate, UITextFieldDelegate> {

    //广告位banner
    BannerPlayerView *imgPlayer;
    //影院列表
    UITableView *cinemaTable;

    //城区筛选弹出之后的遮层
    UIControl *ctrHolder, *ctrHolderWhite;
    //城区筛选的视图
    VerticalCinemaPickerView *districtView;
    //是否正在请求网络的标识
    BOOL isRefresh;
    //列表的提示信息
    AlertViewY *noAlertView;
    NoDataViewY *nodataView;
    //是否是第一次load
    BOOL isFirstLoad;
}

@property (nonatomic, strong) GPSLocationView *addressView;

@end
