//
//  ChooseSeatViewController.m
//  Cinephile
//
//  Created by Albert on 7/13/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import "ChooseSeatViewController.h"
#import "UIConstants.h"
#import <HallView_KKZ/HallView.h>
#import "CinemaRequest.h"
#import <HallView_KKZ/Seat.h>
#import "Movie.h"
#import "Cinema.h"
#import "Order.h"

#import <HallView_KKZ/CPNavigatorView.h>
#import "UIButton+BackgroundColor.h"
#import "CPSeatIndexView.h"
#import <HallView_KKZ/SeatHelper.h>
#import "Ticket.h"
#import "OrderRequest.h"
#import <Category_KKZ/NSStringExtra.h>

#import "SwitchPlanView.h"
#import "SwitchPlanDelegate.h"
#import "Constants.h"
#import <DateEngine_KKZ/DateEngine.h>
#import "Constants.h"
#import "PlanRequest.h"
#import "PayViewController.h"
#import "KKZHintView.h"

#import "AFNetworkReachabilityManager.h"



const NSInteger K_TAG_TICKET_SET_BASE = 1000;
const NSInteger K_TAG_TICKET_GET_BASE = 1001;

//最多可选座位数
const int K_MAX_SELECTED_SEAT = 4;

#define K_COUNT_FOR_NAVIGATORY_HIDE 3 //3秒后缩略图消失

//最大缩放
#define K_MAX_HALL_SCALL 1.0

//当可选座位个数还未请求回来时，如进行选择座位操作，提示
#define K_TOAST_CAN_BY_CNT_NOT_REQUEST @"正在查询座位图的售卖情况，请稍后重试"
#define navBackgroundColor appDelegate.kkzBlue

@interface ChooseSeatViewController()<UIScrollViewDelegate, HallViewDelegate>
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *switchSessionBtn;

/**
 座位图
 */
@property (nonatomic, strong) HallView *hallView;
@property (nonatomic, strong) UILabel *hallLabel;

/**
 座位图 scrollView
 */
@property (nonatomic, strong) UIScrollView *scrollHallView;
/**
 *  提示信息框
 */
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UILabel *tipLabel;

/**
 确认订单按钮
 */
@property (nonatomic, strong) UIButton *btnCheckOrder;

@property (nonatomic, strong) NSMutableArray *selectedSeats;
@property (nonatomic, strong) NSMutableArray *printableSelectedSeats;
/**
 *  全部的座位
 */
@property (nonatomic, strong) NSArray *allSeats;
/**
 *  不可选的座位
 */
@property (nonatomic, strong) NSArray *unavailableSeats;
/**
 *  HallView渲染用的座位(allSeats + unavailableSeats)注意，unavailableSeats要在allSeats后面
 */
@property (nonatomic, strong) NSArray *seatsForHallView;
@property (nonatomic) CGFloat miniScale;

/**
 缩略图
 */
@property (nonatomic, strong) CPNavigatorView *navigatorView;

/**
 底部 影票信息
 */
@property (nonatomic, strong) UIView *ticketView;
@property (nonatomic, strong) NSTimer *timerForNavigator;
/**
 *  缩略图timer Yes:重置开始计时 No:正常倒计时
 *  拖拽、zoom、点击座位时，set YES
 */
@property (nonatomic) BOOL timerFlag;
@property (nonatomic, strong) CPSeatIndexView *seatIndexView;
/**
 *  可选座位数
 */
@property (nonatomic) int canBuyCnt;
/**
 *  不可选座提示信息
 */
@property (nonatomic, copy) NSString *seatErrorMsg;


@property (nonatomic, assign) AFNetworkReachabilityStatus cPReachabilityStatus;

/**
 切换排期视图
 */
@property (nonatomic, strong) SwitchPlanView *switchPlanView;
@property (nonatomic, strong) SwitchPlanDelegate *switchPlanDelegate;

@end

