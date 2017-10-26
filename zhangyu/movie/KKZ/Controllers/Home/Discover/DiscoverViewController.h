//
//  首页 - 发现
//
//  Created by KKZ on 15/8/6.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"
#import "KKZHorizonTableView.h"
#import "LoginViewController.h"

@class KotaListViewController;
@class ClubViewController;

@interface DiscoverViewController : CommonViewController <UIScrollViewDelegate, UIWebViewDelegate, LoginViewControllerDelegate, KKZHorizonTableViewDelegate> {

    UIView *kotaView;
    UIView *clubView;
    UIWebView *tabWebView;
    CGFloat viewPositionY;
    KKZHorizonTableView *horizonTableView;

    //已创建的控制器id和控制器View
    NSMutableDictionary *clubViewsMutableDict;

    //已创建的控制器id和控制器
    NSMutableDictionary *clubCtrsMutableDict;
}

@property (nonatomic, strong) NSString *webTitle;
@property (nonatomic, strong) NSString *userAgentYN;
@property (nonatomic, assign) BOOL BackFromChild;
@property (nonatomic, assign) BOOL isKotaPager;
@property (nonatomic, assign) NSInteger indexY;

@property (nonatomic, copy) NSString *childWebTitle;
@property (nonatomic, strong) UIViewController *childCtr;
@property (nonatomic, copy) NSString *currentUrl;

@property (nonatomic, strong) NSFileManager *userLogFileMgrYN;
@property (nonatomic, copy) NSString *userLogDocumentsDirectory;
@property (nonatomic, copy) NSString *userLogfilePath0;
@property (nonatomic, copy) NSString *userLogfilePath;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, copy) NSString *loadFileUrl;

@property (nonatomic, copy) NSString *login;

@property (nonatomic, copy) NSString *requestUrlStr;

@property (nonatomic, copy) NSString *loginedextraDiv;

@property (nonatomic, strong) KotaListViewController *kotaViewCtr;
@property (nonatomic, strong) ClubViewController *clubViewCtr;
@property (nonatomic, assign) BOOL isFirstLoad;

@end
