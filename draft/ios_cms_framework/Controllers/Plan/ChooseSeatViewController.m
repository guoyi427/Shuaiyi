//
//  ChooseSeatViewController.m
//  CIASMovie
//
//  Created by cias on 2016/12/22.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "ChooseSeatViewController.h"
#import "PlanTimeCollectionViewCell.h"
//#import "AFNetworkReachabilityManager.h"
#import "SeatHelper.h"
#import "SeatRequest.h"
#import "Movie.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "PayViewController.h"
#import "Order.h"
#import "OrderRequest.h"

#import "UserRequest.h"
#import "User.h"
#import "DataEngine.h"
#import "UserDefault.h"
#import <DateEngine_KKZ/DateEngine.h>
#import "AppConfigureRequest.h"
//#import <Category_KKZ/NSDictionaryExtra.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <Category_KKZ/UIImage+Resize.h>
#import "HasEmptySeatView.h"
#import "BestSeatUtil.h"
#import <SDWebImage/SDWebImagePrefetcher.h>

#define K_COUNT_FOR_NAVIGATORY_HIDE 3 //3秒后缩略图消失
//最大缩放
#define K_MAX_HALL_SCALL 1.0

//当可选座位个数还未请求回来时，如进行选择座位操作，提示
#define K_TOAST_CAN_BY_CNT_NOT_REQUEST @"正在查询座位图的售卖情况，请稍后重试"


const NSInteger K_TAG_TICKET_SET_BASE = 1000;
const NSInteger K_TAG_TICKET_GET_BASE = 1001;

@interface ChooseSeatViewController ()

@property (nonatomic, strong) UIView *noSeatAlertView;
@end

@implementation ChooseSeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.printableSelectedSeats = [[NSMutableArray alloc] initWithCapacity:0];
    initFirst = NO;
    
    [self setNavBarUI];
    [self setupUI];
    [planListCollectionView reloadData];
    [planListCollectionView setContentOffset:CGPointMake((63+7.5)*self.selectPlanTimeRow, 0)];
    [self doRequest];
    
    self.selectSeatIconDict = [[NSMutableDictionary alloc] initWithCapacity:0];


    [self requestAPPConfig];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.scrollHallView.delegate = self;
    self.hallView.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (initFirst) {
        [self requestSeat];
    }
    NSComparisonResult result; //非今日场次
    NSDate *nowDate = [NSDate date];
    NSString *nowDateStr = [[DateEngine sharedDateEngine] stringFromDateYYYYMMDD:nowDate];
//    DLog(@"nowDateStr:%@", nowDateStr);
//    DLog(@"self.selectPlanDate.showDate:%@", self.selectPlanDate.showDate);

    result= [self.selectPlanDate.showDate compare:nowDateStr];
    if (result == NSOrderedDescending) {
//        DLog(@"1111");
        NSDate *planDate = [[DateEngine sharedDateEngine] dateFromString:self.planDateString];
        NSString *tipStr1 = [[DateEngine sharedDateEngine] stringFromDate:planDate withFormat:@"MM月dd日"];
        NSString *tipStr2 = [[DateEngine sharedDateEngine] relativeDateStringFromDate:planDate];
        if ([tipStr2 isEqualToString:@"今天"] ||[tipStr2 isEqualToString:@"明天"]||[tipStr2 isEqualToString:@"后天"] ) {
        } else {
            tipStr2 = @"";
        }
        NSString *tipStr = [NSString stringWithFormat:@"您选的是%@ %@的场次，请仔细核对", tipStr2, tipStr1];
        NSMutableAttributedString *attriTipStr = [KKZTextUtility getAttributeStr:tipStr withStartRangeStr:@"的是" withEndRangeStr:@"的场" withFormalColor:[UIColor colorWithHex:@"#333333"] withSpecialColor:[UIColor redColor] withFont:[UIFont systemFontOfSize:13]];
        [[CIASAlertCancleView new] show:@"提示" attributeMessage:attriTipStr cancleTitle:@"我知道了" callback:^(BOOL confirm) {
        }];
    }else{
//        DLog(@"2222");
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.scrollHallView.delegate = nil;
    self.hallView.delegate = nil;
    [self.timerForNavigator invalidate];
    initFirst = YES;
}

