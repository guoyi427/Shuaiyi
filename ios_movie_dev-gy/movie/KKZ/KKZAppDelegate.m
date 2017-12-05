
//
//  KKZAppDelegate.m
//  KKZ
//
//  Created by da zhang on 11-7-20.
//  Copyright 2011年 kokozu. All rights reserved.
//
//  TODO 精简
//


#import "AppRequest.h"
#import "BDMultiDownloader.h"
#import "CacheEngine.h"
#import "City.h"
#import "Constants.h"
#import "Constants.h"
#import "DataEngine.h"


#import "ImageEngine.h"
#import "ImageEngineNew.h"
#import "KKZAppDelegate.h"
#import "KKZIntegralView.h"
#import "KKZUncaughtExceptionHandler.h"
#import "LocationEngine.h"
#import "NSURL+scheme.h"
#import "NotificationEngine.h"
#import "PayViewController.h"
#import "RNCachingURLProtocol.h"
#import "SinaClient.h"
#import "SplashViewController.h"
#import "TaskQueue.h"
#import "UIDeviceExtra.h"

#import "UrlOpenUtility.h"
#import "UserDefault.h"
#import "WXApi.h"
#import "WaitIndicatorView.h"
#import <AVFoundation/AVFoundation.h>
#import <AlipaySDK/AlipaySDK.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import <ShareSDK/ShareSDK.h>
//#import <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/TencentOAuth.h>
#import <sys/utsname.h>

#import "CommonTabBarController.h"
#import "NavigationController.h"
//#import "SingleCenterTask.h"
//开启QQ网页授权需要
//#import <QZoneConnection/ISSQZoneApp.h>

//#import "FMDeviceManager.h"
#import "ThirdPartLoginEngine.h"

#import "NetworkUtil.h"
//#import "LoadingViewManager.h"
#import "CityRequest.h"
#import "ClubTask.h"
#import "KKZUtility.h"
#import "UserManager.h"
#import <AFNetworkActivityLogger/AFNetworkActivityLogger.h>
#import <NetCore_KKZ/KKZBaseRequestParams.h>
#import <UserNotifications/UserNotifications.h>
#import "KKZAppDelegate+Splash.h"
// TODO 推送组件封装，支持友盟、个推两种推送方式共存
//友盟推送
//#import "UMessageEngine.h"
//#import "UMessage.h"
//个推推送
//#import "GeTuiSdk.h"
//#import <GTSDK/GeTuiSdk.h>
#import "KoMovie-Swift.h"

//#import "ShuWeiLocation.h"

// 个推开发者网站中申请App时，注册的AppId、AppKey、AppSecret
#define kGtAppId @"e0wfe46D6lAOc3Xc1BUElA"
#define kGtAppKey @"0wTJvmtULZ5AvWy6oom3n"
#define kGtAppSecret @"NU8kLDakA78fe76kMYpLB7"

//// =============== 重构完成 Start =============== ////
//统计分析组件
#import "StatisticsComponent.h"
//版本更新组件
#import "UpgradeComponent.h"
//// =============== 重构完成 End =============== ////

//  百度sdk
#import <BaiduMapAPI_Base/BMKMapManager.h>

#define kSplashTag 8967
#define kKoMovieTag 7874
#define kTopViewHolderHeight 60
#define SUPPORT_IOS8 0

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";

// 2015-03-06
//#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice
//currentDevice] systemVersion] compare:v options:NSNumericSearch] !=
//NSOrderedAscending)
#define _IPHONE80_ 80000

BOOL runningOniOS5, runningOniOS7, retinaDisplaySupported, isConnected;
float screentHeight, screentContentHeight, screentWith;

// launch3rdSDK; 使用 DEBUG

KKZAppDelegate *appDelegate;

@interface KKZAppDelegate () <UNUserNotificationCenterDelegate>

/**
 * 是否全屏
 */
@property (nonatomic, assign) BOOL isFull;

- (void)getReadyAfterLaunch;
- (void)parseURL:(NSURL *)url application:(UIApplication *)application;
- (void)parseURLYiZhiFu:(NSURL *)url application:(UIApplication *)application;
@end

@implementation KKZAppDelegate

@synthesize window = _window;
@synthesize homeViewController;
@synthesize kkzYellow, kkzGray, kkzRed, kkzGreen, kkzBlue, kkzDarkYellow,
        kkzTextColor, kkzMainColor, kkzDarkBlue, kkzBlack, kkzPink, kkzLine;
@synthesize isAuthorized;
@synthesize sharedMapView;
@synthesize lastViewControllerName;
@synthesize cityId;
@synthesize timer;

- (void)setIsAuthorized:(BOOL)value {
    if (isAuthorized != value) {
        isAuthorized = value;
    }
}

- (BOOL)isAuthorized {
    return ![[DataEngine sharedDataEngine] isAuthorizeExpired];
}

- (void)setCityId:(int)value {
    if (cityId != value) {
        [self willChangeValueForKey:@"changeCity"];
        cityId = value;
        [self didChangeValueForKey:@"changeCity"];
    }
}

- (BOOL)application:(UIApplication *)application
        didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    K_REQUEST_ENC_SALT = [NSMutableString stringWithString:kKsspKey];

    [StatisticsComponent initStatisticsComponent];

    [self loadNotification];
//    [self getFMDeviceManager];
    USER_LOGIN_HUANXIN_WRITE(NO);
    Need_ALERT_WRITE(YES);

    [self getAppUUID];
    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];

    DLog(@"-------------******* exec didFinishLaunchingWithOptions start ");

    [ShareSDK registerApp:kShareSDKAppKey];
    // Bugly
