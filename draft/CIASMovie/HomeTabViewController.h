//
//  HomeTabViewController.h
//  CIASMovie
//
//  Created by cias on 2016/12/6.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTabViewController : UIViewController

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) NSMutableDictionary *viewControllersMap;
@property (nonatomic) NSInteger currentIndex;
/**
 *  正在登录
 */
@property (nonatomic) BOOL showingLogin;
- (void)setSelectedTabAtIndex:(NSInteger)index;
@end