- (void)setupUI{
    UICollectionViewFlowLayout *planListCollectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    [planListCollectionViewLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    planListCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 85) collectionViewLayout:planListCollectionViewLayout];
    planListCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:planListCollectionView];
    planListCollectionView.showsHorizontalScrollIndicator = NO;
    planListCollectionView.delegate = self;
    planListCollectionView.dataSource = self;
    [planListCollectionView registerClass:[PlanTimeCollectionViewCell class] forCellWithReuseIdentifier:@"PlanTimeCollectionViewCell"];
    
    selectseatscreenImageview = [UIImageView new];
    selectseatscreenImageview.backgroundColor = [UIColor clearColor];
    selectseatscreenImageview.contentMode = UIViewContentModeScaleAspectFill;
    selectseatscreenImageview.image = [UIImage imageNamed:@"selectseat_screen"];
    [self.view addSubview:selectseatscreenImageview];
    [selectseatscreenImageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(planListCollectionView.mas_bottom).offset(11);
        make.left.equalTo(@(0));
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(25));
    }];
    
    hallNameLabel = [UILabel new];
    hallNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
    hallNameLabel.textAlignment = NSTextAlignmentCenter;
    hallNameLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:hallNameLabel];
    [hallNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(planListCollectionView.mas_bottom).offset(30);
        make.left.equalTo(@(0));
        //        make.centerX.equalTo(hallNameView.mas_centerX);
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(15));
    }];
    
    screenTypeLabel = [UILabel new];
    screenTypeLabel.textColor = [UIColor colorWithHex:@"#999999"];
    screenTypeLabel.textAlignment = NSTextAlignmentCenter;
    screenTypeLabel.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:screenTypeLabel];
    [screenTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hallNameLabel.mas_bottom).offset(1);
        make.left.equalTo(@(0));
        //        make.centerX.equalTo(hallNameView.mas_centerX);
        make.width.equalTo(@(kCommonScreenWidth));
        make.height.equalTo(@(15));
    }];
    
    self.scrollHallView = [UIScrollView new];
    self.scrollHallView.alwaysBounceHorizontal = NO;
    self.scrollHallView.alwaysBounceVertical = NO;
    self.scrollHallView.delegate = self;
    self.scrollHallView.bouncesZoom = YES;
    self.scrollHallView.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    [self.view addSubview:self.scrollHallView];
    [self.scrollHallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(screenTypeLabel.mas_bottom).offset(16);
        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
    }];
    
    
    self.hallView = [[HallView alloc] init];
    [self.scrollHallView addSubview:self.hallView];
    self.hallView.delegate = self;
    self.hallView.space = 2;
    __weak __typeof(self) weakSelf = self;
    
    [self.hallView setUpdateDrawCallBack:^{
        //update draw rect callback
        [weakSelf.navigatorView update];
    }];
    
    
    self.seatIndexView = [CPSeatIndexView new];
    self.seatIndexView.userInteractionEnabled = NO;
    self.seatIndexView.contentLayer.backgroundColor = [UIColor colorWithHex:@"a7b1be" a:0.8].CGColor;
    self.seatIndexView.contentLayer.borderWidth = 0.5;
    self.seatIndexView.contentLayer.borderColor = [UIColor colorWithHex:@"a3adbb"].CGColor;
    self.seatIndexView.contentLayer.cornerRadius = 3;
    [self.view addSubview:self.seatIndexView];
    [self.seatIndexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.top.equalTo(self.scrollHallView.mas_top);
        make.height.equalTo(self.scrollHallView.mas_height);
        make.width.equalTo(@10);
    }];
    self.navigatorView = [[CPNavigatorView alloc] initWithFrame:CGRectMake(48, 124, 150, 90)];
        self.navigatorView.hidden = YES;
    self.navigatorView.layer.cornerRadius = 2;
    self.navigatorView.spotLayer.cornerRadius = 3;
    self.navigatorView.spotLayer.borderWidth = 2;
    [self.view addSubview:self.navigatorView];
    [self.navigatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@48);
        make.top.equalTo(self.scrollHallView.mas_top);
        make.height.equalTo(@(90));
        make.width.equalTo(@150);
    }];
    
    
    
    self.ticketRecommentView = [UIView new];
    self.ticketRecommentView.backgroundColor = [UIColor whiteColor];
    self.ticketRecommentView.alpha = 0.9;
    [self.view addSubview:self.ticketRecommentView];
    [self.ticketRecommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@91);
    }];
    UIView *recommentLine = [UIView new];
    recommentLine.backgroundColor = [UIColor colorWithHex:@"e0e0e0"];
    [self.ticketRecommentView addSubview:recommentLine];
    [recommentLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.right.equalTo(self.ticketRecommentView);
        make.height.equalTo(@(1));
    }];
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = @"替我选座";
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.textColor = [UIColor colorWithHex:@"b2b2b2"];
    [self.ticketRecommentView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(@(20));
        make.width.equalTo(@(70));
        make.height.equalTo(@(14));
    }];
    UILabel *tipLabel1 = [UILabel new];
    tipLabel1.text = @"请选择购票人数";
    tipLabel1.font = [UIFont systemFontOfSize:10];
    tipLabel1.textAlignment = NSTextAlignmentLeft;
    tipLabel1.textColor = [UIColor colorWithHex:@"333333"];
    [self.ticketRecommentView addSubview:tipLabel1];
    [tipLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(15));
        make.top.equalTo(tipLabel.mas_bottom).offset(4);
        make.width.equalTo(@(80));
        make.height.equalTo(@(12));
    }];
    
    for (int i=4; i>=1; i--) {
        UIButton *recommentSeatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        recommentSeatBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        [recommentSeatBtn setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
        [recommentSeatBtn setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        recommentSeatBtn.tag = 5000+i;
        recommentSeatBtn.layer.cornerRadius = 3;
        recommentSeatBtn.layer.borderWidth = 0.5;
        recommentSeatBtn.layer.borderColor = [UIColor colorWithHex:@"e0e0e0"].CGColor;
        [recommentSeatBtn addTarget:self action:@selector(recommentSeatBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        recommentSeatBtn.backgroundColor = [UIColor colorWithHex:@"#f2f5f5"];
        [self.ticketRecommentView addSubview:recommentSeatBtn];
        [recommentSeatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@(18));
            make.width.equalTo(@(40));
            make.height.equalTo(@30);
            make.right.equalTo(self.ticketRecommentView).offset(-(15+(4-i)*44));
        }];
        
    }
    //底部座位说明
    UIFont *font = [UIFont systemFontOfSize:10];
    UIColor *color = [UIColor colorWithHex:@"333333"];
    
    UIImageView *iconEnable = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seat_enable"]];
    [self.ticketRecommentView addSubview:iconEnable];
    
    UILabel *labelEnable = [UILabel new];
    labelEnable.text = @"可选";
    labelEnable.font = font;
    labelEnable.textColor = color;
    [self.ticketRecommentView addSubview:labelEnable];
    
    UIImageView *iconSold = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seat_sold_icon"]];
    [self.ticketRecommentView addSubview:iconSold];
    
    UILabel *labelSold = [UILabel new];
    labelSold.text = @"已售";
    labelSold.font = font;
    labelSold.textColor = color;
    [self.ticketRecommentView addSubview:labelSold];
    
    UIImageView *iconLover = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seat_lover_icon"]];
    [self.ticketRecommentView addSubview:iconLover];
    
    UILabel *labelLover = [UILabel new];
    labelLover.text = @"情侣座";
    labelLover.font = font;
    labelLover.textColor = color;
    [self.ticketRecommentView addSubview:labelLover];
    
    UIImageView *iconChoose = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"seat_selected_icon"]];
    [self.ticketRecommentView addSubview:iconChoose];
    
    UILabel *labelChoose = [UILabel new];
    labelChoose.text = @"已选";
    labelChoose.font = font;
    labelChoose.textColor = color;
    [self.ticketRecommentView addSubview:labelChoose];
    
    CGFloat itemSpace = 30;
    CGFloat groupSpace = 4;
    
    [iconEnable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@((kCommonScreenWidth-285)/2));
        make.bottom.equalTo(self.view.mas_bottom).insets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    
    [labelEnable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconEnable.mas_right).offset(groupSpace);
        make.bottom.equalTo(iconEnable.mas_bottom);
    }];
    
    [iconSold mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelEnable.mas_right).offset(itemSpace);
        make.bottom.equalTo(iconEnable.mas_bottom);
    }];
    
    [labelSold mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconSold.mas_right).offset(groupSpace);
        make.bottom.equalTo(iconEnable.mas_bottom);
    }];
    
    [iconChoose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelSold.mas_right).offset(itemSpace);
        make.bottom.equalTo(iconEnable.mas_bottom);
    }];
    
    [labelChoose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconChoose.mas_right).offset(groupSpace);
        make.bottom.equalTo(iconEnable.mas_bottom);
    }];
    
    [iconLover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelChoose.mas_right).offset(itemSpace);
        make.bottom.equalTo(iconEnable.mas_bottom);
    }];
    
    [labelLover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconLover.mas_right).offset(groupSpace);
        make.bottom.equalTo(iconEnable.mas_bottom);
    }];
    
    self.ticketView = [UIView new];
    self.ticketView.backgroundColor = [UIColor colorWithHex:@"#ffffff"];
    self.ticketView.alpha = 0.9;
    [self.view addSubview:self.ticketView];
    [self.ticketView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@100);
    }];
    self.ticketView.hidden = YES;
    
    UIView *ticketViewLine = [UIView new];
    ticketViewLine.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].lineColor];
    [self.ticketView addSubview:ticketViewLine];
    [ticketViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    confirmBtn.tag = 206;
    [confirmBtn setTitleColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].btnCharacterColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确认选座" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmOrderClick) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.backgroundColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].btnColor];
    //    [confirmBtn setBackgroundColor:[UIColor colorWithHex:@"#ffcc00"] forState:UIControlStateNormal];
    [self.ticketView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@50);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.ticketView.mas_bottom);
    }];
    
    [self showNoSeatAlertView];
    
    

}

