//
//  PayTypeHeaderView.h
//  CIASMovie
//
//  Created by cias on 2017/2/23.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PayTypeHeaderViewDelegate <NSObject>
- (void)showViewListWithIndex:(NSInteger)section;
- (void)bindStoreVipCard;
@end

@interface PayTypeHeaderView : UIView
{
    UILabel *tipLabel,*payTypeLabel;
    UIButton *addBtn, *showListBtn;
    UIImageView *selectImageView, *arrowImageView;
}
@property (nonatomic, assign) NSInteger payTypeNum;
@property (nonatomic, assign) BOOL isSelectHeader;

@property (nonatomic, strong) NSMutableArray *cardCountList;
@property (nonatomic, copy) NSString *headTitle;
@property (nonatomic, assign) id <PayTypeHeaderViewDelegate>delegate;

- (void)updateLayout;
- (void)isSelected:(BOOL)isSelected;
@end
