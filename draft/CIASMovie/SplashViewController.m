//
//  SplashViewController.m
//  CIASMovie
//
//  Created by cias on 2016/12/6.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "SplashViewController.h"
#import "AppConfigureRequest.h"
#import "KKZTextUtility.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Category_KKZ/UIImage+Resize.h>
#import "SplashViewController+Video.h"


@interface SplashViewController ()
{
    UIImageView *bgImageView;
    UIView      *bgView;
    UILabel     *skipLabel,*timeLabel;
    UIImageView *skipImageView;
    NSString    *cachePath;
    NSString    *pictruePath;
    NSString    *videoPath;
}

@end

@implementation SplashViewController


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].splashBackgroundColor];
    self.hideNavigationBar = YES;
    self.navigationController.navigationBarHidden = YES;//用来隐藏；
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
    if ([kIsOneAnimation isEqualToString:@"1"]) {
        UIImage *logoImage = nil;
        logoImage = [UIImage imageNamed:@"futurecinema"];
        futureCinemaImageView = [UIImageView new];
        futureCinemaImageView.backgroundColor = [UIColor clearColor];
        futureCinemaImageView.clipsToBounds = YES;
        futureCinemaImageView.image = logoImage;
        futureCinemaImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:futureCinemaImageView];
        futureCinemaImageView.alpha = 0;
        [futureCinemaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@((kCommonScreenWidth-logoImage.size.width*Constants.screenWidthRate)/2));
            make.top.equalTo(@((kCommonScreenHeight - logoImage.size.height*Constants.screenHeightRate-25*Constants.screenHeightRate)/2));
            make.size.mas_equalTo(CGSizeMake(logoImage.size.width*Constants.screenWidthRate, logoImage.size.height*Constants.screenHeightRate));
            
        }];
    }
    if ([kIsThreeAnimation isEqualToString:@"1"]) {
        cameraImageView = [UIImageView new];
        //    cameraImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-2, -20, 215, 300)];
        cameraImageView.backgroundColor = [UIColor clearColor];
        cameraImageView.alpha = 0;
        cameraImageView.clipsToBounds = YES;
        cameraImageView.image = [UIImage imageNamed:@"Camera"];
        cameraImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:cameraImageView];
        [cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(-5));
            make.top.equalTo(@(-20));
            make.width.equalTo(@((215*kCommonScreenWidth)/375));
            make.height.equalTo(@((300*((215*kCommonScreenWidth)/375))/215));
        }];
        UIImage *logoImage = nil;
        logoImage = [UIImage imageNamed:@"futurecinema"];

        futureCinemaImageView = [UIImageView new];
        futureCinemaImageView.backgroundColor = [UIColor clearColor];
        futureCinemaImageView.clipsToBounds = YES;
        futureCinemaImageView.image = logoImage;
        futureCinemaImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:futureCinemaImageView];
        futureCinemaImageView.alpha = 0;
        [futureCinemaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@((kCommonScreenWidth-logoImage.size.width*Constants.screenWidthRate)/2));
            make.top.equalTo(@((kCommonScreenHeight - logoImage.size.height*Constants.screenHeightRate-25*Constants.screenHeightRate)/2));
            make.size.mas_equalTo(CGSizeMake(logoImage.size.width*Constants.screenWidthRate, logoImage.size.height*Constants.screenHeightRate));
            
        }];
        popcornImageView = [UIImageView new];
        popcornImageView.backgroundColor = [UIColor clearColor];
        popcornImageView.clipsToBounds = YES;
        popcornImageView.image = [UIImage imageNamed:@"Popcorn"];
        popcornImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:popcornImageView];
        popcornImageView.alpha = 0;
        [popcornImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            //        make.width.equalTo(@(kCommonScreenWidth));
            //        make.height.equalTo(@((kCommonScreenWidth*560)/1350));
            
#if K_HENGDIAN
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(@0);
#else
            if (kCommonScreenWidth>375) {
                make.bottom.equalTo(@(30));
                make.right.equalTo(@(70));
                make.width.equalTo(@(675+165*2));
                make.height.equalTo(@(280+100));
                
            }else{
                make.bottom.equalTo(@(20));
                make.right.equalTo(@(70));
                make.width.equalTo(@(675));
                make.height.equalTo(@(280));
            }
#endif
        }];
    }
    
    if ([kIsTwoAnimation isEqualToString:@"1"]) {
        
        UIImage *logoImage = [UIImage imageNamed:@"futurecinema"];
        
        futureCinemaImageView = [UIImageView new];
        futureCinemaImageView.backgroundColor = [UIColor clearColor];
        futureCinemaImageView.clipsToBounds = YES;
        futureCinemaImageView.image = logoImage;
        futureCinemaImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:futureCinemaImageView];
        futureCinemaImageView.alpha = 0;
        [futureCinemaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@((kCommonScreenWidth-logoImage.size.width*Constants.screenWidthRate)/2));
            make.top.equalTo(@(140));
            make.size.mas_equalTo(CGSizeMake(logoImage.size.width*Constants.screenWidthRate, logoImage.size.height*Constants.screenHeightRate));
            
        }];
        UIImage *popcornImage = [UIImage imageNamed:@"Popcorn"];
        popcornImageView = [UIImageView new];
        popcornImageView.backgroundColor = [UIColor clearColor];
        popcornImageView.clipsToBounds = YES;
        popcornImageView.image = popcornImage;
        popcornImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:popcornImageView];
        popcornImageView.alpha = 0;
        [popcornImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(@(20));
            make.left.right.equalTo(@(0));
            make.width.equalTo(@(popcornImage.size.width));
            make.height.equalTo(@(popcornImage.size.height));
        }];
    }
    