- (void) showNoSeatAlertView {
    UIImage *noOrderAlertImage = [UIImage imageNamed:@"seat_nodata"];
    NSString *noOrderAlertStr = @"影厅座位加载中";
    CGSize noOrderAlertStrSize = [KKZTextUtility measureText:noOrderAlertStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:15]];
    self.noSeatAlertView = [[UIView alloc] init];
    self.noSeatAlertView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.noSeatAlertView];
    [self.noSeatAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.right.equalTo(self.view);
        //        make.top.equalTo(screenTypeLabel.mas_bottom).offset(16);
        //        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
        make.left.equalTo(self.view.mas_left).offset((kCommonScreenWidth - noOrderAlertImage.size.width)/2);
        make.centerY.equalTo(self.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(noOrderAlertImage.size.width, noOrderAlertStrSize.height+noOrderAlertImage.size.height+15));
    }];
    //    self.noSeatAlertView = [[UIView alloc] initWithFrame:CGRectMake((kCommonScreenWidth - noOrderAlertImage.size.width)/2, 0.277*kCommonScreenHeight, noOrderAlertImage.size.width, noOrderAlertStrSize.height+noOrderAlertImage.size.height+15)];
    //    UIView *contentView = [[UIView alloc] init];
    //    contentView.backgroundColor = [UIColor greenColor];
    //    [self.view addSubview:contentView];
    //    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.equalTo(self.noSeatAlertView.mas_left).offset((kCommonScreenWidth - noOrderAlertImage.size.width)/2);
    //        make.centerY.equalTo(self.noSeatAlertView.mas_centerY);
    //        make.size.mas_equalTo(CGSizeMake(noOrderAlertImage.size.width, noOrderAlertStrSize.height+noOrderAlertImage.size.height+15));
    //    }];
    UIImageView *noOrderAlertImageView = [[UIImageView alloc] init];
    [self.noSeatAlertView addSubview:noOrderAlertImageView];
    noOrderAlertImageView.image = noOrderAlertImage;
    noOrderAlertImageView.contentMode = UIViewContentModeScaleAspectFill;
    [noOrderAlertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.noSeatAlertView);
        make.height.equalTo(@(noOrderAlertImage.size.height));
    }];
    UILabel *noOrderAlertLabel = [[UILabel alloc] init];
    [self.noSeatAlertView addSubview:noOrderAlertLabel];
    noOrderAlertLabel.text = noOrderAlertStr;
    noOrderAlertLabel.font = [UIFont systemFontOfSize:15];
    noOrderAlertLabel.textAlignment = NSTextAlignmentCenter;
    noOrderAlertLabel.textColor = [UIColor colorWithHex:@"#666666"];
    [noOrderAlertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.noSeatAlertView);
        make.top.equalTo(noOrderAlertImageView.mas_bottom).offset(15);
        make.height.equalTo(@(noOrderAlertStrSize.height));
    }];
}

- (void)setNavBarUI{
    
    UIColor *styleColor = [UIColor whiteColor];
#if K_HENGDIAN
    styleColor = [UIColor blackColor];
#endif
    
    UIView * customTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth-140, 44)];
    customTitleView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = customTitleView;
    cinemaTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, kCommonScreenWidth-140-50, 15)];
    cinemaTitleLabel.textColor = styleColor;
    cinemaTitleLabel.backgroundColor = [UIColor clearColor];
    cinemaTitleLabel.textAlignment = NSTextAlignmentCenter;
    cinemaTitleLabel.text = self.cinemaName;
    cinemaTitleLabel.font = [UIFont systemFontOfSize:16];
    [customTitleView addSubview:cinemaTitleLabel];
//    [cinemaTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@(7));
//        make.left.equalTo(@(10));
//        make.right.equalTo(customTitleView.mas_right).offset(-10);
//        make.height.equalTo(@(15));
//    }];
    
    movieTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, kCommonScreenWidth-140-50, 13)];
    movieTitleLabel.textColor = [UIColor colorWithHex:[UIConstants sharedDataEngine].characterColor];
    movieTitleLabel.textAlignment = NSTextAlignmentCenter;
    movieTitleLabel.text = self.movieName;
    movieTitleLabel.font = [UIFont systemFontOfSize:13];
    [customTitleView addSubview:movieTitleLabel];
