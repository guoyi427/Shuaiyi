//
//  SellPickUpCell.h
//  cias
//
//  Created by cias on 2017/4/21.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol refreashCellHeight <NSObject>

- (void)refreashCellHeight:(CGFloat)cellHeght withIndex:(NSIndexPath *)indexPath;

@end
@interface SellPickUpCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *sellProductImage;
@property (weak, nonatomic) IBOutlet UILabel *sellProductName;
@property (weak, nonatomic) IBOutlet UILabel *sellProductPrice;
@property (weak, nonatomic) IBOutlet UILabel *sellProductNUmber;
@property (weak, nonatomic) IBOutlet UIButton *unfoldBtn;
@property (weak, nonatomic) IBOutlet UIView *erWeiMaView;
- (IBAction)unfoldAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *erWeiMaHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTop;

@property (weak, nonatomic) IBOutlet UILabel *describeLabel;



@property (nonatomic, assign) id <refreashCellHeight> delegate;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL    isClick;

- (void)setCellWithDic:(NSDictionary *)dic withIndex:(NSIndexPath *)indexPath;

@end
