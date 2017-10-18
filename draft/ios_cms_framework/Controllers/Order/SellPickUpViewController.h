//
//  SellPickUpViewController.h
//  cias
//
//  Created by cias on 2017/4/21.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellPickUpViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UIButton *leftBarBtn;
    UILabel *navTitleLabel;
}
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) UINavigationBar *navBar;

@property (nonatomic, strong) NSMutableArray *productList;
@property (nonatomic, strong) NSMutableArray *productStatusList;

@end
