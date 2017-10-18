//
//  PayTypeCell.h
//  CIASMovie
//
//  Created by cias on 2017/2/8.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayTypeCell : UITableViewCell
{
    UILabel *tipLabel,*payTypeLabel;
    UIImageView *selectedImageView;
}
@property (nonatomic, assign) NSInteger payTypeNum;

- (void)updateLayout;


@end
