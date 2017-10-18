//
//  VipCardRechargeOrderController.h
//  CIASMovie
//
//  Created by avatar on 2017/3/5.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTypeDetail.h"
#import "Order.h"

@interface VipCardRechargeOrderController : UIViewController
{
    UIButton * backButton;
    UILabel *cinemaTitleLabel, *movieTitleLabel;
    NSTimer *timer;
    int timeCount;
    BOOL initFirst;
}
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cardCinemaLogoImageView;

@property (weak, nonatomic) IBOutlet UILabel *cardType;
@property (weak, nonatomic) IBOutlet UILabel *cardId;
@property (weak, nonatomic) IBOutlet UILabel *cardBalance;
@property (weak, nonatomic) IBOutlet UILabel *cardTime;
@property (weak, nonatomic) IBOutlet UIButton *cardPayBtn;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardValidDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardSaleMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardStoreMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardDiscountMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardDiscountTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardValidTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardPhoneTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardSaleTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardStoreTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardDiscountTitleLabel2;


//新城会员卡UI
@property (weak, nonatomic) IBOutlet UILabel *cardTitleXCLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNoValueXCLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardBalanXCLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardValidXCLabe;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardNoXCLeft;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTitleXCBottom;//6
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardBalanXCRight;//-15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardNoXCBottom;//-15






@property (weak, nonatomic) IBOutlet UILabel *cardTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardImageViewWitdh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardImageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardBackImageViewWitdh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardBackImageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardLogoLeft;//35
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTypeRight;//24
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTimeBottom;//25
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTimeRight;//25
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardViewHeight;//251
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTypeLabelLeft;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTypeLabelRight;//15

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceHeigh;//209
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceHeight1;//7

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceHeight2;//7
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceHeight3;//7
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceHeight4;//15

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceHeigth5;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceHeight6;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceHeight7;//7
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceHeight8;//7
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTypeTop;//30




















@property (nonatomic, strong) NSMutableDictionary *cardRecargeValueSelectedDic;
@property (nonatomic, strong) CardTypeDetail *cardTypeDetail;
@property (nonatomic, strong) Order *cardOrder;
@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, copy) NSString *cinemaId;
@property (nonatomic, copy) NSString *cinemaName;
@property (nonatomic, strong) UINavigationBar *navBar;



- (IBAction)cardPayAction:(UIButton *)sender;

@end
