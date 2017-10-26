//
//  CommonWebViewController.h
//  KoMovie
//
//  Created by 艾广华 on 15/12/22.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "CommonViewController.h"

typedef enum : NSUInteger {
    FirstBrowser = 0,
    SecondBrowse,
} BrowserHierarchy;

/*****************全局的默认配置URL对象(正式)***********************/
static NSString *Periphery_HomePage_URL = @"http://zhoubian.komovie.cn";
static NSString *ShoppingCart_URL = @"http://zhoubian.komovie.cn/cart";
static NSString *Order_Requset_URL = @"http://zhoubian.komovie.cn/user/orderList";
static NSString *ShoppingAddress_URL = @"http://zhoubian.komovie.cn/user/addressList"; // 收货地址

/*****************全局的默认配置URL对象(测试)***********************/
// static NSString *Periphery_HomePage_URL = @"http://dev.zhoubian.komovie.cn/";
// static NSString *ShoppingCart_URL = @"http://dev.zhoubian.komovie.cn/cart";
// static NSString *Order_Requset_URL = @"http://dev.zhoubian.komovie.cn/user/orderList";
// static NSString *ShoppingAddress_URL = @"http://dev.zhoubian.komovie.cn/user/addressList";

@interface CommonWebViewController : CommonViewController

/**
 *  请求的浏览器的层级
 */
@property (nonatomic, assign) BrowserHierarchy browserHierarchy;

/**
 *  网页视图
 */
@property (nonatomic, strong) UIWebView *webView;

/**
 *  请求的地址
 */
@property (nonatomic, strong) NSString *requestURL;

/**
 * 加载URL地址。
 *
 * @param url URL
 */
- (void)loadRequestWithURL:(NSString *)url;

/**
 * 重新加载页面。
 */
- (void)reloadPage;

/**
 *  刷新当前已经加载过的请求
 *
 *  @param url
 */
- (void)refreshRequestWithURL:(NSString *)url;

/**
 *  一级浏览器加载的URL对象
 */
@property (nonatomic, strong) NSString *firstWebRequestURL;

/**
 *  滚动轮
 */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end
