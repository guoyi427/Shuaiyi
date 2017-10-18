//
//  UserViewController.m
//  CIASMovie
//
//  Created by cias on 2016/12/7.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "UserViewController.h"
#import "UserLoginView.h"
#import "UserRegisterCodeView.h"
#import "UserRegisterPhoneView.h"
#import "UserForgetPWPhoneView.h"
#import "UserForgetPWCodeView.h"
#import "UserForgetResetPWView.h"
#import "UserRegisterSetPWView.h"
#import "UserDefault.h"
#import <Category_KKZ/UIImage+Resize.h>
//#import "UIImage+Resize.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AccoutViewController.h"
#import "OrderListViewController.h"
#import "UserRequest.h"
#import "User.h"
#import "DataEngine.h"
#import "CinemaListViewController.h"
#import "BindCardViewController.h"
#import "VipCardRechargeController.h"
//#import "CouponListViewController.h"
#import "KKZTextUtility.h"
//#import "VipcardViewController.h"

@interface UserViewController ()

@property (nonatomic, strong) UIButton           * loginBtn;
@property (nonatomic, strong) UILabel            * userNickNameLabel;
@property (nonatomic, strong) UIView             * backView;

@property (nonatomic, strong) UIImageView             * headerImageView;
@property (nonatomic, strong) UIImageView             * userPhotoView,*userNickNameImageView,*editImageView;
@property (nonatomic, strong) UIImage                 * placeHolderImage,*userNickNameImage;
@property (nonatomic, assign) int sexValue;

//

@property (nonatomic, strong) UIVisualEffectView * blurEffectView;

@end

@implementation UserViewController


- (void)dealloc {
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"blurEffectViewBackgroundColor" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"handleUserSignOut" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"handleLoginViewSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.hideNavigationBar = YES;
    self.sexValue = 3;
    
    //MARK: 添加顶部背景图
    [self addHeaderImageView];
    
    //MARK: 添加余下控件
    [self addQuickBtnView];
    //    DLog(@"%@", [DataEngine sharedDataEngine].sessionId);
    
    //最后添加浮层 75%透明度，颜色#000000
    //    [[UIApplication sharedApplication].keyWindow addSubview:self.blurEffectView];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserLoginViewSuccessNotification:) name:@"handleLoginViewSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSignOutNotification:) name:@"handleUserSignOut" object:nil];
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldChangehangeBackGroundColor:) name:@"blurEffectViewBackgroundColor" object:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //    self.navigationController.navigationBar.topItem.title = @"我的";
    if (!Constants.isAuthorized) {
        self.editImageView.hidden = YES;
        //MARK: 先隐藏，登录成功后，不隐藏
        self.userNickNameLabel.hidden = YES;
        self.userNickNameImageView.hidden = YES;
        //添加 登录按钮
        self.loginBtn.hidden = NO;
        [self.userPhotoView sd_setImageWithURL:nil placeholderImage:self.placeHolderImage];
        //        [UIView animateWithDuration:.2 animations:^{
        //            self.blurEffectView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
        //
        //        } completion:^(BOOL finished) {
        //            //加载登录view
        //            //用于遮盖状态栏
        //            [[UIApplication sharedApplication].keyWindow setWindowLevel:UIWindowLevelAlert];
        //            if (!_loginView) {
        //                [[UIApplication sharedApplication].keyWindow addSubview:self.loginView];
        //            }
        //        }];
        
    } else {
        User * user = (User *)[KKZTextUtility readPersonArrayData];
        if ((user.phoneNumber.length < 11) || (user.phoneNumber.intValue == 0)) {
            
        } else {
            DLog(@"本地保存的User：%@", user);
            self.loginBtn.hidden = YES;
            self.editImageView.hidden = NO;
            //MARK: 先隐藏，登录成功后，不隐藏
            self.userNickNameLabel.hidden = NO;
            self.userNickNameLabel.text = @"";
            self.userPhotoView.image = nil;
            
            if ([user.headingUrl hasPrefix:@"http://"] || [user.headingUrl hasPrefix:@"https://"]) {
                [self.userPhotoView sd_setImageWithURL:[NSURL URLWithString:user.headingUrl] placeholderImage:self.placeHolderImage];
            } else {
                self.userPhotoView.image = [UIImage imageNamed:@"login_logo"];
            }
            
            if (user.sex.intValue == 1) {
                //男
                self.userNickNameImageView.hidden = NO;
                self.sexValue = 1;
            } else if (user.sex.intValue == 2) {
                //女
                self.userNickNameImageView.hidden = NO;
                self.sexValue = 2;
            } else {
                self.userNickNameImageView.hidden = YES;
            }
            NSString *userNameStr = user.nickName.length>0?user.nickName:[user.phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            self.userNickNameLabel.text = userNameStr;
            CGSize userNameStrSize = [KKZTextUtility measureText:userNameStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:15*Constants.screenWidthRate]];
            
            
            if (self.sexValue == 1) {
                //MARK: 1为男生
                self.userNickNameImage = [UIImage imageNamed:@"man_icon"];
                self.userNickNameLabel.frame = CGRectMake((kCommonScreenWidth -(userNameStrSize.width + 1 + 4 + self.userNickNameImage.size.width*Constants.screenWidthRate))/2, CGRectGetMaxY(self.userPhotoView.frame)+15*Constants.screenHeightRate, userNameStrSize.width + 1, userNameStrSize.height);
                self.userNickNameImageView.frame = CGRectMake(CGRectGetMaxX(self.userNickNameLabel.frame)+4, CGRectGetMaxY(self.userPhotoView.frame)+15*Constants.screenHeightRate+(CGRectGetHeight(self.userNickNameLabel.frame) - self.userNickNameImage.size.height*Constants.screenHeightRate)/2, self.userNickNameImage.size.width*Constants.screenWidthRate, self.userNickNameImage.size.height*Constants.screenHeightRate);
                self.userNickNameImageView.image = self.userNickNameImage;
            } else if (self.sexValue == 2){
                self.userNickNameImage = [UIImage imageNamed:@"lady_icon"];
                self.userNickNameLabel.frame = CGRectMake((kCommonScreenWidth -(userNameStrSize.width + 1 + 4 + self.userNickNameImage.size.width*Constants.screenWidthRate))/2, CGRectGetMaxY(self.userPhotoView.frame)+15*Constants.screenHeightRate, userNameStrSize.width + 1, userNameStrSize.height);
                self.userNickNameImageView.frame = CGRectMake(CGRectGetMaxX(self.userNickNameLabel.frame)+4, CGRectGetMaxY(self.userPhotoView.frame)+15*Constants.screenHeightRate+(CGRectGetHeight(self.userNickNameLabel.frame) - self.userNickNameImage.size.height*Constants.screenHeightRate)/2, self.userNickNameImage.size.width*Constants.screenWidthRate, self.userNickNameImage.size.height*Constants.screenHeightRate);
                self.userNickNameImageView.image = self.userNickNameImage;
                
            } else {
                self.userNickNameLabel.frame = CGRectMake((kCommonScreenWidth -(userNameStrSize.width + 1))/2, CGRectGetMaxY(self.userPhotoView.frame)+15*Constants.screenHeightRate, userNameStrSize.width + 1, userNameStrSize.height);
                self.userNickNameImageView.frame = CGRectMake(CGRectGetMaxX(self.userNickNameLabel.frame)+4, CGRectGetMaxY(self.userPhotoView.frame)+15*Constants.screenHeightRate+(CGRectGetHeight(self.userNickNameLabel.frame) - self.userNickNameImage.size.height*Constants.screenHeightRate)/2, self.userNickNameImage.size.width*Constants.screenWidthRate, self.userNickNameImage.size.height*Constants.screenHeightRate);
                self.userNickNameImageView.image = nil;
            }
        }
    }
    
    [self.navigationController.view removeGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    
}

- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.navigationController.view addGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
}

- (void) addHeaderImageView {
    [self.view addSubview:self.headerImageView];
    [self.headerImageView addSubview:self.userPhotoView];
    self.placeHolderImage = [UIImage centerResizeFrom:[UIImage imageNamed:@"login_user"] newSize:_userPhotoView.frame.size bgColor:[UIColor colorWithHex:@"#000000" a:0.3]];
    [self.userPhotoView sd_setImageWithURL:nil placeholderImage:self.placeHolderImage];
    //MARK: 这个在登录之后改动
    [self.headerImageView addSubview:self.userNickNameLabel];
    if (self.sexValue) {
        [self.headerImageView addSubview:self.userNickNameImageView];
    }
    [self.headerImageView addSubview:self.editImageView];
    [self.headerImageView addSubview:self.loginBtn];
    
}


- (void)userSignOutNotification:(NSNotification *)notification {
    BOOL didSignout = [notification object];
    if (didSignout) {
        self.editImageView.hidden = YES;
        //MARK: 先隐藏，登录成功后，不隐藏
        self.userNickNameLabel.hidden = YES;
        self.userNickNameImageView.hidden = YES;
        //添加 登录按钮
        self.loginBtn.hidden = NO;
    }
    
}

- (void)handleUserLoginViewSuccessNotification:(NSNotification *)notification {
    NSString *isFromRegister = [[notification userInfo] kkz_stringForKey:@"isFromRegister"];
    User *user = (User *)[[notification userInfo] objectForKey:@"data"];
    //    DLog(@"接受通知的user:%@",user);
    //    DLog(@"%@", isFromRegister);
    self.loginBtn.hidden = YES;
    self.editImageView.hidden = NO;
    //MARK: 先隐藏，登录成功后，不隐藏
    self.userNickNameLabel.hidden = NO;
    
    if ([user.headingUrl hasPrefix:@"http://"] || [user.headingUrl hasPrefix:@"https://"]) {
        [self.userPhotoView sd_setImageWithURL:[NSURL URLWithString:user.headingUrl] placeholderImage:self.placeHolderImage];
    } else {
        self.userPhotoView.image = [UIImage imageNamed:@"login_logo"];
    }
    
    
    if (user.sex.intValue == 1) {
        //男
        self.userNickNameImageView.hidden = NO;
        self.sexValue = 1;
    } else if (user.sex.intValue == 2) {
        //女
        self.userNickNameImageView.hidden = NO;
        self.sexValue = 2;
    } else {
        self.userNickNameImageView.hidden = YES;
    }
    NSString *userNameStr = user.nickName.length>0?user.nickName:[user.phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.userNickNameLabel.text = userNameStr;
    CGSize userNameStrSize = [KKZTextUtility measureText:userNameStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:15]];
    
    
    if (self.sexValue == 1) {
        //MARK: 1为男生
        self.userNickNameImage = [UIImage imageNamed:@"man_icon"];
        self.userNickNameLabel.frame = CGRectMake((kCommonScreenWidth -(userNameStrSize.width + 1 + 4 + self.userNickNameImage.size.width))/2, CGRectGetMaxY(self.userPhotoView.frame)+15, userNameStrSize.width + 1, userNameStrSize.height);
        self.userNickNameImageView.frame = CGRectMake(CGRectGetMaxX(self.userNickNameLabel.frame)+4, CGRectGetMaxY(self.userPhotoView.frame)+15+(CGRectGetHeight(self.userNickNameLabel.frame) - self.userNickNameImage.size.height)/2, self.userNickNameImage.size.width, self.userNickNameImage.size.height);
        self.userNickNameImageView.image = self.userNickNameImage;
    } else if (self.sexValue == 2){
        self.userNickNameImage = [UIImage imageNamed:@"lady_icon"];
        self.userNickNameLabel.frame = CGRectMake((kCommonScreenWidth -(userNameStrSize.width + 1 + 4 + self.userNickNameImage.size.width))/2, CGRectGetMaxY(self.userPhotoView.frame)+15, userNameStrSize.width + 1, userNameStrSize.height);
        self.userNickNameImageView.frame = CGRectMake(CGRectGetMaxX(self.userNickNameLabel.frame)+4, CGRectGetMaxY(self.userPhotoView.frame)+15+(CGRectGetHeight(self.userNickNameLabel.frame) - self.userNickNameImage.size.height)/2, self.userNickNameImage.size.width, self.userNickNameImage.size.height);
        self.userNickNameImageView.image = self.userNickNameImage;
        
    } else {
        self.userNickNameLabel.frame = CGRectMake((kCommonScreenWidth -(userNameStrSize.width + 1))/2, CGRectGetMaxY(self.userPhotoView.frame)+15, userNameStrSize.width + 1, userNameStrSize.height);
        self.userNickNameImageView.frame = CGRectMake(CGRectGetMaxX(self.userNickNameLabel.frame)+4, CGRectGetMaxY(self.userPhotoView.frame)+15+(CGRectGetHeight(self.userNickNameLabel.frame) - self.userNickNameImage.size.height)/2, self.userNickNameImage.size.width, self.userNickNameImage.size.height);
        self.userNickNameImageView.image = nil;
    }
    if ([isFromRegister isEqualToString:@"YES"]) {
        [[CIASAlertCancleView new] show:@"" message:@"恭喜您，注册成功" cancleTitle:@"知道了" callback:^(BOOL confirm) {
        }];
    }
}


