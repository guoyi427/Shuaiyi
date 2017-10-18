//
//  OrderListViewController.h
//  CIASMovie
//
//  Created by avatar on 2017/1/14.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListViewController : UIViewController
{
    UIButton *leftBarBtn;
}
//0 待付款列表  1已完成列表 2 已取消列表
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) BOOL isBackFirst;
@property (nonatomic, strong) NSMutableArray *btnSelectArr;

@end
