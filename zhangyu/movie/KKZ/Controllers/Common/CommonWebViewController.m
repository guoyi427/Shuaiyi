//
//  CommonWebViewController.m
//  KoMovie
//
//  Created by 艾广华 on 15/12/22.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "CommonSecondWebViewController.h"
#import "CommonWebViewController.h"
#import "DataEngine.h"
#import "KKZUtility.h"
#import "NSStringExtra.h"
#import "PayTask.h"
#import "TaskQueue.h"
#import "UrlOpenUtility.h"
#import <AlipaySDK/AlipaySDK.h>

/*****************需要处理的URL对象***********************/
static NSString *control_URL_Protocol = @"komovie";
static NSString *control_URL_Host = @"app";
static NSString *control_URL_Path = @"/page";

/*****************支付宝处理的对象***********************/
static NSString *apliy_URL_Path = @"/pay";

/*****************关闭按钮**********************/
static CGFloat closeButtonWidth = 50;
static CGFloat closeButtonLeftInset = 20;

@interface CommonWebViewController () <UIWebViewDelegate>

/**
 *  请求的URL字符串
 */
@property (nonatomic, strong) NSString *urlString;

/**
 *  H5协议传过来的参数
 */
@property (nonatomic, strong) NSString *extral2String;

/**
 *  H5协议传过来的参数
 */
@property (nonatomic, strong) NSString *extral1String;

/**
 *  H5协议传过来的名字
 */
@property (nonatomic, strong) NSString *name;

/**
 *  网页的状态
 */
@property (nonatomic, strong) NSString *komovieState;

/**
 *  网页订单状态
 */
@property (nonatomic, strong) NSString *komoviePaystatus;

/**
 *  网页订单成功之后的回调地址
 */
@property (nonatomic, copy) NSString *callBackUrl;

/**
 *  关闭按钮
 */
@property (nonatomic, strong) UIButton *closeButton;
@end

@implementation CommonWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //延伸的布局
    self.edgesForExtendedLayout = UIRectEdgeNone;

    //增加版本信息
    [self addVersionInfoToUserAgent];

    //加载导航条
    [self loadNavBar];

    //加载网页视图
    [self loadWebView];

    //加载滚动轮
    [self loadIndicatorView];
}

#pragma mark - Private Method

- (void)loadNavBar {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)loadWebView {
    //初始化webView对象
    if (self.requestURL) {
        [self loadRequestWithURL:self.requestURL];
    }
    [self.view addSubview:self.webView];
}

- (void)loadIndicatorView {
    [self.view addSubview:self.indicatorView];
}

- (void)refreshRequestWithURL:(NSString *)url {
    [self loadRequestWithURL:url];
}

- (void)loadRequestWithURL:(NSString *)url {

    //加载UIWebView的请求
    url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *requestURL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    NSString *host = requestURL.host;
    if ([host rangeOfString:[self needToAppendDomain]].location != NSNotFound) {
        [self appendRequest:request];
    }
    [self.webView loadRequest:request];

    //加载滚动轮
    [self.indicatorView startAnimating];
}

- (void)loadAiplyRequestWithURL:(NSString *)url {
    NSURL *requestURL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    [request addValue:self.komovieState forHTTPHeaderField:@"Komovie-State"];
    [request addValue:self.komoviePaystatus forHTTPHeaderField:@"Komovie-Paystatus"];
    [self.webView loadRequest:request];
}

- (void)appendRequest:(NSMutableURLRequest *)request {
    NSString *sessinId = [DataEngine sharedDataEngine].sessionId;
    if ([KKZUtility stringIsEmpty:sessinId]) {
        sessinId = @"";
    }
    [request addValue:sessinId forHTTPHeaderField:@"Komovie-Sid"];
    NSString *time = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    [request addValue:time forHTTPHeaderField:@"Komovie-T"];
    NSString *encString = [[NSString stringWithFormat:@"%@koMovie_App_Sid", time] MD5String];
    NSString *finalEncString = [encString MD5String];
    [request addValue:finalEncString forHTTPHeaderField:@"Komovie-Enc"];
}