//MARK:   四个按钮  

- (void) addQuickBtnView {
    
    if ([kIsBaoShanStandardAccountStyle isEqualToString:@"1"]) {
        //目前只有两个按钮，需单独处理
        [self getTwoBtnView];
    } else {
        //四个按钮，根据顺序分为两类
        [self getFourBtnView];
    }
}

- (void)getTwoBtnView {
    UIImage *orderImage = [UIImage imageNamed:@"personal_ticket"];
    UIImage *couponImage = [UIImage imageNamed:@"coupon"];
    
    CGFloat leftX = (kCommonScreenWidth - orderImage.size.width*Constants.screenHeightRate - couponImage.size.width *Constants.screenHeightRate- 105*Constants.screenHeightRate)/2;
    
    UIImageView *orderImageView = [[UIImageView alloc] init];
    UIImageView *couponImageView = [[UIImageView alloc] init];
    
    orderImageView.userInteractionEnabled = YES;
    couponImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:orderImageView];
    [self.view addSubview:couponImageView];
    
    orderImageView.image = orderImage;
    couponImageView.image = couponImage;
    
    UITapGestureRecognizer *orderImageViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderImageViewBtnClick:)];
    [orderImageView addGestureRecognizer:orderImageViewSingleTap];
    UITapGestureRecognizer *couponImageViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couponImageViewBtnClick:)];
    [couponImageView addGestureRecognizer:couponImageViewSingleTap];
    
    [orderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(leftX);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(orderImage.size.width*Constants.screenWidthRate, orderImage.size.height*Constants.screenHeightRate));
    }];
    [couponImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderImageView.mas_right).offset(105*Constants.screenWidthRate);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(couponImage.size.width*Constants.screenWidthRate, couponImage.size.height*Constants.screenHeightRate));
        
    }];
    
    UILabel *orderImageViewLabel = [[UILabel alloc] init];
    UILabel *couponImageViewLabel = [[UILabel alloc] init];
    [self.view addSubview:orderImageViewLabel];
    [self.view addSubview:couponImageViewLabel];
    
    NSString *orderImageViewLabelStr = @"";
    NSString *couponImageViewLabelStr = @"";
    orderImageViewLabelStr = @"电影票";
    couponImageViewLabelStr = @"优惠券";
    
    orderImageViewLabel.text = orderImageViewLabelStr;
    orderImageViewLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    orderImageViewLabel.textAlignment = NSTextAlignmentCenter;
    orderImageViewLabel.textColor = [UIColor colorWithHex:@"#333333"];
    
    couponImageViewLabel.text = couponImageViewLabelStr;
    couponImageViewLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    couponImageViewLabel.textAlignment = NSTextAlignmentCenter;
    couponImageViewLabel.textColor = [UIColor colorWithHex:@"#333333"];
    
    CGSize orderImageViewLabelStrSize = [KKZTextUtility measureText:orderImageViewLabelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    [orderImageViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(leftX);
        make.top.equalTo(orderImageView.mas_bottom).offset(10*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(orderImage.size.width*Constants.screenWidthRate, orderImageViewLabelStrSize.height));
    }];
    [couponImageViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderImageViewLabel.mas_right).offset(105*Constants.screenWidthRate);
        make.top.equalTo(orderImageView.mas_bottom).offset(10*Constants.screenHeightRate);
        make.size.mas_equalTo(CGSizeMake(couponImage.size.width*Constants.screenWidthRate, orderImageViewLabelStrSize.height));
    }];
    
    UIView *line1View = [[UIView alloc] init];
    line1View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [self.view addSubview:line1View];
    [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(orderImageViewLabel.mas_bottom).offset(25*Constants.screenHeightRate);
        make.height.equalTo(@(1));
    }];
    
    UIButton *allOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:allOrderBtn];
    [allOrderBtn setTitle:@"全部订单" forState:UIControlStateNormal];
    [allOrderBtn setImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
    allOrderBtn.titleLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
    [allOrderBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
    [allOrderBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(kCommonScreenWidth - 78), 0, 0)];
    [allOrderBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -(kCommonScreenWidth + 22))];
    [allOrderBtn addTarget:self action:@selector(allOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [allOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(line1View.mas_bottom).offset(0);
        make.height.equalTo(@(44*Constants.screenHeightRate));
    }];
    UIView *line2View = [[UIView alloc] init];
    line2View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [self.view addSubview:line2View];
    [line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(allOrderBtn.mas_bottom).offset(0);
        make.height.equalTo(@(1));
    }];
    UIButton *userAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:userAccountBtn];
    [userAccountBtn setTitle:@"账户" forState:UIControlStateNormal];
    [userAccountBtn setImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
    userAccountBtn.titleLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
    [userAccountBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
    [userAccountBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(kCommonScreenWidth - 50), 0, 0)];
    [userAccountBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -(kCommonScreenWidth-6))];
    [userAccountBtn addTarget:self action:@selector(userAccountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [userAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(line2View.mas_bottom).offset(0);
        make.height.equalTo(@(44*Constants.screenHeightRate));
    }];
    
    UIView *line3View = [[UIView alloc] init];
    line3View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [self.view addSubview:line3View];
    [line3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(userAccountBtn.mas_bottom).offset(0);
        make.height.equalTo(@(1));
    }];
    UIButton *userSettingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:userSettingBtn];
    [userSettingBtn setTitle:@"设置" forState:UIControlStateNormal];
    [userSettingBtn setImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
    userSettingBtn.titleLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
    [userSettingBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
    [userSettingBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(kCommonScreenWidth - 50), 0, 0)];
    [userSettingBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -(kCommonScreenWidth-6))];
    [userSettingBtn addTarget:self action:@selector(userSettingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [userSettingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(line3View.mas_bottom).offset(0);
        make.height.equalTo(@(44*Constants.screenHeightRate));
    }];
    UIView *line4View = [[UIView alloc] init];
    line4View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [self.view addSubview:line4View];
    [line4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(userSettingBtn.mas_bottom).offset(0);
        make.height.equalTo(@(1));
    }];
    
}

