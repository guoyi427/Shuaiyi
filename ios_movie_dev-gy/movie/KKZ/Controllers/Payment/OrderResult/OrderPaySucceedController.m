//
//  购票成功页面
//
//  Created by KKZ on 15/9/9.
//  Copyright (c) 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "EGORefreshTableHeaderView.h"
#import "OrderDetailViewController.h"
#import "OrderPaySucceedController.h"
#import "ShareView.h"
#import "UIActionSheet+Blocks.h"
#import "UIAlertView+Blocks.h"
#import "UIViewControllerExtra.h"
#import "UserDefault.h"
#import "DateEngine.h"
#import <QuartzCore/QuartzCore.h>

#import "Cinema.h"
#import "Movie.h"
#import "Ticket.h"

#import "OrderTask.h"
#import "TaskQueue.h"

#import "DataEngine.h"
#import "DateEngine.h"
#import "ImageEngine.h"
#import "UIConstants.h"

#import "Banner.h"
#import "PassbookTask.h"
#import "RewardScoreTask.h"

#import "AppRequest.h"
#import "ActivityWebViewController.h"
#import <SDWebImage/SDWebImageManager.h>
#import "KoMovie-Swift.h"

#define kMarginX 30
#define kFont 13

#define kTextSizeMovieName 16 // 电影名称的字体大小
#define kTextSizeTicketInfo 13 // 影票其他信息的字体大小

@interface OrderPaySucceedController ()
@property (nonatomic, strong) UIView *shareView;
@end

@implementation OrderPaySucceedController