@implementation ChooseSeatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHex:@"#e5e5e5"];
    
    self.printableSelectedSeats = [[NSMutableArray alloc] initWithCapacity:0];
    
    UIView *movieContainer = [UIView new];
    movieContainer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:movieContainer];
    [movieContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@64);
        make.left.right.equalTo(@0);
        make.height.equalTo(@65);
    }];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.font = [UIFont systemFontOfSize:16];
    [movieContainer addSubview:self.nameLabel];
    
    self.infoLabel = [UILabel new];
    self.infoLabel.textColor = [UIColor colorWithHex:@"#666666"];
    self.infoLabel.font = [UIFont systemFontOfSize:12];
    [movieContainer addSubview:self.infoLabel];
    
    self.switchSessionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.switchSessionBtn setTitle:@"换场次" forState:UIControlStateNormal];
    [self.switchSessionBtn setTitleColor:[UIColor colorWithHex:@"#666666"] forState:UIControlStateNormal];
    self.switchSessionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.switchSessionBtn.layer.borderColor = [UIColor colorWithHex:@"#bdbdbd"].CGColor;
    self.switchSessionBtn.layer.borderWidth = K_ONE_PIXEL;
    self.switchSessionBtn.layer.cornerRadius = 25.0/2;
    [self.switchSessionBtn addTarget:self action:@selector(switchClick) forControlEvents:UIControlEventTouchUpInside];
    [movieContainer addSubview:self.switchSessionBtn];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@15);
        make.right.equalTo(movieContainer.mas_right).offset(-60);
    }];
    
    
    [self.switchSessionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(movieContainer.mas_right).offset(-15);
        make.width.equalTo(@60);
        make.height.equalTo(@25);
        make.top.equalTo(movieContainer.mas_top).offset(20);
    }];
    
    UIView *tipContainer = [UIView new];
    tipContainer.backgroundColor = [UIColor colorWithHex:@"0xfffade"];
    
    [self.view addSubview:tipContainer];

    self.tipView = tipContainer;
    
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.bottom.equalTo(tipContainer.mas_top).offset(-15);
    }];
    
    CGFloat tipFont = 12;
    UILabel *tipLabel = [UILabel new];
    tipLabel.numberOfLines = 10;
    tipLabel.font = [UIFont systemFontOfSize:tipFont];
    tipLabel.textColor = [UIColor colorWithHex:@"#977D46"];
    [tipContainer addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@13);
        make.right.equalTo(tipContainer.mas_right).offset(-13);
        make.centerY.equalTo(tipContainer);
    }];
    self.tipLabel = tipLabel;
    
    [tipContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(tipLabel.mas_bottom);
        make.top.equalTo(movieContainer.mas_bottom);
    }];
    
    
    self.scrollHallView = [UIScrollView new];
    self.scrollHallView.alwaysBounceHorizontal = NO;
    self.scrollHallView.alwaysBounceVertical = NO;
    self.scrollHallView.delegate = self;
    self.scrollHallView.bouncesZoom = YES;
    self.scrollHallView.backgroundColor = [UIColor colorWithHex:@"#e5e5e5"];
    [self.view addSubview:self.scrollHallView];
    [self.scrollHallView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(tipContainer.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom).offset(-80);
    }];
    
    self.hallView = [[HallView alloc]init];
    [self.scrollHallView addSubview:self.hallView];
    
    self.seatIndexView = [CPSeatIndexView new];
    [self.view addSubview:self.seatIndexView];
    [self.seatIndexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@4);
        make.top.equalTo(self.scrollHallView.mas_top);
        make.height.equalTo(self.scrollHallView.mas_height);
        make.width.equalTo(@10);
    }];
    
    
    self.hallLabel = [UILabel new];
    self.hallView.delegate  = self;
    self.hallView.space = 4;
    self.hallLabel.font = [UIFont systemFontOfSize:10];
    self.hallLabel.textColor = [UIColor colorWithHex:@"#333333"];
    __weak __typeof(self) weakSelf = self;
    [self.hallView setUpdateDrawCallBack:^{
        //update draw rect callback
        [weakSelf.navigatorView update];
    }];
    [self.view addSubview:self.hallLabel];
    [self.hallLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(tipContainer.mas_bottom).insets(UIEdgeInsetsMake(5, 0, 0, 0));
    }];
    
    UIImageView *hallNameBg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hall_bg"]];
    [self.view insertSubview:hallNameBg belowSubview:self.hallLabel];
    [hallNameBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipContainer.mas_bottom);
        make.centerX.equalTo(self.view);
    }];
    
    self.navigatorView = [CPNavigatorView new];
    self.navigatorView.hidden = YES;
    [self.view addSubview:self.navigatorView];
    [self.navigatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@26);
        make.width.equalTo(@121);
        make.height.equalTo(@49);
        make.top.equalTo(tipContainer.mas_bottom).offset(33);
    }];
    
   
    //底部座位说明
    UIFont *font = [UIFont systemFontOfSize:12];
    
    UIButton *recommendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [recommendBtn setTitleColor:[UIColor colorWithHex:@"ff6000"] forState:UIControlStateNormal];
    [recommendBtn setTitle:@"推荐座位" forState:UIControlStateNormal];
    recommendBtn.titleLabel.font = font;
    [recommendBtn addTarget:self action:@selector(getRecommendSeats) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recommendBtn];
    
    UIImageView *iconEnable = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"seat_enable"]];
    [self.view addSubview:iconEnable];
    
    
    UILabel *labelEnable = [UILabel new];
    labelEnable.text = @"可选";
    labelEnable.font = font;
    [self.view addSubview:labelEnable];
    
    UIImageView *iconSold = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"seat_sold_icon"]];
    [self.view addSubview:iconSold];
    
    UILabel *labelSold = [UILabel new];
    labelSold.text = @"已售";
    labelSold.font = font;
    [self.view addSubview:labelSold];
    
    UIImageView *iconLover = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"seat_lover_icon"]];
    [self.view addSubview:iconLover];
    
    UILabel *labelLover = [UILabel new];
    labelLover.text = @"情侣座";
    labelLover.font = font;
    [self.view addSubview:labelLover];
    
    UIImageView *iconChoose = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"seat_selected_icon"]];
    [self.view addSubview:iconChoose];
    
    UILabel *labelChoose = [UILabel new];
    labelChoose.text = @"已选";
    labelChoose.font = font;
    [self.view addSubview:labelChoose];
    
    
    CGFloat itemSpace = 10;
    CGFloat groupSpace = 4;
    
    [iconEnable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(itemSpace));
        make.bottom.equalTo(self.view.mas_bottom).insets(UIEdgeInsetsMake(0, 0, 43, 0));
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
    
    [iconLover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelSold.mas_right).offset(itemSpace);
        make.bottom.equalTo(iconEnable.mas_bottom);
    }];
    
    [labelLover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconLover.mas_right).offset(groupSpace);
        make.bottom.equalTo(iconEnable.mas_bottom);
    }];
    
    
    [iconChoose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(labelLover.mas_right).offset(itemSpace);
        make.bottom.equalTo(iconEnable.mas_bottom);
    }];
    
    [labelChoose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconChoose.mas_right).offset(groupSpace);
        make.bottom.equalTo(iconEnable.mas_bottom);
    }];
    
    [recommendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-itemSpace);
        make.bottom.equalTo(self.view.mas_bottom).offset(-37);
    }];
    
    self.ticketView = [UIView new];
    self.ticketView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.ticketView];
    [self.ticketView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@86);
    }];
    self.ticketView.hidden = YES;
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确认订单" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmOrderClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setBackgroundColor:[UIColor colorWithHex:@"0xff6901"] forState:UIControlStateNormal];
    self.btnCheckOrder = confirmBtn;
    [self.ticketView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@43);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.ticketView.mas_bottom);
    }];
    
    self.canBuyCnt = K_MAX_SELECTED_SEAT;
    
    [self settingNavView];
    
    //plan为nil，根据planID请求plan
    if (self.plan == nil) {
       [self requestPlanDetail];
    }else{
        self.title = self.plan.cinema.cinemaName;
        self.kkzTitleLabel.text = self.plan.cinema.cinemaName;
        self.planId = self.plan.planId;
        [self doRequest];
    }
    
    //创建网络监听管理者对象 开始监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startTimer];
    
    KKZAnalyticsEvent *event = [KKZAnalyticsEvent new];
    event.movie_id = self.plan.movieId.stringValue;
    event.movie_name = self.plan.movie.movieName;
    event.cinema_id = self.plan.cinema.cinemaId.stringValue;
    event.cinema_name = self.plan.cinema.cinemaName;
    event.hall_id = self.plan.hallNo;
    event.hall_name = self.plan.hallName;
    event.featur_name = [[DateEngine sharedDateEngine] stringFromDate:self.plan.movieTime];
    [KKZAnalytics postActionWithEvent:event action:AnalyticsActionChoose_seat];
    
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //关闭网络监听
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    [appDelegate hideIndicator];
    [self.timerForNavigator invalidate];
}

