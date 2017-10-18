//
//  OrderDetailViewController.m
//  CIASMovie
//
//  Created by cias on 2017/1/6.
//  Copyright © 2017年 cias. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "KKZTextUtility.h"
#import <Category_KKZ/UIImage+Resize.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "OrderRequest.h"
#import "Order.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <DateEngine_KKZ/DateEngine.h>
#import "SellPickUpViewController.h"
#import "UserDefault.h"
#import "CIASAlertImageView.h"

@interface OrderDetailViewController ()

//@property (nonatomic, strong) UIView    *chooseAlertView;

@end

@implementation OrderDetailViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    dispatch_async(
//                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                       
//                       
//                       
//                   });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    if (_chooseAlertView) {
//        rightBarBtn.selected = !rightBarBtn.selected;
//        [_chooseAlertView removeFromSuperview];
//        _chooseAlertView = nil;
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideNavigationBar = YES;
    self.hideBackBtn = YES;
    self.view.backgroundColor = [UIColor blackColor];
    
    moviePosterImageBg = [UIImageView new];
    moviePosterImageBg.contentMode = UIViewContentModeScaleAspectFill;
    moviePosterImageBg.backgroundColor = [UIColor clearColor];
    moviePosterImageBg.clipsToBounds = YES;
    [self.view addSubview:moviePosterImageBg];
    [moviePosterImageBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(kCommonScreenHeight));
    }];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.frame = CGRectMake(0, 0, kCommonScreenWidth, kCommonScreenHeight);
    blurEffectView.alpha = 0.9;
    [moviePosterImageBg addSubview:blurEffectView];


    holder = [UIScrollView new];
    holder.backgroundColor = [UIColor clearColor];
    [self.view addSubview:holder];
    holder.showsVerticalScrollIndicator = NO;
    
    CGFloat positionY = 86;
    if (Constants.isIphone5) {
        positionY = 70;
    }
    [holder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(positionY));
        make.left.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(kCommonScreenHeight-positionY));
    }];
    [self setupUI];
    [self setNavBarUI];
    [self requestTicketInfo];
}

- (void)updateLayout{
    validCodeLabelTip.hidden = YES;
    validCodeLabel.hidden = YES;
    validInfoBakLabelTip.hidden = YES;
    validInfoBakLabel.hidden = YES;
    validCodeLabelTip.text = @"取票号";
    validInfoBakLabelTip.text = @"验票码";

    
    CGFloat positionY = 86;
    CGFloat leftGap = 27;
    CGFloat leftGap1 = 20;
    
    if (Constants.isIphone5) {
        positionY = 76;
        leftGap = 22;
        leftGap1 = 17;
    }
    if (self.myOrder.orderTicket.thumbnailUrl.length) {
        [moviePosterImageBg sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:self.myOrder.orderTicket.thumbnailUrl] placeholderImage:nil];
    }

    UIImage *placeHolderImage = [UIImage centerResizeFrom:[UIImage imageNamed:@"photo_nopic"] newSize:moviePosterImage.frame.size bgColor:[UIColor clearColor]];
    [moviePosterImage sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:self.myOrder.orderTicket.thumbnailUrlStand] placeholderImage:placeHolderImage];
    
    NSMutableString *validCodeSeperationString = [[NSMutableString alloc] initWithCapacity:0];
    NSMutableString *validInfoBakSeperationString = [[NSMutableString alloc] initWithCapacity:0];

    if (self.myOrder.orderTicket.validCode.length) {
        [validCodeSeperationString appendString:self.myOrder.orderTicket.validCode];

        if (self.myOrder.orderTicket.validCode.length>=4) {
            [validCodeSeperationString insertString:@" " atIndex:4];
        }
        if (self.myOrder.orderTicket.validCode.length>=8) {
            [validCodeSeperationString insertString:@"\n" atIndex:9];
        }
        if (self.myOrder.orderTicket.validCode.length>=12) {
            [validCodeSeperationString insertString:@" " atIndex:14];
        }
        
    }

    if (self.myOrder.orderTicket.validInfoBak.length) {
        [validInfoBakSeperationString appendString:self.myOrder.orderTicket.validInfoBak];

        if (self.myOrder.orderTicket.validInfoBak.length>=4) {
            [validInfoBakSeperationString insertString:@" " atIndex:4];
        }
        if (self.myOrder.orderTicket.validInfoBak.length>=8) {
            [validInfoBakSeperationString insertString:@"\n" atIndex:9];
        }
        if (self.myOrder.orderTicket.validInfoBak.length>=12) {
            [validInfoBakSeperationString insertString:@" " atIndex:14];
        }
        
    }

    NSString *qrCodeString = @"";
    if (self.myOrder.orderTicket.validCode.length && self.myOrder.orderTicket.validInfoBak.length) {
        validCodeLabelTip.hidden = NO;
        validCodeLabel.hidden = NO;
        validInfoBakLabelTip.hidden = NO;
        validInfoBakLabel.hidden = NO;
        qrCodeString = [NSString stringWithFormat:@"%@|%@", self.myOrder.orderTicket.validCode, self.myOrder.orderTicket.validInfoBak];
        validCodeLabel.text = validCodeSeperationString;
        validInfoBakLabel.text = validInfoBakSeperationString;
    }else if (self.myOrder.orderTicket.validCode.length && (self.myOrder.orderTicket.validInfoBak.length<= 0)){
        validCodeLabelTip.hidden = NO;
        validCodeLabel.hidden = NO;
        validInfoBakLabelTip.hidden = YES;
        validInfoBakLabel.hidden = YES;
        validCodeLabel.text = validCodeSeperationString;
        validInfoBakLabel.text = @"一";//validInfoBakSeperationString;

        qrCodeString = [NSString stringWithFormat:@"%@", self.myOrder.orderTicket.validCode];
    }else if (self.myOrder.orderTicket.validInfoBak.length && (self.myOrder.orderTicket.validCode.length<= 0)){
        validCodeLabelTip.hidden = NO;
        validCodeLabel.hidden = NO;
        validInfoBakLabelTip.hidden = YES;
        validInfoBakLabel.hidden = YES;
        validCodeLabelTip.text = @"验票码";
        validCodeLabel.text = validInfoBakSeperationString;
        validInfoBakLabel.text = @"一";//validInfoBakSeperationString;
        qrCodeString = [NSString stringWithFormat:@"%@", self.myOrder.orderTicket.validInfoBak];
    }
//    self.myOrder.orderTicket.validCode = @"1234567890123456";
    
    qrCodeImageView.image = [self encodeQRImageWithContent:qrCodeString size:CGSizeMake(125, 125)];
    
    movieNameLabel.text = self.myOrder.orderTicket.filmName;
    movieEngLishLabel.text = self.myOrder.orderTicket.filmEnglishName;
    CGSize languageSize = [KKZTextUtility measureText:self.myOrder.orderTicket.language font:[UIFont systemFontOfSize:10]];
    languageLael.text = self.myOrder.orderTicket.language;
    [languageLael mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-15));
        make.top.equalTo(@(18));
        make.width.equalTo(@(languageSize.width+8));
        make.height.equalTo(@(15));
    }];
    
    CGSize screenTypeSize = [KKZTextUtility measureText:self.myOrder.orderTicket.filmType font:[UIFont systemFontOfSize:10]];
    screenTypeLabel.text = self.myOrder.orderTicket.filmType;
    [screenTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(languageLael.mas_left).offset(-3);
        make.top.equalTo(@(18));
        make.width.equalTo(@(screenTypeSize.width+8));
        make.height.equalTo(@(15));
    }];
    hallNameLabel.text = self.myOrder.orderTicket.screenName;
    NSMutableArray *seatInfoArray = (NSMutableArray *)[self.myOrder.orderTicket.seatInfo componentsSeparatedByString:@","];
    NSString *seatInfoString = @"";
    if ([seatInfoArray containsObject:@""]) {
        [seatInfoArray removeObject:@""];
    }
    if ([seatInfoArray containsObject:@","]) {
        [seatInfoArray removeObject:@","];
    }
    if ([seatInfoArray containsObject:@" "]) {
        [seatInfoArray removeObject:@" "];
    }