- (void) getFourBtnView {
    //星轶的快捷入口图片也改了
    UIImage *orderImage = [UIImage imageNamed:@"personal_ticket"];
    UIImage *chargeImage = [UIImage imageNamed:@"personal_topup"];
    UIImage *vipCardImage = [UIImage imageNamed:@"personal_addcard"];
    UIImage *vipCardListImage = [UIImage imageNamed:@"personal_vipcard"];
    UIImage *couponImage = [UIImage imageNamed:@"coupon"];
    
    CGFloat leftX = (kCommonScreenWidth - orderImage.size.width*Constants.screenHeightRate - chargeImage.size.width*Constants.screenHeightRate - vipCardListImage.size.width*Constants.screenHeightRate - couponImage.size.width *Constants.screenHeightRate- 45*3*Constants.screenHeightRate)/2;
    
    UIImageView *orderImageView = [[UIImageView alloc] init];
    UIImageView *chargeImageView = [[UIImageView alloc] init];
    UIImageView *vipCardImageView = [[UIImageView alloc] init];
    UIImageView *couponImageView = [[UIImageView alloc] init];
    
    orderImageView.userInteractionEnabled = YES;
    chargeImageView.userInteractionEnabled = YES;
    vipCardImageView.userInteractionEnabled = YES;
    couponImageView.userInteractionEnabled = YES;
    
    [self.view addSubview:orderImageView];
    [self.view addSubview:chargeImageView];
    [self.view addSubview:vipCardImageView];
    [self.view addSubview:couponImageView];
    
    orderImageView.image = orderImage;
    chargeImageView.image = chargeImage;
    if ([kIsXinchengAccountStyle isEqualToString:@"1"]) {
        vipCardImageView.image = vipCardListImage;
    }
    if ([kIsCMSStandardAccountStyle isEqualToString:@"1"]) {
        vipCardImageView.image = vipCardImage;
    }
    
    couponImageView.image = couponImage;
    
    UITapGestureRecognizer *orderImageViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderImageViewBtnClick:)];
    [orderImageView addGestureRecognizer:orderImageViewSingleTap];
    
    UITapGestureRecognizer *chargeImageViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chargeImageViewBtnClick:)];
    [chargeImageView addGestureRecognizer:chargeImageViewSingleTap];
    
    UITapGestureRecognizer *vipCardImageViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(vipCardImageViewBtnClick:)];
    [vipCardImageView addGestureRecognizer:vipCardImageViewSingleTap];
    
    UITapGestureRecognizer *couponImageViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(couponImageViewBtnClick:)];
    [couponImageView addGestureRecognizer:couponImageViewSingleTap];
    
    if ([kIsXinchengAccountStyle isEqualToString:@"1"]) {
        [orderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(leftX);
            make.top.equalTo(self.headerImageView.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(orderImage.size.width*Constants.screenWidthRate, orderImage.size.height*Constants.screenHeightRate));
        }];
        [vipCardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(orderImageView.mas_right).offset(45*Constants.screenWidthRate);
            make.top.equalTo(self.headerImageView.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(vipCardListImage.size.width*Constants.screenWidthRate, vipCardListImage.size.height*Constants.screenHeightRate));
            
        }];
        
        [couponImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(vipCardImageView.mas_right).offset(45*Constants.screenWidthRate);
            make.top.equalTo(self.headerImageView.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(vipCardListImage.size.width*Constants.screenWidthRate, vipCardListImage.size.height*Constants.screenHeightRate));
            
        }];
        [chargeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(couponImageView.mas_right).offset(45*Constants.screenWidthRate);
            make.top.equalTo(self.headerImageView.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(chargeImage.size.width*Constants.screenWidthRate, chargeImage.size.height*Constants.screenHeightRate));
        }];
    }
    if ([kIsCMSStandardAccountStyle isEqualToString:@"1"]) {
        [orderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(leftX);
            make.top.equalTo(self.headerImageView.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(orderImage.size.width*Constants.screenWidthRate, orderImage.size.height*Constants.screenHeightRate));
        }];
        [chargeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(orderImageView.mas_right).offset(45*Constants.screenWidthRate);
            make.top.equalTo(self.headerImageView.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(chargeImage.size.width*Constants.screenWidthRate, chargeImage.size.height*Constants.screenHeightRate));
        }];
        [vipCardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(chargeImageView.mas_right).offset(45*Constants.screenWidthRate);
            make.top.equalTo(self.headerImageView.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(vipCardListImage.size.width*Constants.screenWidthRate, vipCardListImage.size.height*Constants.screenHeightRate));
            
        }];
        
        [couponImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(vipCardImageView.mas_right).offset(45*Constants.screenWidthRate);
            make.top.equalTo(self.headerImageView.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(vipCardListImage.size.width*Constants.screenWidthRate, vipCardListImage.size.height*Constants.screenHeightRate));
            
        }];
    }
    
    
    UILabel *orderImageViewLabel = [[UILabel alloc] init];
    UILabel *chargeImageViewLabel = [[UILabel alloc] init];
    UILabel *vipCardImageViewLabel = [[UILabel alloc] init];
    UILabel *couponImageViewLabel = [[UILabel alloc] init];
    
    [self.view addSubview:orderImageViewLabel];
    [self.view addSubview:chargeImageViewLabel];
    [self.view addSubview:vipCardImageViewLabel];
    [self.view addSubview:couponImageViewLabel];
    
    NSString *orderImageViewLabelStr = @"";
    NSString *chargeImageViewLabelStr = @"";
    NSString *vipCardImageViewLabelStr = @"";
    NSString *couponImageViewLabelStr = @"";
    
    if ([kIsXinchengAccountStyle isEqualToString:@"1"]) {
        orderImageViewLabelStr = @"电影票";
        chargeImageViewLabelStr = @"充值";
        vipCardImageViewLabelStr = @"会员卡";
        couponImageViewLabelStr = @"优惠券";
    }
    if ([kIsCMSStandardAccountStyle isEqualToString:@"1"]) {
        orderImageViewLabelStr = @"电影票";
        chargeImageViewLabelStr = @"充值";
        vipCardImageViewLabelStr = @"绑卡";
        couponImageViewLabelStr = @"优惠券";
    }
    
    orderImageViewLabel.text = orderImageViewLabelStr;
    orderImageViewLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    orderImageViewLabel.textAlignment = NSTextAlignmentCenter;
    orderImageViewLabel.textColor = [UIColor colorWithHex:@"#333333"];
    
    chargeImageViewLabel.text = chargeImageViewLabelStr;
    chargeImageViewLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    chargeImageViewLabel.textAlignment = NSTextAlignmentCenter;
    chargeImageViewLabel.textColor = [UIColor colorWithHex:@"#333333"];
    
    vipCardImageViewLabel.text = vipCardImageViewLabelStr;
    vipCardImageViewLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    vipCardImageViewLabel.textAlignment = NSTextAlignmentCenter;
    vipCardImageViewLabel.textColor = [UIColor colorWithHex:@"#333333"];
    
    couponImageViewLabel.text = couponImageViewLabelStr;
    couponImageViewLabel.font = [UIFont systemFontOfSize:13*Constants.screenWidthRate];
    couponImageViewLabel.textAlignment = NSTextAlignmentCenter;
    couponImageViewLabel.textColor = [UIColor colorWithHex:@"#333333"];
    
    CGSize orderImageViewLabelStrSize = [KKZTextUtility measureText:orderImageViewLabelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13*Constants.screenWidthRate]];
    if ([kIsXinchengAccountStyle isEqualToString:@"1"]) {
        [orderImageViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(leftX);
            make.top.equalTo(orderImageView.mas_bottom).offset(10*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(orderImage.size.width*Constants.screenWidthRate, orderImageViewLabelStrSize.height));
        }];
        
        [vipCardImageViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(orderImageViewLabel.mas_right).offset(45*Constants.screenWidthRate);
            make.top.equalTo(orderImageView.mas_bottom).offset(10*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(vipCardListImage.size.width*Constants.screenWidthRate, orderImageViewLabelStrSize.height));
        }];
        
        [couponImageViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(vipCardImageViewLabel.mas_right).offset(45*Constants.screenWidthRate);
            make.top.equalTo(orderImageView.mas_bottom).offset(10*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(couponImage.size.width*Constants.screenWidthRate, orderImageViewLabelStrSize.height));
        }];
        [chargeImageViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(couponImageViewLabel.mas_right).offset(45*Constants.screenWidthRate);
            make.top.equalTo(orderImageView.mas_bottom).offset(10*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(chargeImage.size.width*Constants.screenWidthRate, orderImageViewLabelStrSize.height));
        }];
    }
    if ([kIsCMSStandardAccountStyle isEqualToString:@"1"]) {
        [orderImageViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(leftX);
            make.top.equalTo(orderImageView.mas_bottom).offset(10*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(orderImage.size.width*Constants.screenWidthRate, orderImageViewLabelStrSize.height));
        }];
        [chargeImageViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(orderImageViewLabel.mas_right).offset(45*Constants.screenWidthRate);
            make.top.equalTo(orderImageView.mas_bottom).offset(10*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(chargeImage.size.width*Constants.screenWidthRate, orderImageViewLabelStrSize.height));
        }];
        [vipCardImageViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(chargeImageViewLabel.mas_right).offset(45*Constants.screenWidthRate);
            make.top.equalTo(orderImageView.mas_bottom).offset(10*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(vipCardListImage.size.width*Constants.screenWidthRate, orderImageViewLabelStrSize.height));
        }];
        
        [couponImageViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(vipCardImageViewLabel.mas_right).offset(45*Constants.screenWidthRate);
            make.top.equalTo(orderImageView.mas_bottom).offset(10*Constants.screenHeightRate);
            make.size.mas_equalTo(CGSizeMake(couponImage.size.width*Constants.screenWidthRate, orderImageViewLabelStrSize.height));
        }];
    }
    
    
    UIView *line1View = [[UIView alloc] init];
    line1View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [self.view addSubview:line1View];
    [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(orderImageViewLabel.mas_bottom).offset(25*Constants.screenHeightRate);
        make.height.equalTo(@(1));
    }];
    
    UIButton *allOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:allOrderBtn];
    [allOrderBtn setTitle:@"全部订单" forState:UIControlStateNormal];
    [allOrderBtn setImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
    allOrderBtn.titleLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
    [allOrderBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
    [allOrderBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(kCommonScreenWidth - 78), 0, 0)];
    [allOrderBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -(kCommonScreenWidth + 22))];
    [allOrderBtn addTarget:self action:@selector(allOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [allOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(line1View.mas_bottom).offset(0);
        make.height.equalTo(@(44*Constants.screenHeightRate));
    }];
    UIView *line2View = [[UIView alloc] init];
    line2View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [self.view addSubview:line2View];
    [line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(allOrderBtn.mas_bottom).offset(0);
        make.height.equalTo(@(1));
    }];
    UIButton *userAccountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:userAccountBtn];
    [userAccountBtn setTitle:@"账户" forState:UIControlStateNormal];
    [userAccountBtn setImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
    userAccountBtn.titleLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
    [userAccountBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
    [userAccountBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(kCommonScreenWidth - 50), 0, 0)];
    [userAccountBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -(kCommonScreenWidth-6))];
    [userAccountBtn addTarget:self action:@selector(userAccountBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [userAccountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(line2View.mas_bottom).offset(0);
        make.height.equalTo(@(44*Constants.screenHeightRate));
    }];
    
    UIView *line3View = [[UIView alloc] init];
    line3View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [self.view addSubview:line3View];
    [line3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(userAccountBtn.mas_bottom).offset(0);
        make.height.equalTo(@(1));
    }];
    UIButton *userSettingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:userSettingBtn];
    [userSettingBtn setTitle:@"设置" forState:UIControlStateNormal];
    [userSettingBtn setImage:[UIImage imageNamed:@"home_more"] forState:UIControlStateNormal];
    userSettingBtn.titleLabel.font = [UIFont systemFontOfSize:14*Constants.screenWidthRate];
    [userSettingBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
    [userSettingBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -(kCommonScreenWidth - 50), 0, 0)];
    [userSettingBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -(kCommonScreenWidth-6))];
    [userSettingBtn addTarget:self action:@selector(userSettingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [userSettingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(line3View.mas_bottom).offset(0);
        make.height.equalTo(@(44*Constants.screenHeightRate));
    }];
    UIView *line4View = [[UIView alloc] init];
    line4View.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [self.view addSubview:line4View];
    [line4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(userSettingBtn.mas_bottom).offset(0);
        make.height.equalTo(@(1));
    }];
    
}