/**
 *  请求plan
 */
-(void)requestPlanDetail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
    [params setValue:self.planId forKey:@"plan_id"];
    PlanRequest *planRequest = [[PlanRequest alloc] init];
    
    [planRequest requestPlanDetail:self.planId.stringValue success:^(Ticket * _Nullable plan) {
        self.plan = plan;
        self.title = self.plan.cinema.cinemaName;
        self.kkzTitleLabel.text = self.plan.cinema.cinemaName;
        [self doRequest];
    } failure:^(NSError * _Nullable err) {
        DLog(@"排期详情请求失败%@",err);
    }];
    
}

- (void) doRequest
{
    [self setContent];
    
    //清除之前的座位数据（避免切换场次时用到之前数据）
    self.allSeats = nil;
    self.unavailableSeats = nil;
    
    [self requestSeat];
    
    [self requestUnavalaibleSeats];
}

- (void) dealloc
{
    
}

/**
 *  MARK: 设置信息
 */
- (void) setContent
{
    self.hallLabel.text = [NSString stringWithFormat:@"%@银幕",self.plan.hallName];
    self.nameLabel.text = self.plan.movie.movieName;
    self.infoLabel.text = [NSString stringWithFormat:@"%@（%@ %@）",[[DateEngine sharedDateEngine] dateWeekTimeStringFromDate:self.plan.movieTime],self.plan.screenType,self.plan.language];
}