//    [movieTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(cinemaTitleLabel.mas_bottom).offset(5);
//        make.left.equalTo(@(10));
//        make.right.equalTo(customTitleView.mas_right).offset(-10);
//        make.height.equalTo(@(13));
//    }];
    
    UIView * customRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    customRightView.backgroundColor = [UIColor clearColor];

    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 50, 15)];
    dateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    dateLabel.textColor = styleColor;
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.textAlignment = NSTextAlignmentRight;
    [customRightView addSubview:dateLabel];
//    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(customRightView);
//        make.top.equalTo(@(10));
//        make.height.equalTo(@(15));
//    }];
    detailDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 27, 50, 15)];
    detailDateLabel.font = [UIFont systemFontOfSize:10];
    detailDateLabel.textColor = [UIColor colorWithHex:@"#999999"];
    detailDateLabel.backgroundColor = [UIColor clearColor];
    detailDateLabel.textAlignment = NSTextAlignmentRight;
    [customRightView addSubview:detailDateLabel];
//    [detailDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.width.equalTo(customRightView);
//        make.top.equalTo(dateLabel.mas_bottom).offset(1);
//        make.height.equalTo(@(15));
//    }];
    UIBarButtonItem *mapItem = [[UIBarButtonItem alloc] initWithCustomView:customRightView];
    self.navigationItem.rightBarButtonItem = mapItem;
    
    NSDate *planDate = [[DateEngine sharedDateEngine] dateFromString:self.planDateString];
    dateLabel.text = [[DateEngine sharedDateEngine] stringFromDate:planDate withFormat:@"MM.dd"];
    detailDateLabel.text = [[DateEngine sharedDateEngine] relativeDateStringFromDate:planDate];
    

}

- (void)doRequest {
    [self updateLayout];
    [self selectedSeats];
    self.allSeats = nil;
    self.unavailableSeats = nil;

    [self requestSeat];

}

- (void)updateLayout{
    self.selectPlan = [self.planList objectAtIndex:self.selectPlanTimeRow];

    hallNameLabel.text = [NSString stringWithFormat:@"%@ 银幕", self.selectPlan.screenName];
    if (self.selectPlan.filmInfo.count) {
        Movie *movie = [self.selectPlan.filmInfo objectAtIndex:0];
        screenTypeLabel.text = [NSString stringWithFormat:@"%@  %@", movie.filmType, movie.language];
    }else{
        screenTypeLabel.text = @"";
    }
}

