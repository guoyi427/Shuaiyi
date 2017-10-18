//
//  CardTypeListViewController.h
//  CIASMovie
//
//  Created by avatar on 2017/3/13.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardTypeListViewController : UIViewController
{
    BOOL initFirst;
}
@property (nonatomic, strong) UINavigationBar *navBar;

@property (nonatomic, copy) NSString *cinemaId;
@property (nonatomic, copy) NSString *cinemaName;

@end