//    [self configBugly];
    [self initializePlat];
    
    //  baidu sdk
    BMKMapManager *mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [mapManager start:@"j6qz0WONU7Q2PCcsZnCVGAATH73jPpxQ"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
//    [[ShuWeiLocation sharedInstance] startLocationWithAppId:@"2065dd06349e" andAppKey:@"e2e87836-2746-4b43-9b64-288048bc3b9b"];
    
    retinaDisplaySupported = [[UIDevice currentDevice] hasRetinaDisplay];
    screentHeight = [UIScreen mainScreen].bounds.size.height;
    screentWith = [UIScreen mainScreen].bounds.size.width;
    screentContentHeight = screentHeight - 20;
    runningOniOS5 = ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9);
    runningOniOS7 = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0);

    isAuthorized = NO;
    isConnected = YES;

    appDelegate = (KKZAppDelegate *) [[UIApplication sharedApplication] delegate];

    UIWindow *window = [[UIWindow alloc]
            initWithFrame:CGRectMake(0, 0, screentWith, screentHeight)];
    window.backgroundColor = [UIColor whiteColor];
    self.window = window;

    [[LocationEngine sharedLocationEngine] start];

    control = [[NavigationControl alloc] initWithHolder:self.window];

    // TODO 处理城市的逻辑进行封装
    //加载城市数据列表
    int cityid = USER_CITY;
    City *city = nil;
    if (cityid) {
        city = [City getCityWithId:USER_CITY];
    }

    if (!USER_CITY || !city) {
        [self refreshCityList];
    }

    if ([self hasSplashInCache]) {
        //创建根视图splash控制器
        SplashViewController *splash = [[SplashViewController alloc] init];
        [self makeKeyRootController:splash];
    }else{
        [self backFromVedioLoginView];
    }
    [self requestSplashData];


    if (!USER_HASLAUNCHED) {

        //        [DataEngine sharedDataEngine].sessionId = nil;
        //        [DataEngine sharedDataEngine].userId = nil;

        USER_KOTA_TICKET_WRITE(YES);
    }

    //    [DataEngine sharedDataEngine];

    // TODO 定位的逻辑封装其他类
    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(locationGet:)
                   name:LocationUpdateSucceededNotification
                 object:nil];
    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(locationGetFailed:)
                   name:LocationUpdateFailedNotification
                 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationChanged:)
                                                 name:LocationChangedNotification
                                               object:nil];
    [self performSelector:@selector(getReadyAfterLaunch)
                 withObject:nil
                 afterDelay:3];
    [NetworkUtil me];

    // TODO 推送封装其他类：个推+友盟
    // 通过个推平台分配的appId、 appKey 、appSecret
    // 启动SDK，注：该方法需要在主线程中调用
    

//    [GeTuiSdk startSdkWithAppId:kGtAppId
//                         appKey:kGtAppKey
//                      appSecret:kGtAppSecret
//                       delegate:self];
//    [GeTuiSdk runBackgroundEnable:true];


    //    //初始化友盟推送
    //    [UMessageEngine applicationDidFinishLaunching:launchOptions];
//    NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if (notification) {
//        NSString *payload = notification[@"payload"];
//        if (payload) {
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[payload dataUsingEncoding:NSUTF8StringEncoding]
//                                                                options:NSJSONReadingMutableContainers
//                                                                  error:nil];
//
//            [[KKZRemoteNotificationCenter sharedInstance] collect:dic];
//
//        }
//
//        [GeTuiSdk clearAllNotificationForNotificationBar];
//    }

    self.idfaUrl = @"";
// TODO IM模块封装
// 注册环信监听
// registerSDKWithAppKey:注册的appKey，详细见下面注释。
// apnsCertName:推送证书名(不需要加后缀)，详细见下面注释。
#ifdef DEBUG
    [[AFNetworkActivityLogger sharedLogger] startLogging];
#else
    
#endif
    
    // 登录成功后，自动去取好友列表
    // SDK获取结束后，会回调
    // - (void)didFetchedBuddyList:(NSArray *)buddyList error:(EMError
    // *)error方法。
    
    [self registerRemoteNotification];
    

    //    [self loadListRequest];
    [self loadTitleListRequest];

    self.kkzScale = [[UIScreen mainScreen] scale];

    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[LocationEngine sharedLocationEngine] start];

    //一个月清除缓存

    dispatch_async(
            dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                double nowTime = [[NSDate date] timeIntervalSince1970];
                double cacheTime = USER_CACHE;

                long cacheSizeMB = [[CacheEngine sharedCacheEngine] diskCacheSizeMB];

                if (cacheTime > 0) {
                    if ((nowTime - cacheTime) > 30 * 24 * 3600 || cacheSizeMB >= 80) {
                        [[CacheEngine sharedCacheEngine] resetCache];
                        [[ImageEngine sharedImageEngine] resetCache];
                        [[ImageEngineNew sharedImageEngineNew] resetCache];
                        [[BDMultiDownloader shared] clearDiskCache];
                    }
                } else {
                    double cacheTime = [[NSDate date] timeIntervalSince1970];
                    USER_CACHE_WRITE(cacheTime);
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }

            });
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    DLog(@"内存警告memory Warning");
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[ImageEngineNew sharedImageEngineNew] releaseImageCache];
    [[ImageEngine sharedImageEngine] releaseImageCache];

    kkzYellow = nil;
    kkzDarkYellow = nil;
    kkzGray = nil;
    kkzRed = nil;
    kkzGreen = nil;
    kkzBlue = nil;
    kkzDarkBlue = nil;
    kkzTextColor = nil;

    sharedMapView = nil;
}

