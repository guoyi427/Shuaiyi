//
//  KKZAppDelegate.h
//  KKZ
//
//  Created by da zhang on 11-7-20.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "NavigationControl.h"

#import "KKZIntegralView.h"
#import "UIAlertView+Blocks.h"
#import "WXApi.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@class IntegralView;

#define MoviePlayerControllerDidEnterFullscreenNotification @"UIMoviePlayerControllerDidEnterFullscreenNotification"
#define MoviePlayerControllerDidExitFullscreenNotification @"UIMoviePlayerControllerDidExitFullscreenNotification"

typedef void (^CheckNetBlock)(BOOL succeeded);

@class WaitIndicatorView;
@class SplashViewController;
@class CommonTabBarController;

@interface KKZAppDelegate : NSObject <UIApplicationDelegate, WXApiDelegate> {
    CommonTabBarController *homeViewController;
    WaitIndicatorView *indicator;
    KKZIntegralView *integralV;
    UIColor *kkzYellow, *kkzDarkYellow, *kkzGray, *kkzRed, *kkzGreen, *kkzBlue, *kkzDarkBlue;
    UIColor *kkzTextColor, *kkzMainColor;

    BOOL isAuthorized, logged, hasPassword, isSplashDisplayed;

    MKMapView *sharedMapView;

    NSString *lastViewControllerName; //for umeng

    UIView *topViewHolder;

    NSMutableArray *viewTagArray;
    NSInteger viewTag;

    NavigationControl *control;

    NSURL *openUrl;
}

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) CommonTabBarController *homeViewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// TODO 检查颜色是否有用，精简
@property (nonatomic, strong, readonly) UIColor *kkzYellow;
@property (nonatomic, strong, readonly) UIColor *kkzGray;
@property (nonatomic, strong, readonly) UIColor *kkzRed;
@property (nonatomic, strong, readonly) UIColor *kkzGreen;
@property (nonatomic, strong, readonly) UIColor *kkzBlue;
@property (nonatomic, strong, readonly) UIColor *kkzDarkBlue;
@property (nonatomic, strong, readonly) UIColor *kkzDarkYellow;
@property (nonatomic, strong, readonly) UIColor *kkzTextColor;
@property (nonatomic, strong, readonly) UIColor *kkzMainColor;
@property (nonatomic, strong, readonly) UIColor *kkzBlack;
@property (nonatomic, strong, readonly) UIColor *kkzPink;
@property (nonatomic, strong, readonly) UIColor *kkzLine;

@property (nonatomic, assign) CGFloat kkzScale;

@property (nonatomic, strong) MKMapView *sharedMapView;
@property (nonatomic, strong) NSString *lastViewControllerName;
@property (nonatomic, assign) double cacheTimeStamp;

// TODO 用户的登录信息，使用专门类统一管理
@property (nonatomic, assign) BOOL isAuthorized;
@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, assign) int cityId;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) CheckNetBlock checkNetBlock;
@property (nonatomic, retain) NSString *idfaUrl;
@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@property (nonatomic, strong) NSArray *discoveryTabsList;

@property (nonatomic, strong) UIAlertView *appdelegateAlert;

@property (nonatomic, strong) UIAlertView *locationAlert;
@property (nonatomic, assign) BOOL cityChange;
@property (nonatomic, assign) int selectedTab;

- (NSURL *)applicationDocumentsDirectory;
- (NSString *)channelId;
- (void)makePhoneCallWithTel:(NSString *)telNumber;
- (void)signout;

- (void)backFromSplashView;
- (void)backFromVedioLoginView;

/**
 *  进入好友推荐页面
 */
- (void)startFriendViewController;

- (void)showIndicatorWithTitle:(NSString *)title
                      animated:(BOOL)animated
                    fullScreen:(BOOL)fullLayout
                  overKeyboard:(BOOL)overKb
                   andAutoHide:(BOOL)autoHide;

- (void)showIndicatorWithTitle:(NSString *)title
                      subTitle:(NSString *)subTitle
                        bgAlpa:(CGFloat)alpa
                      animated:(BOOL)animated
                    fullScreen:(BOOL)fullLayout
                  overKeyboard:(BOOL)overKb
                   andAutoHide:(BOOL)autoHide;
//- (void)showAtStatusBar:(NSString *)msg isAutohidden:(BOOL)is;

- (void)hideIndicator;
- (BOOL)isIndicator;

- (void)showAlertViewForTaskInfo:(NSDictionary *)userInfo;
- (void)showAlertViewForRequestInfo:(NSDictionary *)userInfo;

- (void)showAlertViewForTitle:(NSString *)title
                      message:(NSString *)message
                 cancelButton:(NSString *)cancelButtonTitle;
- (void)showAlertViewForTitle:(NSString *)title
                      message:(NSString *)message
                 cancelButton:(NSString *)cancelButtonTitle
                        limit:(BOOL)limit;

- (void)pushViewController:(id)ctr animation:(ViewSwitchAnimation)animation;
//- (void)switchToViewController:(id)ctr animation:(ViewSwitchAnimation)animation;
- (void)popViewControllerAnimated:(BOOL)animated;
//- (void)popViewControllerAnimated:(BOOL)animated killTask:(BOOL)killTask;
- (void)setViewStackMaskShow:(bool)show;

- (void)bringShareViewControllerToFront;
- (void)sendShareViewControllerToBack;

- (void)resetMapView;

- (void)setSelectedPage:(int)value tabBar:(BOOL)exist;
- (void)showIntegralViewWithTitle:(NSString *)title andScore:(NSString *)score andIconPath:(NSString *)iconpath;

@end
