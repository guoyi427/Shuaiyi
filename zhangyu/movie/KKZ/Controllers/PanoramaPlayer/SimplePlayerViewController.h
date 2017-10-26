//
//  播放全景视频的页面
//
//  Created by KKZ on 15/10/8.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import <Panframe/Panframe.h>

#import "CommonViewController.h"

@protocol SimplePlayerViewControllerDelegate <NSObject>

- (void)changFrameBtnClicked;

@end

@interface SimplePlayerViewController : CommonViewController <UIActionSheetDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<SimplePlayerViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, assign) CGFloat videoLength;
@property (nonatomic, assign) BOOL isLive;
@property (nonatomic, strong) NSArray *videoQualities;
@property (nonatomic, strong) NSArray *videoList;
@property (nonatomic, assign) int defaultVideoIndex;
@property (nonatomic, copy) NSString *defaultVideoQuality;
@property (nonatomic, assign) int currentMode;

- (void)reloadView;
- (void)startPlay;
- (void)stop;
- (void)localclicked;
- (void)changFrame;
- (void)updata;
- (void)volumeChanged:(NSNotification *)noti;
- (void)outputDeviceChanged:(NSNotification *)noti;
- (void)reachablityChangedWWAN:(NSNotification *)noti;
- (void)stopBackgroundYN;
- (void)startPlayActiveYN;

@end
