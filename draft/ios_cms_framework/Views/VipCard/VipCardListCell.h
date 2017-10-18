//
//  VipCardListCell.h
//  CIASMovie
//
//  Created by avatar on 2017/2/27.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VipCard.h"

@interface VipCardListCell : UITableViewCell
{
    UILabel *cardTitleLabel,*cardValueLabel,*cardTypeLabel,*cardBalanceValueLabel,*cardValidTimeLabel;
    UIImageView *cardBackImageView,*cardImageView,*cardLogoImageView;
}
@property (nonatomic, assign) NSInteger indexPathNum;
@property (nonatomic, strong) VipCard *myCard;

- (void)updateLayout;

@end
