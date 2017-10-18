//
//  OpenCardViewController.h
//  CIASMovie
//
//  Created by avatar on 2017/3/13.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardTypeDetail.h"

@interface OpenCardViewController : UIViewController
{
    UIButton *leftBarBtn,*rightBarBtn;
    int timeCountOfBind;
}
@property (nonatomic, strong) CardTypeDetail *cardTypeDetail;
@property (nonatomic, copy) NSString *cinemaId;
@property (nonatomic, copy) NSString *cinemaName;
@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, strong) NSTimer *timerOfBind;


@end
