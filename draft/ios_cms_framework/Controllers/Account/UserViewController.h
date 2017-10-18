//
//  UserViewController.h
//  CIASMovie
//
//  Created by cias on 2016/12/7.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UserViewController :UIViewController
{
    int timeCountOfRegister,timeCountOfForget;
}
@property (nonatomic, strong) UINavigationBar *uvcNaviBar;
@property (nonatomic, strong) NSTimer *timerOfRegister;
@property (nonatomic, strong) NSTimer *timerOfForget;
@property (nonatomic, assign) BOOL isShouldLogin;

@end