- (void)applicationWillResignActive:(UIApplication *)application {

    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [self parseURL:url application:application];
    [ShareSDK handleOpenURL:url wxDelegate:nil];
    [WXApi handleOpenURL:url delegate:self];

    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    [WXApi handleOpenURL:url delegate:self];

    [self parseURL:url application:application];
    [self parseURLYiZhiFu:url application:application];

    //    DLog(@"$$$$$$$$$$$url%@",url);

    NSString *resultStr = [url absoluteString];

    //    DLog(@"resultStr$$$$$$$$$$$$%@",resultStr);

    if ([resultStr isEqualToString:@"sinaweibosso.1767451078://"
                                   @"?WBOpenURLContextResultKey="
                                   @"WBOpenURLContextResultCanceld"]) {
        return NO;
    } else {
        return [ShareSDK handleOpenURL:url
                     sourceApplication:sourceApplication
                            annotation:annotation
                            wxDelegate:nil];
    }

    DLog(@"测试翼支付");

    return YES;
}

#if SUPPORT_IOS8
- (void)application:(UIApplication *)application
        didRegisterUserNotificationSettings:
                (UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}
#endif

- (void)dealloc {

    [[NSNotificationCenter defaultCenter]
            removeObserver:self
                      name:LocationUpdateSucceededNotification
                    object:nil];
    [[NSNotificationCenter defaultCenter]
            removeObserver:self
                      name:LocationChangedNotification
                    object:nil];
    [[NSNotificationCenter defaultCenter]
            removeObserver:self
                      name:LocationUpdateFailedNotification
                    object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Notification management

/** 注册 APNs */
- (void)registerRemoteNotification {

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                              completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                DLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

- (void)application:(UIApplication *)application
        didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //友盟推送：注册设备的 deviceToken
    //    [UMessageEngine registerDeviceToken:deviceToken];

    NSString *token = [[deviceToken description]
            stringByTrimmingCharactersInSet:
                    [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    DLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);

    //向个推服务器注册deviceToken
//    [GeTuiSdk registerDeviceToken:token];
    
    
}

- (void)application:(UIApplication *)application
        didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DLog(@"FailToRegisterForRemoteNotificationsWithError %@",
         [error description]);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    DLog(@"@#@#@#@%@didReceiveRemoteNotification",userInfo);
//    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    DLog(@"@#@#@#@willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    
    DLog(@"@#@#@#@didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
//    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
}

#endif


#pragma mark lazy init color
- (UIColor *)kkzYellow {
    if (!kkzYellow)
        kkzYellow = [UIColor colorWithRed:255.0 / 255.0
                                    green:216.0 / 255.0
                                     blue:0.0 / 255.0
                                    alpha:1];
    return kkzYellow;
}

- (UIColor *)kkzGray {
    if (!kkzGray)
        kkzGray = [UIColor colorWithRed:149 / 255.0
                                  green:149 / 255.0
                                   blue:149 / 255.0
                                  alpha:1];
    return kkzGray;
}

- (UIColor *)kkzRed {
    if (!kkzRed)
        kkzRed = [UIColor colorWithRed:230 / 255.0
                                 green:86 / 255.0
                                  blue:78 / 255.0
                                 alpha:1];
    return kkzRed;
}

- (UIColor *)kkzGreen {
    if (!kkzGreen)
        kkzGreen = [UIColor colorWithRed:83 / 255.0
                                   green:208 / 255.0
                                    blue:145 / 255.0
                                   alpha:1];
    return kkzGreen;
}

- (UIColor *)kkzBlue {
    return appDelegate.kkzPink;
//    if (!kkzBlue)
//        kkzBlue =
//                [UIColor colorWithRed:0
//                                green:140 / 255.0
//                                 blue:255 / 255.0
//                                alpha:1];
//    return kkzBlue;
}

- (UIColor *)kkzDarkBlue {
    if (!kkzDarkBlue)
        kkzDarkBlue = [UIColor colorWithRed:6.0 / 255.0
                                      green:36.0 / 255.0
                                       blue:56.0 / 255.0
                                      alpha:1];
    return kkzDarkBlue;
}

- (UIColor *)kkzDarkYellow {
    if (!kkzDarkYellow)
        kkzDarkYellow = [UIColor colorWithRed:255 / 255.0
                                        green:105 / 255.0
                                         blue:0 / 255.0
                                        alpha:1.0];
    return kkzDarkYellow;
}

- (UIColor *)kkzTextColor {
    if (!kkzTextColor)
        kkzTextColor = [UIColor colorWithRed:67 / 255.0
                                       green:67 / 255.0
                                        blue:67 / 255.0
                                       alpha:1.0];
    return kkzTextColor;
}

- (UIColor *)kkzMainColor {
    if (!kkzMainColor)
        kkzMainColor = [UIColor r:255 g:129 b:0];
    return kkzMainColor;
}

- (UIColor *)kkzBlack {
    if (!kkzBlack) {
        kkzBlack = [UIColor r:50 g:50 b:50];
    }
    return kkzBlack;
}

- (UIColor *)kkzPink {
    if (!kkzPink) {
        kkzPink = [UIColor colorWithHex:@"#e50066"];
    }
    return kkzPink;
}

- (UIColor *)kkzLine {
    if (!kkzLine) {
        kkzLine = [UIColor r:240 g:240 b:240];
    }
    return kkzLine;
}

- (MKMapView *)sharedMapView {
    if (!sharedMapView) {
        sharedMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        sharedMapView.mapType = MKMapTypeStandard;
        sharedMapView.exclusiveTouch = NO;
    }
    return sharedMapView;
}

#pragma mark location related
- (void)locationGet:(NSNotification *)notification {
    [[LocationEngine sharedLocationEngine] reset];
}

- (void)locationGetFailed:(NSNotification *)notification {
}

- (void)locationChanged:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    DLog(@"%@", userInfo);
    City *city = [City getCityWithId:USER_CITY];

    NSString *newCityName = [userInfo kkz_stringForKey:@"newCity"];

    if ([newCityName isEqualToString:@"北京市市辖区"]) {
        newCityName = @"北京";
    } else if ([newCityName isEqualToString:@"上海市市辖区"]) {
        newCityName = @"上海";
    } else if ([newCityName isEqualToString:@"重庆市市辖区"]) {
        newCityName = @"重庆";
    } else if ([newCityName isEqualToString:@"天津市市辖区"]) {
        newCityName = @"天津";
    }

    City *newCity = [City getCityWithName:newCityName];

    if (USER_CITY && city && newCity) {

        if (![city.cityName isEqualToString:newCityName]) {

            NSString *user_city = USER_GPS_CITY;

            if (!USER_GPS_CITY || ![newCityName isEqualToString:user_city]) {

                RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
                cancel.action = ^{

                    USER_GPS_CITY_WRITE(newCityName);
                };
                RIButtonItem *resign = [RIButtonItem itemWithLabel:@"好的"];
                resign.action = ^{

                    USER_CITY_WRITE(newCity.cityId);
                    USER_GPS_CITY_WRITE(newCityName);
                    self.cityId = newCity.cityId.intValue;
                };
                NSString *alertStr =
                        [NSString stringWithFormat:
                                          @"你现在位于\"%@\",是否设为默认城市？",
                                          newCityName];
                UIAlertView *alertAt = [[UIAlertView alloc] initWithTitle:@""
                                                                  message:alertStr
                                                         cancelButtonItem:cancel
                                                         otherButtonItems:resign, nil];
                [alertAt show];
            }
        }
    } else {
        USER_GPS_CITY_WRITE(newCityName);
    }
}

// TODO 版本更新模块封装
// TODO 版本升级：https://itunes.apple.com/lookup?id=xxx
//- (void)latestVersionFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
//    THIRD_LOGIN_WRITE(YES);
//    self.idfaUrl = @"";
//    if (!succeeded)
//        return;
//
//    NSString *serverVersion =
//            [[userInfo objectForKey:@"version"] objectForKey:@"version"];
//
//    NSDictionary *currentInfo = [[DataEngine sharedDataEngine] getSoftwareInfo];
//    NSString *currentVersion = [currentInfo objectForKey:@"CFBundleVersion"];
//
//    NSArray *arr = [serverVersion componentsSeparatedByString:@"."];
//    NSArray *arr1 = [currentVersion componentsSeparatedByString:@"."];
//
//    NSMutableString *arrStr = [[NSMutableString alloc] initWithCapacity:0];
//    for (int i = 0; i < arr.count; i++) {
//        arrStr = (NSMutableString *) [arrStr
//                stringByAppendingFormat:@"%@", [arr objectAtIndex:i]];
//    }
//    if (arrStr.length < 3) {
//        arrStr = (NSMutableString *) [arrStr stringByAppendingFormat:@"%d", 0];
//    }
//    NSMutableString *arr1Str = [[NSMutableString alloc] initWithCapacity:0];
//    for (int j = 0; j < arr1.count; j++) {
//        arr1Str = (NSMutableString *) [arr1Str
//                stringByAppendingFormat:@"%@", [arr1 objectAtIndex:j]];
//    }
//    if (arr1Str.length < 3) {
//        arr1Str = (NSMutableString *) [arr1Str stringByAppendingFormat:@"%d", 0];
//    }
//    int num = arrStr.intValue;
//    int num1 = arr1Str.intValue;
//
//    if (num < num1) {
//        THIRD_LOGIN_WRITE(NO);
//        self.idfaUrl = @"http://ai.m.taobao.com/";
//    } else {
//        THIRD_LOGIN_WRITE(YES);
//        self.idfaUrl = @"";
//    }
//
//    DLog(@"THIRD_LOGIN ==== %d", THIRD_LOGIN);
//
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    if (num > num1) {
//
//        if ([[userInfo kkz_objForKey:@"forceUpdate"] boolValue]) {
//
//            RIButtonItem *done = [RIButtonItem itemWithLabel:@"马上体验"];
//            done.action = ^{
//
//                NSURL *url = [NSURL URLWithString:kAppUrl];
//
//                if (url) {
//                    [[UIApplication sharedApplication]
//                            openURL:url];
//                }
//                exit(0);
//                //        self.appdelegateAlert = nil;
//            };
//
//            NSDictionary *version = userInfo[@"version"];
//
//            UIAlertView *alert =
//                    [[UIAlertView alloc] initWithTitle:@""
//                                               message:version[@"updateMessage"]
//                                      cancelButtonItem:done
//                                      otherButtonItems:nil];
//            [alert show];
//
//            self.appdelegateAlert = alert;
//
//        } else {
//
//            RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"以后再说"];
//            cancel.action = ^{
//                self.appdelegateAlert = nil;
//            };
//
//            RIButtonItem *done = [RIButtonItem itemWithLabel:@"马上体验"];
//            done.action = ^{
//                // [[UIApplication sharedApplication] openURL:[NSURL
//                // URLWithString:kAppUrl]];
//
//                NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/cn/app/"
//                                                  @"kou-dian-ying-quan-guo-zai/"
//                                                  @"id485584268?mt=8"];
//
//                if (url) {
//                    [[UIApplication sharedApplication]
//                            openURL:url];
//                }
//
//                self.appdelegateAlert = nil;
//            };
//
//            NSDictionary *version = userInfo[@"version"];
//            UIAlertView *alert =
//                    [[UIAlertView alloc] initWithTitle:@""
//                                               message:version[@"updateMessage"]
//                                      cancelButtonItem:cancel
//                                      otherButtonItems:done, nil];
//            [alert show];
//            self.appdelegateAlert = alert;
//        }
//    }
//}

- (void)refreshCityList {
    //加载本地城市列表到内存
    [[CityRequest new] loadCityListSuccess:nil failure:nil];
}

- (void)getReadyAfterLaunch {
    @autoreleasepool {

        THIRD_LOGIN_WRITE(NO);

        [UpgradeComponent checkAppUpdate]; // 检查版本更新

        // TODO What's idfaUrl
        //        self.idfaUrl = @"http://ai.m.taobao.com/";
        //        SystemTask *task = [[SystemTask alloc] initLatestVersion:^(BOOL
        //        succeeded, NSDictionary *userInfo) {
        //            [self latestVersionFinished:userInfo status:succeeded];
        //        }];
        //        [[TaskQueue sharedTaskQueue] addTaskToQueue:task];

        // TODO launch3rdSDK使用
        //#ifdef DEBUG
        //        launch3rdSDK = YES;
        //#ifdef DEBUG
        //        launch3rdSDK = NO;
        //#endif
        //        if (launch3rdSDK) {
        //            @try {
        //                [MobClick startWithAppkey:@"4eda21de5270150da7000027"
        //                             reportPolicy:SEND_INTERVAL
        //                                channelId:[self channelId]];
        //                [MobClick kkzEvent:@"launch" label:[self
        //                channelId]];////保留
        //                [MobClick setCrashReportEnabled:YES];
        //                                self.idfaUrl = [MobClick getAdURL];
        //            }
        //            @catch (NSException *exception) {
        //                LERR(exception);
        //            }
        //            @finally {
        //            }
        //        } else {
        //            //        InitUncaughtExceptionHandler();
        //        }

        // TODO session未过期查询余额？
        //刷新 session
        if ([DataEngine sharedDataEngine].isAuthorizeExpired) {

        } else {

            [[UserManager shareInstance] updateBalance:nil failure:nil];
        }
    }
}

- (void)showAlertViewForTaskInfo:(NSDictionary *)userInfo {
    NSDictionary *logicError = [userInfo objectForKey:@"LogicError"];
    if (![logicError objectForKey:timeOutErrorKey]) {

        if ([logicError kkz_stringForKey:@"message"].length &&
            [logicError kkz_stringForKey:@"message"]) {
            [self showAlertViewForTitle:@""
                                  message:[logicError kkz_stringForKey:@"message"]
                             cancelButton:@"知道了"];
        } else if ([logicError kkz_stringForKey:@"error"].length &&
                   [logicError kkz_stringForKey:@"error"]) {
            [self showAlertViewForTitle:@""
                                  message:[logicError kkz_stringForKey:@"error"]
                             cancelButton:@"知道了"];
        } else {

            [self showAlertViewForTitle:@""
                                  message:[logicError kkz_stringForKey:@""]
                             cancelButton:@"知道了"];
        }
    }
}

- (void)showAlertViewForRequestInfo:(NSDictionary *)userInfo {
    if ([userInfo kkz_stringForKey:KKZRequestErrorMessageKey].length && [userInfo kkz_stringForKey:KKZRequestErrorMessageKey]) {
        
        [UIAlertView showAlertView:[userInfo kkz_stringForKey:KKZRequestErrorMessageKey]
                        buttonText:@"确定"];
    }
}

- (void)showAlertViewForTitle:(NSString *)title
                      message:(NSString *)message
                 cancelButton:(NSString *)cancelButtonTitle {

    if ([message length] != 0) {
        NSDate *updateTime = USER_EXPIRE_ALERT;
        if ([title isEqual:nil]) {
            title = @"";
        }
        if (!updateTime || [updateTime timeIntervalSinceNow] < -2) {
            //适配iOS9 更新UI在主线程进行
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView =
                        [[UIAlertView alloc] initWithTitle:title
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:cancelButtonTitle
                                         otherButtonTitles:nil, nil];
                [alertView show];
            });

            USER_EXPIRE_ALERT_WRITE([NSDate date]);
        }
    }
}

- (void)showAlertViewForTitle:(NSString *)title
                      message:(NSString *)message
                 cancelButton:(NSString *)cancelButtonTitle
                        limit:(BOOL)limit {

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:cancelButtonTitle
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)makePhoneCallWithTel:(NSString *)telNumber {
    //    NSArray *array = [telNumber componentsSeparatedByString:@"/"];
    //    if (array && array.count) {
    //        telNumber = array[0];
    //    }

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",
                                                                 [telNumber length]
                                                                         ? telNumber
                                                                         : kHotLine]];
    if (url) {
        [[UIApplication sharedApplication]
                openURL:url];
    }
}

