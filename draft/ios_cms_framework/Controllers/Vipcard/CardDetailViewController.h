//
//  CardDetailViewController.h
//  CIASMovie
//
//  Created by avatar on 2017/3/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardListDetail.h"

@interface CardDetailViewController : UIViewController
{
    UIButton * backButton;
}
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cardBackImageView;
@property (weak, nonatomic) IBOutlet UIImageView *cardLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardIdTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardIdValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardTimeLabel;
//新城会员卡
@property (weak, nonatomic) IBOutlet UILabel *cardTitleXCLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardValidXCLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardBalanceXCLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNoValueXCLabel;



@property (weak, nonatomic) IBOutlet UITableView *cardDisPlayTableView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardImageWitdh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardBackImageWitdh;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardBackImageHeight;




@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardLogoLeft;//35
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardLogoTop;//25
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTypeTop;//30
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTypeRight;//24
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardIdLabelTop;//32
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardIdValueTop;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTimeBottom;//25
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTimeRight;//25

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardDisplatTableViewTop;//10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardBackImageTop;//64 + 10
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardImageTop;//64+25

@property (weak, nonatomic) IBOutlet UIButton *cardUseBtn;
- (IBAction)cardUseBtnClick:(UIButton *)sender;


//新城约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardNoXCLeft;//20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardNoXCBottom;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardValidXCRight;//15
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardBalanceXCBottom;//6
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardTitleXCBottom;//6




@property (nonatomic, strong) CardListDetail *cardListDetail;
@property (nonatomic, strong) UINavigationBar *navBar;



















@end