#pragma mark -- 快捷按钮点击事件监听
//MARK: 设置按钮点击事件
- (void) userSettingBtnClick:(id)sender {
    DLog(@"跳转设置页");
    SettingViewController *setVc = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:setVc animated:YES];
    
}
//MARK: 账户按钮点击事件
- (void) userAccountBtnClick:(id)sender {
    DLog(@"跳转账户页");
    if (Constants.isAuthorized) {
        AccoutViewController *accountVc = [[AccoutViewController alloc] init];
        [self.navigationController pushViewController:accountVc animated:YES];
    } else {
        [[DataEngine sharedDataEngine] startLoginWith:YES withFinished:^(BOOL succeeded) {
            if (succeeded) {
                AccoutViewController *accountVc = [[AccoutViewController alloc] init];
                [self.navigationController pushViewController:accountVc animated:YES];
            }
        }];
    }
}
//MARK: 全部订单按钮点击事件
- (void) allOrderBtnClick:(id)sender {
    DLog(@"跳转全部订单页");
    if (Constants.isAuthorized) {
        OrderListViewController *orderVc = [[OrderListViewController alloc] init];
        orderVc.selectedIndex = 0;//注意：最好别越界,已加容错处理,只是想要的页面不对了
        [self.navigationController pushViewController:orderVc animated:YES];
    } else {
        [[DataEngine sharedDataEngine] startLoginWith:YES withFinished:^(BOOL succeeded) {
            if (succeeded) {
                OrderListViewController *orderVc = [[OrderListViewController alloc] init];
                orderVc.selectedIndex = 0;//注意：最好别越界,已加容错处理,只是想要的页面不对了
                [self.navigationController pushViewController:orderVc animated:YES];
            }
        }];
    }
    
    
}
//MARK: 电影票按钮点击事件
- (void) orderImageViewBtnClick:(id)sender {
    DLog(@"跳转电影票");
    if (Constants.isAuthorized) {
        NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"0",@"0", nil];
        OrderListViewController *orderVc = [[OrderListViewController alloc] init];
        orderVc.selectedIndex = 1;
        orderVc.btnSelectArr = tmpArr;
        [self.navigationController pushViewController:orderVc animated:YES];
    } else {
        [[DataEngine sharedDataEngine] startLoginWith:YES withFinished:^(BOOL succeeded) {
            if (succeeded) {
                NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"0",@"0", nil];
                OrderListViewController *orderVc = [[OrderListViewController alloc] init];
                orderVc.selectedIndex = 1;
                orderVc.btnSelectArr = tmpArr;
                [self.navigationController pushViewController:orderVc animated:YES];
            }
        }];
    }
}
//MARK: 充值按钮点击事件
- (void) chargeImageViewBtnClick:(id)sender {
    DLog(@"跳转充值");
    //    [[CIASAlertCancleView new] show:@"温馨提示" message:@"该功能尚未开放" cancleTitle:@"知道了" callback:^(BOOL confirm) {
    //    }];
    
    if([kIsHaveVipCard isEqualToString:@"1"]) {
        if (Constants.isAuthorized) {
            VipCardRechargeController *rechageVc = [[VipCardRechargeController alloc] init];
            [self.navigationController pushViewController:rechageVc animated:YES];
        } else {
            [[DataEngine sharedDataEngine] startLoginWith:YES withFinished:^(BOOL succeeded) {
                if (succeeded) {
                    VipCardRechargeController *rechageVc = [[VipCardRechargeController alloc] init];
                    [self.navigationController pushViewController:rechageVc animated:YES];
                }
            }];
        }
    } else {
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"该功能尚未开放" cancleTitle:@"知道了" callback:^(BOOL confirm) {
        }];
        
    }
    
    
}
//MARK: 绑卡按钮点击事件
- (void) vipCardImageViewBtnClick:(id)sender {
    
    if([kIsHaveVipCard isEqualToString:@"1"]) {
        if ([kIsXinchengAccountStyle isEqualToString:@"1"]) {
            //MARK: 绑卡需选择影院，先跳转影院列表
            if (Constants.isAuthorized) {
                //    __weak __typeof(self) weakSelf = self;
                VipcardViewController *ctr = [[VipcardViewController alloc]  init];
                [self.navigationController pushViewController:ctr animated:YES];
            } else {
                [[DataEngine sharedDataEngine] startLoginWith:YES withFinished:^(BOOL succeeded) {
                    if (succeeded) {
                        //    __weak __typeof(self) weakSelf = self;
                        VipcardViewController *ctr = [[VipcardViewController alloc]  init];
                        [self.navigationController pushViewController:ctr animated:YES];
                    }
                }];
            }
        }
        if ([kIsCMSStandardAccountStyle isEqualToString:@"1"]) {
            //MARK: 绑卡需选择影院，先跳转影院列表
            if (Constants.isAuthorized) {
                //    __weak __typeof(self) weakSelf = self;
                CinemaListViewController *ctr = [[CinemaListViewController alloc] init];
                ctr.isBindingCard = YES;
                ctr.selectCinemaForCardBlock = ^(NSString *cinemaId, NSString *cinemaName) {
                    DLog(@"%@_%@", cinemaId,cinemaName);
                    BindCardViewController *bindCard = [[BindCardViewController alloc] init];
                    bindCard.cinemaName = cinemaName;
                    bindCard.cinemaId = cinemaId;
                    [self.navigationController pushViewController:bindCard animated:YES];
                };
                [self.navigationController pushViewController:ctr animated:YES];
            } else {
                [[DataEngine sharedDataEngine] startLoginWith:YES withFinished:^(BOOL succeeded) {
                    if (succeeded) {
                        //    __weak __typeof(self) weakSelf = self;
                        CinemaListViewController *ctr = [[CinemaListViewController alloc] init];
                        ctr.isBindingCard = YES;
                        ctr.selectCinemaForCardBlock = ^(NSString *cinemaId, NSString *cinemaName) {
                            DLog(@"%@_%@", cinemaId,cinemaName);
                            BindCardViewController *bindCard = [[BindCardViewController alloc] init];
                            bindCard.cinemaName = cinemaName;
                            bindCard.cinemaId = cinemaId;
                            [self.navigationController pushViewController:bindCard animated:YES];
                        };
                        [self.navigationController pushViewController:ctr animated:YES];
                    }
                }];
            }
        }
        
    } else {
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"该功能尚未开放" cancleTitle:@"知道了" callback:^(BOOL confirm) {
        }];
        
    }
    
    DLog(@"跳转绑卡");
    
}

