//
//  VipCardOrderDetailViewController.h
//  CIASMovie
//
//  Created by avatar on 2017/1/15.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OrderDetailOfMovie;

@interface VipCardOrderDetailViewController : UIViewController
{
    UIButton *leftBarBtn;
}
@property (nonatomic, strong) OrderDetailOfMovie *orderDetailOfMovie;

@end
