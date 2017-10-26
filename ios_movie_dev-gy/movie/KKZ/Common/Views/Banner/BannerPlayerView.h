//
//  播放Banner的控件
//
//  Created by zhang da on 2010-10-20.
//  Copyright 2010 Ariadne’s Thread Co., Ltd All rights reserved.
//

#import "InfinitePagingView.h"
#import "StyledPageControl.h"

#define NOTIFICATION_KEY_HEIGHT @"height"

@interface BannerPlayerView : UIView <InfinitePagingViewDataSource, InfinitePagingViewDelegate>

@property (nonatomic, strong) NSString *typeId;
@property (nonatomic, assign) Boolean isShowingMovie;

/**
 * 更新Banner的数据。
 */
- (void)updateBannerData;

/**
 * 开始自动播放Banner。
 */
- (void)startPlay;

/**
 * 停止自动播放Banner。
 */
- (void)stopPlay;

@end