- (void)login {
    [self signout];
    [[DataEngine sharedDataEngine] startLoginFinished:^(BOOL succeeded) {
        
    }];
}

- (void)signout {

    //清空登录数据
    [[DataEngine sharedDataEngine] signout];

    //停止sign-in PUID的统计
    [StatisticsComponent logoutEvent];

    //退出所有的授权
    [ThirdPartLoginEngine signoutAllAuth];

    USER_CINEMA_WRITE(0);
    BOOKING_PHONE_WRITE(nil);
    BINDING_PHONE_WRITE(nil);

    //清空缓存
    [[CacheEngine sharedCacheEngine] clearCaches];
}

- (void)makeKeyRootController:(UIViewController *)controller {

    //改变RootWindow的跟视图控制器
    NavigationController *naV =
            [[NavigationController alloc] initWithRootViewController:controller];
    naV.navigationBarHidden = TRUE;
    self.window.rootViewController = naV;
    [self.window makeKeyAndVisible];
}

/**
 * 视图播放页面
 * Splash页面返回 -> 跳转到首页
 */
- (void)backFromSplashView {
    [self backFromVedioLoginView];
}

- (void)backFromVedioLoginView {
    if (![CLLocationManager locationServicesEnabled]) {
        [self showAlertViewForTitle:@"提示"
                              message:@"您还没有开启定位功能"
                         cancelButton:@"OK"];
        USER_GPS_CITY_WRITE(nil);
    }

    //进入首页
    [self startHomeViewController];
}

