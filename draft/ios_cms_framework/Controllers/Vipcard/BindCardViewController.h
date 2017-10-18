//
//  BindCardViewController.h
//  CIASMovie
//
//  Created by avatar on 2017/2/21.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindCardViewController : UIViewController
{
    UIButton *leftBarBtn,*rightBarBtn;
    int timeCountOfBind;
}
@property (nonatomic, copy) NSString *cinemaId;
@property (nonatomic, copy) NSString *cinemaName;
@property (nonatomic, strong) NSTimer *timerOfBind;

@end
