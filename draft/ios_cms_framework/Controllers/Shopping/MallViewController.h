//
//  MallViewController.h
//  CIASMovie
//
//  Created by cias on 2016/12/7.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MallViewController : UIViewController

@property (nonatomic, strong) UINavigationBar *navBar;
/**
 *  网页视图
 */
@property (nonatomic, strong) UIWebView *webView;

/**
 *  滚动轮
 */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end