//    if (seatInfoArray.count>0 && [[seatInfoArray lastObject] isEqualToString:@","] && [[seatInfoArray lastObject] isEqualToString:@""]) {
//        [seatInfoArray removeLastObject];
//    }

    for (int i=0; i<seatInfoArray.count; i++) {
        if (seatInfoArray.count==1) {
            selectSeatsLabel.numberOfLines = 1;
            [selectSeatsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(timeLabel.mas_right).offset(8);
                make.top.equalTo(seatLabel.mas_bottom).offset(5);
                make.width.equalTo(@(((kCommonScreenWidth-51)/8)*3+10));
                make.height.equalTo(@(15));
            }];
            seatInfoString = [seatInfoArray objectAtIndex:0];
        }else if (seatInfoArray.count==2) {
            selectSeatsLabel.numberOfLines = 1;
            [selectSeatsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(timeLabel.mas_right).offset(8);
                make.top.equalTo(seatLabel.mas_bottom).offset(5);
                make.width.equalTo(@(((kCommonScreenWidth-51)/8)*3+10));
                make.height.equalTo(@(15));
            }];
            seatInfoString = [NSString stringWithFormat:@"%@/%@", [seatInfoArray objectAtIndex:0], [seatInfoArray objectAtIndex:1]];
//
//            NSMutableAttributedString *seatInfoAttibutedString = [[NSMutableAttributedString alloc] initWithString:seatInfoString];
////            NSRange redRange = NSMakeRange([[seatInfoArray objectAtIndex:0] length], 1);
//            NSRange redRange = NSMakeRange([[seatInfoAttibutedString string] rangeOfString:@"/"].location, [[seatInfoAttibutedString string] rangeOfString:@"/"].length);
//            //需要设置的位置
//            [seatInfoAttibutedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"b2b2b2"] range:redRange];
//            //设置颜色
//            [selectSeatsLabel setAttributedText:seatInfoAttibutedString];
        }else if (seatInfoArray.count==3) {
            selectSeatsLabel.numberOfLines = 2;
            [selectSeatsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(timeLabel.mas_right).offset(8);
                make.top.equalTo(seatLabel.mas_bottom).offset(3);
                make.width.equalTo(@(((kCommonScreenWidth-51)/8)*3+10));
                make.height.equalTo(@(32));
            }];

            seatInfoString = [NSString stringWithFormat:@"%@/%@\n%@", [seatInfoArray objectAtIndex:0], [seatInfoArray objectAtIndex:1], [seatInfoArray objectAtIndex:2]];
//            NSMutableAttributedString *seatInfoAttibutedString = [[NSMutableAttributedString alloc] initWithString:seatInfoString];
////            NSRange redRange = NSMakeRange([[seatInfoArray objectAtIndex:0] length], 1);
//            NSRange redRange = NSMakeRange([[seatInfoAttibutedString string] rangeOfString:@"/"].location, [[seatInfoAttibutedString string] rangeOfString:@"/"].length);
//
//            //需要设置的位置
//            [seatInfoAttibutedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"b2b2b2"] range:redRange];
//            //设置颜色
//            [selectSeatsLabel setAttributedText:seatInfoAttibutedString];
        }else if (seatInfoArray.count==4) {
            selectSeatsLabel.numberOfLines = 2;
            [selectSeatsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(timeLabel.mas_right).offset(8);
                make.top.equalTo(seatLabel.mas_bottom).offset(3);
                make.width.equalTo(@(((kCommonScreenWidth-51)/8)*3+10));
                make.height.equalTo(@(32));
            }];
            
            seatInfoString = [NSString stringWithFormat:@"%@/%@\n%@/%@", [seatInfoArray objectAtIndex:0], [seatInfoArray objectAtIndex:1], [seatInfoArray objectAtIndex:2], [seatInfoArray objectAtIndex:3]];
//            NSMutableAttributedString *seatInfoAttibutedString = [[NSMutableAttributedString alloc] initWithString:seatInfoString];
//            NSRange redRange = NSMakeRange([[seatInfoArray objectAtIndex:0] length], 1);
//            NSRange redRange = NSMakeRange([[seatInfoAttibutedString string] rangeOfString:@"/"].location, [[seatInfoAttibutedString string] rangeOfString:@"/"].length);
//            NSRange redRange1 = NSMakeRange([[seatInfoAttibutedString string] rangeOfString:@"/"].location, [[seatInfoAttibutedString string] rangeOfString:@"/"].length);
//            //需要设置的位置
//            [seatInfoAttibutedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"b2b2b2"] range:redRange];
//
//            //设置颜色
//            [selectSeatsLabel setAttributedText:seatInfoAttibutedString];
        }

    }
    selectSeatsLabel.text = seatInfoString;
    cinemaNameLabel.text = self.myOrder.orderTicket.cinemaName;
    cinemaAddressLabel.text = self.myOrder.orderTicket.cinemaAddress;
    
//    ticketNoLabel.text = self.myOrder.orderTicket.validCode;
#if kIsXinchengOrderDetailStyle
    if (self.myOrder.orderDetailGoodsList.count>0) {
        [upHalfView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(357+43));
        }];
        [downHalfView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(335+41+43));
        }];
        [ticketbgline mas_updateConstraints:^(MASConstraintMaker *make) {
            if (kCommonScreenWidth>375) {
                make.top.equalTo(@(330+43));
            }else{
                make.top.equalTo(@(330+43));
            }
        }];
        [gotoProductListBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kCommonScreenWidth, 35));
        }];
        NSString *tipLabelStr = @"查看卖品取货凭证";
        CGSize tipLabelStrSize = [KKZTextUtility measureText:tipLabelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
        [gotoProductTipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(tipLabelStrSize.width+5, tipLabelStrSize.height));
        }];
        UIImage *gotoOrderTipImage = [UIImage imageNamed:@"home_more"];
        [gotoProductImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(gotoOrderTipImage.size.width, gotoOrderTipImage.size.height));
        }];
        [hallLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(qrCodeImageView.mas_bottom).offset(90);
        }];
        
        [movieInfoBg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(667-86-55+43));
        }];
        
        positionY += 55;
        CGFloat h = 86-43;
        if (Constants.isIphone5) {
            h = 70-43;
        }
        [holder setContentSize:CGSizeMake(kCommonScreenWidth, 667-h)];
        
        pickUpTicketLabel.text = [NSString stringWithFormat:@"订单内包含%ld张影票和%ld张卖品券\n请到影院终端机扫码取票", seatInfoArray.count,  self.myOrder.orderDetailGoodsList.count];
    } else {
        pickUpTicketLabel.text = [NSString stringWithFormat:@"订单内包含%ld张影票\n请到影院终端机扫码取票", seatInfoArray.count];
    }
    
#else
    pickUpTicketLabel.text = [NSString stringWithFormat:@"订单内包含%ld张影票\n请到影院终端机扫码取票",seatInfoArray.count];
#endif
    

    NSDate *planBeginTime = [NSDate dateWithTimeIntervalSince1970:[self.myOrder.orderTicket.planBeginTime longLongValue]/1000];
    timeDateLabel.text = [[DateEngine sharedDateEngine] shortDateStringFromDate:planBeginTime];
    timeHourLabel.text = [[DateEngine sharedDateEngine] shortTimeStringFromDate:planBeginTime];
    if (self.isShowJudgeAlert) {
        //一个月弹框一次
        dispatch_async(dispatch_get_main_queue(), ^{
            double nowTime = [[NSDate date] timeIntervalSince1970];
            double lastTime = USER_ALERTTIME;
            
            if (lastTime > 0) {
                //30天后再次弹框
                //                           if ((nowTime - lastTime) > 30 * 24 * 3600 ) {
                //
                //                           }
                if ((nowTime - lastTime) > 30 * 24 * 3600 ) {
                    NSString * const reviewURL = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&onlyLatestVersion=true&pageNumber=1&sortOrdering=1&id=%@", kStoreAppId];
                    NSURL * url = [NSURL URLWithString:reviewURL];
                    [[CIASAlertImageView new] show:@"五星鼓励" message:@"欢迎给我们评分留言\n告诉我们你用的多爽" image:[UIImage imageNamed:@"toscore"] cancleTitle:@"残忍拒绝" otherTitle:@"写个好评" callback:^(BOOL confirm) {
                        if (confirm) {
                            UIApplication *application = [UIApplication sharedApplication];
                            
                            if([application canOpenURL:url]) {
                                
                                if ([application respondsToSelector:@selector(openURL:)]) {
                                    [application openURL:url];
                                } else {
                                    [application openURL:url options:@{} completionHandler:nil];
                                }
                            }
                        }
                    }];
                    double lastTime = [[NSDate date] timeIntervalSince1970];
                    USER_ALERTTIME_WRITE(lastTime);
                }
            } else {
                double lastTime = [[NSDate date] timeIntervalSince1970];
                USER_ALERTTIME_WRITE(lastTime);
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        });
    }
    
    //原来的位置
    
}