- (void)requestSeat{
    [self resetSelectedSeats];
    self.ticketRecommentView.hidden = NO;

    //新隐藏座位图，获取座位数据后再显示
    self.hallView.hidden = YES;
    self.navigatorView.hidden = YES;
    self.seatIndexView.hidden = YES;
    [[UIConstants sharedDataEngine] loadingAnimation];
    if (self.noSeatAlertView.superview) {
    } else {
        [self showNoSeatAlertView];
    }
//    [SVProgressHUD show];
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.selectPlan.sessionId,@"planId", nil];

    SeatRequest *request = [[SeatRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    [request requestSeatListParams:pagrams success:^(NSArray * _Nullable data) {
        weakSelf.allSeats = data;
        [weakSelf updateHallView];
//        [SVProgressHUD dismiss];
        [[UIConstants sharedDataEngine] stopLoadingAnimation];

    } failure:^(NSError * _Nullable err) {
        if (self.noSeatAlertView.superview) {
        } else {
            [self showNoSeatAlertView];
        }
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
    
}


/**
 *  MARK: 推荐座位
 */
- (void)recommentSeatBtnClick:(UIButton *)button{
    NSInteger seatNum = button.tag-5000;

    if (seatNum==1) {
        BestSeatUtil *util = [[BestSeatUtil alloc] init];
        util.seats = (NSMutableArray *)self.seatsForHallView;
        NSArray * arr = [util findRecommendSeats:1];
        DLog(@"arr == %@", arr);
        for (Seat *seat  in arr) {
            [self.hallView selectSeat:seat];
        }

    }else if (seatNum==2){
        BestSeatUtil *util = [[BestSeatUtil alloc] init];
        util.seats = (NSMutableArray *)self.seatsForHallView;
        NSArray * arr = [util findRecommendSeats:2];
        DLog(@"arr == %@", arr);
        if (arr) {
            [self.hallView selectSeats:arr];
        }
        else {
            [CIASPublicUtility showAlertViewForTitle:@"" message:@"亲，没有合适的座位，换个场次试试吧" cancelButton:@"好的"];
        }

    }else if (seatNum==3){
        BestSeatUtil *util = [[BestSeatUtil alloc] init];
        util.seats = (NSMutableArray *)self.seatsForHallView;
        NSArray * arr = [util findRecommendSeats:3];
        DLog(@"arr == %@", arr);
        if (arr) {
            [self.hallView selectSeats:arr];
        }
        else {
            [CIASPublicUtility showAlertViewForTitle:@"" message:@"亲，没有合适的座位，换个场次试试吧" cancelButton:@"好的"];
        }

//        [BestSeatUtil];
    }else if (seatNum==4){
        BestSeatUtil *util = [[BestSeatUtil alloc] init];
        util.seats = (NSMutableArray *)self.seatsForHallView;
        NSArray * arr = [util findRecommendSeats:4];
        if (arr) {
            [self.hallView selectSeats:arr];
        }
        else {
            [CIASPublicUtility showAlertViewForTitle:@"" message:@"亲，没有合适的座位，换个场次试试吧" cancelButton:@"好的"];
        }
        DLog(@"arr == %@", arr);

    }
}

/**
 *  MARK: 跟新座位图
 */
- (void)updateHallView {
    
    if (self.allSeats.count == 0) {
        return;
    }
    if (self.noSeatAlertView) {
        [self.noSeatAlertView removeFromSuperview];
        self.noSeatAlertView = nil;
    }
    //获取最大 行和列
    NSNumber *numMaxCol = [self.allSeats valueForKeyPath:@"@max.graphCol"];
    NSNumber *numRow = [self.allSeats valueForKeyPath:@"@max.graphRow"];
    int maxCol = [numMaxCol intValue];
    int maxRow = [numRow intValue];
    
    CGFloat padding = 10;
    [self.scrollHallView setZoomScale:1.0];
    
    CGSize hallSize = [self.hallView sizeWithColumnNum:maxCol andRowNum:maxRow];
    CGFloat leftPading = 15;
    self.miniScale = (hallSize.width == 0 ? 1 : MAX(self.scrollHallView.frame.size.width * 1.0 / (hallSize.width + 6 * padding + leftPading),
                                                    self.scrollHallView.frame.size.height * 1.0 / (hallSize.height + 7 * padding)));
    self.hallView.frame = CGRectMake(leftPading, 10, hallSize.width+ 6 * padding , hallSize.height );
    // 计算座位图中间位置
    CGFloat h = hallSize.height;
    CGFloat w = hallSize.width;
    CGFloat H = self.scrollHallView.frame.size.height;
    CGFloat W = self.scrollHallView.frame.size.width;
    CGPoint offset = CGPointMake((w - W + leftPading)/2 , (h - H)/2);
    [self.scrollHallView setContentOffset:offset];
    
    self.hallView.columnNum = maxCol;
    self.hallView.rowNum = maxRow;
    self.hallView.maxSelectedNum = maxSelectedSeatNum;
    
    [self.hallView updateDataSource:self.seatsForHallView];
    
    [self.hallView updateLayout];
    __weak __typeof(self) weakSelf = self;
    [self.hallView getSeatByIdBlock:^Seat *(NSString *seatId) {
        NSPredicate *cinemaIdPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"seatId = '%@'", seatId]];
        NSArray *result = [weakSelf.allSeats filteredArrayUsingPredicate:cinemaIdPredicate];
        if (result.count != 0) {
            return result[0];
        }
        
        return nil;
        
    }];
    self.hallView.backgroundColor = [UIColor clearColor];
    
    self.navigatorView.sourceView = self.hallView;
    self.navigatorView.hidden = NO;
    self.seatIndexView.count = maxRow;
    self.seatIndexView.zoomLevel = self.miniScale;
    self.seatIndexView.aisles = self.hallView.aisle;
    
    self.seatIndexView.rowHeight = self.hallView.seatHeight;
    [self.seatIndexView updateData];
    
    [self startTimer];
    
    self.scrollHallView.maximumZoomScale = 1.0;
    [self.scrollHallView setMinimumZoomScale:self.miniScale];
    [self.scrollHallView setZoomScale:self.miniScale animated:YES];
//    CGRect zoomRect = [self zoomRectForScale:1.0 withCenter:CGPointMake(self.hallView.frame.size.width/2-40, self.hallView.frame.size.height/2-40)];
//    [self.scrollHallView zoomToRect:zoomRect animated:YES];
    
    /*
     [self.scrollHallView setMinimumZoomScale:self.miniScale];
     [self.scrollHallView setZoomScale:self.miniScale animated:YES];
     */
    
    self.hallView.hidden = NO;
    self.navigatorView.hidden = NO;
    self.seatIndexView.hidden = NO;
    
    float widthOffset = self.scrollHallView.frame.size.width - hallSize.width * self.miniScale;
    if (widthOffset > 0) {
        [self.scrollHallView setContentInset:UIEdgeInsetsMake(0, widthOffset / 2.0, 0, 0)];
    }
    
    float heightOffset = self.scrollHallView.frame.size.height - hallSize.height * self.miniScale;
    if (heightOffset > 0) {
        [self.scrollHallView setContentInset:UIEdgeInsetsMake(heightOffset / 2, 0, heightOffset / 2, 0)];
    }
}

- (void)requestAPPConfig{
    AppConfigureRequest *request = [[AppConfigureRequest alloc] init];
    NSDictionary *pagrams = [[NSDictionary alloc] init];
    pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.movieId,@"movieId", nil];
    [request requestQuerySeatIconParams:pagrams success:^(NSDictionary * _Nullable data) {
        NSArray *iconArr = [data kkz_objForKey:@"data"];
        if (iconArr.count > 0) {
            [self downloadSeatSeletedIcon:iconArr];
        }
        
        
    } failure:^(NSError * _Nullable err) {
//        [CIASPublicUtility showAlertViewForTaskInfo:err];
    }];
}


/**
 下载座位选中icon

 @param URLs icon URLs
 */
- (void) downloadSeatSeletedIcon:(NSArray *)URLs
{
    if (URLs.count == 0) {
        return;
    }
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:URLs.count];
    
    SDWebImageManager *imageManager = [SDWebImageManager new];
    __block NSInteger count = 0;
    for (NSString *str in URLs) {
        [imageManager loadImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:str]
                               options:SDWebImageContinueInBackground
                              progress:nil
                             completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                 if (image) {
                                     [images addObject:image];
                                 }
                                 count++;
                                 
                                 if (count == URLs.count) {
                                     self.hallView.seatSeletedIcons = [images copy];
                                 }
                             }];
    }
}


//下单锁座
- (void)confirmOrderClick {
    if (Constants.isAuthorized) {
        if ([self.hallView hasEmtpySeats]) {
            //            [CIASPublicUtility showAlertViewForTitle:@"" message:@"不能留空座位" cancelButton:@"好的"];
            [self.hasEmptySeatView show];
            return;
        }
        if (self.selectedSeats.count<=0) {
            [CIASPublicUtility showAlertViewForTitle:@"" message:@"请选择座位" cancelButton:@"好的"];
            return;
        }
        [self makeOrderLockSeat];
    } else {
        [[DataEngine sharedDataEngine] startLoginWith:YES withFinished:^(BOOL succeeded) {
            if (succeeded) {
                if ([self.hallView hasEmtpySeats]) {
                    //            [CIASPublicUtility showAlertViewForTitle:@"" message:@"不能留空座位" cancelButton:@"好的"];
                    [self.hasEmptySeatView show];
                    return;
                }
                if (self.selectedSeats.count<=0) {
                    [CIASPublicUtility showAlertViewForTitle:@"" message:@"请选择座位" cancelButton:@"好的"];
                    return;
                }
                [self makeOrderLockSeat];
            }
        }];
    }
}