//
//MARK: 优惠券按钮点击事件
- (void) couponImageViewBtnClick:(id)sender {
    DLog(@"跳转优惠券");
    if ([kIsHaveCoupon isEqualToString:@"1"]) {
        if (Constants.isAuthorized) {
            CouponListViewController *couponVc = [[CouponListViewController alloc] initWithNibName:@"CouponListViewController" bundle:[NSBundle mainBundle]];
            
            [self.navigationController pushViewController:couponVc animated:YES];
        } else {
            [[DataEngine sharedDataEngine] startLoginWith:YES withFinished:^(BOOL succeeded) {
                if (succeeded) {
                    CouponListViewController *couponVc = [[CouponListViewController alloc] init];
                    [self.navigationController pushViewController:couponVc animated:YES];
                }
            }];
        }
    } else {
        //没有优惠券
        [[CIASAlertCancleView new] show:@"温馨提示" message:@"该功能尚未开放" cancleTitle:@"知道了" callback:^(BOOL confirm) {
        }];
    }
    
}


#pragma mark -- 登陆 修改头像按钮

//
- (void)editImageViewBtnClick:(id)sender {
    DLog(@"可以去修改头像和用户基本信息了");
#if  K_XINGYI
    EditProfileViewController *eVc = [[EditProfileViewController alloc] init];
    [self.navigationController pushViewController:eVc animated:YES];
#elif K_HENGDIAN
    EditProfileViewController *eVc = [[EditProfileViewController alloc] init];
    [self.navigationController pushViewController:eVc animated:YES];
#elif K_HUACHEN
    EditProfileViewController *eVc = [[EditProfileViewController alloc] init];
    [self.navigationController pushViewController:eVc animated:YES];
#else
    [[CIASAlertCancleView new] show:@"温馨提示" message:@"该功能尚未开放" cancleTitle:@"知道了" callback:^(BOOL confirm) {
    }];
#endif
    
    
}
//MARK: 登录按钮点击进行登录
- (void)userPhotoViewBtnClick:(id)sender {
    //加载虚化浮层,这个浮层可以共用
    [Constants.appDelegate loginIn];
}