- (void)setNavBarUI{
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 64)];
    [bar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
             forBarPosition:UIBarPositionAny
                 barMetrics:UIBarMetricsDefault];
    [self.view addSubview:bar];
    bar.alpha = 0.0;
    self.navBar = bar;
    UIView *barLine = [[UIView alloc]initWithFrame:CGRectMake(0, 68.5, kCommonScreenWidth, 0.5)];
    barLine.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [bar addSubview:barLine];
    
    leftBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBarBtn.frame = CGRectMake(13.5, 27.5, 28, 28);
    [leftBarBtn setImage:[UIImage imageNamed:@"titlebar_home"]
                forState:UIControlStateNormal];
    leftBarBtn.backgroundColor = [UIColor clearColor];
    [leftBarBtn addTarget:self
                   action:@selector(leftItemClick)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftBarBtn];
    
    rightBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBarBtn.frame = CGRectMake(kCommonScreenWidth-28-20, 27.5, 28, 28);
    [rightBarBtn setImage:[UIImage imageNamed:@"titlebar_share"]
                forState:UIControlStateNormal];
    rightBarBtn.backgroundColor = [UIColor clearColor];
    [rightBarBtn addTarget:self
                    action:@selector(rightItemClick:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBarBtn];

    UIView * customTitleView = [[UIView alloc] initWithFrame:CGRectMake(70, 24, kCommonScreenWidth-140, 44)];
    customTitleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:customTitleView];
    //    self.navigationItem.titleView = customTitleView;
    navTitleLabel = [UILabel new];
    navTitleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.text = @"您的影票";
    navTitleLabel.font = [UIFont systemFontOfSize:18];
    [customTitleView addSubview:navTitleLabel];
    [navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(7));
        make.left.equalTo(@(0));
        make.right.equalTo(customTitleView.mas_right).offset(0);
        make.height.equalTo(@(15));
    }];

}

