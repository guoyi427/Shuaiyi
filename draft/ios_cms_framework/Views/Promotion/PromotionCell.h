//
//  PromotionCell.h
//  CIASMovie
//
//  Created by cias on 2017/2/25.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VipCard.h"

@interface PromotionCell : UITableViewCell
{
    UILabel *tipLabel,*payCardNoLabel, *detailLabel;
    UIImageView *selectedImageView;
}

@property (nonatomic, assign) NSInteger indexPathNum;
@property (nonatomic, assign) BOOL isSelectCell;
@property (nonatomic, strong) VipCard *myCard;
@property (nonatomic, copy) NSString *leftTitle;
@property (nonatomic, copy) NSString *rightTitle;
@property (nonatomic, copy) NSString *detail;

- (void)updateLayout;

@end