- (void) loginBtnClick {
    //加载虚化浮层,这个浮层可以共用
    [Constants.appDelegate loginIn];
}

//MARK: --请求方法集中


//MARK:  控件初始化方法

- (UIImageView *)userNickNameImageView {
    if (!_userNickNameImageView) {
        _userNickNameImageView = [[UIImageView alloc] init];
        _userNickNameImageView.frame = CGRectMake(CGRectGetMaxX(self.userNickNameLabel.frame)+4, CGRectGetMaxY(self.userPhotoView.frame)+15*Constants.screenHeightRate+(CGRectGetHeight(self.userNickNameLabel.frame) - self.userNickNameImage.size.height*Constants.screenHeightRate)/2, self.userNickNameImage.size.width*Constants.screenWidthRate, self.userNickNameImage.size.height*Constants.screenHeightRate);
        _userNickNameImageView.image = self.userNickNameImage;
        _userNickNameImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _userNickNameImageView;
}

- (UILabel *)userNickNameLabel {
    if (!_userNickNameLabel) {
        NSString *userNameStr = @"维克虾米";
        CGSize userNameStrSize = [KKZTextUtility measureText:userNameStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:15*Constants.screenWidthRate]];
        _userNickNameLabel = [[UILabel alloc] init];
        if (self.sexValue == 0) {
            //MARK: 用户未设置性别
            self.userNickNameImage = nil;
            _userNickNameLabel.frame = CGRectMake((kCommonScreenWidth -(userNameStrSize.width + 1))/2, CGRectGetMaxY(self.userPhotoView.frame)+15*Constants.screenHeightRate, userNameStrSize.width + 1, userNameStrSize.height);
        } else {
            if (self.sexValue == 1) {
                //MARK: 1为男生
                self.userNickNameImage = [UIImage imageNamed:@"man_icon"];
            } else if (self.sexValue == 2) {
                self.userNickNameImage = [UIImage imageNamed:@"lady_icon"];
            }
            _userNickNameLabel.frame = CGRectMake((kCommonScreenWidth -(userNameStrSize.width + 1 + 4 + self.userNickNameImage.size.width*Constants.screenWidthRate))/2, CGRectGetMaxY(self.userPhotoView.frame)+15*Constants.screenHeightRate, userNameStrSize.width + 1, userNameStrSize.height);
        }
        _userNickNameLabel.text = userNameStr;
        _userNickNameLabel.font = [UIFont systemFontOfSize:15*Constants.screenWidthRate];
        _userNickNameLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
    }
    return _userNickNameLabel;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        UIImage *headerImage = [UIImage imageNamed:@"personal_bg"];
        _headerImageView.frame = CGRectMake(0, 0, kCommonScreenWidth, headerImage.size.height*Constants.screenHeightRate);
        _headerImageView.image = headerImage;
        _headerImageView.userInteractionEnabled = YES;
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerImageView;
}

