//
//  首页 - 电影列表
//
//  Created by KKZ on 16/1/23.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "BannerPlayerView.h"
#import "CityListNewViewController.h"
#import "CommonViewController.h"


@class ShowMoreIndicator;
@class PPiFlatSegmentedControl;
@class Banner;

@interface MoviesNewViewController : CommonViewController <CityListViewControllerDelegate, UIGestureRecognizerDelegate> {
    
    //banner轮播图
    BannerPlayerView *_imgPlayer;
    
    //是否显示了banner
    BOOL _isShowBanner;
}

/**
 *  城市是否发生变化
 */
@property (nonatomic, assign) BOOL cityChanged;

/**
 *  提示用户是否切换到当前定位的城市
 */
@property (nonatomic, assign) BOOL isGpsCity;

/**
 *  开屏广告
 */
@property (nonatomic, strong) Banner *banner;

/**
 *  是否需要展示强制更新的信息
 */
@property (nonatomic, assign) BOOL needAlert;


@end
