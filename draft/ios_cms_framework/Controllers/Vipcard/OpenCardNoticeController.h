//
//  OpenCardNoticeController.h
//  CIASMovie
//
//  Created by avatar on 2017/3/27.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenCardNoticeController : UIViewController

@property (nonatomic, strong) UINavigationBar *navBar;

@property (nonatomic, copy) NSString *titleShowStr;
@property (nonatomic, copy) NSString *contentShowStr;
@property (nonatomic, assign) BOOL isFromCoupon;

@end