- (void)setupUI{

//    UIView *blackPosterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 211)];
//    blackPosterView.backgroundColor = [UIColor blackColor];
//    blackPosterView.alpha = 0.65;
//    [moviePosterImage addSubview:blackPosterView];
    //    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    //    blurEffectView.frame = CGRectMake(0, 0, kCommonScreenWidth, 211);
    //    blurEffectView.alpha = 0.5;
    //    [moviePosterImage addSubview:blurEffectView];
    //    [Constants.rootNav.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:@"#ffffff" a:0.0]] orBarMetrics:UIBarMetricsDefault];
    
#if kIsXinchengOrderDetailStyle
    //MARK: 票根页重做-- 新城使用--需要根据  有无卖品  来判断
    
    CGFloat positionY = 0;
    CGFloat leftGap = 27;
    CGFloat leftGap1 = 15;
    
    if (Constants.isIphone5) {
        //        positionY = 76-64;
        leftGap = 22;
        leftGap1 = 12;
    }
    
    movieInfoBg = [UIView new];
    [holder addSubview:movieInfoBg];
    movieInfoBg.backgroundColor = [UIColor clearColor];
    [movieInfoBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(positionY));
        make.left.equalTo(@(leftGap));
        make.width.equalTo(@(kCommonScreenWidth-2*leftGap));
        make.height.equalTo(@(667-86-55));
    }];
    positionY += (667-86-55);
    
    upHalfView = [UIView new];
    [movieInfoBg addSubview:upHalfView];
    upHalfView.backgroundColor = [UIColor whiteColor];
    upHalfView.layer.cornerRadius = 7;
    
    [upHalfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth-2*leftGap));
        make.height.equalTo(@(357));
    }];
    
    
    downHalfView = [UIView new];
    [movieInfoBg addSubview:downHalfView];
    downHalfView.backgroundColor = [UIColor whiteColor];
    downHalfView.layer.cornerRadius = 7;
    
    [downHalfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(335+41));
        make.left.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth-2*leftGap));
        make.height.equalTo(@(151));
    }];
    
    
    //MARK: 上下区分线
    ticketbgline = [UIImageView new];
    ticketbgline.backgroundColor = [UIColor clearColor];
    ticketbgline.image = [UIImage imageNamed:@"ticketbg_line"];
    ticketbgline.contentMode = UIViewContentModeScaleAspectFit;
    ticketbgline.clipsToBounds = YES;
    [movieInfoBg addSubview:ticketbgline];
    
    [ticketbgline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.right.equalTo(movieInfoBg);
        if (kCommonScreenWidth>375) {
            make.height.equalTo(@(72));
            make.top.equalTo(@(330));
        }else{
            make.height.equalTo(@(73));
            make.top.equalTo(@(330));
        }
    }];
    
    
    
    //    downHalfView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    //    downHalfView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    //    downHalfView.layer.shadowOpacity = 0.4;//阴影透明度，默认0
    //    downHalfView.layer.shadowRadius = 4;//阴影半径，默认3
    
    
    UIView *yellowVLine = [UIView new];
    yellowVLine.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
    [movieInfoBg addSubview:yellowVLine];
    [yellowVLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(18));
        make.left.equalTo(@(0));
        make.width.equalTo(@(5));
        make.height.equalTo(@(30));
    }];
    
    movieNameLabel = [UILabel new];
    movieNameLabel.font = [UIFont systemFontOfSize:18];
    movieNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    movieNameLabel.backgroundColor = [UIColor clearColor];
    movieNameLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:movieNameLabel];
    [movieNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap1));
        make.top.equalTo(@(18));
        make.width.equalTo(@(kCommonScreenWidth-130));
        make.height.equalTo(@(15));
    }];
    movieEngLishLabel = [UILabel new];
    movieEngLishLabel.font = [UIFont systemFontOfSize:10];
    movieEngLishLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    movieEngLishLabel.backgroundColor = [UIColor clearColor];
    movieEngLishLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:movieEngLishLabel];
    [movieEngLishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap1));
        make.top.equalTo(movieNameLabel.mas_bottom).offset(6);
        make.height.equalTo(@(12));
        make.width.equalTo(@(kCommonScreenWidth-55));
    }];
    
    screenTypeLabel = [self getFlagLabelWithFont:10 withBgColor:@"#ffcc00" withTextColor:@"#000000"];
    //    screenTypeLabel.hidden = YES;
    [movieInfoBg addSubview:screenTypeLabel];
    languageLael = [self getFlagLabelWithFont:10 withBgColor:@"#333333" withTextColor:@"#FFFFFF"];
    //    languageLael.hidden = YES;
    [movieInfoBg addSubview:languageLael];
    
    CGSize languageSize = [KKZTextUtility measureText:@"英语" font:[UIFont systemFontOfSize:10]];
    languageLael.text = @"英语";
    [languageLael mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-leftGap1));
        make.top.equalTo(@(18));
        make.width.equalTo(@(languageSize.width+8));
        make.height.equalTo(@(15));
    }];
    CGSize screenTypeSize = [KKZTextUtility measureText:@"3D|IMAX" font:[UIFont systemFontOfSize:10]];
    screenTypeLabel.text = @"3D|IMAX";
    [screenTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(languageLael.mas_left).offset(-3);
        make.top.equalTo(@(18));
        make.width.equalTo(@(screenTypeSize.width+8));
        make.height.equalTo(@(15));
    }];
    
    moviePosterImage = [UIImageView new];
    moviePosterImage.contentMode = UIViewContentModeScaleAspectFill;
    moviePosterImage.backgroundColor = [UIColor colorWithHex:@"#f2f5f5"];
    moviePosterImage.clipsToBounds = YES;
    [movieInfoBg addSubview:moviePosterImage];
    [moviePosterImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(62));
        make.left.equalTo(@(0));
        make.width.equalTo(movieInfoBg);
        make.height.equalTo(@(127));
    }];
    
    qrCodeImageView = [UIImageView new];
    qrCodeImageView.contentMode = UIViewContentModeScaleAspectFill;
    qrCodeImageView.backgroundColor = [UIColor colorWithHex:@"#f2f5f5"];
    qrCodeImageView.clipsToBounds = YES;
    [movieInfoBg addSubview:qrCodeImageView];
    [qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moviePosterImage.mas_bottom).offset(27);
        make.left.equalTo(@(leftGap1));
        make.width.equalTo(@(125));
        make.height.equalTo(@(125));
    }];
    
    validCodeLabelTip = [UILabel new];
    validCodeLabelTip.font = [UIFont systemFontOfSize:10];
    validCodeLabelTip.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    validCodeLabelTip.backgroundColor = [UIColor clearColor];
    validCodeLabelTip.hidden = YES;
    validCodeLabelTip.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:validCodeLabelTip];
    validCodeLabelTip.text = @"取票号";
    [validCodeLabelTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qrCodeImageView.mas_right).offset(16);
        make.top.equalTo(moviePosterImage.mas_bottom).offset(28);
        make.height.equalTo(@(12));
        make.width.equalTo(@(40));
    }];
    validCodeLabel = [UILabel new];
    validCodeLabel.font = [UIFont systemFontOfSize:15];
    if (Constants.isIphone5) {
        validCodeLabel.font = [UIFont systemFontOfSize:13];
    }
    validCodeLabel.numberOfLines = 2;
    validCodeLabel.textColor = [UIColor colorWithHex:@"#333333"];
    validCodeLabel.backgroundColor = [UIColor clearColor];
    validCodeLabel.textAlignment = NSTextAlignmentLeft;
    validCodeLabel.hidden = YES;
    [movieInfoBg addSubview:validCodeLabel];
    [validCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(validCodeLabelTip.mas_right);
        make.top.equalTo(moviePosterImage.mas_bottom).offset(16);
        make.height.equalTo(@(36));
        
        if (Constants.isIphone5) {
            make.height.equalTo(@(32));
            
        }
        make.right.equalTo(@(-leftGap1+5));
    }];
    validInfoBakLabelTip = [UILabel new];
    validInfoBakLabelTip.hidden =YES;
    validInfoBakLabelTip.font = [UIFont systemFontOfSize:10];
    validInfoBakLabelTip.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    validInfoBakLabelTip.backgroundColor = [UIColor clearColor];
    validInfoBakLabelTip.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:validInfoBakLabelTip];
    validInfoBakLabelTip.text = @"验票码";
    [validInfoBakLabelTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qrCodeImageView.mas_right).offset(16);
        make.top.equalTo(validCodeLabelTip.mas_bottom).offset(29);
        make.height.equalTo(@(12));
        make.width.equalTo(@(40));
    }];
    validInfoBakLabel = [UILabel new];
    validInfoBakLabel.font = [UIFont systemFontOfSize:15];
    if (Constants.isIphone5) {
        validInfoBakLabel.font = [UIFont systemFontOfSize:13];
    }
    validInfoBakLabel.hidden = YES;
    validInfoBakLabel.numberOfLines = 2;
    validInfoBakLabel.textColor = [UIColor colorWithHex:@"#333333"];
    validInfoBakLabel.backgroundColor = [UIColor clearColor];
    validInfoBakLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:validInfoBakLabel];
    [validInfoBakLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(validInfoBakLabelTip.mas_right);
        make.top.equalTo(validCodeLabelTip.mas_bottom).offset(17);
        make.height.equalTo(@(36));
        
        if (Constants.isIphone5) {
            make.height.equalTo(@(32));
            
        }
        make.right.equalTo(@(-leftGap1+5));
    }];

    pickUpTicketLabel = [UILabel new];
    pickUpTicketLabel.font = [UIFont systemFontOfSize:10];
    pickUpTicketLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    pickUpTicketLabel.backgroundColor = [UIColor clearColor];
    pickUpTicketLabel.textAlignment = NSTextAlignmentLeft;
    pickUpTicketLabel.numberOfLines = 2;
    [movieInfoBg addSubview:pickUpTicketLabel];
    [pickUpTicketLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qrCodeImageView.mas_right).offset(16);
        make.right.equalTo(@(-10));
        
        if (kCommonScreenWidth>375) {
            make.bottom.equalTo(qrCodeImageView.mas_bottom).offset(5);
        }else{
            make.bottom.equalTo(qrCodeImageView.mas_bottom);
        }
        make.height.equalTo(@(30));
    }];
    
    
    gotoProductListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gotoProductListBtn.layer.cornerRadius = 3.0f;
    gotoProductListBtn.clipsToBounds = YES;
    gotoProductListBtn.layer.borderWidth = 0.5f;
    gotoProductListBtn.layer.borderColor = [UIColor colorWithHex:@"#e0e0e0"].CGColor;
    [movieInfoBg addSubview:gotoProductListBtn];
    gotoProductListBtn.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    [gotoProductListBtn addTarget:self action:@selector(gotoOrderProductListViewClick) forControlEvents:UIControlEventTouchUpInside];
    gotoProductListBtn.contentMode = UIViewContentModeScaleAspectFit;
    [gotoProductListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(movieInfoBg.mas_left).offset(20);
        make.right.equalTo(movieInfoBg.mas_right).offset(-20);
        make.top.equalTo(qrCodeImageView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(kCommonScreenWidth, 0));
    }];
    
    NSString *tipLabelStr = @"查看卖品取货凭证";
    CGSize tipLabelStrSize = [KKZTextUtility measureText:tipLabelStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:13]];
    gotoProductTipLabel = [[UILabel alloc] init];
    [gotoProductListBtn addSubview:gotoProductTipLabel];
    gotoProductTipLabel.text = tipLabelStr;
    gotoProductTipLabel.font = [UIFont systemFontOfSize:13];
    gotoProductTipLabel.textColor = [UIColor colorWithHex:@"#333333"];
    [gotoProductTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gotoProductListBtn.mas_left).offset(15);
        make.centerY.equalTo(gotoProductListBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(tipLabelStrSize.width+5, 0));
    }];
    
    UIImage *gotoOrderTipImage = [UIImage imageNamed:@"home_more"];
    gotoProductImageView = [[UIImageView alloc] init];
    [gotoProductListBtn addSubview:gotoProductImageView];
    gotoProductImageView.image = gotoOrderTipImage;
    gotoProductImageView.contentMode = UIViewContentModeScaleAspectFit;
    [gotoProductImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(gotoProductListBtn.mas_right).offset(-15);
        make.centerY.equalTo(gotoProductListBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(gotoOrderTipImage.size.width, 0));
    }];
    
    
    
    hallLabel = [UILabel new];
    hallLabel.font = [UIFont systemFontOfSize:10];
    hallLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    hallLabel.backgroundColor = [UIColor clearColor];
    hallLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:hallLabel];
    hallLabel.text = @"影厅";
   
    [hallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap1));
        make.top.equalTo(qrCodeImageView.mas_bottom).offset(55);
        make.height.equalTo(@(12));
        make.width.equalTo(@(((kCommonScreenWidth-51)*3)/8-22));
    }];
    
    hallNameLabel = [UILabel new];
    hallNameLabel.font = [UIFont systemFontOfSize:13];
    hallNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    hallNameLabel.backgroundColor = [UIColor clearColor];
    hallNameLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:hallNameLabel];
    [hallNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap1));
        make.top.equalTo(hallLabel.mas_bottom).offset(5);
        make.width.equalTo(@(((kCommonScreenWidth-51)/8)*3-22));
        make.height.equalTo(@(15));
    }];
    
    timeLabel = [UILabel new];
    timeLabel.font = [UIFont systemFontOfSize:10];
    timeLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:timeLabel];
    timeLabel.text = @"时间";
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hallLabel.mas_right).offset(10);
        make.centerY.equalTo(hallLabel.mas_centerY);
        make.height.equalTo(@(12));
        make.width.equalTo(@(((kCommonScreenWidth-51)/8)*2-11));
    }];
    timeDateLabel = [UILabel new];
    timeDateLabel.font = [UIFont systemFontOfSize:13];
    timeDateLabel.textColor = [UIColor colorWithHex:@"#333333"];
    timeDateLabel.backgroundColor = [UIColor clearColor];
    timeDateLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:timeDateLabel];
    [timeDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hallLabel.mas_right).offset(10);
        make.top.equalTo(timeLabel.mas_bottom).offset(5);
        make.width.equalTo(@(((kCommonScreenWidth-51)/8)*2));
        make.height.equalTo(@(15));
    }];
    timeHourLabel = [UILabel new];
    timeHourLabel.font = [UIFont systemFontOfSize:13];
    timeHourLabel.textColor = [UIColor colorWithHex:@"#333333"];
    timeHourLabel.backgroundColor = [UIColor clearColor];
    timeHourLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:timeHourLabel];
    [timeHourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hallLabel.mas_right).offset(10);
        make.top.equalTo(timeDateLabel.mas_bottom).offset(1);
        make.width.equalTo(@(((kCommonScreenWidth-51)/8)*2-11));
        make.height.equalTo(@(15));
    }];
    
    seatLabel = [UILabel new];
    seatLabel.font = [UIFont systemFontOfSize:10];
    seatLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    seatLabel.backgroundColor = [UIColor clearColor];
    seatLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:seatLabel];
    seatLabel.text = @"座位";
    [seatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right).offset(8);
        make.centerY.equalTo(hallLabel.mas_centerY);
        make.height.equalTo(@(12));
        make.width.equalTo(@(((kCommonScreenWidth-51)/8)*3));
    }];
    selectSeatsLabel = [UILabel new];
    selectSeatsLabel.font = [UIFont systemFontOfSize:13];
    selectSeatsLabel.textColor = [UIColor colorWithHex:@"#333333"];
    selectSeatsLabel.backgroundColor = [UIColor clearColor];
    selectSeatsLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:selectSeatsLabel];
    [selectSeatsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right).offset(8);
        make.top.equalTo(seatLabel.mas_bottom).offset(5);
        make.width.equalTo(@(((kCommonScreenWidth-51)/8)*3+10));
        make.height.equalTo(@(15));
    }];
    if (Constants.isIphone5) {
        hallNameLabel.font = [UIFont systemFontOfSize:12];
        timeDateLabel.font = [UIFont systemFontOfSize:12];
        timeHourLabel.font = [UIFont systemFontOfSize:12];
        selectSeatsLabel.font = [UIFont systemFontOfSize:12];
    }
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lineColor];
    [movieInfoBg addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap1));
        make.right.equalTo(@(-leftGap1));
        make.top.equalTo(timeHourLabel.mas_bottom).offset(12);
        make.height.equalTo(@(0.5));
    }];
    
    cinemaNameLabel = [UILabel new];
    cinemaNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    cinemaNameLabel.textAlignment = NSTextAlignmentLeft;
    cinemaNameLabel.font = [UIFont systemFontOfSize:16];
    [movieInfoBg addSubview:cinemaNameLabel];
    
    locationImageView = [UIImageView new];
    locationImageView.backgroundColor = [UIColor clearColor];
    locationImageView.clipsToBounds = YES;
    locationImageView.image = [UIImage imageNamed:@"list_location_icon"];
    locationImageView.contentMode = UIViewContentModeScaleAspectFit;
    [movieInfoBg addSubview:locationImageView];
    
    cinemaAddressLabel = [UILabel new];
    cinemaAddressLabel.backgroundColor = [UIColor clearColor];
    cinemaAddressLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    cinemaAddressLabel.textAlignment = NSTextAlignmentLeft;
    cinemaAddressLabel.font = [UIFont systemFontOfSize:13];
    [movieInfoBg addSubview:cinemaAddressLabel];
    
    [cinemaNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap1));
        make.top.equalTo(line.mas_bottom).offset(15);
        make.width.equalTo(@(kCommonScreenWidth-70));
        make.height.equalTo(@(15));
    }];
    
    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap1));
        make.top.equalTo(cinemaNameLabel.mas_bottom).offset(5);
        make.width.equalTo(@(12));
        make.height.equalTo(@(14));
    }];
    
    [cinemaAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationImageView.mas_right).offset(5);
        make.top.equalTo(cinemaNameLabel.mas_bottom).offset(5);
        make.width.equalTo(@(kCommonScreenWidth-70-100));
        make.height.equalTo(@(15));
    }];
    
    UIButton *telephoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    telephoneBtn.backgroundColor = [UIColor clearColor];
    [telephoneBtn setBackgroundImage:[UIImage imageNamed:@"phone_icon"] forState:UIControlStateNormal];
    [movieInfoBg addSubview:telephoneBtn];
    [telephoneBtn addTarget:self action:@selector(telCinemaWithMobile) forControlEvents:UIControlEventTouchUpInside];
    [telephoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(25);
        make.right.equalTo(@(-(10+leftGap1)));
        make.width.equalTo(@(20));
        make.height.equalTo(@(20));
    }];
    
    UIView *sLine = [UIView new];
    sLine.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lineColor];
    [movieInfoBg addSubview:sLine];
    [sLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(telephoneBtn.mas_left).offset(-leftGap1);
        make.top.equalTo(line.mas_bottom).offset(15);
        make.height.equalTo(@(35));
        make.width.equalTo(@(0.5));
    }];
    
    customerTelephoneLabel = [UILabel new];
    customerTelephoneLabel.text = [NSString stringWithFormat:@"客服热线：%@",kHotLineForDisplay];
    customerTelephoneLabel.backgroundColor = [UIColor clearColor];
    customerTelephoneLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
    customerTelephoneLabel.textAlignment = NSTextAlignmentCenter;
    customerTelephoneLabel.font = [UIFont systemFontOfSize:14];
    [holder addSubview:customerTelephoneLabel];
    [customerTelephoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(movieInfoBg.mas_bottom).offset(15);
        make.width.equalTo(@(kCommonScreenWidth-30));
        make.height.equalTo(@(15));
    }];
    
    positionY += 55;
    CGFloat h = 86;
    if (Constants.isIphone5) {
        h = 70;
    }
    
    [holder setContentSize:CGSizeMake(kCommonScreenWidth, 667-h)];
