//
//  OpenCardDetailController.h
//  CIASMovie
//
//  Created by avatar on 2017/3/13.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTypeDetail.h"

@interface OpenCardDetailController : UIViewController
{
    UIButton * backButton;
}
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;

@property (weak, nonatomic) IBOutlet UIImageView *cinemaLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardCinemaName;
@property (weak, nonatomic) IBOutlet UILabel *cardDiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardValidTimeLabel;
@property (weak, nonatomic) IBOutlet UITableView *cinemaLimitTableView;
@property (weak, nonatomic) IBOutlet UIButton *protocolSelectBtn;
- (IBAction)protocolSelectBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *protocolDetailBtn;
- (IBAction)protocolDetailBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *openCardBtn;
- (IBAction)openCardBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardImageViewWitdh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardImageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cinemaNameTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardDiscountTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTypeTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardBalanceBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImageTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardImageViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *protocolViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openCardBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *protocolBtnTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *protocolBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cinemaLogoLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTypeRight;

//新城会员卡UI
@property (weak, nonatomic) IBOutlet UILabel *cardNoXCLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardTitleXCLabe;
@property (weak, nonatomic) IBOutlet UILabel *cardBalanXCLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardValidXCLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardBalanXCLeft;//-15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardNoXCLeft;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTitleXCBottom;//6
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardNoXCBottom;//-15




@property (nonatomic, strong) CardTypeDetail *cardTypeDetail;
@property (nonatomic, copy) NSString *cinemaId;
@property (nonatomic, copy) NSString *cinemaName;
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) NSArray *cardCinemaList;

@end
