//
//  KKZCommonWebView.h
//  KoMovie
//
//  Created by 艾广华 on 16/3/22.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>


@class KKZCommonWebView;
@protocol IMYWebViewDelegate <NSObject>
@optional
- (void)webViewDidStartLoad:(KKZCommonWebView *)webView;
- (void)webViewDidFinishLoad:(KKZCommonWebView *)webView;
- (void)webView:(KKZCommonWebView *)webView didFailLoadWithError:(NSError *)error;
- (BOOL)webView:(KKZCommonWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
@end

@interface KKZCommonWebView : UIView

/**
 *  是否使用UIWebView
 */
@property (nonatomic, readonly) BOOL usingUIWebView;

/**
 *  原始的请求
 */
@property (nonatomic, readonly) NSURLRequest *originRequest;

/**
 *  当前的请求
 */
@property (nonatomic, readonly) NSURLRequest *currentRequest;

/**
 *  代理对象
 */
@property(weak,nonatomic)id<IMYWebViewDelegate> delegate;

/**
 *  滚动视图
 */
@property (nonatomic, readonly) UIScrollView *scrollView;

/**
 *  请求的URL对象
 */
@property (nonatomic, readonly) NSURL *URL;

/**
 *  当前是否正在加载 
 */
@property (nonatomic, readonly, getter=isLoading) BOOL loading;

/**
 *  当前网页是否能后退
 */
@property (nonatomic, readonly) BOOL canGoBack;

/**
 *  当前网页是否能前进
 */
@property (nonatomic, readonly) BOOL canGoForward;

/**
 *  是否根据视图大小来缩放页面  默认为YES
 */
@property (nonatomic, assign) BOOL scalesPageToFit;

/**
 *  后退
 *
 *  @return
 */
- (id)goBack;

/**
 *  前进
 *
 *  @return
 */
- (id)goForward;

/**
 *  重新加载
 *
 *  @return 
 */
- (id)reload;

/**
 *  停止运行
 */
- (void)stopLoading;

/**
 *  加载请求
 *
 *  @param request
 *
 *  @return
 */
- (id)loadRequest:(NSURLRequest *)request;

/**
 *  加载HTML字符串
 *
 *  @param string
 *  @param baseURL
 *
 *  @return
 */
- (id)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;

/**
 *  运行JS的代码
 *
 *  @param javaScriptString  运行的js脚本名称
 *  @param completionHandler 回调结果
 */
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler;
@end