//    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
//    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    cachePath = [KKZTextUtility getCachesDirectory];
    pictruePath = [cachePath stringByAppendingPathComponent:@"flash.png"];
    videoPath = [cachePath stringByAppendingPathComponent:@"flash.mp4"];
    
    // 判读缓存数据是否存在
    if ([self isHaveCachesWithPath:pictruePath]) {
        
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight)];
        [self.view addSubview:bgImageView];
        bgImageView.hidden = YES;
        bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        bgImageView.backgroundColor = [UIColor clearColor];
        
        bgView = [[UIView alloc] init];
        [self.view addSubview:bgView];
        bgView.hidden = YES;
        bgView.backgroundColor = [UIColor colorWithHex:@"#000000"];
        bgView.alpha = 0.6;
        bgView.layer.cornerRadius = 5;
        bgView.clipsToBounds = YES;
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(15);
            make.right.equalTo(self.view.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(75, 50));
        }];
        UITapGestureRecognizer *bgViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewSingleTap:)];
        [bgView addGestureRecognizer:bgViewTapGestureRecognizer];
        
        NSString *skipLabelStr = @"跳过";
        CGSize skipLabelStrSize = [KKZTextUtility measureText:skipLabelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:15]];
        skipLabel = [[UILabel alloc] init];
        [bgView addSubview:skipLabel];
        skipLabel.text = skipLabelStr;
        skipLabel.userInteractionEnabled = NO;
        skipLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
        [skipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(10);
            make.top.equalTo(bgView.mas_top).offset(10);
            make.size.mas_equalTo(CGSizeMake(skipLabelStrSize.width+5, skipLabelStrSize.height));
        }];
        
        
        NSString *timeLabelStr = @"5秒";
        CGSize timeLabelStrSize = [KKZTextUtility measureText:timeLabelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
        timeLabel = [[UILabel alloc] init];
        [bgView addSubview:timeLabel];
        timeLabel.text = timeLabelStr;
        timeLabel.userInteractionEnabled = NO;
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView.mas_left).offset(10);
            make.top.equalTo(skipLabel.mas_bottom).offset(4);
            make.size.mas_equalTo(CGSizeMake(skipLabelStrSize.width+5, timeLabelStrSize.height));
        }];
        
        UIImage *skipImage = [UIImage imageNamed:@"login_arrow"];
        skipImageView = [[UIImageView alloc] init];
        [bgView addSubview:skipImageView];
        skipImageView.image = skipImage;
        skipImageView.userInteractionEnabled = NO;
        [skipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(skipLabel.mas_right).offset(7);
            make.top.equalTo(bgView.mas_top).offset((50-skipImage.size.height)/2);
            make.size.mas_equalTo(CGSizeMake(skipImage.size.width, skipImage.size.height));
        }];
        
    }
    
    
    
}

- (BOOL) isHaveCachesWithPath:(NSString *)path {
    // 判读缓存数据是否存在
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return YES;
    }
    return NO;
}


- (NSString *) getPictureCachesData {
    
    if ([self isHaveCachesWithPath:pictruePath]) {
        NSURL *pathUrl = [NSURL URLWithString:pictruePath];
        NSString *pathStr = [pathUrl path];
        return pathStr;
    }
    
    return @"";
}

- (NSString *) getVideoCachesData {

    if ([self isHaveCachesWithPath:videoPath]) {
        NSURL *pathUrl = [NSURL URLWithString:videoPath];
        NSString *pathStr = [NSString stringWithFormat:@"file://%@",[pathUrl path]];
        return pathStr;
    }
    
    return @"";
}

//点击手势
-(void)singleTap:(UITapGestureRecognizer *)gesture{
//    cameraImageView.alpha = 0;
//    popcornImageView.alpha = 0;
//    futureCinemaImageView.alpha = 0;
//    [self startCameraImageAnimation];
//    [self performSelector:@selector(startFutureImageAnimation) withObject:nil afterDelay:1.0f];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self startCameraImageAnimation];
    [self performSelector:@selector(startFutureImageAnimation) withObject:nil afterDelay:1.0f];
}