- (UIImageView *)userPhotoView {
    if (!_userPhotoView) {
        _userPhotoView = [[UIImageView alloc] initWithFrame:CGRectMake((kCommonScreenWidth - 100*Constants.screenWidthRate)/2, 50*Constants.screenHeightRate, 100*Constants.screenWidthRate, 100*Constants.screenWidthRate)];
        _userPhotoView.contentMode = UIViewContentModeScaleAspectFit;
        _userPhotoView.layer.cornerRadius = 50*Constants.screenWidthRate;
        _userPhotoView.clipsToBounds = YES;
        _userPhotoView.userInteractionEnabled = YES;
        UITapGestureRecognizer *userPhotoViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userPhotoViewBtnClick:)];
        [_userPhotoView addGestureRecognizer:userPhotoViewSingleTap];
    }
    return _userPhotoView;
}

- (UIImageView *)editImageView {
    if (!_editImageView) {
        UIImage *editImage = [UIImage imageNamed:@"edit_uesr"];
        _editImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kCommonScreenWidth - 100*Constants.screenWidthRate)/2+100*Constants.screenWidthRate-(editImage.size.width*Constants.screenWidthRate-15*Constants.screenWidthRate), 35*Constants.screenHeightRate, editImage.size.width*Constants.screenWidthRate, editImage.size.height*Constants.screenHeightRate)];
        _editImageView.contentMode = UIViewContentModeCenter;
        _editImageView.image = editImage;
        _editImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *editImageViewSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editImageViewBtnClick:)];
        [_editImageView addGestureRecognizer:editImageViewSingleTap];
    }
    return _editImageView;
}

- (UIButton *) loginBtn {
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *loginStr = @"点击登录";
        CGSize loginStrSize = [KKZTextUtility measureText:loginStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:15*Constants.screenWidthRate]];
        _loginBtn.frame = CGRectMake((kCommonScreenWidth -(loginStrSize.width + 5))/2, CGRectGetMaxY(self.userPhotoView.frame)+15*Constants.screenHeightRate, loginStrSize.width + 5, loginStrSize.height);
        [_loginBtn setTitle:loginStr forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:15*Constants.screenWidthRate];
        [_loginBtn setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
        _loginBtn.backgroundColor = [UIColor clearColor];
        [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIView *) backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(kCommonScreenWidth/2, kCommonScreenHeight/2, 0, 0)];
        _backView.backgroundColor = [UIColor colorWithHex:@"#000000"];
        _backView.alpha = 0.8;
    }
    return _backView;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}


@end
