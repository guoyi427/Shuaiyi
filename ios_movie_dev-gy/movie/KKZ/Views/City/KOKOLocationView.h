//
//  KOKOLocationView.h
//  KoMovie
//
//  Created by renzc on 16/9/7.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMLampText;
@class KOKOLocationView;

@protocol KOKOLocationViewDelegate <NSObject>

/**
 *  切换城市的代理方法
 */
- (void)changeCityBtnClicked:(KOKOLocationView *)locationView;


@end


@interface KOKOLocationView : UIView
/**
 *  定位城市名称
 */
@property (nonatomic, strong) XMLampText *locationLabel;

/**
 *  定位城市名称Bg
 */
@property (nonatomic, strong) UIView *accountTitleLabelBg;

/**
 *  定位的Icon
 */
@property (nonatomic, strong) UIImageView *locationIconImageView;


@property (nonatomic,strong) NSString *cityText;
@property (nonatomic,assign) CGFloat motionWidth;


@property (nonatomic, weak) id<KOKOLocationViewDelegate> delegate;


@end