#pragma mark - View lifecycle
- (id)initWithOrder:(NSString *)orderNo {
    self = [super init];
    if (self) {
        self.orderNo = orderNo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor r:37 g:188 b:37];

    //右边返回主页
    RoundCornersButton *rightBtn = [[RoundCornersButton alloc] initWithFrame:CGRectMake(screentWith - 15 - 60, 7, 60, 30)];
    rightBtn.cornerNum = 3;
    rightBtn.titleName = @"完成";
    rightBtn.titleColor = [UIColor whiteColor];
    rightBtn.titleFont = [UIFont boldSystemFontOfSize:14];
    rightBtn.rimWidth = 1;
    rightBtn.rimColor = [UIColor whiteColor];
    rightBtn.fillColor = [UIColor clearColor];
    [rightBtn addTarget:self action:@selector(backtoHomepage) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:rightBtn];

    Ticket *ticket = self.myOrder.plan;
    CinemaDetail *cinema = ticket.cinema;

    holder = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)];

    [holder setBackgroundColor:[UIColor r:245 g:245 b:245]];

    [self.view addSubview:holder];

    holder.delegate = self;
    holder.alpha = 1;
    holder.showsVerticalScrollIndicator = NO;

    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screentWith, 215)];
    headview.backgroundColor = [UIColor whiteColor];
    headview.userInteractionEnabled = YES;
    [holder addSubview:headview];

    CGFloat positionYH = 20;

    UIImage *imgStatusIcon = [UIImage imageNamed:@"paySucceedIcon"];
    UIImageView *imgStatusIconV = [[UIImageView alloc] initWithFrame:CGRectMake((screentWith - 53) * 0.5, positionYH, 53, 53)];
    imgStatusIconV.image = imgStatusIcon;
    [headview addSubview:imgStatusIconV];

    positionYH += 70;

    orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, positionYH, screentWith, 20)];
    orderStateLabel.text = @"购票成功";
    orderStateLabel.textColor = [UIColor blackColor];
    orderStateLabel.textAlignment = NSTextAlignmentCenter;
    orderStateLabel.font = [UIFont systemFontOfSize:18];
    [headview addSubview:orderStateLabel];

    positionYH += 45;

    qrView = [[UIView alloc] initWithFrame:CGRectMake(0, positionYH, screentWith, 70)];
    qrView.backgroundColor = [UIColor clearColor];
    qrView.hidden = NO;
    qrView.userInteractionEnabled = YES;
    [holder addSubview:qrView];

    codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMarginX, 0, 70, 70)];
    [codeImageView loadImageWithURL:self.myOrder.qrCodePath andSize:ImageSizeMiddle];
    codeImageView.layer.borderWidth = 1.0;
    codeImageView.layer.cornerRadius = 3;
    codeImageView.layer.borderColor = [UIColor r:204 g:204 b:204].CGColor;
    codeImageView.contentMode = UIViewContentModeScaleAspectFit;
    codeImageView.userInteractionEnabled = YES;
    codeImageView.clipsToBounds = YES;
    [qrView addSubview:codeImageView];

    self.ticketNo = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(codeImageView.frame) + 10, 0, 50, 20)];
    self.ticketNo.text = self.myOrder.finalTicketNoName;
    self.ticketNo.textColor = [UIColor lightGrayColor];
    self.ticketNo.font = [UIFont systemFontOfSize:14];
    [qrView addSubview:self.ticketNo];

    ticketNoValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.ticketNo.frame), 0, screentWith, 20)];
    ticketNoValue.text = [TicketReminderController insertSpacesFormat:self.myOrder.finalTicketNo];
    ticketNoValue.textColor = [UIColor blackColor];
    ticketNoValue.textAlignment = NSTextAlignmentLeft;
    ticketNoValue.font = [UIFont systemFontOfSize:15];
    [qrView addSubview:ticketNoValue];


    self.verificationCode = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(codeImageView.frame) + 10, 20, 50, 20)];

    self.verificationCode.textColor = [UIColor lightGrayColor];
    self.verificationCode.text = self.myOrder.finalVerifyCodeName;
    self.verificationCode.font = [UIFont systemFontOfSize:14];
    [qrView addSubview:self.verificationCode];

    verificationCodeValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.verificationCode.frame), 20, screentWith, 20)];
    verificationCodeValue.text = [TicketReminderController insertSpacesFormat:self.myOrder.finalVerifyCode];
    verificationCodeValue.textAlignment = NSTextAlignmentLeft;
    verificationCodeValue.textColor = [UIColor blackColor];
    verificationCodeValue.font = [UIFont systemFontOfSize:15];
    [qrView addSubview:verificationCodeValue];
    
    if (self.myOrder.finalTicketNo.length >0  && self.myOrder.finalVerifyCode.length > 0) {
        //finalTicketNo finalVerifyCode 都有
        
    }else if (self.myOrder.finalTicketNo.length > 0){
        //只有finalTicketNo
        self.verificationCode.hidden = YES;
        verificationCodeValue.hidden = YES;
        
        self.ticketNo.frame = CGRectMake(CGRectGetMaxX(codeImageView.frame) + 10, 20, 50, 20);
        ticketNoValue.frame = CGRectMake(CGRectGetMaxX(self.ticketNo.frame), 20, screentWith, 20);
    }else if (self.myOrder.finalVerifyCode.length > 0){
        //只有finalVerifyCode
        self.ticketNo.hidden = YES;
        ticketNoValue.hidden = YES;
        self.verificationCode.frame = CGRectMake(CGRectGetMaxX(codeImageView.frame) + 10, 20, 50, 20);
        verificationCodeValue.frame = CGRectMake(CGRectGetMaxX(self.verificationCode.frame), 20, screentWith, 20);
    }

    self.warningText = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(codeImageView.frame) + 10, 40, screentWith - 25 - CGRectGetMaxX(codeImageView.frame), 40)];
    self.warningText.numberOfLines = 0;
    self.warningText.text = self.myOrder.machineTypeDesc;
    self.warningText.textColor = [UIColor lightGrayColor];
    self.warningText.font = [UIFont systemFontOfSize:14];
    [qrView addSubview:self.warningText];


    UIImage *imgTicketBottom = [UIImage imageNamed:@"ticketPageBottom"];
    UIImageView *imgTicketBottomV = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headview.frame) - 20, screentWith, 30)];
    imgTicketBottomV.image = imgTicketBottom;
    [holder insertSubview:imgTicketBottomV belowSubview:headview];

    orderView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headview.frame) + 10, screentWith, 150)];
    orderView.backgroundColor = [UIColor clearColor];
    orderView.userInteractionEnabled = YES;
    [holder addSubview:orderView];

    CGFloat poY = 20;

    movieNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, poY, screentWith - 15 * 2, kTextSizeMovieName)];
    movieNameLabel.backgroundColor = [UIColor clearColor];
    movieNameLabel.textAlignment = NSTextAlignmentCenter;
    movieNameLabel.textColor = [UIColor blackColor];
    movieNameLabel.font = [UIFont systemFontOfSize:kTextSizeMovieName];
    movieNameLabel.text = self.myOrder.plan.movie.movieName;
    [orderView addSubview:movieNameLabel];
    poY += 15 + kTextSizeMovieName;
    
    UILabel *startTime = [[UILabel alloc] initWithFrame:CGRectMake(kMarginX, poY, 40, kTextSizeTicketInfo)];
    startTime.backgroundColor = [UIColor clearColor];
    startTime.textAlignment = NSTextAlignmentLeft;
    startTime.textColor = [UIColor lightGrayColor];
    startTime.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    startTime.text = @"场   次";
    [orderView addSubview:startTime];
    
    startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(startTime.frame) + 10, poY, screentWith - 15 - 70, kTextSizeTicketInfo)];
    startTimeLabel.backgroundColor = [UIColor clearColor];
    startTimeLabel.textColor = [UIColor blackColor];
    startTimeLabel.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    NSString *date = [[DateEngine sharedDateEngine] stringFromDate:self.myOrder.plan.movieTime withFormat:@"M月d日"];
    NSString *week = [[DateEngine sharedDateEngine] weekDayXingQiFromDateCP:self.myOrder.plan.movieTime];
    NSString *day = [[DateEngine sharedDateEngine] relativeDateStringFromDate:self.myOrder.plan.movieTime];
    NSString *time = [[DateEngine sharedDateEngine] stringFromDate:self.myOrder.plan.movieTime withFormat:@"HH:mm"];
    NSString *moTime = nil;
    if (day.length != 0) {
        moTime = [NSString stringWithFormat:@"%@%@（%@）  %@",date, week, day, time];
    }else {
        moTime = [NSString stringWithFormat:@"%@%@  %@",date, week, time];
    }
    startTimeLabel.text = [NSString stringWithFormat:@"%@ %@%@", moTime, ticket.language ? ticket.language : @"", self.myOrder.plan.screenType ? self.myOrder.plan.screenType : @""];
    [orderView addSubview:startTimeLabel];
    
    poY += 10 + kTextSizeMovieName;

    UILabel *cinemaN = [[UILabel alloc] initWithFrame:CGRectMake(kMarginX, poY, 40, kTextSizeTicketInfo)];
    cinemaN.backgroundColor = [UIColor clearColor];
    cinemaN.textAlignment = NSTextAlignmentLeft;
    cinemaN.textColor = [UIColor lightGrayColor];
    cinemaN.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    cinemaN.text = @"影   院";
    [orderView addSubview:cinemaN];

    cinemaNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cinemaN.frame) + 10, poY, screentWith - 15 - CGRectGetMaxX(cinemaN.frame) - 10, kTextSizeTicketInfo)];
    cinemaNameLabel.backgroundColor = [UIColor clearColor];
    cinemaNameLabel.textColor = [UIColor blackColor];
    cinemaNameLabel.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    cinemaNameLabel.text = [NSString stringWithFormat:@"%@ %@", cinema.cinemaName, ticket.hallName];
    [orderView addSubview:cinemaNameLabel];

    poY += 10 + kTextSizeTicketInfo;

    UILabel *seatLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMarginX, poY, 40, kTextSizeTicketInfo)];
    seatLabel.backgroundColor = [UIColor clearColor];
    seatLabel.textColor = [UIColor lightGrayColor];
    seatLabel.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    seatLabel.text = @"座   位";
    [orderView addSubview:seatLabel];

    NSString *seatsInfo = [self.myOrder readableSeatInfos];
    CGSize size = [seatsInfo sizeWithFont:[UIFont systemFontOfSize:kTextSizeTicketInfo] constrainedToSize:CGSizeMake(screentWith - 52 - 15, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];

    seatInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(seatLabel.frame) + 10, poY, screentWith - 70 - 15, size.height)];
    seatInfoLabel.backgroundColor = [UIColor clearColor];
    seatInfoLabel.textColor = [UIColor blackColor];
    seatInfoLabel.numberOfLines = 0;
    seatInfoLabel.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    seatInfoLabel.text = [self.myOrder readableSeatInfos];
    [orderView addSubview:seatInfoLabel];

    poY += 10 + kTextSizeTicketInfo;

    UILabel *mobileTicket = [[UILabel alloc] initWithFrame:CGRectMake(kMarginX, poY, 40, kTextSizeTicketInfo)];
    mobileTicket.backgroundColor = [UIColor clearColor];
    mobileTicket.textAlignment = NSTextAlignmentLeft;
    mobileTicket.textColor = [UIColor lightGrayColor];
    mobileTicket.font = [UIFont systemFontOfSize:kTextSizeTicketInfo];
    mobileTicket.text = @"手机号";
    [orderView addSubview:mobileTicket];

    mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(mobileTicket.frame) + 10, poY, screentWith - 15 - 70, kTextSizeTicketInfo)];
    mobileLabel.backgroundColor = [UIColor clearColor];
    mobileLabel.textColor = [UIColor r:50 g:50 b:50];
    mobileLabel.font = [UIFont systemFontOfSize:kFont];
    NSString *mobile = self.myOrder.mobile;
    if (mobile.length == 11) {
        NSMutableString *mutableMobile = [NSMutableString stringWithString:mobile];
        [mutableMobile insertString:@" " atIndex:3];
        [mutableMobile insertString:@" " atIndex:8];
        mobile = [mutableMobile copy];
    }
    mobileLabel.text = mobile;
    [orderView addSubview:mobileLabel];

    
    ShareView *poplistview = [[ShareView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(orderView.frame), screentWith, 120)];
    poplistview.userShareInfo = @"orderDetail";
    poplistview.titleLabel.text = @"炫耀一下";
    poplistview.titleLabel.textColor = [UIColor colorWithHex:@"0x969696"];
    //分享订单
    NSString *shareUrl = [NSString stringWithFormat:@"%@&type=%@&targetId=%@&userId=%@", kAppShareHTML5Url, @"10", self.myOrder.orderId, [DataEngine sharedDataEngine].userId];

    NSString *content = [NSString stringWithFormat:@"我在#章鱼电影#买了《%@》，%@，%@，%@的电影票。查看详情：%@。更多精彩，尽在【章鱼电影客户端】。",
                                                   self.myOrder.plan.movie.movieName,
                                                   self.myOrder.plan.cinema.cinemaName,
                                                   self.myOrder.plan.hallName,
                                                   [self.myOrder movieTimeDesc],
                                                   shareUrl];
    NSString *contentQQSpace = [NSString stringWithFormat:@"我在#章鱼电影#买了《%@》，%@，%@，%@的电影票。",
                                                          self.myOrder.plan.movie.movieName,
                                                          self.myOrder.plan.cinema.cinemaName,
                                                          self.myOrder.plan.hallName,
                                                          [self.myOrder movieTimeDesc]];
    NSString *contentWeChat = [NSString stringWithFormat:@"我在#章鱼电影#买了《%@》，%@，%@，%@的电影票。",
                                                         self.myOrder.plan.movie.movieName,
                                                         self.myOrder.plan.cinema.cinemaName,
                                                         self.myOrder.plan.hallName,
                                                         [self.myOrder movieTimeDesc]];

    

    [poplistview setBackgroundColor:[UIColor clearColor]];
    self.shareView = poplistview;
    [holder addSubview:poplistview];
    
    [[SDWebImageManager sharedManager]  downloadImageWithURL:[NSURL URLWithString:self.myOrder.plan.movie.thumbPath]
                                                     options:SDWebImageContinueInBackground progress:nil
                                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                       UIImage *im = image;
                                                       if (im == nil) {
                                                           im = [UIImage imageNamed:@"Icon-120"];
                                                       }
                                                       
                                                       //评分信息，影片海报，我的文字或者语音评论信息等以及抠电影的下载信息
                                                       [poplistview updateWithcontent:content
                                                                        contentWeChat:contentWeChat
                                                                       contentQQSpace:contentQQSpace
                                                                                title:@"章鱼电影"
                                                                            imagePath:image
                                                                             imageURL:self.myOrder.plan.movie.thumbPath
                                                                                  url:shareUrl
                                                                             soundUrl:nil
                                                                             delegate:appDelegate
                                                                            mediaType:SSPublishContentMediaTypeNews
                                                                       statisticsType:StatisticsTypeOrder
                                                                            shareInfo:[self.myOrder.plan.movie.movieId stringValue]
                                                                            sharedUid:[DataEngine sharedDataEngine].userId];
                                                         
                                                     }];

   

    [holder setContentSize:CGSizeMake(screentWith, CGRectGetMaxY(poplistview.frame) + 15)];

    [self queryBannerImage];
    [self getScoreAfterSucceed];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    [self setStatusBarLightStyle];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [KKZAnalytics postActionWithEvent:[[KKZAnalyticsEvent alloc] initWithOrder:self.myOrder] action:AnalyticsActionPay_success];
}