- (void)makeOrderLockSeat{
    //获取网络状态
    //    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus <= 0) {
    ////        [self.view makeToast:@"网络连接错误，请检查网络连接"];
    //        return;
    //    }
    confirmBtn.userInteractionEnabled = NO;
    [[UIConstants sharedDataEngine] loadingAnimation];
    
    //        [SVProgressHUD show];
    OrderRequest *request = [[OrderRequest alloc] init];
    __weak __typeof(self) weakSelf = self;
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:self.cinemaId,@"cinemaId", [self.selectedSeats componentsJoinedByString:@","],@"seatIds",self.selectPlan.sessionId,@"sessionId", [DataEngine sharedDataEngine].userName,@"mobile", nil];
    
    [request requestOrderAddParams:pagrams success:^(NSDictionary * _Nullable data) {
        confirmBtn.userInteractionEnabled = YES;
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        
        DLog(@"plans == %@", data);
        NSDictionary *orderNoDict = [data kkz_objForKey:@"data"];
        NSString *orderNo = (NSString *)[orderNoDict kkz_stringForKey:@"orderCode"];
        Plan *selectPlan = [weakSelf.planList objectAtIndex:weakSelf.selectPlanTimeRow];
        PayViewController *ctr = [[PayViewController alloc] init];
        ctr.aplan = weakSelf.selectPlan;
        ctr.orderNo = orderNo;
        ctr.selectPlanDateString = self.planDateString;
        ctr.planId = selectPlan.sessionId;
        ctr.movieId = weakSelf.movieId;
        ctr.cinemaId = weakSelf.cinemaId;
        ctr.movieName = weakSelf.movieName;
        ctr.cinemaName = weakSelf.cinemaName;

        ctr.planList = weakSelf.planList;
        ctr.selectPlanDate = weakSelf.selectPlanDate;
        ctr.selectPlanTimeRow = weakSelf.selectPlanTimeRow;
        [weakSelf.navigationController pushViewController:ctr animated:YES];
        
    } failure:^(NSError * _Nullable err) {
        confirmBtn.userInteractionEnabled = YES;
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        NSString *orderNo = @"";
        if (err.code == 70006) {
            orderNo = [err.userInfo kkz_objForKey:@"kkz.error.message"];
            if (orderNo.length<=0) {
                NSDictionary *responseDict = [err.userInfo kkz_objForKey:@"kkz.error.response"];
                orderNo = [responseDict kkz_objForKey:@"error"];
            }

//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
//                                                                   style:UIAlertActionStyleCancel
//                                                                 handler:^(UIAlertAction *_Nonnull action){
//                                                                 }];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"我知道了"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *_Nonnull action) {
                                                                   [self deleteOrder:orderNo];
                                                               }];
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"为充分利用座位资源，影院系统已将您未支付的订单取消" preferredStyle:UIAlertControllerStyleAlert];
//            [alertVC addAction:cancelAction];
            [alertVC addAction:sureAction];
            
            [self presentViewController:alertVC
                               animated:YES
                             completion:^{
                             }];
            
        } else if (err.code == 40005) {
//            用户验证失败,请从新登录
            //加载虚化浮层,这个浮层可以共用
            [Constants.appDelegate signout];

            [Constants.appDelegate loginIn];
        } else {
            [CIASPublicUtility showAlertViewForTaskInfo:err];
        }
    }];

}

- (void)deleteOrder:(NSString *)orderNo{
    [[UIConstants sharedDataEngine] loadingAnimation];
    
    OrderRequest *request = [[OrderRequest alloc] init];
    NSDictionary *pagrams = [NSDictionary dictionaryWithObjectsAndKeys:orderNo,@"orderCode", ciasTenantId,@"tenantId", nil];
    
    [request requestCancelOrderParams:pagrams success:^(id _Nullable data) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [self makeOrderLockSeat];
    } failure:^(NSError * _Nullable err) {
        [[UIConstants sharedDataEngine] stopLoadingAnimation];
        [CIASPublicUtility showAlertViewForTaskInfo:err];
        
    }];
    
}



#pragma mark UIScrollViewDelegate methods

/**
 *  MARK: 设置缩略图timer
 */
- (void) startTimer
{
    if ([self.timerForNavigator isValid]) {
        return;
    }
    
    if (self.timerForNavigator == nil) {
        self.timerForNavigator = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
    }
    
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:self.timerForNavigator forMode:NSDefaultRunLoopMode];
    self.timerFlag = YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.hallView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    self.navigatorView.hidden = NO;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    self.timerFlag = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        return;
    }
    CGRect visibleRect2 = CGRectIntersection(scrollView.bounds, self.hallView.frame);
    [self.navigatorView updateVisibleRect:visibleRect2 scale:scrollView.zoomScale];
    
    [self.seatIndexView updatePosition:scrollView.contentOffset scale:scrollView.zoomScale];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        return;
    }

    //show navigator
    self.navigatorView.hidden = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([scrollView isKindOfClass:[UICollectionView class]]) {
        return;
    }

    self.timerFlag = YES;
}

- (NSString *)printableSeat:(NSString *)seatId row:(NSString *)row col:(NSString *)col {
    if (row && col) {
        return [NSString stringWithFormat:@"%@_%@|%@", row, col, seatId];
    }
    return nil;
}


- (CGRect)zoomRectForHallViewScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self.scrollHallView frame].size.height / scale;
    zoomRect.size.width = [self.scrollHallView frame].size.width / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x;
    zoomRect.origin.y = center.y;
    
    return zoomRect;
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self.scrollHallView frame].size.height / scale;
    zoomRect.size.width = [self.scrollHallView frame].size.width / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)timerHandler {
    static NSInteger count = 1;
    if (self.timerFlag == YES) {
        count = K_COUNT_FOR_NAVIGATORY_HIDE;
    }
    
    if (count < 0) {
        count = 0;
    }
    if (count == 0 && self.navigatorView.hidden == NO && self.scrollHallView.isZooming == NO) {
        self.navigatorView.hidden = YES;
    }
    self.timerFlag = NO;
    
    count--;
}


