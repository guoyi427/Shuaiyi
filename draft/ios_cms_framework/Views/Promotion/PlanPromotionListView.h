//
//  PromotionListView.h
//  CIASMovie
//
//  Created by cias on 2017/2/25.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PlanPromotionListViewDelegate <NSObject>

@end

@interface PlanPromotionListView : UIView<UITableViewDelegate, UITableViewDataSource>{
    UITableView *promotionTableView;
    UIControl   *_overlayView;
    UIButton *confirmBtn;
    BOOL selected, isSame, lastSame;

}
@property (nonatomic, strong) NSMutableArray *discountCardList;
@property (nonatomic, strong) NSMutableArray *promotionList;
@property (nonatomic, assign) NSInteger selectedNum;
@property (nonatomic, assign) NSInteger lastSelectedNum;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *selectProductIds;
@property (nonatomic, strong) NSDictionary *promotionDict;
@property (nonatomic, strong) NSArray *selectCouponsList;

@property (nonatomic, weak) id<PlanPromotionListViewDelegate> delegate;

- (void)updateLayout;
- (void)show;
- (void)dismiss;


@end