/**
 *  MARK: 处理提示信息
 *
 *  @param message 信息
 */
- (void) handleMessage:(NSString *)message
{
    if (message.length != 0) {
        self.tipLabel.text = message;
        [self.tipView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.tipLabel.mas_bottom).offset(7);
        }];
    }
    
}

/**
 *  MARK: 请求座位
 */
- (void) requestSeat
{
    
    [appDelegate showIndicatorWithTitle:@"获取座位中"
                               animated:YES
                             fullScreen:NO
                           overKeyboard:YES
                            andAutoHide:NO];
    
    PlanRequest *request = [PlanRequest new];
    
    self.hallView.hidden = YES;
    self.navigatorView.hidden = YES;
    self.seatIndexView.hidden = YES;
    
    [request requestCinemaSeat:self.plan.cinema.cinemaId
                        planId:self.plan.planId
                        hallId:self.plan.hallNo
                       success:^(NSArray * _Nullable seats, NSString * _Nullable notice) {
                           
                           self.allSeats = seats;
                           [self handleMessage:notice];
                           
                           [self updateHallView];
                           
                           [appDelegate hideIndicator];
                           
                       } failure:^(NSError * _Nullable err) {
                           DLog(@"request seat error: %@",err);
                           
                           //网络错误提示
                           if (err.code == KKZ_REQUEST_STATUS_NETWORK_ERROR) {
                               
                               return ;
                           }
                           NSString *messsage = [err.userInfo objectForKey:KKZRequestErrorMessageKey];
                           if (messsage.length > 0) {
                               [appDelegate showAlertViewForTitle:nil message:messsage cancelButton:@"确定"];
                           }
                       }];
    
}
/**
 *  MARK: 请求不可用座位
 */
- (void) requestUnavalaibleSeats
{
    PlanRequest *request = [PlanRequest new];
    
    [request requestCinemaUnavailableSeat:self.plan.planId success:^(NSArray * _Nullable seats) {
        DLog(@"unavailable %@",seats);
        self.unavailableSeats = seats;

        if (seats.count > 0) {
            [self resetSelectedSeats];
        }
        [self updateHallView];
    
    } failure:^(NSError * _Nullable err) {
        DLog(@"unavailable failure %@",err);
        //网络错误提示
        if (err.code == KKZ_REQUEST_STATUS_NETWORK_ERROR) {

            return ;
        }
        NSString *messsage = [err.userInfo objectForKey:KKZRequestErrorMessageKey];
        if (messsage.length > 0) {
            
        }
    }];
}

/**
 *  MARK: 重置选中座位
 */
- (void)resetSelectedSeats {
    
    //删除全部的ticket
    for (UIView *subView in self.ticketView.subviews) {
        if (subView.tag >= K_TAG_TICKET_SET_BASE) {
            [subView removeFromSuperview];
        }
    }
    
    self.ticketView.hidden = YES;
    
    [self.selectedSeats removeAllObjects];
    [self.printableSelectedSeats removeAllObjects];
    
    [self updateHallView];
}
/**
 *  MARK: 跟新座位图
 */
