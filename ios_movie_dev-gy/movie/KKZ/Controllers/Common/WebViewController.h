//
//  WebViewController.h
//
//  Created by zhang da on 12-8-15.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//
//  加载网页的父ViewController
//

#import "CommonViewController.h"
#import "LoginViewController.h"

@interface WebViewController : CommonViewController <UIScrollViewDelegate, UIWebViewDelegate, LoginViewControllerDelegate> {
}

/**
 * 页面的标题。
 */
@property (nonatomic, strong) NSString *webTitle;

/**
 * 加载中的提示 UIView。
 */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

/**
 * 初始化。
 *
 * @param title 标题
 */
- (id)initWithTitle:(NSString *)title;

- (void)loadURL:(NSString *)url;

/**
 * 加载指定的 URL。不使用本地缓存。
 *
 * @param url URL 地址
 */
- (void)loadRequestWithURL:(NSString *)url;

/**
 * 加载指定的 URL。
 *
 * @param url      URL 地址
 * @param useCache 是否使用本地缓存
 */
- (void)loadRequestWithURL:(NSString *)url useCache:(BOOL)useCache;

/**
 * 加载指定的 URL。不使用本地缓存。
 *
 * @param request 页面加载的 URL
 */
- (void)loadRequest:(NSURLRequest *)request;

/**
 * 加载指定的 URL。
 *
 * @param request  页面加载的 URL
 * @param useCache 是否使用本地缓存
 */
- (void)loadRequest:(NSURLRequest *)request useCache:(BOOL)useCache;

/**
 * 重新加载页面。
 */
- (void)reloadPage;

@end