- (void)startHomeViewController {
    
    //将用户首次登录置为YES
    USER_HASLAUNCHED_WRITE(YES);

    CommonTabBarController *tabController = [[CommonTabBarController alloc] init];
    homeViewController = tabController;
    [self makeKeyRootController:tabController];

    isSplashDisplayed = true;

    [self openUrlController];


}

- (void)parseURLYiZhiFu:(NSURL *)url application:(UIApplication *)application {

    NSString *urlStr = [url absoluteString];
    if ([urlStr hasPrefix:@"ZhangYu://"]) {
        //翼支付
        if ([urlStr hasPrefix:@"ZhangYu://resultCode=00"]) {
            NSDictionary *d =
                    [NSDictionary dictionaryWithObject:urlStr
                                                forKey:@"yiPayResult"];
            [[NSNotificationCenter defaultCenter]
                    postNotificationName:@"yiPaySucceedNotification"
                                  object:@NO
                                userInfo:d];
        }
    }

    return;
}

- (void)parseURL:(NSURL *)url application:(UIApplication *)application {
    DLog(@"AppDelegate -> parseURL: %@", url);

    NSString *urlStr = [url absoluteString];
    if ([urlStr hasPrefix:@"ZhangYu://"]) {

        //如果极简 SDK
        //不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给 SDK
        if ([urlStr hasPrefix:@"ZhangYu://safepay/"]) {
            [[AlipaySDK defaultService]
                    processOrderWithPaymentResult:url
                                  standbyCallback:^(NSDictionary *resultDic){

                                  }];
        }
        //        //翼支付
        //        else if ([urlStr hasPrefix:@"KoMovie://resultCode=00"]) {
        //            NSDictionary *d = [NSDictionary dictionaryWithObject:urlStr
        //            forKey:@"yiPayResult"];
        //            [[NSNotificationCenter defaultCenter]
        //            postNotificationName:@"yiPaySucceedNotification" object:@NO
        //            userInfo:d];
        //        }
    }
    //使用 komovie://app/page? 形式启动 APP
    else if ([urlStr hasPrefix:APP_OPEN_PATH] || [urlStr hasPrefix:@"zhangyu"]) {
        [UrlOpenUtility handleOpenAppUrl:[NSURL URLWithString:urlStr]];
    }
    //使用 komovie:// 形式启动 APP
    else if ([urlStr hasPrefix:@"ZhangYu://"]) {
        NSDictionary *params = [url queryParams];
        NSString *uId = [params kkz_stringForKey:@"alipay_user_id"];
        NSString *token = [params kkz_stringForKey:@"auth_code"];
        NSString *host = [url host];
        DLog(@"AppDelegate -> URL params: %@", params);

        if (uId && [uId length] && token && [token length]) { //支付宝钱包打开 APP
            
            [[UserManager shareInstance] login:uId password:token site:SiteTypeAliPay success:^(UserLogin * _Nullable userLogin) {
                
            } failure:^(NSError * _Nullable err) {
                
            }];

        } else if ([host isEqualToString:@"payBackUrl"]) {
            [[NSNotificationCenter defaultCenter]
                    postNotificationName:@"pufaPaySucceedNotification"
                                  object:nil];
        } else { //其他方式启动 APP
            openUrl = url;

            if (isSplashDisplayed) {
                [self openUrlController];
            }
        }
    }
}

