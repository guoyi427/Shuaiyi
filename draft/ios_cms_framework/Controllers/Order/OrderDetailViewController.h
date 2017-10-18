//
//  OrderDetailViewController.h
//  CIASMovie
//
//  Created by cias on 2017/1/6.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Order.h"
#import "OrderTicket.h"

@interface OrderDetailViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *holder;
    UIImageView *moviePosterImage, *moviePosterImageBg;
    UIView *movieInfoBg;
    UILabel *movieNameLabel, *movieEngLishLabel;
    UILabel *screenTypeLabel, *languageLael;
    UILabel *hallLabel, *hallNameLabel;
    UILabel *timeLabel, *timeDateLabel, *timeHourLabel;
    UIImageView *hallImageView;
    UILabel *seatLabel, *selectSeatsLabel;
    UILabel *cinemaNameLabel;
    UILabel *cinemaAddressLabel;
//    UILabel *distanceLabel;
    UIImageView *locationImageView;
    UIImageView *qrCodeImageView;
    UILabel *validCodeLabel, *validInfoBakLabel;
    UILabel *pickUpTicketLabel;
    UILabel *validCodeLabelTip;
    UILabel *validInfoBakLabelTip;
    
    UILabel *customerTelephoneLabel;
    
    UIButton *leftBarBtn, *rightBarBtn;
//    UIButton *shareQQBtn,*shareWXBtn;

    UILabel *navTitleLabel;
    UIView *upHalfView;
    UIView *downHalfView;
    
    UIButton    *gotoProductListBtn;
    UIImageView *gotoProductImageView;
    UILabel     *gotoProductTipLabel;
    UIImageView *ticketbgline;
}
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) NSMutableArray  *productList;

@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, strong) Order *myOrder;
@property (nonatomic, assign) BOOL isShowJudgeAlert;

- (void)updateLayout;

@end
