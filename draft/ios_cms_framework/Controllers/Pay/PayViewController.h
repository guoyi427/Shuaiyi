//
//  PayViewController.h
//  CIASMovie
//
//  Created by cias on 2017/1/6.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "Plan.h"
#import "ProductView.h"
#import "PayTypeCell.h"
#import "ProductListView.h"
#import "Order.h"
#import "OrderTicket.h"
#import "PlanDate.h"
#import "PayTypeHeaderView.h"
#import "PromotionListView.h"
#import "CodeView.h"
#import "ProductListDetail.h"
#import "Product.h"

@interface PayViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ProductViewDelegate, PayTypeHeaderViewDelegate, CodeViewDelegate, ProductListViewDelegate, PromotionListViewDelegate>
{
//影票信息

    UILabel *cinemaTitleLabel, *movieTitleLabel;
    UIImageView *moviePosterImage;
    UIView *blackPosterView;
    UIView *movieInfoBg;
    UILabel *movieNameLabel, *movieEngLishLabel;
    UILabel *screenTypeLabel, *languageLael;
    UILabel *hallLabel, *hallNameLabel;
    UILabel *timeLabel, *timeDateLabel, *timeHourLabel;
    UIImageView *hallImageView;
    UILabel *seatLabel, *selectSeatsLabel;
    UILabel *cinemaNameLabel;
    UILabel *cinemaAddressLabel;
    UILabel *distanceLabel;
    UIImageView *locationImageView;
    UILabel *telephoneLabel;
    UIButton * backButton;
//卖品
    ProductView *productView;
    
//影票价格信息
    UIView *infoView;
    UILabel *ticketLabel, *ticketUnitPriceLabel, *ticketPriceLabel, *serviceLabel;
    UILabel *productLabel, *productUnitPriceLabel, *productPriceLabel;
//选择支付方式
    UIView *payMethodHeadView;
    UILabel *payMethodTipLabel;
//活动
    UIView *eventView;
    UILabel *eventLabel, *eventTipLabel, *eventNumberLabel;
//优惠券
    UIView *couponView;
    UILabel *couponTipLabel, *couponLabel;
    UIButton *addCouponBtn, *showCouponListBtn;
    UIImageView *couponArrowImageView;
    UITableView *couponListTable;
    
// tableviewheader
    UIView *topHeaderView;
    UITableView *payTableView;
    NSInteger selectedNum;//会员卡选中的行数
    NSInteger lastSelectedNum;//上次会员卡选中的行数

    NSInteger payMethodType;//支付方式
    NSInteger payMethodNum;
    
    BOOL selected, isSame;
    NSTimer *timer;
    int timeCount;
    BOOL hasOrderExpired;
    UIButton *confirmBtn;
    BOOL initFirst, initFirstPromotion;

}

@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) NSMutableArray *payMethodList;
@property (nonatomic, strong) NSMutableArray *myCardList;
@property (nonatomic, strong) NSMutableArray *myDiscountCardList;
@property (nonatomic, strong) NSMutableArray *promotionList;

@property (nonatomic, strong) NSMutableArray *couponList;
@property (nonatomic, strong) NSMutableArray *myProductList;
@property (nonatomic, strong) NSMutableArray *selectProductList;
@property (nonatomic, copy) NSString *selectProductIds;

@property (nonatomic, strong) ProductListView *productList;

@property (nonatomic, strong) PromotionListView *promotionListView;

@property (nonatomic, assign) BOOL isHasProduct;
@property (nonatomic, assign) BOOL isHasPromotion;
@property (nonatomic, assign) BOOL isFromOrder;

@property (nonatomic, assign) BOOL isHasCoupon;
@property (nonatomic, assign) BOOL showCouponList;
@property (nonatomic, assign) NSInteger selectedCouponNum;
@property (nonatomic, assign) BOOL isSameCoupon;
@property (nonatomic, assign) BOOL isAddDelet;


@property (nonatomic, strong) Movie *amovie;
@property (nonatomic, strong) Plan *aplan;
@property (nonatomic, strong) Order *myOrder;

@property (nonatomic, assign) NSInteger selectPlanTimeRow;
@property (nonatomic, strong) NSMutableArray *planList;
@property (nonatomic, strong) PlanDate *selectPlanDate;

///
@property (nonatomic, copy) NSString *movieId;
@property (nonatomic, copy) NSString *cinemaId;
@property (nonatomic, copy) NSString *movieName;
@property (nonatomic, copy) NSString *cinemaName;
@property (nonatomic, copy) NSString *planId;//排期Id是对应接口返回的sessionId
@property (nonatomic, copy) NSString *selectPlanDateString;

////储值卡列表
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *selectVipCardNo;
@property (nonatomic, copy) NSString *lastSelectVipCardNo;
@property (nonatomic, copy) NSString *selectVipCardBalance;//选中的会员卡支付的余额
@property (nonatomic, copy) NSString *vipCardTitle;
@property (nonatomic, copy) NSString *lastVipCardTitle;

@property (nonatomic, assign) float moneyToPay;//最终需要支付价格
@property (nonatomic, assign) float discountMoney;//会员卡折扣价格
@property (nonatomic, assign) float productMoney;//卖品价格
@property (nonatomic, assign) float promotionMoney;//活动价格
@property (nonatomic, assign) float couponMoney;//兑换券价格

//选中的活动Id
@property (nonatomic, copy) NSString *selectActivityId;
@property (nonatomic, copy) NSString *selectActivityType;//活动的类型，身份卡还是一般活动
@property (nonatomic, copy) NSString *activityDiscountPrice;//活动的折扣价
@property (nonatomic, assign) NSInteger selectedPromotionIndex;


//选择的优惠券字符串
@property (nonatomic, copy) NSString *selectCouponsString;
@property (nonatomic, strong) NSMutableArray *selectCouponsList;

@property (nonatomic, assign) NSInteger selectedSection;
@property (nonatomic, strong) UIVisualEffectView * blurEffectView;
@property (nonatomic, strong) CodeView * codeView;

//自营为YES  系统方为NO
@property (nonatomic, assign) BOOL productType;//卖品类型（系统方还是自营）
@property (nonatomic, assign) BOOL promotionType;//活动型号 （系统方还是自营）
@property (nonatomic, assign) BOOL storeVipCardType;//储值卡类型（系统方还是自营）


@end