- (void)addVersionInfoToUserAgent {
    NSString *userAgent = [[[UIWebView alloc] initWithFrame:CGRectZero] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    NSString *suffix = [NSString stringWithFormat:@"komovie_%@_ios", version];

    if ([userAgent rangeOfString:suffix].length <= 0) { // 未添加版本信息
        NSString *customUserAgent = [NSString stringWithFormat:@"%@/%@", userAgent, suffix];
        NSDictionary *dictionary = @{ @"UserAgent" : customUserAgent };
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *requestURL = request.URL;

    //先判断需不需要打开页面
    if ([UrlOpenUtility handleOpenAppUrl:[request URL]]) {
        return NO; //执行本地代码，返回false不让网页读取网络资源
    }

    if (self.browserHierarchy == FirstBrowser) {
        if (![self.urlString isEqualToString:requestURL.absoluteString] && navigationType == UIWebViewNavigationTypeLinkClicked) {
            self.extral2String = requestURL.absoluteString;
            [self jumpToSecondPageController];
            return NO;
        }
    } else if (self.browserHierarchy == SecondBrowse) {
        if ([self.firstWebRequestURL isEqualToString:requestURL.absoluteString]) {
            [self cancelViewController];
            return NO;
        }
    }
    return [self needToControlDomain:requestURL];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.kkzTitleLabel.text = title;
    [self.indicatorView stopAnimating];
    if (self.browserHierarchy == SecondBrowse) {
        [self closeButtonShowOrHidden];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.indicatorView stopAnimating];
}

- (BOOL)needToControlDomain:(NSURL *)URL {
    NSString *scheme = URL.scheme;
    NSString *host = URL.host;
    NSString *path = URL.path;
    if ([scheme isEqualToString:control_URL_Protocol] && [host isEqualToString:control_URL_Host] && [path isEqualToString:control_URL_Path]) {

        //查询的参数
        NSString *query = URL.query;

        //将捕捉到的URL对象转换成字典
        [self paramDictionaryWithQuery:query];

        //判断捕捉的数据类型
        if ([self.name isEqualToString:@"Login"]) {
            if ([self.extral2String isEqualToString:@"1"]) {
                if (appDelegate.isAuthorized) {
                    [appDelegate signout];
                }
                [self needTologin];
            }
            return NO;
        }
    } else if ([scheme isEqualToString:control_URL_Protocol] && [host isEqualToString:control_URL_Host] && [path isEqualToString:apliy_URL_Path]) {
        NSDictionary *paramDic = [self paramDictionaryWithAliData:URL.query];
        NSString *orderNo = [paramDic objectForKey:@"orderNo"]; // 周边订单号
        NSString *notifyUrl = [paramDic objectForKey:@"notifyUrl"]; // 接口参数
        NSString *callBackUrl = [paramDic objectForKey:@"callBackUrl"]; // 接口参数
        self.callBackUrl = callBackUrl; //成功之后的回调地址
        self.komovieState = [NSString stringWithFormat:@"%d", [[paramDic objectForKey:@"komovieState"] intValue]]; //订单状态
        PayTask *task = [[PayTask alloc] initEcshopOrder:orderNo
                                               payMethod:PayMethodAliMoblie
                                             callbackUrl:callBackUrl
                                               notifyUrl:notifyUrl
                                                finished:^(BOOL succeeded, NSDictionary *userInfo) {
                                                    [self payOrderFinished:userInfo
                                                                    status:succeeded];
                                                }];

        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
            [appDelegate showIndicatorWithTitle:@"支付订单"
                                       animated:YES
                                     fullScreen:NO
                                   overKeyboard:NO
                                    andAutoHide:NO];
        }
    }
    return YES;
}

- (void)payOrderFinished:(NSDictionary *)userInfo
                  status:(BOOL)succeeded {
    if (succeeded) {
        NSString *payUrl = [userInfo objectForKey:@"payUrl"];
        NSString *sign = [userInfo objectForKey:@"sign"];
        //调用第三方支付控件
        [self alipayWithUrl:payUrl
                    andSign:sign];
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

- (void)alipayWithUrl:(NSString *)payUrl andSign:(NSString *)paySign {
    //获取安全支付单例并调用安全支付接口
    [appDelegate hideIndicator];
    [[AlipaySDK defaultService] payOrder:paySign
                              fromScheme:kAlipayScheme
                                callback:^(NSDictionary *resultDic) {
                                    
        int stateStaus = [[resultDic objectForKey:@"resultStatus"] intValue];
        if (stateStaus == 9000) {
            self.komoviePaystatus = @"2";
            [self loadAiplyRequestWithURL:self.callBackUrl];
        } else if (stateStaus == 6001) {
            self.komoviePaystatus = @"3";
            [self loadAiplyRequestWithURL:self.callBackUrl];
        } else {
            self.komoviePaystatus = @"3";
            [self loadAiplyRequestWithURL:self.callBackUrl];
        }
    }];
}

- (void)paramDictionaryWithQuery:(NSString *)query {
    NSArray *paramArray = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < paramArray.count; i++) {
        NSString *paramString = paramArray[i];
        NSArray *array = [paramString componentsSeparatedByString:@"="];
        if (array.count > 1) {
            NSString *key = array[0];
            NSString *value = array[1];
            [paramDic setValue:value
                        forKey:key];
        }
    }
    self.name = paramDic[@"name"];
    self.extral1String = paramDic[@"extra1"];
    self.extral2String = paramDic[@"extra2"];
}

- (NSDictionary *)paramDictionaryWithAliData:(NSString *)query {
    NSArray *paramArray = [query componentsSeparatedByString:@"="];
    NSDictionary *paramDic = [[NSDictionary alloc] init];
    if (paramArray.count > 1) {
        NSString *paramString = [paramArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        paramDic = [NSJSONSerialization JSONObjectWithData:[paramString dataUsingEncoding:NSUTF8StringEncoding]
                                                   options:kNilOptions
                                                     error:nil];
    }
    return paramDic;
}

- (void)needTologin {
    [[DataEngine sharedDataEngine] startLoginFinished:^(BOOL succeeded) {
        //readme: 只有当登录成功后才回调url
        if (succeeded) {
            [self loadRequestWithURL:self.extral1String];
        }
    }];
}

- (void)jumpToSecondPageController {
    CommonSecondWebViewController *second = [[CommonSecondWebViewController alloc] init];
    second.browserHierarchy = SecondBrowse;
    second.requestURL = self.extral2String;
    second.firstWebRequestURL = self.requestURL;
    [self pushViewController:second
                   animation:CommonSwitchAnimationBounce];
}

- (void)closeButtonShowOrHidden {

    CGRect titleFrame = self.kkzTitleLabel.frame;
    if ([self.webView canGoBack]) {
        [self.navBarView addSubview:self.closeButton];
        titleFrame.size.width = kCommonScreenWidth - CGRectGetMaxX(self.closeButton.frame) - 60.0f;
        titleFrame.origin.x = CGRectGetMaxX(self.closeButton.frame);
    } else {
        [_closeButton removeFromSuperview];
        titleFrame.size.width = kCommonScreenWidth - 120.0f;
        titleFrame.origin.x = (kCommonScreenWidth - titleFrame.size.width) * 0.5f;
    }
    //    self.kkzTitleLabel.backgroundColor = [UIColor grayColor];
    self.kkzTitleLabel.frame = titleFrame;
    //    self.kkzBackBtn.backgroundColor = [UIColor redColor];
}

- (NSString *)needToAppendDomain {
    return @".komovie.cn";
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.navBarView.frame), kCommonScreenWidth, kCommonScreenHeight - CGRectGetMaxY(self.navBarView.frame))];
        //设置WebView的参数
        [_webView setScalesPageToFit:YES];
        _webView.delegate = self;
    }
    return _webView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.backgroundColor = [UIColor clearColor];
        [_indicatorView setCenter:CGPointMake(kCommonScreenWidth * 0.5f, kCommonScreenHeight * 0.5f)];
    }
    return _indicatorView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:0];
        _closeButton.frame = CGRectMake(CGRectGetMaxX(self.kkzBackBtn.frame) - closeButtonLeftInset, 0, closeButtonWidth, CGRectGetHeight(self.navBarView.frame));
        [_closeButton setTitle:@"关闭"
                      forState:UIControlStateNormal];
        [_closeButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [_closeButton setTitleColor:[UIColor whiteColor]
                           forState:UIControlStateNormal];
        _closeButton.backgroundColor = [UIColor clearColor];
        [_closeButton addTarget:self
                         action:@selector(cancelViewController)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (BOOL)showNavBar {
    return YES;
}

- (void)dealloc {
    //WebView停止请求
    [self.webView stopLoading];
}

/**
 * 重新加载页面。
 */
- (void)reloadPage {
    [self.webView reload];
}

@end
