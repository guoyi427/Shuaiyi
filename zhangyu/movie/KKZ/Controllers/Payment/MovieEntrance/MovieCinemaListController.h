//
//  电影详情页面 - 影院列表
//
//  Created by KKZ on 16/2/18.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"

#import "VerticalCinemaPickerView.h"

@class KKZHorizonTableView;
@class AlertViewY;
@class NoDataViewY;
@class Movie;

@interface MovieCinemaListController
    : CommonViewController <VerticalCinemaPickerViewDelegate> {

  //右边搜索按钮
  UIButton *searchBtn;
  //右边筛选按钮
  UIButton *selectDistrictBtn;
  //遮层
  UIControl *ctrHolder;
  //遮层
  UIControl *ctrHolderWhite;
  //区域选择view
  VerticalCinemaPickerView *districtView;
}

/**
 *  影片id
 */
@property(nonatomic, copy) NSNumber *movieId;

/**
 *  影片
 */
@property(nonatomic, strong) Movie *movie;

/**
 *  是否正在更新日期列表
 */
@property(nonatomic, assign) BOOL isRefresh;

@end
