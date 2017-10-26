//
//  城市列表页面
//
//  Created by KKZ on 16/1/25.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CityCell.h"
#import "CommonViewController.h"

@class EGORefreshTableHeaderView;
@class NoDataViewY;
@class AlertViewY;

@protocol CityListViewControllerDelegate <NSObject>

@optional
/**
 *  切换城市的代理方法
 */
- (void)myCityDidChange;

/**
 *  点击选择城市的名字和城市ID
 *
 *  @param cityName
 *  @param cityId   
 */
- (void)chooseCityWithName:(NSString *)cityName
                withCityId:(NSString *)cityId;

@end

@interface CityListNewViewController : CommonViewController <UITableViewDataSource, UITableViewDelegate, CityCellDelegate> {

    //城市列表
    UITableView *cityTable;
    //头部刷新控件
    EGORefreshTableHeaderView *refreshHeaderView;
    //等位城市信息
    NSMutableArray *headerSet;
    //数据加载提示信息
    NoDataViewY *nodataView;
    AlertViewY *noAlertView;
}

/**
 * 城市列表的代理
 */
@property (nonatomic, assign) id<CityListViewControllerDelegate> delegate;

/**
 * 当前定位城市的名称
 */
@property (nonatomic, retain) NSString *cityNameGPS;

@end
