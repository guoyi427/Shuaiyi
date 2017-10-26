//
//  ECardViewController.h
//  KoMovie
//
//  Created by avatar on 14-11-13.
//  Copyright (c) 2014年 kokozu. All rights reserved.
//

#import "EcardCell.h"
#import "EcardCell.h"
#import "RoundCornersButton.h"
#import "ShowMoreButton.h"

@class EGORefreshTableHeaderView;
@class NoDataViewY;
@class AlertViewY;

@interface ECardViewController : CommonViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,
                                                       ShowMoreButtonDelegate, UIGestureRecognizerDelegate> {
    UIView *headview, *noOrderAlertView, *sectionHeader;
    UILabel *noOrderAlertLabel;

    UITableView *redCouponTableView;
    NSMutableArray *redCouponList;
    ShowMoreButton *showMoreBtn;

    NSInteger currentPage;
    BOOL tableLocked;
    UILabel *noRedAlertLabel;
    UITextField *eCardNo;

    NoDataViewY *nodataView;
    AlertViewY *noAlertView;
}
@end