#else
    //MARK: 以前的票根页--中都在用
    
    CGFloat positionY = 0;
    CGFloat leftGap = 27;
    CGFloat leftGap1 = 15;
    
    if (Constants.isIphone5) {
        //        positionY = 76-64;
        leftGap = 22;
        leftGap1 = 12;
    }
    
    movieInfoBg = [UIView new];
    [holder addSubview:movieInfoBg];
    movieInfoBg.backgroundColor = [UIColor clearColor];
    [movieInfoBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(positionY));
        make.left.equalTo(@(leftGap));
        make.width.equalTo(@(kCommonScreenWidth-2*leftGap));
        make.height.equalTo(@(667-86-55));
    }];
    positionY += (667-86-55);
    
    upHalfView = [UIView new];
    [movieInfoBg addSubview:upHalfView];
    upHalfView.backgroundColor = [UIColor whiteColor];
    upHalfView.layer.cornerRadius = 7;
    [upHalfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(0));
        make.left.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth-2*leftGap));
        make.height.equalTo(@(357));
    }];
    downHalfView = [UIView new];
    [movieInfoBg addSubview:downHalfView];
    downHalfView.backgroundColor = [UIColor whiteColor];
    downHalfView.layer.cornerRadius = 7;
    [downHalfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(335+41));
        make.left.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth-2*leftGap));
        make.height.equalTo(@(151));
    }];
    //MARK: 上下区分线
    UIImageView *ticketbgline = [UIImageView new];
    ticketbgline.backgroundColor = [UIColor clearColor];
    ticketbgline.image = [UIImage imageNamed:@"ticketbg_line"];
    ticketbgline.contentMode = UIViewContentModeScaleAspectFit;
    ticketbgline.clipsToBounds = YES;
    [movieInfoBg addSubview:ticketbgline];
    [ticketbgline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.right.equalTo(movieInfoBg);
        if (kCommonScreenWidth>375) {
            make.height.equalTo(@(72));
            make.top.equalTo(@(330));
        }else{
            make.height.equalTo(@(73));
            make.top.equalTo(@(330));
        }
    }];
    
    //    downHalfView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    //    downHalfView.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    //    downHalfView.layer.shadowOpacity = 0.4;//阴影透明度，默认0
    //    downHalfView.layer.shadowRadius = 4;//阴影半径，默认3
    
    
    UIView *yellowVLine = [UIView new];
    yellowVLine.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lumpColor];
    [movieInfoBg addSubview:yellowVLine];
    [yellowVLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(18));
        make.left.equalTo(@(0));
        make.width.equalTo(@(5));
        make.height.equalTo(@(30));
    }];
    
    movieNameLabel = [UILabel new];
    movieNameLabel.font = [UIFont systemFontOfSize:18];
    movieNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    movieNameLabel.backgroundColor = [UIColor clearColor];
    movieNameLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:movieNameLabel];
    [movieNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap1));
        make.top.equalTo(@(18));
        make.width.equalTo(@(kCommonScreenWidth-130));
        make.height.equalTo(@(15));
    }];
    movieEngLishLabel = [UILabel new];
    movieEngLishLabel.font = [UIFont systemFontOfSize:10];
    movieEngLishLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    movieEngLishLabel.backgroundColor = [UIColor clearColor];
    movieEngLishLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:movieEngLishLabel];
    [movieEngLishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap1));
        make.top.equalTo(movieNameLabel.mas_bottom).offset(6);
        make.height.equalTo(@(12));
        make.width.equalTo(@(kCommonScreenWidth-55));
    }];
    
    screenTypeLabel = [self getFlagLabelWithFont:10 withBgColor:@"#ffcc00" withTextColor:@"#000000"];
    //    screenTypeLabel.hidden = YES;
    [movieInfoBg addSubview:screenTypeLabel];
    languageLael = [self getFlagLabelWithFont:10 withBgColor:@"#333333" withTextColor:@"#FFFFFF"];
    //    languageLael.hidden = YES;
    [movieInfoBg addSubview:languageLael];
    
    CGSize languageSize = [KKZTextUtility measureText:@"英语" font:[UIFont systemFontOfSize:10]];
    languageLael.text = @"英语";
    [languageLael mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-leftGap1));
        make.top.equalTo(@(18));
        make.width.equalTo(@(languageSize.width+8));
        make.height.equalTo(@(15));
    }];
    CGSize screenTypeSize = [KKZTextUtility measureText:@"3D|IMAX" font:[UIFont systemFontOfSize:10]];
    screenTypeLabel.text = @"3D|IMAX";
    [screenTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(languageLael.mas_left).offset(-3);
        make.top.equalTo(@(18));
        make.width.equalTo(@(screenTypeSize.width+8));
        make.height.equalTo(@(15));
    }];
    
    moviePosterImage = [UIImageView new];
    moviePosterImage.contentMode = UIViewContentModeScaleAspectFill;
    moviePosterImage.backgroundColor = [UIColor colorWithHex:@"#f2f5f5"];
    moviePosterImage.clipsToBounds = YES;
    [movieInfoBg addSubview:moviePosterImage];
    [moviePosterImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(62));
        make.left.equalTo(@(0));
        make.width.equalTo(movieInfoBg);
        make.height.equalTo(@(127));
    }];
    
    qrCodeImageView = [UIImageView new];
    qrCodeImageView.contentMode = UIViewContentModeScaleAspectFill;
    qrCodeImageView.backgroundColor = [UIColor colorWithHex:@"#f2f5f5"];
    qrCodeImageView.clipsToBounds = YES;
    [movieInfoBg addSubview:qrCodeImageView];
    [qrCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moviePosterImage.mas_bottom).offset(27);
        make.left.equalTo(@(leftGap1));
        make.width.equalTo(@(125));
        make.height.equalTo(@(125));
    }];
    
    validCodeLabelTip = [UILabel new];
    validCodeLabelTip.font = [UIFont systemFontOfSize:10];
    validCodeLabelTip.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    validCodeLabelTip.backgroundColor = [UIColor clearColor];
    validCodeLabelTip.hidden = YES;
    validCodeLabelTip.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:validCodeLabelTip];
    validCodeLabelTip.text = @"取票号";
    [validCodeLabelTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qrCodeImageView.mas_right).offset(16);
        make.top.equalTo(moviePosterImage.mas_bottom).offset(22);
        make.height.equalTo(@(12));
        make.width.equalTo(@(40));
    }];
    validCodeLabel = [UILabel new];
    validCodeLabel.font = [UIFont systemFontOfSize:15];
    if (Constants.isIphone5) {
        validCodeLabel.font = [UIFont systemFontOfSize:13];
    }
    validCodeLabel.numberOfLines = 2;
    validCodeLabel.textColor = [UIColor colorWithHex:@"#333333"];
    validCodeLabel.backgroundColor = [UIColor clearColor];
    validCodeLabel.textAlignment = NSTextAlignmentLeft;
    validCodeLabel.hidden = YES;
    [movieInfoBg addSubview:validCodeLabel];
    [validCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(validCodeLabelTip.mas_right);
        make.top.equalTo(moviePosterImage.mas_bottom).offset(18);
        make.height.equalTo(@(36));
        
        if (Constants.isIphone5) {
            make.height.equalTo(@(32));
            
        }
        make.right.equalTo(@(-leftGap1+5));
    }];
    validInfoBakLabelTip = [UILabel new];
    validInfoBakLabelTip.hidden =YES;
    validInfoBakLabelTip.font = [UIFont systemFontOfSize:10];
    validInfoBakLabelTip.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    validInfoBakLabelTip.backgroundColor = [UIColor clearColor];
    validInfoBakLabelTip.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:validInfoBakLabelTip];
    validInfoBakLabelTip.text = @"验票码";
    [validInfoBakLabelTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qrCodeImageView.mas_right).offset(16);
        make.top.equalTo(validCodeLabelTip.mas_bottom).offset(20);
        make.height.equalTo(@(12));
        make.width.equalTo(@(40));
    }];
    validInfoBakLabel = [UILabel new];
    validInfoBakLabel.font = [UIFont systemFontOfSize:15];
    if (Constants.isIphone5) {
        validInfoBakLabel.font = [UIFont systemFontOfSize:13];
    }
    validInfoBakLabel.hidden = YES;
    validInfoBakLabel.numberOfLines = 2;
    validInfoBakLabel.textColor = [UIColor colorWithHex:@"#333333"];
    validInfoBakLabel.backgroundColor = [UIColor clearColor];
    validInfoBakLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:validInfoBakLabel];
    [validInfoBakLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(validInfoBakLabelTip.mas_right);
        make.top.equalTo(validCodeLabelTip.mas_bottom).offset(17);
        make.height.equalTo(@(36));
        
        if (Constants.isIphone5) {
            make.height.equalTo(@(32));
            
        }
        make.right.equalTo(@(-leftGap1+5));
    }];
    
    UIButton *addTicketToWalletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addTicketToWalletBtn.backgroundColor = [UIColor clearColor];
    [addTicketToWalletBtn setImage:[UIImage imageNamed:@"wallet_btn"] forState:UIControlStateNormal];
    //    [addTicketToWalletBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    //    [addTicketToWalletBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    //    [addTicketToWalletBtn setBackgroundImage:[UIImage imageNamed:@"wallet_btn"] forState:UIControlStateNormal];
    [movieInfoBg addSubview:addTicketToWalletBtn];
    [addTicketToWalletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qrCodeImageView.mas_right).offset(16);
        //        make.right.equalTo(@(-leftGap1));
        make.height.equalTo(@((kCommonScreenWidth-leftGap*2-leftGap1-125-16-leftGap1)/4));
        make.width.equalTo(@(375-leftGap*2-leftGap1-125-16-leftGap1));
        if (Constants.isIphone5) {
            make.width.equalTo(@(320-leftGap*2-leftGap1-125-16-leftGap1));
        }
        
        if (kCommonScreenWidth>375) {
            make.bottom.equalTo(qrCodeImageView.mas_bottom).offset(5);
        }else{
            make.bottom.equalTo(qrCodeImageView.mas_bottom);
        }
    }];
    
    pickUpTicketLabel = [UILabel new];
    pickUpTicketLabel.font = [UIFont systemFontOfSize:10];
    pickUpTicketLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    pickUpTicketLabel.backgroundColor = [UIColor clearColor];
    pickUpTicketLabel.textAlignment = NSTextAlignmentLeft;
    pickUpTicketLabel.numberOfLines = 2;
    [movieInfoBg addSubview:pickUpTicketLabel];
    [pickUpTicketLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qrCodeImageView.mas_right).offset(16);
        make.right.equalTo(@(-10));
        
        if (kCommonScreenWidth>375) {
            make.bottom.equalTo(addTicketToWalletBtn.mas_top).offset(5);
        }else{
            make.bottom.equalTo(addTicketToWalletBtn.mas_top);
        }
        make.height.equalTo(@(30));
    }];
    hallLabel = [UILabel new];
    hallLabel.font = [UIFont systemFontOfSize:10];
    hallLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    hallLabel.backgroundColor = [UIColor clearColor];
    hallLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:hallLabel];
    hallLabel.text = @"影厅";
    [hallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap1));
        make.top.equalTo(moviePosterImage.mas_bottom).offset(203);
        make.height.equalTo(@(12));
        make.width.equalTo(@(((kCommonScreenWidth-51)*3)/8-22));
    }];
    
    hallNameLabel = [UILabel new];
    hallNameLabel.font = [UIFont systemFontOfSize:13];
    hallNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    hallNameLabel.backgroundColor = [UIColor clearColor];
    hallNameLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:hallNameLabel];
    [hallNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap1));
        make.top.equalTo(hallLabel.mas_bottom).offset(5);
        make.width.equalTo(@(((kCommonScreenWidth-51)/8)*3-22));
        make.height.equalTo(@(15));
    }];
    
    timeLabel = [UILabel new];
    timeLabel.font = [UIFont systemFontOfSize:10];
    timeLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:timeLabel];
    timeLabel.text = @"时间";
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hallLabel.mas_right).offset(10);
        make.top.equalTo(moviePosterImage.mas_bottom).offset(203);
        make.height.equalTo(@(12));
        make.width.equalTo(@(((kCommonScreenWidth-51)/8)*2-11));
    }];
    timeDateLabel = [UILabel new];
    timeDateLabel.font = [UIFont systemFontOfSize:13];
    timeDateLabel.textColor = [UIColor colorWithHex:@"#333333"];
    timeDateLabel.backgroundColor = [UIColor clearColor];
    timeDateLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:timeDateLabel];
    [timeDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hallLabel.mas_right).offset(10);
        make.top.equalTo(timeLabel.mas_bottom).offset(5);
        make.width.equalTo(@(((kCommonScreenWidth-51)/8)*2));
        make.height.equalTo(@(15));
    }];
    timeHourLabel = [UILabel new];
    timeHourLabel.font = [UIFont systemFontOfSize:13];
    timeHourLabel.textColor = [UIColor colorWithHex:@"#333333"];
    timeHourLabel.backgroundColor = [UIColor clearColor];
    timeHourLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:timeHourLabel];
    [timeHourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hallLabel.mas_right).offset(10);
        make.top.equalTo(timeDateLabel.mas_bottom).offset(1);
        make.width.equalTo(@(((kCommonScreenWidth-51)/8)*2-11));
        make.height.equalTo(@(15));
    }];
    
    seatLabel = [UILabel new];
    seatLabel.font = [UIFont systemFontOfSize:10];
    seatLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    seatLabel.backgroundColor = [UIColor clearColor];
    seatLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:seatLabel];
    seatLabel.text = @"座位";
    [seatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right).offset(8);
        make.top.equalTo(moviePosterImage.mas_bottom).offset(203);
        make.height.equalTo(@(12));
        make.width.equalTo(@(((kCommonScreenWidth-51)/8)*3));
    }];
    selectSeatsLabel = [UILabel new];
    selectSeatsLabel.font = [UIFont systemFontOfSize:13];
    selectSeatsLabel.textColor = [UIColor colorWithHex:@"#333333"];
    selectSeatsLabel.backgroundColor = [UIColor clearColor];
    selectSeatsLabel.textAlignment = NSTextAlignmentLeft;
    [movieInfoBg addSubview:selectSeatsLabel];
    [selectSeatsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeLabel.mas_right).offset(8);
        make.top.equalTo(seatLabel.mas_bottom).offset(5);
        make.width.equalTo(@(((kCommonScreenWidth-51)/8)*3+10));
        make.height.equalTo(@(15));
    }];
    if (Constants.isIphone5) {
        hallNameLabel.font = [UIFont systemFontOfSize:12];
        timeDateLabel.font = [UIFont systemFontOfSize:12];
        timeHourLabel.font = [UIFont systemFontOfSize:12];
        selectSeatsLabel.font = [UIFont systemFontOfSize:12];
    }
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lineColor];
    [movieInfoBg addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap1));
        make.right.equalTo(@(-leftGap1));
        make.top.equalTo(timeHourLabel.mas_bottom).offset(12);
        make.height.equalTo(@(0.5));
    }];
    
    cinemaNameLabel = [UILabel new];
    cinemaNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    cinemaNameLabel.textAlignment = NSTextAlignmentLeft;
    cinemaNameLabel.font = [UIFont systemFontOfSize:16];
    [movieInfoBg addSubview:cinemaNameLabel];
    
    locationImageView = [UIImageView new];
    locationImageView.backgroundColor = [UIColor clearColor];
    locationImageView.clipsToBounds = YES;
    locationImageView.image = [UIImage imageNamed:@"list_location_icon"];
    locationImageView.contentMode = UIViewContentModeScaleAspectFit;
    [movieInfoBg addSubview:locationImageView];
    
    cinemaAddressLabel = [UILabel new];
    cinemaAddressLabel.backgroundColor = [UIColor clearColor];
    cinemaAddressLabel.textColor = [UIColor colorWithHex:@"#b2b2b2"];
    cinemaAddressLabel.textAlignment = NSTextAlignmentLeft;
    cinemaAddressLabel.font = [UIFont systemFontOfSize:13];
    [movieInfoBg addSubview:cinemaAddressLabel];
    
    [cinemaNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap1));
        make.top.equalTo(line.mas_bottom).offset(15);
        make.width.equalTo(@(kCommonScreenWidth-70));
        make.height.equalTo(@(15));
    }];
    
    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(leftGap1));
        make.top.equalTo(cinemaNameLabel.mas_bottom).offset(5);
        make.width.equalTo(@(12));
        make.height.equalTo(@(14));
    }];
    
    [cinemaAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationImageView.mas_right).offset(5);
        make.top.equalTo(cinemaNameLabel.mas_bottom).offset(5);
        make.width.equalTo(@(kCommonScreenWidth-70-100));
        make.height.equalTo(@(15));
    }];
    
    UIButton *telephoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    telephoneBtn.backgroundColor = [UIColor clearColor];
    [telephoneBtn setBackgroundImage:[UIImage imageNamed:@"phone_icon"] forState:UIControlStateNormal];
    [movieInfoBg addSubview:telephoneBtn];
    [telephoneBtn addTarget:self action:@selector(telCinemaWithMobile) forControlEvents:UIControlEventTouchUpInside];
    [telephoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(25);
        make.right.equalTo(@(-(10+leftGap1)));
        make.width.equalTo(@(20));
        make.height.equalTo(@(20));
    }];
    
    UIView *sLine = [UIView new];
    sLine.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lineColor];
    [movieInfoBg addSubview:sLine];
    [sLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(telephoneBtn.mas_left).offset(-leftGap1);
        make.top.equalTo(line.mas_bottom).offset(15);
        make.height.equalTo(@(35));
        make.width.equalTo(@(0.5));
    }];
    
    customerTelephoneLabel = [UILabel new];
    customerTelephoneLabel.text = [NSString stringWithFormat:@"客服热线：%@",kHotLineForDisplay];
    customerTelephoneLabel.backgroundColor = [UIColor clearColor];
    customerTelephoneLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
    customerTelephoneLabel.textAlignment = NSTextAlignmentCenter;
    customerTelephoneLabel.font = [UIFont systemFontOfSize:14];
    [holder addSubview:customerTelephoneLabel];
    [customerTelephoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(movieInfoBg.mas_bottom).offset(15);
        make.width.equalTo(@(kCommonScreenWidth-30));
        make.height.equalTo(@(15));
    }];
    
    positionY += 55;
    CGFloat h = 86;
    if (Constants.isIphone5) {
        h = 70;
    }
    
    [holder setContentSize:CGSizeMake(kCommonScreenWidth, 667-h)];
