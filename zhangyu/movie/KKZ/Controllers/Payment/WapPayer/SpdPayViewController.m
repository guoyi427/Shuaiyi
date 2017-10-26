//
//  浦发支付页面
//
//  Created by 艾广华 on 16/3/2.
//  Copyright © 2016年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "SpdPayViewController.h"

@interface SpdPayViewController () <UIWebViewDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>

/**
 * 网页视图
 */
@property (nonatomic, strong) UIWebView *webView;

/**
 * 是否网络授权
 */
@property (nonatomic, assign) BOOL authenticated;

/**
 * 网络请求
 */
@property (nonatomic, strong) NSMutableURLRequest *urlRequest;

/**
 * 网络请求连接
 */
@property (nonatomic, strong) NSURLConnection *urlConnection;

@end

@implementation SpdPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //加载导航栏
    [self loadNavBar];

    //加载网页视图
    [self loadWebView];
}

- (void)loadNavBar {
    self.statusView.backgroundColor = self.navBarView.backgroundColor;
    self.kkzTitleLabel.text = @"浦发支付";
}

- (void)loadWebView {
    [self.view addSubview:self.webView];
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navBarView.frame), kCommonScreenWidth, self.KCommonContentHeight - CGRectGetMaxY(self.navBarView.frame))];
        NSURL *url = [NSURL URLWithString:self.requestURL];
        _urlRequest = [NSMutableURLRequest requestWithURL:url];
        [_urlRequest setHTTPMethod:@"POST"];
        NSData *paramesDicData = [self.parameters dataUsingEncoding:NSUTF8StringEncoding];
        [_urlRequest setHTTPBody:paramesDicData];
        _webView.delegate = self;
        [_webView loadRequest:_urlRequest];
    }
    return _webView;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (!_authenticated) {
        _authenticated = NO;
        _urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
        return NO;
    }
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge previousFailureCount] == 0) {
        _authenticated = YES;
        SecTrustRef secTrustRef = challenge.protectionSpace.serverTrust;
        NSURLCredential *credential = [NSURLCredential credentialForTrust:secTrustRef];
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
    } else {
        [challenge.sender cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _authenticated = YES;
    [self.webView loadRequest:_urlRequest];
    [_urlConnection cancel];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    DLog(@"网页请求完成");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DLog(@"网页请求失败===%@", [error localizedDescription]);
}

@end