- (void) startCameraImageAnimation{
    if ([kIsTwoAnimation isEqualToString:@"1"] || [kIsOneAnimation isEqualToString:@"1"]) {
        
    } else {
        //3个动画才有
        cameraImageView.transform = CGAffineTransformMakeTranslation(0, -50);
        [UIView animateWithDuration:0.6 animations:^{
            cameraImageView.transform = CGAffineTransformMakeTranslation(1.0,1.0);
            cameraImageView.alpha = 1;
        }];
    }
    popcornImageView.transform = CGAffineTransformMakeTranslation(0, 35);
    [UIView animateWithDuration:0.6 animations:^{
        popcornImageView.transform = CGAffineTransformMakeTranslation(1.0,1.0);
        popcornImageView.alpha = 1;
    }];
    
}

- (void) startFutureImageAnimation{
    if (kCommonScreenWidth==320) {
        futureCinemaImageView.transform = CGAffineTransformMakeTranslation(0, -25);

    }else{
        futureCinemaImageView.transform = CGAffineTransformMakeTranslation(0, -25);
    }
    [UIView animateWithDuration:0.6 animations:^{
        
        futureCinemaImageView.transform = CGAffineTransformMakeTranslation(1.0,1.0);
        futureCinemaImageView.alpha = 1;
        
    }];
    
    [self performSelector:@selector(startDisappearAnimation) withObject:nil afterDelay:1.0f];
}

- (void) startDisappearAnimation{
    [UIView animateWithDuration:1.0f animations:^{
        if ([self isHaveCachesWithPath:pictruePath] || [self isHaveCachesWithPath:videoPath]) {
            if ([kIsOneAnimation isEqualToString:@"1"]) {
                if (futureCinemaImageView) {
                    [futureCinemaImageView removeFromSuperview];
                    futureCinemaImageView = nil;
                }
            }
            
            if ([kIsTwoAnimation isEqualToString:@"1"]) {
                if (futureCinemaImageView) {
                    [futureCinemaImageView removeFromSuperview];
                    futureCinemaImageView = nil;
                }
                if (popcornImageView) {
                    [popcornImageView removeFromSuperview];
                    popcornImageView = nil;
                }
            }
            
            if ([kIsThreeAnimation isEqualToString:@"1"]) {
                if (cameraImageView) {
                    [cameraImageView removeFromSuperview];
                    cameraImageView = nil;
                }
                if (popcornImageView) {
                    [popcornImageView removeFromSuperview];
                    popcornImageView = nil;
                }
                if (futureCinemaImageView) {
                    [futureCinemaImageView removeFromSuperview];
                    futureCinemaImageView = nil;
                }
            }
    
        } else {
            self.view.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
            self.view.alpha = 0.0f;
        }        

    } completion:^(BOOL finished) {
        //加入静态图或者视频逻辑
        //5s定时器或者点击事件
//        [self.view addSubview:bgImageView];
        if ([self isHaveCachesWithPath:pictruePath]) {
            bgImageView.hidden = NO;
            bgView.hidden = NO;
            timeCount = 5;
            self.timerOfSplash = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(beforeActivityMethodOfSplash:) userInfo:nil repeats:YES];
            UIImage *picImage = [UIImage imageWithContentsOfFile:[self getPictureCachesData]];
            bgImageView.image = picImage;
        } else if ([self isHaveCachesWithPath:videoPath]) {
            [self playVideoWithPath:[self getVideoCachesData]];
        } else {
            
            if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus <= 0) {
                [self performSelector:@selector(shouldBackWithoutNetwork) withObject:nil afterDelay:0.5f];
            } else {
                if (self.dismissBlock) {
                    self.dismissBlock();
                }
            }
            
        }
        
    }];
    
}
- (void)beforeActivityMethodOfSplash:(NSTimer *)time
{
    
    timeCount--;
    
    if (timeCount ==  0) {
        if (self.dismissBlock) {
            self.dismissBlock();
        }
        timeLabel.text = @"0秒";
        [timeLabel setNeedsDisplay];
        
        [_timerOfSplash invalidate];
        _timerOfSplash = nil;
        
    }else {
        //倒计时显示
        NSString *countDownStr = @"";
        
        if (timeCount < 0) {
            countDownStr = [NSString stringWithFormat:@"0秒"];
        }else{
            countDownStr = [NSString stringWithFormat:@"%d秒",timeCount];
        }
        timeLabel.text = countDownStr;
        [timeLabel setNeedsDisplay];
    }
}



- (void) shouldBackWithoutNetwork {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

//MARK: 跳过按钮
- (void)bgViewSingleTap:(UITapGestureRecognizer *)gesture {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    [_timerOfSplash invalidate];
    _timerOfSplash = nil;
}

- (void) willDismiss:(void (^)())a_block
{
    self.willDismissBlock = a_block;
}

- (void) dismissCallback:(void (^)())a_block
{
    self.dismissBlock = a_block;
}


- (BOOL)prefersStatusBarHidden {
    return NO;//隐藏为YES，显示为NO
}

@end
