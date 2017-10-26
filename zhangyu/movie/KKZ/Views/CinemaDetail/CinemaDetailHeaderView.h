//
//  影院详情页面的HeaderView
//
//  Created by 艾广华 on 16/4/18.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

@protocol CinemaDetailHeaderDelegate <NSObject>

/**
 *  表头的高度变化
 */
- (void)cinemaDetailHeaderHeightChange;

/**
 *  单击打电话按钮
 */
- (void)didSelectCallPhoneButton;

/**
 *  单击地图定位按钮
 */
- (void)didSelectCallLocationButton;

@end

@interface CinemaDetailHeaderView : UIView

/**
 *  影院名字
 */
@property(nonatomic, strong) NSString *cinemaName;

@property(nonatomic) CGFloat point;

@property(nonatomic, copy) NSString *cinemaTel;

@property(nonatomic, copy) NSString *cinemaAddress;

@property(nonatomic, copy) NSString *cinemaIntro;

/**
 *  更新显示内容
 */
- (void)updateCinemaDisplay;

/**
 *  代理
 */
@property(nonatomic, weak) id<CinemaDetailHeaderDelegate> delegate;

@end
