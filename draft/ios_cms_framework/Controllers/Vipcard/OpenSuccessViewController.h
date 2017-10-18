//
//  OpenSuccessViewController.h
//  CIASMovie
//
//  Created by avatar on 2017/3/14.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailOfMovie.h"
#import "CardListDetail.h"

@interface OpenSuccessViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;

@property (weak, nonatomic) IBOutlet UIImageView *cardCinemaLogoImageVIew;
@property (weak, nonatomic) IBOutlet UILabel     *cardTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel     *cardIdTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel     *cardIdValueLabel;
@property (weak, nonatomic) IBOutlet UILabel     *cardBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel     *cardValidLabel;
@property (weak, nonatomic) IBOutlet UILabel     *cardOpenSuccessLabel;
@property (weak, nonatomic) IBOutlet UILabel     *cardOpenSuccessLabel2;
@property (weak, nonatomic) IBOutlet UILabel     *cardOpenSuccessLabel3;
@property (weak, nonatomic) IBOutlet UIButton    *cardDetailBtn;
@property (weak, nonatomic) IBOutlet UIButton    *cardDetailBtn2;
- (IBAction)gotoCardDetail:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton    *cardCouponBtn;
@property (weak, nonatomic) IBOutlet UIButton    *cardCouponBtn2;
- (IBAction)gotoCardCouponList:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton    *cardBuyTicketBtn;
- (IBAction)gotoBuyTicketInCard:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardImageWitdh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardBackImageWitdh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardBackImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardLogoLeft;//35
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardLogoTop;//25
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTypeTop;//30
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTypeRight;//24
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardIdTitleTop;//32
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardIdValueTop;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTimeBottom;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTimeRight;//25
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardSuccessLabelTop;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardSuccessLabelTop2;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardSuccessLabelTop3;//5
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;//84
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardDetailBtnTop;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardDetailBtnHeight;//42
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardCouponBtnTop;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardDetailBtn2Right;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardCouponBtn2Right;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;//355
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewTop;//64
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardBackImageTop;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardImageTop;//25

//新城会员卡UI
@property (weak, nonatomic) IBOutlet UILabel *cardNoXClabel;
@property (weak, nonatomic) IBOutlet UILabel *cardTitleXCLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardValidXCLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardBalanXCLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTitleXCBottom;//-6
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardNoXCLeft;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardNoXCBottom;//-15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardValidXCRight;//-15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardValidXCBottom;//-15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardBalanXCBottom;//-6




@property (nonatomic, strong) OrderDetailOfMovie *myOrderDetail;
@property (nonatomic, strong) CardListDetail     *cardListDetail;

@property (nonatomic, copy)   NSString        *orderNo;
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) NSMutableArray  *couponList;





@end