- (void)openUrlController {
    [UrlOpenUtility handleOpenAppUrl:openUrl];
    openUrl = nil;
}

- (void)resetMapView {
    sharedMapView.delegate = nil;
    [sharedMapView removeOverlays:sharedMapView.overlays];
    [sharedMapView removeAnnotations:sharedMapView.annotations];
}

#pragma mark navigation part
- (void)pushViewController:(id)ctr animation:(ViewSwitchAnimation)animation {
    [self hideIndicator];
    [control pushViewController:ctr animation:animation];
}

- (void)popViewControllerAnimated:(BOOL)animated {
    [[TaskQueue sharedTaskQueue] cancelAllTasks];

    [self hideIndicator];
    [control popViewControllerAnimated:animated];
}

- (void)setViewStackMaskShow:(bool)show {
    [control setMaskShow:show];
}

- (void)setSelectedPage:(int)value tabBar:(BOOL)exist {
    [homeViewController setSelectedPage:value];
}

#pragma mark waiting view
- (void)showIndicatorWithTitle:(NSString *)title
                      animated:(BOOL)animated
                    fullScreen:(BOOL)fullLayout
                  overKeyboard:(BOOL)overKb
                   andAutoHide:(BOOL)autoHide {
    if (!indicator) {
        indicator = [[WaitIndicatorView alloc] initWithFrame:self.window.bounds];
    }
    if (fullLayout) {
        indicator.frame = CGRectMake(0, 0, screentWith, screentHeight);
    } else {
        indicator.frame =
                CGRectMake((screentWith - 90 * 1.2) / 2,
                           (screentContentHeight - 66) / 2.0, 90 * 1.2, 66 * 1.2);
    }
    indicator.title = title ? title : @"加载中";
    indicator.subTitle = nil;
    indicator.alpa = 0;
    indicator.animated = animated;
    indicator.fullScreen = fullLayout;
    [indicator updateLayout];

    if (overKb) {
        NSInteger count = [[UIApplication sharedApplication].windows count];
        if (count >= 1) {
            UIWindow *w =
                    [[UIApplication sharedApplication]
                                    .windows objectAtIndex:count - 1];
            [w addSubview:indicator];
        }
    } else {
        [self.window addSubview:indicator];
        [self.window bringSubviewToFront:indicator];
    }
    /*
    [[LoadingViewManager sharedInstance] startWithText:title ? title : @"加载中"];
     */
    if (autoHide) {
        [self performSelector:@selector(hideIndicator)
                     withObject:nil
                     afterDelay:2.0];
    }
}

