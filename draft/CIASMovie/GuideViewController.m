//
//  GuideViewController.m
//  CIASMovie
//
//  Created by avatar on 2017/2/21.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "GuideViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].splashBackgroundColor];
    self.hideNavigationBar = YES;
    if ([kIsOneAnimation isEqualToString:@"1"]) {
        //MARK: 动画只有logo展示
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
            make.top.equalTo(@((kCommonScreenHeight - logoImage.size.height*Constants.screenHeightRate-25*Constants.screenHeightRate)/2));
            make.size.mas_equalTo(CGSizeMake(logoImage.size.width*Constants.screenWidthRate, logoImage.size.height*Constants.screenHeightRate));
            
        }];
    }
    if([kIsThreeAnimation isEqualToString:@"1"]){
        //MARK: 动画分为3个部分，逐个进行展示
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
    
    //欢迎页面
    _welcome = [[WelcomeView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight)];
    _welcome.delegate = self;
    _welcome.hidden = YES;
    [self.view addSubview:_welcome];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self startCameraImageAnimation];
    [self performSelector:@selector(startFutureImageAnimation) withObject:nil afterDelay:1.0f];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
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
    
    [self performSelector:@selector(startDisappearAnimation) withObject:nil afterDelay:0.5f];
}

- (void) startDisappearAnimation{
    [UIView animateWithDuration:1.0f animations:^{
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
        
    } completion:^(BOOL finished) {
        _welcome.hidden = NO;
    }];
    
}

- (void) shouldBackWithoutNetwork {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
}

- (void)returnBackButtonClick {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