- (void) updateHallView
{
    
    if (self.allSeats.count == 0) {
        return;
    }
    
    //获取最大 行和列
    NSNumber *numMaxCol = [self.allSeats valueForKeyPath:@"@max.graphCol"];
    NSNumber *numRow = [self.allSeats valueForKeyPath:@"@max.graphRow"];
    int maxCol = [numMaxCol intValue];
    int maxRow = [numRow intValue];
    
    CGSize hallSize = [self.hallView sizeWithColumnNum:maxCol andRowNum:maxRow];
    CGFloat padding = 10;
    
    self.miniScale = ( hallSize.width == 0? 1: MIN(self.scrollHallView.frame.size.width*1.0/(hallSize.width + 6 * padding) ,
                                                      self.scrollHallView.frame.size.height*1.0/ (hallSize.height + 6 * padding)));
    [self.scrollHallView setZoomScale:1.0 animated:YES];
    self.scrollHallView.contentSize = CGSizeMake(hallSize.width + 2 * padding, hallSize.height + 2 * padding);
    self.hallView.frame = CGRectMake(20, 10, hallSize.width + 7 * padding, hallSize.height + 7 * padding);
    self.hallView.columnNum = maxCol;
    self.hallView.rowNum = maxRow;
    self.hallView.maxSelectedNum = self.canBuyCnt;
    
    [self.hallView updateDataSource:self.seatsForHallView];
    
    [self.hallView updateLayout];
    __weak __typeof(self)weakSelf = self;
    [self.hallView getSeatByIdBlock:^Seat *(NSString *seatId) {
        NSPredicate *cinemaIdPredicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"seatId = '%@'",seatId]];
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
    
    self.hallView.hidden = NO;
    self.navigatorView.hidden = NO;
    self.seatIndexView.hidden = NO;
    
    float widthOffset = self.scrollHallView.frame.size.width - hallSize.width * self.miniScale;
    if (widthOffset > 0) {
        [self.scrollHallView setContentInset:UIEdgeInsetsMake(0, widthOffset/2.0, 0, 0)];
    }
    
    float heightOffset = self.scrollHallView.frame.size.height - hallSize.height * self.miniScale;
    if (heightOffset > 0) {
        [self.scrollHallView setContentInset:UIEdgeInsetsMake(heightOffset/2, 0, heightOffset/2, 0)];
    }
}
/**
 *  MARK: 推荐座位
 */
- (void) getRecommendSeats
{
    if (self.canBuyCnt == 0) {
        //可选座位为0
        if (self.seatErrorMsg) {
            
        }
        return;
    }
    NSArray *availableSeats = [SeatHelper availableSeatsWithAllSeats:self.allSeats unavailableSeats:self.unavailableSeats];
    
    if (self.canBuyCnt == 1) {
        Seat *seat = [SeatHelper getOneSeatsFrom:availableSeats maxGraphRow:self.hallView.rowNum maxGraphCol:self.hallView.columnNum];
        [self.hallView selectSeat:seat];
    }else{
        NSArray *recommendSeats = [SeatHelper getTowSeatsFrom:availableSeats maxGraphRow:self.hallView.rowNum maxGraphCol:self.hallView.columnNum];
        if (recommendSeats) {
            [self.hallView selectSeats:recommendSeats];
        }
    }
    
}
/**
 *  MARK: 切换影院
 */
- (void) switchClick
{
    if (self.switchPlanView == nil) {
        self.switchPlanView = [SwitchPlanView new];
        self.switchPlanDelegate = [[SwitchPlanDelegate alloc] init];
        self.switchPlanView.title = @"切换场次";
    }
    __weak __typeof(self)weakSelf = self;
    self.switchPlanDelegate .planList = self.planArray;
    self.switchPlanDelegate .currentPlan = self.plan;
    [self.switchPlanDelegate  switchToPlan:^(Ticket *plan) {
        weakSelf.plan = plan;
        [weakSelf doRequest];
        [weakSelf.switchPlanView dismiss];
        
        [weakSelf resetSelectedSeats];
    }];
    
    __weak SwitchPlanView *weakSwitch = self.switchPlanView;
    
    [self.switchPlanView dismissCallback:^{
        [weakSwitch dismiss];
    }];
    
    self.switchPlanView.delegate = self.switchPlanDelegate;
    self.switchPlanView.dataSource = self.switchPlanDelegate;
    [self.switchPlanView updateData];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    [self.switchPlanView showInView:window];

}
#pragma mark UIScrollViewDelegate methods

/**
 *  MARK: 设置缩略图timer
 */
- (void) startTimer
{
    
    if (self.timerForNavigator == nil || self.timerForNavigator.isValid == NO) {
        self.timerForNavigator = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
    }
    
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:self.timerForNavigator forMode:NSDefaultRunLoopMode];
    self.timerFlag = YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.hallView;
}

- (void) scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
   self.navigatorView.hidden = NO;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    
    self.timerFlag = YES;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect visibleRect2 = CGRectIntersection(scrollView.bounds, self.hallView.frame);
    [self.navigatorView updateVisibleRect:visibleRect2 scale:scrollView.zoomScale];
    
    [self.seatIndexView updatePosition:scrollView.contentOffset scale:scrollView.zoomScale];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //show navigator
    self.navigatorView.hidden = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
   self.timerFlag = YES;
    
}


- (NSString *)printableSeat:(NSString *)seatId area:(NSString *)area row:(NSString *)row col:(NSString *)col {
    if (row && col) {
        return [NSString stringWithFormat:@"%@_%@|%@",row, col, seatId];
    }
    return nil;
}


- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self.scrollHallView frame].size.height / scale;
    zoomRect.size.width  = [self.scrollHallView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void) timerHandler
{
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
    
    
    count --;
}

