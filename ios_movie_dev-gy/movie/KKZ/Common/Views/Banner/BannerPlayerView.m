//
//  播放Banner的控件
//
//  Created by zhang da on 2010-10-20.
//  Copyright 2010 Ariadne’s Thread Co., Ltd All rights reserved.
//

#import "AppRequest.h"
#import "Banner.h"
#import "BannerPlayerView.h"
#import "KKZUtility.h"
#import "Reachability.h"
#import "TaskQueue.h"
#import "ThumbView.h"
#import "UrlOpenUtility.h"
#import "WebViewController.h"

static const NSTimeInterval PLAY_INTERVAL_SECONDS = 5;

@interface BannerPlayerView () {

    InfinitePagingView *pagingView;
    StyledPageControl *pageControl;
    NSArray *banners;
}

@end

@implementation BannerPlayerView

#pragma mark - Lifecycle methods
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = appDelegate.kkzGray;

        banners = [[NSMutableArray alloc] init];

        pagingView = [[InfinitePagingView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        pagingView.backgroundColor = [UIColor clearColor];
        pagingView.delegate = self;
        pagingView.dataSource = self;
        [self addSubview:pagingView];

        pageControl = [[StyledPageControl alloc] initWithFrame:CGRectMake(8, frame.size.height - 20, screentWith - 8 * 2, 20)];
        pageControl.pageControlStyle = PageControlStyleDefault;
        pageControl.coreSelectedColor = [UIColor orangeColor];
        [self addSubview:pageControl];
    }
    return self;
}

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startPlay) object:nil];
}

#pragma mark - Public methods
/**
 * 更新Banner的数据。
 */
- (void)updateBannerData {

    AppRequest *request = [[AppRequest alloc] init];
    [request requestBanners:[NSNumber numberWithInt:USER_CITY]
            targetType:[NSNumber numberWithInteger:self.typeId.integerValue]
            success:^(NSArray *_Nullable a_banners) {

                [self handleBannerData:a_banners status:YES];

            }
            failure:^(NSError *_Nullable err) {
                [self handleBannerData:nil status:NO];
            }];
}

- (void)handleBannerData:(NSArray *)a_banners status:(BOOL)succeed {

    [appDelegate hideIndicator];

    // 请求失败或者Banner为空：高度=0，不自动播放
    // 请求成功且Banner数量等于1：高度>0，不自动播放
    // 请求成功且Banner数量大于1：高度>0，自动播放

    banners = a_banners;

    CGFloat height;
    if (screentWith == 375) {
        height = 88;
    } else if (screentWith == 414) {
        height = 97;
    } else {
        height = 75;
    }
    if (!succeed || banners.count == 0) { // 请求失败或者Banner为空
        height = 0;
    }

    if ([self.typeId isEqualToString:@"1"]) { // 电影
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imagePlayerViewHeightMovie" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%f", height] forKey:NOTIFICATION_KEY_HEIGHT]];

    } else if ([self.typeId isEqualToString:@"2"]) { // 影院
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imagePlayerViewHeightCinema" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%f", height] forKey:NOTIFICATION_KEY_HEIGHT]];

    } else if ([self.typeId isEqualToString:@"6"]) { // 约电影
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imagePlayerViewHeightKota" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%f", height] forKey:NOTIFICATION_KEY_HEIGHT]];
    } else if ([self.typeId isEqualToString:@"15"]) { // 发现
        [[NSNotificationCenter defaultCenter] postNotificationName:@"imagePlayerViewHeightDiscover" object:nil userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%f", height] forKey:NOTIFICATION_KEY_HEIGHT]];
    }

    [self stopPlay];
    [self reloadData];

    if (succeed && banners.count > 1) { // Banner的数量大于1轮询播放
        [self performSelector:@selector(startPlay)
                     withObject:nil
                     afterDelay:PLAY_INTERVAL_SECONDS
                        inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    }
}

/**
 * 开始自动播放Banner。
 */
- (void)startPlay {
    if (!pagingView.dragging && !pagingView.decelerating) {

        NSInteger currentPage = pageControl.currentPage;
        currentPage++;
        if (currentPage >= pageControl.numberOfPages) {
            currentPage = 0;
        }

        [pagingView scrollToRowAtIndex:currentPage animated:YES];
    }

    [self performSelector:@selector(startPlay)
                 withObject:nil
                 afterDelay:PLAY_INTERVAL_SECONDS];
}

/**
 * 停止自动播放Banner。
 */
- (void)stopPlay {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startPlay) object:nil];
}

- (void)reloadData {
    [pageControl setNumberOfPages:banners.count];
    [pagingView reloadData];
}

#pragma mark - InfinitePagingView datasource
- (NSString *)pagingViewImagePathAtIndex:(NSInteger)index {
    Banner *banner = (Banner *) banners[index];
    return banner.imagePath;
}

- (NSInteger)pagingViewPageCount {
    return banners.count;
}

- (CGFloat)pagingViewPageWidth {
    return kAppScreenWidth;
}

#pragma mark InfinitePagingView delegate
- (void)pagingViewSelectedChanged:(NSInteger)newPage {
    NSInteger index = newPage - 1;
    index = MAX(index, 0);
    index = MIN(index, pageControl.numberOfPages);

    pageControl.currentPage = index;
}

- (void)pagingViewTapped:(NSInteger)index {
    //统计事件：Banner的点击事件
    if ([self.typeId isEqualToString:@"1"]) {
        if (self.isShowingMovie) {
            StatisEvent(EVENT_BANNER_CLICK_SOURCE_SHOWING);
        } else {
            StatisEvent(EVENT_BANNER_CLICK_SOURCE_COMING);
        }
    } else if ([self.typeId isEqualToString:@"2"]) {
        StatisEvent(EVENT_BANNER_CLICK_SOURCE_CINEMA);
    }

    if (![[NetworkUtil me] reachable]) {
        return;
    }

    Banner *managedObject = (Banner *) banners[index];

    if (![UrlOpenUtility handleOpenAppUrl:[NSURL URLWithString:managedObject.targetUrl]]) {
        WebViewController *ctr = [[WebViewController alloc] initWithTitle:managedObject.title];
        [ctr loadURL:managedObject.targetUrl];
        CommonViewController *parentCtr = [KKZUtility getRootNavagationLastTopController];
        [parentCtr pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
    }
}

- (void)pagingViewDragBegan {
    [self stopPlay];
}

- (void)pagingViewScrollEnded {
    [self performSelector:@selector(startPlay)
                 withObject:nil
                 afterDelay:PLAY_INTERVAL_SECONDS];
}

@end
