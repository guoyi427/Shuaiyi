//
//  KKZCommonWebView.m
//  KoMovie
//
//  Created by 艾广华 on 16/3/22.
//  Copyright © 2016年 kokozu. All rights reserved.
//

#import "KKZCommonWebView.h"

#import <WebKit/WebKit.h>

@interface KKZCommonWebView () <WKNavigationDelegate, UIWebViewDelegate>

/**
 *  使用的网页视图
 */
@property (nonatomic, readonly) id realWebView;

/**
 *  原始的请求对象
 */
@property (nonatomic, strong) NSURLRequest *originRequest;

/**
 *  当前的请求
 */
@property (nonatomic, strong) NSURLRequest *currentRequest;

@end

@implementation KKZCommonWebView

@synthesize scalesPageToFit = _scalesPageToFit;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initMyself];
    }
    return self;
}

- (void)_initMyself {
    Class wkWebView = NSClassFromString(@"WKWebView");
    if (wkWebView && self.usingUIWebView == NO) {
        _usingUIWebView = NO;
        [self initWKWebView];
    } else {
        _usingUIWebView = YES;
        [self initUIWebView];
    }
    self.scalesPageToFit = YES;
    [self.realWebView setFrame:self.bounds];
    [self.realWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

    [self addSubview:self.realWebView];
}

- (void)initWKWebView {
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.preferences = [[WKPreferences alloc] init];
    configuration.userContentController = [[WKUserContentController alloc] init];

    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.bounds
                                            configuration:configuration];
    webView.backgroundColor = [UIColor clearColor];
    webView.navigationDelegate = self;
    webView.opaque = NO;
    _realWebView = webView;
}

- (void)initUIWebView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.bounds];
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    webView.delegate = self;
    for (UIView *subview in [webView.scrollView subviews]) {
        if ([subview isKindOfClass:[UIImageView class]]) {
            ((UIImageView *) subview).image = nil;
            subview.backgroundColor = [UIColor clearColor];
        }
    }
    _realWebView = webView;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (self.originRequest == nil) {
        self.originRequest = webView.request;
    }

    [self callback_webViewDidFinishLoad];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self callback_webViewDidStartLoad];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self callback_webViewDidFailLoadWithError:error];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    BOOL resultBOOL = [self callback_webViewShouldStartLoadWithRequest:request navigationType:navigationType];
    return resultBOOL;
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self callback_webViewDidFinishLoad];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self callback_webViewDidStartLoad];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self callback_webViewDidFailLoadWithError:error];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self callback_webViewDidFailLoadWithError:error];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    BOOL resultBOOL = [self callback_webViewShouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType];
    if (resultBOOL) {
        self.currentRequest = navigationAction.request;
        if (navigationAction.targetFrame == nil) {
            [webView loadRequest:navigationAction.request];
        }
        decisionHandler(WKNavigationActionPolicyAllow);
    } else {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

#pragma mark - IMYWebViewDelegate
- (void)callback_webViewDidFinishLoad {
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:self];
    }
}

- (void)callback_webViewDidStartLoad {
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:self];
    }
}

- (void)callback_webViewDidFailLoadWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:self didFailLoadWithError:error];
    }
}

- (BOOL)callback_webViewShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(NSInteger)navigationType {
    BOOL resultBOOL = YES;
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        if (navigationType == -1) {
            navigationType = UIWebViewNavigationTypeOther;
        }
        resultBOOL = [self.delegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return resultBOOL;
}

#pragma mark - common method
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler {
    if (_usingUIWebView) {
        NSString *result = [(UIWebView *) self.realWebView stringByEvaluatingJavaScriptFromString:javaScriptString];
        if (completionHandler) {
            completionHandler(result, nil);
        }
    } else {
        return [(WKWebView *) self.realWebView evaluateJavaScript:javaScriptString
                                                completionHandler:completionHandler];
    }
}

- (id)loadRequest:(NSURLRequest *)request {
    self.currentRequest = request;
    if (_usingUIWebView) {
        [(UIWebView *) self.realWebView loadRequest:request];
        return nil;
    } else {
        return [(WKWebView *) self.realWebView loadRequest:request];
    }
}

- (id)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL {
    if (_usingUIWebView) {
        [(UIWebView *) self.realWebView loadHTMLString:string baseURL:baseURL];
        return nil;
    }
    return [(WKWebView *) self.realWebView loadHTMLString:string baseURL:baseURL];
}

- (id)goBack {
    if (_usingUIWebView) {
        [(UIWebView *) self.realWebView goBack];
        return nil;
    } else {
        return [(WKWebView *) self.realWebView goBack];
    }
}

- (id)goForward {
    if (_usingUIWebView) {
        [(UIWebView *) self.realWebView goForward];
        return nil;
    } else {
        return [(WKWebView *) self.realWebView goForward];
    }
}

- (id)reload {
    if (_usingUIWebView) {
        [(UIWebView *) self.realWebView reload];
        return nil;
    } else {
        return [(WKWebView *) self.realWebView reload];
    }
}

- (void)stopLoading {
    [self.realWebView stopLoading];
}

#pragma mark - setter method
- (void)setScalesPageToFit:(BOOL)scalesPageToFit {
    if (_usingUIWebView) {
        UIWebView *webView = _realWebView;
        webView.scalesPageToFit = scalesPageToFit;
    } else {
        if (_scalesPageToFit == scalesPageToFit) {
            return;
        }

        WKWebView *webView = _realWebView;

        NSString *jScript = @"var meta = document.createElement('meta'); \
        meta.name = 'viewport'; \
        meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'; \
        var head = document.getElementsByTagName('head')[0];\
        head.appendChild(meta);";

        if (scalesPageToFit) {
            WKUserScript *wkUScript = [[NSClassFromString(@"WKUserScript") alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
            [webView.configuration.userContentController addUserScript:wkUScript];
        } else {
            NSMutableArray *array = [NSMutableArray arrayWithArray:webView.configuration.userContentController.userScripts];
            for (WKUserScript *wkUScript in array) {
                if ([wkUScript.source isEqual:jScript]) {
                    [array removeObject:wkUScript];
                    break;
                }
            }
            for (WKUserScript *wkUScript in array) {
                [webView.configuration.userContentController addUserScript:wkUScript];
            }
        }
    }

    _scalesPageToFit = scalesPageToFit;
}

#pragma mark - getter method
- (UIScrollView *)scrollView {
    return [self.realWebView scrollView];
}

- (BOOL)scalesPageToFit {
    if (_usingUIWebView) {
        return [_realWebView scalesPageToFit];
    } else {
        return _scalesPageToFit;
    }
}

- (NSURL *)URL {
    if (_usingUIWebView) {
        return [(UIWebView *) self.realWebView request].URL;
    }
    return [(WKWebView *) self.realWebView URL];
}

- (BOOL)isLoading {
    return [self.realWebView isLoading];
}

- (BOOL)canGoBack {
    return [self.realWebView canGoBack];
}

- (BOOL)canGoForward {
    return [self.realWebView canGoForward];
}

- (NSURLRequest *)currentRequest {
    if (_usingUIWebView) {
        return [(UIWebView *) self.realWebView request];
        ;
    } else {
        return _currentRequest;
    }
}

#pragma mark - 清理
- (void)dealloc {
    if (_usingUIWebView) {
        UIWebView *webView = _realWebView;
        webView.delegate = nil;
    } else {
        WKWebView *webView = _realWebView;
        webView.navigationDelegate = nil;
    }
    [_realWebView scrollView].delegate = nil;
    [_realWebView stopLoading];
    [_realWebView removeFromSuperview];
    _realWebView = nil;
}

@end