#endif
    

}

//MARK: --跳转卖品列表查看取货凭证吧
- (void) gotoOrderProductListViewClick {
    DLog(@"跳转卖品列表查看取货凭证吧");
    SellPickUpViewController *sellVc = [[SellPickUpViewController alloc] initWithNibName:@"SellPickUpViewController" bundle:[NSBundle mainBundle]];
    sellVc.productList = [NSMutableArray arrayWithArray:self.myOrder.orderDetailGoodsList];
    [self.navigationController pushViewController:sellVc animated:YES];
}

- (void)requestTicketInfo {
//    [SVProgressHUD show];
    [[UIConstants sharedDataEngine] loadingAnimation];
    OrderRequest *request = [[OrderRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
//    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode", nil];
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.orderNo,@"orderCode",ciasTenantId,@"tenantId", nil];
//    [request requestOutTicketInfoParams:pagrams success:^(id _Nullable data) {//之前调用的接口，不对
    [request requestOrderDetailParams:pagrams success:^(id _Nullable data) {
//        [SVProgressHUD dismiss];
        
        weakSelf.myOrder = data;
        [weakSelf updateLayout];
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        //主线程刷新，防止闪烁
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];

    }];
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 64) {
        CGFloat alpha = scrollView.contentOffset.y / 64;
        if (alpha>0.5) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
       
        }else{
            
        }
        if (alpha>0.7) {
            self.navBar.alpha = 0.8;
        }else{
            self.navBar.alpha = alpha;
        }
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        self.navBar.alpha = 0.8;
    }
}