#pragma mark hall view delegate
- (void)selectSeatAtColumn:(NSString *)col row:(NSString *)row withId:(NSString *)seatId {
    // holder.frame = CGRectMake(0, 95, 320, 266);
    //如果座位已在selectedSeats，不操作
    if ([self.selectedSeats containsObject:seatId]) {
        return;
    }
    [self.selectedSeats addObject:seatId];
    NSString *seatDesc = [self printableSeat:seatId row:row col:col];
    if (seatDesc) {
        [self.printableSelectedSeats addObject:seatDesc];
    }
    DLog(@"%@ - %@", self.selectedSeats, self.printableSelectedSeats);
    
    //座位按钮
    UIButton *seatInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    seatInfoButton.backgroundColor = [UIColor colorWithHex:@"#f1f4f4"];
    seatInfoButton.layer.cornerRadius = 2.5;
    seatInfoButton.layer.borderWidth = 0.5;
    seatInfoButton.layer.borderColor = [UIColor colorWithHex:@"#e0e0e0"].CGColor;
    seatInfoButton.tag = [self.selectedSeats count] + K_TAG_TICKET_SET_BASE;
    seatInfoButton.frame = CGRectMake(15 + (65 + 5) * ([self.selectedSeats count] - 1), 10, 65, 30);
    seatInfoButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [seatInfoButton setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
    seatInfoButton.alpha = 1;
//    seatInfoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    [seatInfoButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [seatInfoButton setTitle:[NSString stringWithFormat:@"%@排%@座", row, col] forState:UIControlStateNormal];
//    [seatInfoButton setBackgroundImage:[UIImage imageNamed:@"seatInfo_deselect_button"] forState:UIControlStateNormal];
    [seatInfoButton addTarget:self action:@selector(ticketClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.ticketView addSubview:seatInfoButton];
//    [UIView animateWithDuration:.3
//                     animations:^{
//                         seatInfoButton.alpha = 1;
//                     }];
    if (self.selectedSeats.count > 0) {
        self.ticketRecommentView.hidden = YES;
        self.ticketView.hidden = NO;
    }
    
    self.timerFlag = YES;
}

- (void)deselectSeatAtColumn:(NSString *)col row:(NSString *)row withId:(NSString *)seatId {
    NSInteger deselectIndex = [self.selectedSeats indexOfObject:seatId];
    
    [self removeTicketAt:deselectIndex];
    
    NSString *seatDesc = [self printableSeat:seatId row:row col:col];
    if (seatDesc) {
        [self.printableSelectedSeats removeObject:seatDesc];
    }
    
    if ([self.selectedSeats count] == 0) {
        [self.scrollHallView setZoomScale:self.miniScale animated:YES];
    }
    if (self.selectedSeats.count <= 0) {
        self.ticketView.hidden = YES;
        self.ticketRecommentView.hidden = NO;
    }
}

- (void)selectNumReachMax {
    [CIASPublicUtility showAlertViewForTitle:@"" message:[NSString stringWithFormat:@"最多可选%d个座位", maxSelectedSeatNum] cancelButton:@"知道了"];
//    if (self.didGetCanBuyCnt == NO) {
//        [self.view makeToast:K_TOAST_CAN_BY_CNT_NOT_REQUEST];
//        return;
//    }
//    
//    if ([CPUserCenter shareInstance].remainCardCount == 1) {
//        [UIAlertView showWithTitle:@""
//                           message:@"哎呀，剩余次数不够啦~"
//                 cancelButtonTitle:@"知道啦"
//                 otherButtonTitles:nil
//                          tapBlock:nil];
//        return;
//    }
//    
//    if (self.canBuyCnt == 0 && self.seatErrorMsg.length > 0) {
//        [self.view makeToast:self.seatErrorMsg];
//    } else {
//        [self.view makeToast:[NSString stringWithFormat:@"最多可选%@个座位", @(self.canBuyCnt)]];
//    }
}

- (void)touchAt:(CGPoint)point didChangeSteatStatus:(BOOL)changeStatus {
    CGFloat scale = self.scrollHallView.zoomScale;
    //当修改了座位数，当前缩放不是最大时，设置缩放为最大
    if ([self.selectedSeats count] > 0 && changeStatus && scale != K_MAX_HALL_SCALL) {
        float newScale = K_MAX_HALL_SCALL;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:point];
        [self.scrollHallView zoomToRect:zoomRect animated:YES];
    }
}

/**
 代理：座位是否可被选
*/
//- (BOOL)shouldSelectSeats:(NSArray *)seats
//    return YES;
//}

/**
 *  MARK: 移除ticketView中的票
 *
 *  @param index index
 */
- (void)removeTicketAt:(NSInteger)index {
    if (index > self.selectedSeats.count) {
        return;
    }
    UIButton *seatInfoButton = (UIButton *) [self.ticketView viewWithTag:index + K_TAG_TICKET_GET_BASE];
    [seatInfoButton removeFromSuperview];
    
    [self.selectedSeats removeObjectAtIndex:index];
    
    for (NSInteger i = index + 1; i < self.selectedSeats.count + 1; i++) {
        UIView *view = [self.ticketView viewWithTag:(i + K_TAG_TICKET_GET_BASE)];
        view.tag = i - 1 + K_TAG_TICKET_GET_BASE;
    }
    
    for (NSInteger i = 0; i < [self.selectedSeats count]; i++) {
        UIButton *waitMoveButton = (UIButton *) [self.ticketView viewWithTag:(i + K_TAG_TICKET_GET_BASE)];
        [UIView animateWithDuration:.5
                         animations:^{
                             waitMoveButton.frame = CGRectMake(15 + (65 + 5) * i, 10, 65, 30);
                             
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
}


/**
 *  MARK: 座位按钮 点击
 *
 *  @param selector selector
 */
- (void)ticketClick:(id)selector {
    UIButton *btn = (UIButton *) selector;
    for (int i = 0; i < [self.selectedSeats count]; i++) {
        if (i + K_TAG_TICKET_GET_BASE == btn.tag) {
            NSString *seatID = [self.selectedSeats objectAtIndex:i];
            
            [self.hallView deselectSeatWithSeatId:seatID];
            
            Seat *seat = [self findSeatBy:seatID];
            if (seat && (seat.seatState == SeatStateLoverL || seat.seatState == SeatStateLoverR) && self.selectedSeats.count > 0) {
                NSString *seatLoverID = nil;
                if (seat.seatState == SeatStateLoverL) {
                    seatLoverID = [self.selectedSeats objectAtIndex:i];
                }else{
                    seatLoverID = [self.selectedSeats objectAtIndex:i-1];
                }
                [self.hallView deselectSeatWithSeatId:seatLoverID];
            }
        }
    }
}

/**
 *  MARK: 根据seatID找seat
 *
 *  @param seatID seat id
 *
 *  @return seat
 */
- (Seat *)findSeatBy:(NSString *)seatID {
    if (seatID.length == 0) {
        return nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"seatId = %@", seatID];
    NSArray *resault = [self.allSeats filteredArrayUsingPredicate:predicate];
    if (resault.count > 0) {
        Seat *seat = resault.firstObject;
        return seat;
    }
    
    return nil;
}



#pragma mark - Get
- (NSMutableArray *)selectedSeats {
    if (_selectedSeats == nil) {
        _selectedSeats = [NSMutableArray array];
    }
    return _selectedSeats;
}

/**
 *  get选中座位的id
 *
 *  @return 选中座位的id
 */
- (NSString *)selectedSeatIds {
    return [self.selectedSeats componentsJoinedByString:@","];
}

- (NSString *)selectedSeatInfos {
    NSMutableArray *finalSeatInfo = [[NSMutableArray alloc] init];
    for (NSString *seat in self.printableSelectedSeats) {
        NSArray *seatInfo = [seat componentsSeparatedByString:@"|"];
        if ([seatInfo count])
            [finalSeatInfo addObject:[seatInfo objectAtIndex:0]];
    }
    NSString *final = [finalSeatInfo componentsJoinedByString:@","];
    return final;
}

- (NSString *)selectedSeatDesc {
    NSString *raw = [self selectedSeatInfos];
    NSString *readable = [raw stringByReplacingOccurrencesOfString:@"_" withString:@"排"];
    readable = [readable stringByReplacingOccurrencesOfString:@"," withString:@"座, "];
    if (![raw isEqualToString:@""]) {
        readable = [NSString stringWithFormat:@"%@座", readable];
    }
    return readable;
}

/**
 *  MARK: 重置选中座位
 */
- (void)resetSelectedSeats {
    [self deselectAllButton];
    
    //删除全部的ticket
    for (UIView *subView in self.ticketView.subviews) {
        if (subView.tag>=K_TAG_TICKET_SET_BASE) {
            [subView removeFromSuperview];
        }
    }
    self.ticketView.hidden = YES;
    [self.selectedSeats removeAllObjects];
    [self.printableSelectedSeats removeAllObjects];
}

- (void)deselectAllButton {
    DLog(@"selectedSeats %@", self.selectedSeats);
}

#pragma mark - Set

- (void)setAllSeats:(NSArray *)allSeats {
    if (_allSeats != allSeats) {
        _allSeats = allSeats;
        self.seatsForHallView = [_allSeats arrayByAddingObjectsFromArray:self.unavailableSeats];
    }
}

- (void)setUnavailableSeats:(NSArray *)unavailableSeats {
    if (_unavailableSeats != unavailableSeats) {
        _unavailableSeats = unavailableSeats;
        self.seatsForHallView = [_allSeats arrayByAddingObjectsFromArray:self.unavailableSeats];
    }
}



#pragma mark --UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio{
    return self.planList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    //    if (collectionView==incomingDateCollectionView) {
    //        return 1;
    //    }
    return 1;
}

//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 15, 15, 0);

}

//定义每个UICollectionView 纵向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 7.5;
}
//定义每个UICollectionView 横向的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 15;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    return CGSizeMake(63, 55);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"PlanTimeCollectionViewCell";
    PlanTimeCollectionViewCell *cell = (PlanTimeCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建PlanTimeCollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    Plan *plan = [self.planList objectAtIndex:indexPath.row];
    cell.selectPlan = plan;
    if (indexPath.row == self.selectPlanTimeRow) {
        cell.isSelect = YES;
    }else{
        cell.isSelect = NO;
    }

    //        Movie *movie = [self.movieList objectAtIndex:indexPath.row];
    //        cell.movieName = movie.filmName;
    //        cell.imageUrl = movie.filmPoster;
    //        cell.point = movie.point;
    //        cell.availableScreenType = movie.availableScreenType;
    [cell updateLayout];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Plan *plan = [self.planList objectAtIndex:indexPath.row];
    if ([plan.isSale isEqualToString:@"1"]) {
            NSComparisonResult result; //是否过期
            int lockTime = [klockTime intValue];
            NSDate *lateDate = [[NSDate date] dateByAddingTimeInterval:lockTime*60];
            NSDate *startTimeDate = [[DateEngine sharedDateEngine] dateFromString:plan.startTime];
            result= [startTimeDate compare:lateDate];
            if (result == NSOrderedDescending) {
        
            }else{
                [CIASPublicUtility showAlertViewForTitle:@"" message:[NSString stringWithFormat:@"请在开场前%d分钟购票", lockTime] cancelButton:@"确定"];
                return;
            }
        self.selectPlanTimeRow = indexPath.row;
        
        [self updateLayout];
        [self requestSeat];
        [collectionView reloadData];
    }else{
        
    }

}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}


- (HasEmptySeatView *)hasEmptySeatView {
    if (!_hasEmptySeatView) {
        _hasEmptySeatView = [[HasEmptySeatView alloc] initWithFrame:CGRectMake((kCommonScreenWidth-171)/2, (kCommonScreenHeight-140)/2, 171, 140)];
    }
    return _hasEmptySeatView;
}

/*
 [self.selectSeatIconDict addEntriesFromDictionary:userInfo];
 NSArray *keys = [self.selectSeatIconDict allKeys];
 if (keys.count) {
 for (NSString *key in keys) {
 if ([key isEqualToString:self.movieId]) {
 NSArray *values = [self.selectSeatIconDict objectForKey:key];
 [self downloadSeatSeletedIcon:values];
 return;
 }
 
 }
 }
 */


@end
