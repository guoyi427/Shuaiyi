//
//  CardTypeCell.h
//  CIASMovie
//
//  Created by avatar on 2017/3/13.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTypeDetail.h"

@interface CardTypeCell : UITableViewCell
{
    UILabel *cardTitleLabel,*cardValueLabel,*cardTypeLabel,*cardBalanceValueLabel,*cardValidTimeLabel;
    UIImageView *cardBackImageView,*cardImageView,*cardLogoImageView;
}
@property (nonatomic, assign) NSInteger indexPathNum;
@property (nonatomic, strong) CardTypeDetail *myCardType;

- (void)updateLayout;

@end
