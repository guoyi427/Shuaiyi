//
//  全景播放页面
//
//  Created by KKZ on 15/10/12.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "DirectBroadcastingController.h"

#import "DataEngine.h"
#import "DateEngine.h"
#import "NetworkStatus.h"
#import "RIButtonItem.h"
#import "ShareView.h"
#import "SimplePlayerTask.h"
#import "SimplePlayerVideo.h"
#import "SimplePlayerVideo.h"
#import "SimplePlayerViewController.h"
#import "TaskQueue.h"
#import "UserDefault.h"
#import <AVFoundation/AVFoundation.h>

@interface DirectBroadcastingController () <SimplePlayerViewControllerDelegate> {

    SimplePlayerViewController *simplerPlayerCtr;
    BOOL isFullScreen;
    UIView *simplerPlayerView;
    NSArray *videoList;
    UIView *alertView;
    UIView *selectAlertView;
}

@end

@implementation DirectBroadcastingController

- (void)dealloc {
    if (simplerPlayerCtr) {
        [simplerPlayerCtr.view removeFromSuperview];
        [simplerPlayerCtr removeFromParentViewController];
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AppDidEnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"appBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVAudioSessionRouteChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reachablityChanged" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reachablityChangedWWAN" object:nil];
}

- (id)initWithExtraData:(NSString *)extra1 extra2:(NSString *)extra2 extra3:(NSString *)extra3 {
    self = [super init];
    if (self) {
        if (extra1) {
            self.recordId = [extra1 integerValue];
            [self requestVideoByRecordidWithRecordId:self.recordId];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    simplerPlayerCtr = [[SimplePlayerViewController alloc] init];
    [self addChildViewController:simplerPlayerCtr];
    simplerPlayerCtr.delegate = self;
    simplerPlayerView = simplerPlayerCtr.view;
    [self.view addSubview:simplerPlayerCtr.view];
    [self.view setBackgroundColor:[UIColor blackColor]];

    self.postImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 90)];

    videoList = [[NSArray alloc] init];

    alertView = [[UIView alloc] initWithFrame:CGRectMake((screentHeight - 250) * 0.5, (screentWith - 100) * 0.5, 250, 100)];
    alertView.layer.cornerRadius = 3;
    [alertView setBackgroundColor:[UIColor whiteColor]];

    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 250 - 10, 60)];
    lab.textColor = [UIColor grayColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:15];
    [alertView addSubview:lab];
    lab.text = @"视频资源获取失败，请检测网络状况";

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 250, 0.6)];
    [line setBackgroundColor:[UIColor grayColor]];
    [alertView addSubview:line];

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 250, 40)];
    [alertView addSubview:btn];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [btn setTitle:@"知道了" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor r:0 g:140 b:255] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(alertBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    alertView.transform = CGAffineTransformMakeRotation(0.5 * M_PI);
    [self.view addSubview:alertView];

    CGRect f = alertView.frame;
    f.origin.x = (screentWith - 100) * 0.5;
    f.origin.y = (screentHeight - 250) * 0.5;
    alertView.frame = f;

    alertView.hidden = YES;

    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 60, 125, 40)];
    cancel.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor r:0 g:140 b:255] forState:UIControlStateNormal];

    UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(125, 60, 100, 40)];
    done.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [done addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    [done setTitle:@"继续" forState:UIControlStateNormal];
    [done setTitleColor:[UIColor r:0 g:140 b:255] forState:UIControlStateNormal];

    selectAlertView = [[UIView alloc] initWithFrame:CGRectMake((screentWith - 250) * 0.5, (screentHeight - 100) * 0.5, 250, 100)];
    selectAlertView.layer.cornerRadius = 3;
    [selectAlertView setBackgroundColor:[UIColor whiteColor]];

    [selectAlertView addSubview:cancel];
    [selectAlertView addSubview:done];

    UILabel *sellab = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 250 - 10, 60)];
    sellab.textColor = [UIColor grayColor];
    sellab.textAlignment = NSTextAlignmentCenter;
    sellab.numberOfLines = 0;
    sellab.font = [UIFont systemFontOfSize:15];
    [selectAlertView addSubview:sellab];
    sellab.text = @"正在使用移动网络观看内容，这可能产生流量费用";

    UIView *selline = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 250, 0.6)];
    [selline setBackgroundColor:[UIColor grayColor]];
    [selectAlertView addSubview:selline];

    selectAlertView.transform = CGAffineTransformMakeRotation(0.5 * M_PI);
    [self.view addSubview:selectAlertView];

    selectAlertView.hidden = YES;

    f = selectAlertView.frame;
    f.origin.x = (screentWith - 100) * 0.5;
    f.origin.y = (screentHeight - 250) * 0.5;
    selectAlertView.frame = f;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopByManualOperation) name:@"AppDidEnterBackground" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPlayByManualOperation) name:@"appBecomeActive" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self

                                             selector:@selector(volumeChangedYN:)

                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"

                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outputDeviceChangedYN:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestAgain) name:@"reachablityChanged" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachablityChangedWWANYN:) name:@"reachablityChangedWWAN" object:nil];
}

- (void)reachablityChangedWWANYN:(NSNotification *)noti {
    [simplerPlayerCtr reachablityChangedWWAN:noti];
}

