//
//  Splash欢迎页面
//
//  Created by alfaromeo on 11-11-21.
//  Copyright (c) 2011年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "SplashViewController.h"

#import "AppRequest.h"
#import "KKZUtility.h"
#import "TaskQueue.h"
#import "UserDefault.h"
#import "KKZAppDelegate+Splash.h"

static const NSInteger kPageDisplayDuration = 3;

@interface SplashViewController()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *skipBtn;
@property (nonatomic) int countdown;
@end

@implementation SplashViewController {
    
    //广告图片视图
    UIImageView *splashImage;
}


//MARK：
//页面处理流程：
//本地是否有上次加载的图片 -> 有 -> 加载图片 -> 执行动画 -> 跳转
//                     -> 否 -> 显示默认的图片 -> 跳转
//请求接口 -> 更新splash图片的地址并且加载到图片

#pragma mark - View lifecycle

/**
 *  视图将要出现
 *
 *  @param animated
 */
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [splashImage stopAnimating];
}

/**
 *  视图加载后
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.countdown = kPageDisplayDuration;

    [self initSubViews]; //初始化布局
}

/**
 * 初始化布局
 */
- (void)initSubViews {

    //显示广告的视图
    splashImage = [[UIImageView alloc] init];
    splashImage.clipsToBounds = YES;
    splashImage.contentMode = UIViewContentModeScaleAspectFill;
    splashImage.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:splashImage];
    
    UIImage *splash = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:K_SPLASH_IMAGE_STORE_KEY];
    splashImage.image = splash;
    
    //广告的覆盖视图
//    UIView *bootom = [UIView new];
//    [self.view addSubview:bootom];
//    [bootom mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@133);
//        make.width.equalTo(self.view);
//        make.bottom.equalTo(self.view.mas_bottom);
//    }];
    
//    UIImageView *iconV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_icon_slogan"]];
//    [bootom addSubview:iconV];
//    [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(bootom.mas_centerX);
//        make.bottom.equalTo(bootom.mas_bottom).offset(-20);
//    }];
    
    [splashImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.width.equalTo(self.view);
        make.top.equalTo(@0);
    }];
    
    /*
    UIButton *skipBtn = [UIButton buttonWithType:0];
    skipBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:skipBtn];
    [skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@58);
        make.height.equalTo(@24);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(@30);
    }];
    skipBtn.layer.cornerRadius = 12;
    skipBtn.layer.masksToBounds = YES;
    [skipBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5f]];
    [skipBtn setTitle:[NSString stringWithFormat:@"跳过 %@s", @(self.countdown)] forState:UIControlStateNormal];
    [skipBtn addTarget:self action:@selector(backFromSplashView) forControlEvents:UIControlEventTouchUpInside];
    self.skipBtn = skipBtn;

    */
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
}



/**
 *  进入主页面
 */
- (void)enterHomeController {
    [self performSelector:@selector(backFromSplashView) withObject:nil afterDelay:0];
}

/**
 *  进入视频页面
 */
- (void)backFromSplashView {
    [self.timer invalidate];
    self.timer = nil;
    [appDelegate backFromSplashView];
}

#pragma mark - Override from CommonViewController
- (BOOL)showTitleBar {
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) timerHandler
{
    if (self.countdown <= 0) {
        [self backFromSplashView];
    }
//    [self.skipBtn setTitle:[NSString stringWithFormat:@"跳过 %@s", @(self.countdown)] forState:UIControlStateNormal];
    
    self.countdown--;
}



@end