- (void)showIndicatorWithTitle:(NSString *)title
                      subTitle:(NSString *)subTitle
                        bgAlpa:(CGFloat)alpa
                      animated:(BOOL)animated
                    fullScreen:(BOOL)fullLayout
                  overKeyboard:(BOOL)overKb
                   andAutoHide:(BOOL)autoHide {
    if (!indicator) {
        indicator = [[WaitIndicatorView alloc] initWithFrame:self.window.bounds];
    }
    if (fullLayout) {
        indicator.frame = CGRectMake(0, 0, screentWith, screentContentHeight);
    } else {
        indicator.frame =
                CGRectMake((screentWith - 90 * 1.2) / 2,
                           (screentContentHeight - 66) / 2.0, 90 * 1.2, 66 * 1.2);
    }

    indicator.title = title ? title : @"加载中";
    indicator.subTitle = subTitle ? subTitle : @"";
    indicator.animated = animated;
    indicator.alpa = alpa;
    [indicator updateLayout];

    if (overKb) {
        NSInteger count = [[UIApplication sharedApplication].windows count];
        if (count >= 1) {
            UIWindow *w =
                    [[UIApplication sharedApplication]
                                    .windows objectAtIndex:count - 1];
            [w addSubview:indicator];
        }
    } else {
        [self.window addSubview:indicator];
        [self.window bringSubviewToFront:indicator];
    }

    if (autoHide) {
        [self performSelector:@selector(hideIndicator)
                     withObject:nil
                     afterDelay:1.0];
    }
}

- (void)showIntegralViewWithTitle:(NSString *)title
                         andScore:(NSString *)score
                      andIconPath:(NSString *)iconpath {
    if (!integralV) {
        integralV = [[KKZIntegralView alloc] initWithFrame:self.window.bounds];
    }
    integralV.alpha = 1;
    [integralV updateWithTitle:title andScore:score andIconPath:iconpath];

    [self.window addSubview:integralV];
    [self.window bringSubviewToFront:integralV];

    //    [self hideintegralV];
    __weak typeof(self) weakSelf = self;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [weakSelf hideintegralV];
    });
}

- (void)hideIndicator {
    [indicator removeFromSuperview];
//    [[LoadingViewManager sharedInstance] stop];
}

- (void)hideintegralV {
    [UIView animateWithDuration:1
            animations:^{
                integralV.alpha = 0;
            }
            completion:^(BOOL finished) {
                [integralV removeFromSuperview];
            }];
}

- (BOOL)isIndicator {
    if (indicator && [indicator superview]) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark umeng delegate
- (NSString *)channelId {
    return @"App Store";
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask]
            lastObject];
}

#pragma mark shareSDK relate
- (void)bringShareViewControllerToFront {
#warning 是否需要修改
    //    self.window.rootViewController = shareViewCtr;
    //    [self pushViewController:shareViewCtr animation:NO];
}

- (void)sendShareViewControllerToBack {
#warning 是否需要修改
    //    [self popViewControllerAnimated:NO];
}

// TODO 社会化组件封装
- (void)initializePlat {
    //向微信注册
    [WXApi registerApp:kWeixinKey withDescription:@"demo 2.0"];

    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:kSinaKey
                               appSecret:kSinaSecret
                             redirectUri:kSinaCallback];

    //添加微信应用
    //    [ShareSDK connectWeChatWithAppId:kWeixinKey
    //                           wechatCls:[WXApi class]];
    [ShareSDK connectWeChatWithAppId:kWeixinKey
                           appSecret:kWeixinSecret
                           wechatCls:[WXApi class]];

    /**
   连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
   http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
   如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
   **/
//    [ShareSDK connectQZoneWithAppKey:kQzoneAPIKey
//                           appSecret:kQzoneSecretKey
//                   qqApiInterfaceCls:[QQApiInterface class]
//                     tencentOAuthCls:[TencentOAuth class]];
    //导入QQ互联和QQ好友分享需要的外部库类型，如果不需要QQ空间SSO和QQ好友分享可以不调用此方法
//    [ShareSDK importQQClass:[QQApiInterface class]
//            tencentOAuthCls:[TencentOAuth class]];

    //添加QQ应用  注册网址  http://open.qq.com/