- (void)telCinemaWithMobile {
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *_Nonnull action){
                                                         }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *_Nonnull action) {
                                                           UIApplication *application = [UIApplication sharedApplication];
                                                          
                                                           if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                                               [application openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [self.myOrder.orderTicket.telephoneNumber length]>0 ? self.myOrder.orderTicket.telephoneNumber:kHotLine]] options:@{} completionHandler:nil];
                                                           }else{
                                                               [application openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", [self.myOrder.orderTicket.telephoneNumber length]>0 ? self.myOrder.orderTicket.telephoneNumber:kHotLine]]];
                                                           }
                                                           
                                                       }];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"是否拨打影院电话" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:cancelAction];
    [alertVC addAction:sureAction];
    
    [self presentViewController:alertVC
                       animated:YES
                     completion:^{
                     }];
}

- (void)leftItemClick{
    
    #if kIsHuaChenTmpTabbarStyle
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:0];
    #endif
    
    #if kIsSingleCinemaTabbarStyle
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:0];
    #endif
    
    #if kIsXinchengTmpTabbarStyle
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:0];
    #endif
    
    if ([kIsXinchengTabbarStyle isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:2];
    }
    if ([kIsCMSStandardTabbarStyle isEqualToString:@"1"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [Constants.appDelegate setHomeSelectedTabAtIndex:0];
    }
    

}