- (void)volumeChangedYN:(NSNotification *)noti {
    [simplerPlayerCtr volumeChanged:noti];
}

- (void)outputDeviceChangedYN:(NSNotification *)noti {
    [simplerPlayerCtr outputDeviceChanged:noti];
}

- (void)stopByManualOperation {
    [simplerPlayerCtr stopBackgroundYN];
}

- (void)startPlayByManualOperation {
    [simplerPlayerCtr startPlayActiveYN];
}

- (void)cancelAction {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {

        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
    selectAlertView.hidden = YES;
    [appDelegate popViewControllerAnimated:NO];
}

- (void)doneAction {
    selectAlertView.hidden = YES;
    [simplerPlayerCtr startPlay];
}

- (void)changFrameBtnClicked {
    DLog(@"全屏播放");

    if (isFullScreen) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {

            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        }

        isFullScreen = NO;
        [simplerPlayerCtr.view removeFromSuperview];

        CGAffineTransform landscapeTransform;
        landscapeTransform = CGAffineTransformMakeRotation(0 * M_PI / 180);
        CGFloat landscapeTransformX = 0;
        landscapeTransform = CGAffineTransformTranslate(landscapeTransform, landscapeTransformX, landscapeTransformX);

        [simplerPlayerCtr.view setTransform:landscapeTransform];
        [self.view addSubview:simplerPlayerCtr.view];

        simplerPlayerCtr.view.frame = CGRectMake(0, self.contentPositionY, screentWith, 181 * (screentWith / 320));
        [simplerPlayerCtr reloadView];

        return;
    } else {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {

            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        }

        isFullScreen = YES;
        [simplerPlayerCtr.view removeFromSuperview];
        simplerPlayerCtr.view.frame = CGRectMake(0, 0, screentWith, screentHeight);
        [simplerPlayerCtr reloadView];

        [appDelegate.window addSubview:simplerPlayerCtr.view];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestVideoByRecordidWithRecordId:(long)recordId {
    Need_ALERT_WRITE(NO);
    SimplePlayerTask *task = [[SimplePlayerTask alloc] initSimplePlayerDataWithRecord_id:[NSString stringWithFormat:@"%ld", recordId]
                                                                                finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                                                    [self checkVideoInfoFinished:userInfo status:succeeded];
                                                                                }];

    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

- (void)checkVideoInfoFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    if (succeeded) {
        DLog(@"video info succeeded");

        NSArray *videoListArr = userInfo[@"videoList"];
        NSArray *videoQualitiesArr = userInfo[@"videoQualities"];
        int defaultVideoIndex = [userInfo[@"defaultVideoIndex"] intValue];
        NSString *defaultVideoQuality = userInfo[@"defaultVideoQuality"];
        int defaultVideoMode = [userInfo[@"defaultVideoMode"] intValue];

        videoList = [videoListArr copy];
        SimplePlayerVideo *defaultVideo = (SimplePlayerVideo *) userInfo[@"defaultVideo"];
        simplerPlayerCtr.videoUrl = defaultVideo.videoPath;
        simplerPlayerCtr.videoName = defaultVideo.videoName;
        simplerPlayerCtr.videoQualities = videoQualitiesArr;
        simplerPlayerCtr.videoList = videoListArr;
        simplerPlayerCtr.defaultVideoIndex = defaultVideoIndex;
        simplerPlayerCtr.defaultVideoQuality = defaultVideoQuality;

        if (defaultVideo.live == 0) {
            simplerPlayerCtr.videoLength = defaultVideo.videoLength;
            simplerPlayerCtr.isLive = YES;
        } else {
            simplerPlayerCtr.isLive = NO;
        }

        if (defaultVideoMode == 1) {
            simplerPlayerCtr.currentMode = 0;
        } else {
            simplerPlayerCtr.currentMode = 1;
        }

        [simplerPlayerCtr updata];
        //        simplerPlayerCtr.videoUrl = @"http://media.komovie.cn/trailer/14074700193357.mp4";

        DLog(@"[NetworkStatus getNetWorkStates] ===== %@", [NetworkStatus getNetWorkStates]);
        if ([[NetworkStatus getNetWorkStates] isEqualToString:@"1"]) {
            [simplerPlayerCtr startPlay];
        } else if ([[NetworkStatus getNetWorkStates] isEqualToString:@"2"] || [[NetworkStatus getNetWorkStates] isEqualToString:@"3"] || [[NetworkStatus getNetWorkStates] isEqualToString:@"4"]) {
            selectAlertView.hidden = NO;
        } else if (simplerPlayerCtr.videoUrl.length) {
            [simplerPlayerCtr startPlay];
        }
    } else {
        alertView.hidden = NO;
    }
}

- (void)alertBtnClicked {
    alertView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    Need_ALERT_WRITE(NO);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:NO];
    Need_ALERT_WRITE(YES);
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {

        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }
}

- (void)cancelViewController {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {

        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    }

    [simplerPlayerCtr stop];
    [appDelegate popViewControllerAnimated:NO];
}

- (void)requestAgain {

    if (videoList.count == 0) {
        [self requestVideoByRecordidWithRecordId:self.recordId];
    }
}

@end