#pragma mark utilities

//点击完成返回首页
- (void)backtoHomepage {
    [self popToViewControllerAnimated:YES];
    [appDelegate setSelectedPage:0 tabBar:YES];
}

//PassBook相关
- (void)getPassBook:(UIButton *)btn {
    PassbookTask *task = [[PassbookTask alloc] initPassbookDataWithOrderId:self.orderNo
                                                                  finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                                      [self checkPassbookInfoFinished:userInfo status:succeeded];
                                                                  }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

- (void)checkPassbookInfoFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    if (succeeded) {
        NSString *str = userInfo[@"komoviePkpass"];
        [self openAndAddPassToPassbook:str];
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

- (void)openAndAddPassToPassbook:(NSString *)str {

    NSData *decodeData = [Cryptor decodeBase64WithUTF8String:str];
    NSError *error = nil;
    PKPass *newPass = [[PKPass alloc] initWithData:decodeData error:&error];

    // 检查是否有错误，如有弹出对话框。
    if (error != nil) {
        [[[UIAlertView alloc] initWithTitle:@"Passes error"
                                    message:[error localizedDescription]
                                   delegate:nil
                          cancelButtonTitle:@"知道了"
                          otherButtonTitles:nil] show];
        return;
    }

    //检查PKPassLibrary内是否已经有同样的pass, 有的话, 进行更新, 没有就要进行增加.
    PKPassLibrary *passLibrary = [[PKPassLibrary alloc] init];
    if ([passLibrary containsPass:newPass]) {
        [appDelegate showAlertViewForTitle:@"" message:@"已经添加到passbook了" cancelButton:@"知道了"];
        BOOL replaceResult = [passLibrary replacePassWithPass:newPass];

        DLog(@"replaceResult == %d", replaceResult);
    } else {
        PKAddPassesViewController *addController =
                [[PKAddPassesViewController alloc] initWithPass:newPass];
        addController.delegate = self;
        [self presentViewController:addController animated:YES completion:nil];
    }
}

#pragma mark - Pass controller delegate
- (void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//广告位
- (void)queryBannerImage {
    
    AppRequest *request = [[AppRequest alloc] init];
    [request requestBanners:[NSNumber numberWithInt:USER_CITY]
                   targetID:self.myOrder.plan.movie.movieId
                 targetType:@16
                    success:^(NSArray *_Nullable banners) {
                        
                        self.banners = banners;
                        if (self.banners.count) {
                            managedObject = (Banner *) self.banners[0];
                            [self loadAdWith:managedObject.imagePath];
                        }
                        
                    }
                    failure:^(NSError *_Nullable err){
                        
                    }];
}

/**
 加载广告

 @param url 广告图URL
 */
- (void) loadAdWith:(NSString *)url
{
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url]
                                                    options:SDWebImageContinueInBackground
                                                   progress:nil
                                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          
                                                          adView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.shareView.frame.origin.y, screentWith, 98)];
                                                          adView.userInteractionEnabled = YES;
                                                          adView.contentMode = UIViewContentModeScaleAspectFill;
                                                          adView.layer.masksToBounds = YES;
                                                          [holder addSubview:adView];
                                                          adView.image = image;
                                                          
                                                          UIButton *adViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.shareView.frame.origin.y, screentWith, 98)];
                                                          [adViewBtn setBackgroundColor:[UIColor clearColor]];
                                                          [holder addSubview:adViewBtn];
                                                          [adViewBtn addTarget:self action:@selector(bannerDetailClick) forControlEvents:UIControlEventTouchUpInside];
                                                          
                                                          CGRect shareFrame = self.shareView.frame;
                                                          shareFrame.origin.y = CGRectGetMaxY(adView.frame) + 8;
                                                          self.shareView.frame = shareFrame;
                                                          [holder setContentSize:CGSizeMake(screentWith, CGRectGetMaxY(self.shareView.frame) + 15)];
                                                          
                                                      });
                                                      
                                                  }];
    
   
}

- (void)bannerDetailClick {
    if (self.banners.count) {
        CommonWebViewController *ctr = [[CommonWebViewController alloc] init];
        ctr.requestURL = managedObject.targetUrl;
        [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
    }
}

//购票成功之后赠送积分

- (void)getScoreAfterSucceed {
    RewardScoreTask *task = [[RewardScoreTask alloc] initRewardScoreDataWithOrderId:self.orderNo
                                                                           finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                                               [self checkScoreInfoFinished:userInfo status:succeeded];
                                                                           }];
    [[TaskQueue sharedTaskQueue] addTaskToQueue:task];
}

- (void)checkScoreInfoFinished:(NSDictionary *)userInfo status:(BOOL)succeeded {
    if (succeeded) {
        NSString *title = userInfo[@"content"];
        NSString *iconPath = userInfo[@"icon"];
        NSString *score = userInfo[@"integral"];

        if (title.length) {
            [appDelegate showIntegralViewWithTitle:title andScore:score andIconPath:iconPath];
        }
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

#pragma mark override from CommonViewController
- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return NO;
}

- (BOOL)showTitleBar {
    return TRUE;
}

@end
