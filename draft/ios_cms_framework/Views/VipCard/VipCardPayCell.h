//
//  VipCardPayCell.h
//  CIASMovie
//
//  Created by cias on 2017/2/23.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VipCard.h"

@interface VipCardPayCell : UITableViewCell
{
    UILabel *tipLabel,*payCardNoLabel;
    UIImageView *selectedImageView;
}

@property (nonatomic, assign) NSInteger indexPathNum;
@property (nonatomic, strong) VipCard *myCard;

- (void)updateLayout;

@end