//MARK: 弹出框，进行选择
- (void)rightItemClick:(UIButton *)button {
//    button.selected = !button.selected;
//    if (button.selected) {
//        if(!_chooseAlertView){
//            [self.view addSubview:self.chooseAlertView];
//        }
//    } else {
//        if (_chooseAlertView) {
//            [_chooseAlertView removeFromSuperview];
//            _chooseAlertView = nil;
//        }
//    }
    UIImage *shareImage = [self makeImageWithView:movieInfoBg];
    [UIConstants shareWithType:0 andController:self andItems:@[shareImage]];
    
}

//- (void)shareQQBtnClick:(id)sender {
//    if (_chooseAlertView) {
//        rightBarBtn.selected = !rightBarBtn.selected;
//        [_chooseAlertView removeFromSuperview];
//        _chooseAlertView = nil;
//    }
//    UIImage *shareImage = [self makeImageWithView:movieInfoBg];
//    [UIConstants shareWithType:0 andController:self andItems:@[shareImage]];
//
//}
//- (void)shareWXBtnClick:(id)sender {
//    if (_chooseAlertView) {
//        rightBarBtn.selected = !rightBarBtn.selected;
//        [_chooseAlertView removeFromSuperview];
//        _chooseAlertView = nil;
//    }
//    UIImage *shareImage = [self makeImageWithView:movieInfoBg];
//    [UIConstants shareWithType:1 andController:self andItems:@[shareImage]];
//    
//}

- (UIImage *)encodeQRImageWithContent:(NSString *)content size:(CGSize)size {
    UIImage *codeImage = nil;
    NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
    
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    UIColor *onColor = [UIColor blackColor];
    UIColor *offColor = [UIColor whiteColor];
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    return codeImage;
}

- (UIView *)getViewBottomLineWithSuperView:(UIView *)superView withTop:(NSInteger)topIndex{
    UIView *viewBottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, topIndex, kCommonScreenWidth, 0.5)];
    viewBottomLine.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [superView addSubview:viewBottomLine];
    return viewBottomLine;
}

- (UILabel *)getFlagLabelWithFont:(float)font withBgColor:(NSString *)color withTextColor:(NSString *)textColor{
    UILabel *_activityTitle = [UILabel new];
    _activityTitle.font = [UIFont systemFontOfSize:font];
    _activityTitle.textAlignment = NSTextAlignmentCenter;
    _activityTitle.textColor = [UIColor colorWithHex:textColor];
    _activityTitle.backgroundColor = [UIColor colorWithHex:color];
    _activityTitle.layer.cornerRadius = 3.5f;
    _activityTitle.layer.masksToBounds = YES;
    return _activityTitle;
}


- (NSMutableArray *)productList {
    if (_productList) {
        _productList = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _productList;
}


//- (UIView *)chooseAlertView {
//    if (!_chooseAlertView) {
//        _chooseAlertView = [[UIView alloc] initWithFrame:CGRectMake(kCommonScreenWidth-(119+5)*Constants.screenWidthRate, 56, 119*Constants.screenWidthRate, 101*Constants.screenHeightRate)];
//        _chooseAlertView.backgroundColor = [UIColor clearColor];
//        UIImageView *imageViewOfAlertView = [[UIImageView alloc] init];
//        [_chooseAlertView addSubview:imageViewOfAlertView];
//        imageViewOfAlertView.contentMode = UIViewContentModeScaleAspectFit;
//        UIImage *alertImage = [UIImage imageNamed:@"titlepop_triangle"];
//        imageViewOfAlertView.image = alertImage;
//        [imageViewOfAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(_chooseAlertView.mas_right).offset(-12*Constants.screenWidthRate);
//            make.top.equalTo(_chooseAlertView.mas_top);
//            make.size.mas_equalTo(CGSizeMake(alertImage.size.width, alertImage.size.height));
//        }];
//        UIView *choseView = [[UIView alloc] init];
//        choseView.backgroundColor = [UIColor colorWithHex:@"#000000"];
//        choseView.alpha = 0.9;
//        choseView.layer.cornerRadius = 3.5;
//        choseView.clipsToBounds = YES;
//        [_chooseAlertView addSubview:choseView];
//        [choseView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.width.equalTo(_chooseAlertView);
//            make.top.equalTo(imageViewOfAlertView.mas_bottom).offset(-1);
//            make.height.equalTo(@(101*Constants.screenHeightRate));
//        }];
//        //创建2个button，进行帅选
//        
//        
//        
//        shareQQBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        shareWXBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        UIView *line1View = [[UIView alloc] init];
//        line1View.backgroundColor = [UIColor colorWithHex:@"#333333"];
//        
//        [choseView addSubview:shareQQBtn];
//        [choseView addSubview:line1View];
//        [choseView addSubview:shareWXBtn];
//        shareQQBtn.selected = NO;
//        shareWXBtn.selected = NO;
//        
//        [shareQQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(choseView);
//            make.left.width.right.equalTo(choseView);
//            make.height.equalTo(@(50*Constants.screenHeightRate));
//        }];
//        [line1View mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(shareQQBtn.mas_bottom).offset(0);
//            make.left.width.right.equalTo(choseView);
//            make.height.equalTo(@1);
//        }];
//        [shareWXBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(line1View.mas_bottom).offset(0);
//            make.left.width.right.equalTo(choseView);
//            make.height.equalTo(@(50*Constants.screenHeightRate));
//        }];
//        
//        [shareQQBtn setTitle:@"QQ" forState:UIControlStateNormal];
//        [shareQQBtn setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
//        [shareQQBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor] forState:UIControlStateHighlighted];
//        [shareQQBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor] forState:UIControlStateSelected];
//        
//        shareQQBtn.titleLabel.font = [UIFont systemFontOfSize:18*Constants.screenWidthRate];
//        [shareQQBtn addTarget:self action:@selector(shareQQBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [shareWXBtn setTitle:@"微信" forState:UIControlStateNormal];
//        [shareWXBtn setTitleColor:[UIColor colorWithHex:@"#ffffff"] forState:UIControlStateNormal];
//        [shareWXBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor] forState:UIControlStateSelected];
//        [shareWXBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor] forState:UIControlStateHighlighted];
//        
//        shareWXBtn.titleLabel.font = [UIFont systemFontOfSize:18*Constants.screenWidthRate];
//        [shareWXBtn addTarget:self action:@selector(shareWXBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _chooseAlertView;
//}


#pragma mark 生成image
- (UIImage *)makeImageWithView:(UIView *)view {
    
    CGSize viewSize = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    UIGraphicsBeginImageContextWithOptions(viewSize, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




@end
