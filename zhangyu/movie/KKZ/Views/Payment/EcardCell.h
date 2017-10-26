//
//  优惠券/兑换券列表的Cell
//
//  Created by da zhang on 11-9-17.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "Order.h"

@interface EcardCell : UITableViewCell {

    NSString *eCardId;
    UILabel *eCardIdLabel, *eCardNameLabel, *eCardExpiredLabel;
    int rowNumInTable;
    CGRect deleteRect;
    UIImageView *selectImg;
    NSComparisonResult result; //是否过期
    UIView *line;
}

@property (nonatomic, strong) NSString *eCardId;
@property (nonatomic, assign) float amountNum;
@property (nonatomic, assign) int rowNumInTable;

@property (nonatomic, assign) NSInteger segmentIndex;

@property (nonatomic, strong) NSString *couponId;
@property (nonatomic, strong) NSString *maskName;
@property (nonatomic, strong) NSString *expiredDate;

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, strong) NSString *remainCount;

- (void)updateLayoutYN;

@end