#pragma mark hall view delegate
- (void)selectSeatInArea:(NSString *)area column:(NSString *)col row:(NSString *)row withId:(NSString *)seatId {
    // holder.frame = CGRectMake(0, 95, 320, 266);
    [self.selectedSeats addObject:seatId];
    NSString *seatDesc = [self printableSeat:seatId area:area row:row col:col];
    if (seatDesc) {
        [self.printableSelectedSeats addObject:seatDesc];
    }

    DLog(@"%@ - %@", self.selectedSeats, self.printableSelectedSeats);
    
    //座位按钮
    UIButton *seatInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    seatInfoButton.tag = [self.selectedSeats count] + K_TAG_TICKET_SET_BASE;
    seatInfoButton.frame = CGRectMake(10 + (78+10) * ([self.selectedSeats count] - 1), 9, 78, 24);
    seatInfoButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [seatInfoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    seatInfoButton.alpha = .2;
    seatInfoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [seatInfoButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
    [seatInfoButton setTitle:[NSString stringWithFormat:@"%@排%@座",row,col] forState:UIControlStateNormal];
    [seatInfoButton setBackgroundImage:[UIImage imageNamed:@"seatInfo_deselect_button"] forState:UIControlStateNormal];
    [seatInfoButton addTarget:self action:@selector(ticketClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.ticketView addSubview:seatInfoButton];
    [UIView animateWithDuration:.3
                     animations:^{
                         seatInfoButton.alpha = 1;
                     }];
    if (self.selectedSeats.count>0) {
        self.ticketView.hidden = NO;
        
    }
    
    self.timerFlag = YES;
    
}

- (void)deselectSeatInArea:(NSString *)area column:(NSString *)col row:(NSString *)row withId:(NSString *)seatId {
    
    NSInteger deselectIndex = [self.selectedSeats indexOfObject:seatId];
    
    [self removeTicketAt:deselectIndex];
    
    
    NSString *seatDesc = [self printableSeat:seatId area:area row:row col:col];
    if (seatDesc) {
        [self.printableSelectedSeats removeObject:seatDesc];
    }
    
    if ([self.selectedSeats count] == 0) {
        [self.scrollHallView setZoomScale:self.miniScale animated:YES];
    }
    if (self.selectedSeats.count <= 0) {
        self.ticketView.hidden = YES;
    }
    
}

-(void)selectEmptySeat
{
    
}

/**
 *  MARK: 移除ticketView中的票
 *
 *  @param index index
 */
- (void) removeTicketAt:(NSInteger)index
{
    if (index > self.selectedSeats.count) {
        return;
    }
    UIButton *seatInfoButton = (UIButton *)[self.ticketView viewWithTag:index + K_TAG_TICKET_GET_BASE];
    [seatInfoButton removeFromSuperview];
    
    [self.selectedSeats removeObjectAtIndex:index];
    
    for (NSInteger i = index + 1; i < self.selectedSeats.count + 1; i ++) {
        UIView *view = [self.ticketView viewWithTag:(i + K_TAG_TICKET_GET_BASE)];
        view.tag = i - 1 + K_TAG_TICKET_GET_BASE;
    }
    
    for (NSInteger i = 0; i <[self.selectedSeats count]; i++)
    {
        UIButton *waitMoveButton = (UIButton *)[self.ticketView viewWithTag:(i + K_TAG_TICKET_GET_BASE )];
        [UIView animateWithDuration:.5
                         animations:^{
                             waitMoveButton.frame =  CGRectMake(10 + (78+10) * i, 9, 78, 24);
                             
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
 
}


/**
 MARK: 超出选座数量
 */
- (void)selectNumReachMax {
    
    [KKZHintView showHint:@"最多可选4个座位"];
}

- (void) touchAt:(CGPoint)point didChangeSteatStatus:(BOOL)changeStatus {
    CGFloat scale = self.scrollHallView.zoomScale;
    //当修改了座位数，当前缩放不是最大时，设置缩放为最大
    if ([self.selectedSeats count] > 0 && changeStatus && scale != K_MAX_HALL_SCALL) {
        float newScale = K_MAX_HALL_SCALL;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:point];
        [self.scrollHallView zoomToRect:zoomRect animated:YES];
    }
    
}
/**
 *  MARK: 座位按钮 点击
 *
 *  @param selector selector
 */
- (void)ticketClick:(id)selector {
    UIButton *btn = (UIButton *)selector;
    for (int i = 0; i<[self.selectedSeats count]; i++) {
        if (i+K_TAG_TICKET_GET_BASE  == btn.tag) {
            NSString *seatID = [self.selectedSeats objectAtIndex:i];
            
            [self.hallView deselectSeatWithSeatId:seatID];
            
            Seat *seat = [self findSeatBy:seatID];
            if (seat && (seat.seatState.intValue == SeatStateLoverL || seat.seatState.intValue == SeatStateLoverR) && self.selectedSeats.count > 0) {
                //  获取这个情侣座对应的另一个座位， 取消它
                NSInteger loverCol = seat.seatCol.integerValue%2 == 0 ? seat.seatCol.integerValue - 1 : seat.seatCol.integerValue + 1;
                Seat *loverSeat = [self findSeatByRow:seat.seatRow Column:[NSString stringWithFormat:@"%ld", loverCol]];
                [self.hallView deselectSeatWithSeatId:loverSeat.seatId];
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
- (Seat *) findSeatBy:(NSString *)seatID
{
    if (seatID.length == 0) {
        return nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"seatId = %@",seatID];
    NSArray *resault = [self.allSeats filteredArrayUsingPredicate:predicate];
    if (resault.count > 0) {
        Seat *seat = resault.firstObject;
        return seat;
    }
    
    return nil;
}

- (Seat *)findSeatByRow:(NSString *)row Column:(NSString *)column {
    if (row.length == 0 || column.length == 0) {
        return nil;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"seatRow = %@ and seatCol = %@", row, column];
    NSArray *result = [self.allSeats filteredArrayUsingPredicate:predicate];
    if (result.count > 0) {
        Seat *seat = result.firstObject;
        return seat;
    }
    return nil;
}

#pragma mark - 确认订单
/**
 *  MARK: 出票
 */
- (void) confirmOrderClick
{
    if (self.selectedSeats.count == 0) {
        return;
    }
    
    if ([self.hallView hasEmtpySeats]) {
        [KKZHintView showHint:@"不能留空座位"];
        return;
    }
    
    //获取网络状态
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus <= 0) {
        [KKZHintView showHint:@"网络连接错误，请检查网络连接"];
        return;
    }
    
    //统计事件：选座页面锁定座位
    StatisEvent(EVENT_BUY_LOCK_SEAT);
    if (appDelegate.selectedTab == 0) { //电影入口
        StatisEvent(EVENT_BUY_LOCK_SEAT_SOURCE_MOVIE);
    } else if (appDelegate.selectedTab == 1) {
        StatisEvent(EVENT_BUY_LOCK_SEAT_SOURCE_CINEMA);
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        KKZAnalyticsEvent *event = [[KKZAnalyticsEvent alloc] initWithPlan:self.plan];
        NSMutableArray *seats = [NSMutableArray arrayWithCapacity:self.selectedSeats.count];
        //座位信息
        for (NSString *seatInfo in self.printableSelectedSeats) {
            NSString *row, *col, *seatID;
            NSArray *coms = [seatInfo componentsSeparatedByString:@"|"];
            if (coms.count >= 2) {
                seatID = coms[1];
                NSString *secCom = coms[0];
                NSArray * coms2 = [secCom componentsSeparatedByString:@"_"];
                if (coms2.count ==2) {
                    row = coms2[0];
                    col = coms2[1];
                }
            }
            if (row && col && seatID) {
                NSDictionary *dic = @{@"id": seatID, @"X":row, @"Y":col };
                [seats addObject:dic];
            }
        }
        event.seat = [seats copy];
        event.count = seats.count;
        [KKZAnalytics postActionWithEvent:event action:AnalyticsActionConfirm_order];

    });
    
       void (^makeTest)() = ^() {
        
        self.btnCheckOrder.enabled = NO;
        
        [appDelegate showIndicatorWithTitle:@"正在锁座"
                                   animated:YES
                                 fullScreen:NO
                               overKeyboard:NO
                                andAutoHide:NO];
        
        OrderRequest *request = [OrderRequest new];
        [request addTicketOrder:nil seatNO:[self selectedSeatIds]
                       seatInfo:[self selectedSeatInfos]
                         planID:self.plan.planId
                     activityID:self.activityId
                        success:^(Order * _Nullable order) {
            
            [self handleNewOrder:order];
            
            self.btnCheckOrder.enabled = YES;
            
            
        } failure:^(NSError * _Nullable err, Order * _Nullable oldOrder) {
            
            LOCK_SEAT_TIME_WRITE(nil);
            
            //存在未完成订单
            if (oldOrder) {
                
                [self handleOldOrder:oldOrder];
                
            } else {
                self.btnCheckOrder.enabled = YES;
                
                [appDelegate showAlertViewForTitle:nil message:err.userInfo[KKZRequestErrorMessageKey] cancelButton:@"确定"];
                
                [self resetSelectedSeats];
                
                [appDelegate hideIndicator];
            }
            
        }];
        
    };
    
    if (!appDelegate.isAuthorized) {
        [[DataEngine sharedDataEngine] startLoginFinished:^(BOOL succeeded) {
            if (succeeded) {
                makeTest();
            }
        } withController:self];
        
    } else {
        makeTest();
    }
    
    
}


#pragma mark - Get

- (void) handleNewOrder:(Order *)order
{
    //统计事件：锁座成功进入支付订单页
    StatisEvent(EVENT_BUY_LOCK_SEAT_SUCCESS);
    if (appDelegate.selectedTab == 0) { //电影入口
        StatisEvent(EVENT_BUY_LOCK_SEAT_SUCCESS_SOURCE_MOVIE);
    } else if (appDelegate.selectedTab == 1) {
        StatisEvent(EVENT_BUY_LOCK_SEAT_SUCCESS_SOURCE_CINEMA);
    }
    
    LOCK_SEAT_TIME_WRITE([NSDate date]);
    
    PayViewController *ctr = [[PayViewController alloc] initWithOrder:order.orderId];
    ctr.promotionId = self.promotionId.stringValue;
    ctr.isGroupbuy = YES;
    ctr.myOrder = order;
    ctr.orderDate = [NSDate dateWithTimeIntervalSinceNow:15 * 60];
    
    [self pushViewController:ctr animation:CommonSwitchAnimationBounce];
    
}

/**
 MARK: 处理之前未支付订单

 @param oldOrder 之前未支付订单
 */
- (void) handleOldOrder:(Order *)oldOrder
{
    RIButtonItem *cancel = [RIButtonItem itemWithLabel:@"取消"];
    cancel.action = ^{
        self.btnCheckOrder.enabled = YES;
        [appDelegate hideIndicator];
    };
    RIButtonItem *goback = [RIButtonItem itemWithLabel:@"确认"];
    
    WeakSelf
    goback.action = ^{
        
        [weakSelf requestToDeleteOrder:oldOrder.orderId success:^{
            [weakSelf confirmOrderClick];
        }];
        
    };
    
    NSDate *updateTime = USER_EXPIRE_ALERT;
    if (!updateTime || [updateTime timeIntervalSinceNow] < -2) {
        UIAlertView *alertAt = [[UIAlertView alloc] initWithTitle:@"提示"
                                                          message:@"您存在相同场次的未完成订单，\n是否删除之前的订单？"
                                                 cancelButtonItem:cancel
                                                 otherButtonItems:goback, nil];
        [alertAt show];
        USER_EXPIRE_ALERT_WRITE([NSDate date]);
    }
    
}

/**
  MARK: 删除订单

 @param orderID 订单ID
 @param callback 成功回调
 */
- (void) requestToDeleteOrder:(NSString *)orderID success:(void(^)())callback
{
    OrderRequest *request = [OrderRequest new];
    [request deleteOrder:orderID success:^{
        [appDelegate hideIndicator];
        
        if (callback) {
            callback();
        }
        
    } failure:^(NSError * _Nullable err) {
        self.btnCheckOrder.enabled = YES;
        [appDelegate hideIndicator];
        [appDelegate showAlertViewForTitle:nil message:err.userInfo[KKZRequestErrorMessageKey] cancelButton:@"确定"];
        
    }];
}



#pragma mark - GET

- (NSMutableArray *) selectedSeats
{
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
        readable = [NSString stringWithFormat:@"%@座",readable];
    }
    return readable;
}

#pragma mark - Set

- (void) setAllSeats:(NSArray *)allSeats
{
    if (_allSeats != allSeats) {
        _allSeats = allSeats;
        self.seatsForHallView = [_allSeats arrayByAddingObjectsFromArray:self.unavailableSeats];
    }
}

- (void) setUnavailableSeats:(NSArray *)unavailableSeats
{
    if (_unavailableSeats != unavailableSeats) {
        _unavailableSeats = unavailableSeats;
        self.seatsForHallView = [_allSeats arrayByAddingObjectsFromArray:self.unavailableSeats];
    }
}

#pragma mark override from CommonViewController
- (BOOL)showNavBar {
    return YES;
}


- (BOOL)showTitleBar {
    return YES;
}

// 配置导航栏
- (void)settingNavView {
    [self.navBarView setBackgroundColor:navBackgroundColor];
    [self.kkzBackBtn setImage:[UIImage imageNamed:@"backButtonImg"] forState:UIControlStateNormal];
    self.kkzTitleLabel.textColor = [UIColor whiteColor];
}


#pragma mark SET

- (void) setPlan:(Ticket *)plan
{
    self.planId = plan.planId;
    
    _plan = plan;
}

@end