//    [ShareSDK connectQQWithQZoneAppKey:kQzoneAPIKey
//                     qqApiInterfaceCls:[QQApiInterface class]
//                       tencentOAuthCls:[TencentOAuth class]];

    /**
   连接腾讯微博开放平台应用以使用相关功能，此应用需要引用TencentWeiboConnection.framework
   http://dev.t.qq.com上注册腾讯微博开放平台应用，并将相关信息填写到以下字段
   **/
    [ShareSDK connectTencentWeiboWithAppKey:kQQWeiBoAPIKey
                                  appSecret:kQQWeiBoSecretKey
                                redirectUri:kQQWeiBoCallback];

    //开启QQ空间网页授权开关(optional)
//    id<ISSQZoneApp> app =
//            (id<ISSQZoneApp>) [ShareSDK getClientWithType:ShareTypeQQSpace];
//    [app setIsAllowWebAuthorize:YES];
}

//微信支付
- (void)onResp:(BaseResp *)resp {

    NSString *strMsg = @"";
    NSString *strTitle;

    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if ([resp isKindOfClass:[PayResp class]]) {
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];

        switch (resp.errCode) {
            case WXSuccess:
                //                strMsg = @"支付结果：支付成功！";
                //                NSLog(@"支付成功－PaySuccess，retcode = %d",
                //                resp.errCode);

                if ([PAY_WEIXIN_TYPE isEqualToString:@"payorder"]) {
                    [[NSNotificationCenter defaultCenter]
                            postNotificationName:@"wxpaySucceedNotification"
                                          object:nil];
                }
                if ([PAY_WEIXIN_TYPE isEqualToString:@"imprest"]) {
                    [[NSNotificationCenter defaultCenter]
                            postNotificationName:@"wxImprestSucceed"
                                          object:nil];
                }

                break;

            default:
                if (resp.errCode == -2) {
                    //                    strMsg = [NSString
                    //                    stringWithFormat:@"支付结果：您放弃了本次交易！"];

                } else {
                    strMsg =
                            [NSString stringWithFormat:
                                              @"支付结果：支付异常，请稍后重试！"];
                }
                //                NSLog(@"错误，retcode = %d, retstr = %@",
                //                resp.errCode,resp.errStr);
                break;
        }
    }

    if (strMsg.length) {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
        //        message:strMsg delegate:self cancelButtonTitle:@"OK"
        //        otherButtonTitles:nil, nil];
        //        [alert show];

        [appDelegate showAlertViewForTitle:@""
                                   message:strMsg
                              cancelButton:@"确"
                                           @"定"];
    }
}

//环信
// App进入后台

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter]
            postNotificationName:@"AppDidEnterBackground"
                          object:nil];
}

// App将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"rerunthevideo"
                                                        object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appBecomeActive"
                                                        object:nil];
}

- (void)loadNotification {
    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(videoStarted:)
                   name:MoviePlayerControllerDidEnterFullscreenNotification
                 object:nil]; // 播放器即将播放通知

    [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(videoFinished:)
                   name:MoviePlayerControllerDidExitFullscreenNotification
                 object:nil]; // 播放器即将退出通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(login) name:KKZLoginFailNotificationName object:nil];
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application
  supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    if (_isFull) {
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)videoStarted:(NSNotification *)notification { // 开始播放
    KKZAppDelegate *appDelegate =
            (KKZAppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegate.isFull = YES;
}

- (void)videoFinished:(NSNotification *)notification { // 完成播放
    KKZAppDelegate *appDelegate =
            (KKZAppDelegate *) [[UIApplication sharedApplication] delegate];
    appDelegate.isFull = NO;
    if ([[UIDevice currentDevice]
                respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation
                invocationWithMethodSignature:
                        [UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)getAppUUID {
    UIDevice *device = [UIDevice currentDevice]; //创建设备对象
    NSString *deviceUID = [[NSString alloc]
            initWithString:[[device identifierForVendor] UUIDString]];
    if ([deviceUID length] == 0) {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        if (uuid) {
            deviceUID = (__bridge_transfer NSString *) CFUUIDCreateString(NULL, uuid);
            CFRelease(uuid);
        }
    }

    APP_UUID_WRITE(deviceUID);
}

- (void)loadTitleListRequest {

    ClubRequest *request = [ClubRequest new];
    [request requestBBSTab:^(NSArray *_Nullable tabs) {
        self.discoveryTabsList = tabs;
    }
                   failure:nil];
}

// GeTuiSdk 注: iOS7.0 以后支持APP后台刷新数据，会回调
// performFetchWithCompletionHandler 接口，此处为保证个推数据刷新需调用[GeTuiSdk
// resume] 接口恢复个推SDK 运行刷新数据。
- (void)application:(UIApplication *)application
        performFetchWithCompletionHandler:
                (void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
//    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}



/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    DLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    DLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}

-(void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData
                           andTaskId:(NSString *)taskId
                            andMsgId:(NSString *)msgId
                          andOffLine:(BOOL)offLine
                         fromGtAppId:(NSString *)appId
{
    
//    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];

    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:payloadData
                                                        options:NSJSONReadingMutableContainers
                                                          error:nil];
    if (dic && offLine == NO) {
        [[KKZRemoteNotificationCenter sharedInstance] handle:dic showAlert:YES];

    }else if (dic && [UIApplication sharedApplication].applicationState == UIApplicationStateInactive){
        [[KKZRemoteNotificationCenter sharedInstance] handle:dic showAlert:NO];
    }
    
//    [GeTuiSdk clearAllNotificationForNotificationBar];
}

@end
