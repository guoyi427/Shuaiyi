//
//  WebViewController.m
//
//  Created by zhang da on 12-8-15.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "CacheEngine.h"
#import "DataEngine.h"
#import "DataEngine.h"
#import "DateEngine.h"
#import "DirectBroadcastingController.h"
#import "EGORefreshTableHeaderView.h"
#import "ImageEngine.h"
#import "LocationEngine.h"
#import "NSStringExtra.h"
#import "NotificationEngine.h"
#import "PayTask.h"
#import "ShareView.h"
#import "TaskQueue.h"
#import "UIConstants.h"
#import "UrlOpenUtility.h"
#import "UserDefault.h"
#import "WebViewController.h"
#import "XMLampText.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UserManager.h"

/**
 * 是否记录网页加载的日志。
 */
static const BOOL LOGABLE = YES;

/**
 * 打印日志的标签。
 */
static NSString *const TAG = @"WebViewController:";

/**
 * 唤起支付的 URL 前缀。
 */
static NSString *const PAY_URL_PREFIX = @"ZhangYu://app/pay?data=";

/**
 * Komovie 的域名。
 */
static NSString *const KOMOVIE_HOST = @"zhangyu.cn";

@interface WebViewController ()

/**
 * 标题栏文字。
 */
@property (nonatomic, strong) XMLampText *webTitleLabel;

/**
 * 关闭按钮。
 */
@property (nonatomic, strong) UIButton *closeBtn;

/**
 * UIWebView。
 */
@property (nonatomic, strong) UIWebView *webView;

/**
 * UIScrollView。
 */
@property (nonatomic, strong) UIScrollView *webHolder;

/**
 * 进入页面时原始的 UserAgent 值。
 */
@property (nonatomic, strong) NSString *originalUserAgent;

/**
 * 登录的回调地址。
 */
@property (nonatomic, copy) NSString *loginCallbackUrl;

/**
 * 支付的回调地址。
 */
@property (nonatomic, copy) NSString *payCallbackUrl;

/**
 * 支付的状态，该值原样返回给 H5
 */
@property (nonatomic, copy) NSString *payKomovieState;

/**
 * 打印日志的 FileManager。
 */
@property (nonatomic, strong) NSFileManager *logFileManager;

/**
 * 日志文件的目录。
 */
@property (nonatomic, copy) NSString *logFileDirectory;

/**
 * 日志文件的路径。
 */
@property (nonatomic, copy) NSString *logFilePath;

/**
 * 网页加载的起始时间。
 */
@property (nonatomic, strong) NSDate *startDate;

/**
 * 网页加载的结束时间。
 */
@property (nonatomic, strong) NSDate *endDate;

@end

@implementation WebViewController

#pragma mark - Initialize methods
- (id)init {
    self = [super init];
    if (self) {

        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [[NSURLCache sharedURLCache] setDiskCapacity:0];
        [[NSURLCache sharedURLCache] setMemoryCapacity:0];

        [self addVersionInfoToUserAgent];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title {
    if (self) {
        self.webTitle = title;
    }
    self = [self init];
    return self;
}

#pragma mark - UIViewController lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self.navBarView addSubview:self.webTitleLabel];
    [self settingTitleLabelWidth];

    self.closeBtn.hidden = YES;
    [self.navBarView addSubview:self.closeBtn];

    [self.view addSubview:self.webView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingCloseBtnVisibility) name:@"appBecomeActive" object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"appBecomeActive" object:nil];

    // 重置 WebView 的 UserAgent 的值
    NSDictionary *dictionary = @{ @"UserAgent" : self.originalUserAgent };
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];

    [self.webView stopLoading];

    self.webHolder.delegate = nil;
    self.webHolder = nil;
    self.webView.delegate = nil;
    self.webView = nil;
    self.indicatorView = nil;
}

#pragma mark Init Views
- (XMLampText *)webTitleLabel {
    if (!_webTitleLabel) {
        _webTitleLabel = [[XMLampText alloc] initWithFrame:CGRectMake(0, 20, screentWith - 45 * 2, 44.0)];
        _webTitleLabel.lineBreakMode = NSLineBreakByClipping;
        _webTitleLabel.lampText = self.webTitle;
        _webTitleLabel.lampFont = [UIFont systemFontOfSize:15];
        _webTitleLabel.textAlignment = NSTextAlignmentCenter;
        _webTitleLabel.textColor = [UIColor whiteColor];
        _webTitleLabel.backgroundColor = [UIColor clearColor];
        _webTitleLabel.motionWidth = screentWith - 45 * 2;
    }
    return _webTitleLabel;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(44, 20, 44, 44);
        [_closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _closeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        _closeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_closeBtn addTarget:self action:@selector(closeViewController) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.hidden = YES;
    }
    return _closeBtn;
}

- (UIWebView *)webView {
    if (!_webView) {
        CGFloat top = runningOniOS7 ? 20 : 0;
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, top + 44, screentWith, screentContentHeight - 44)];
        _webView.delegate = self;
        [_webView setScalesPageToFit:YES];
    }
    return _webView;
}

- (UIScrollView *)webHolder {
    if (!_webHolder) {
        NSArray *views = [self.webView subviews];
        for (UIView *view in views) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                _webHolder = (UIScrollView *) view;
                break;
            }
        }

        if (_webHolder) {
            _webHolder.backgroundColor = [UIColor clearColor];
            _webHolder.delegate = self;
            _webHolder.showsVerticalScrollIndicator = NO;
        }
    }
    return _webHolder;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_indicatorView setCenter:self.webView.center];
        [self.view addSubview:_indicatorView];
    }
    return _indicatorView;
}

#pragma mark - Public methods
- (void)loadURL:(NSString *)url {
    [self loadRequestWithURL:url];
}

/**
 * 加载指定的 URL。不使用本地缓存。
 *
 * @param url URL 地址
 */
- (void)loadRequestWithURL:(NSString *)url {
    [self loadRequestWithURL:url useCache:NO];
}

/**
 * 加载指定的 URL。
 *
 * @param url      URL 地址
 * @param useCache 是否使用本地缓存
 */
- (void)loadRequestWithURL:(NSString *)url useCache:(BOOL)useCache {
    NSURL *nsUrl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:nsUrl];
    [self loadRequest:request useCache:useCache];
}

/**
 * 加载指定的 URL。不使用本地缓存。
 *
 * @param request 页面加载的 URL
 */
- (void)loadRequest:(NSURLRequest *)request {
    [self loadRequest:request useCache:NO];
}

/**
 * 加载指定的 URL。
 *
 * @param request  页面加载的 URL
 * @param useCache 是否使用本地缓存
 */
- (void)loadRequest:(NSURLRequest *)request useCache:(BOOL)useCache {
    NSMutableURLRequest *mutableRequest = [request mutableCopy];

    if (!useCache) { // 不使用本地缓存
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
        mutableRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        mutableRequest.timeoutInterval = 0;
    } else {
        mutableRequest.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
        mutableRequest.timeoutInterval = 600;
    }

    if ([self isKomovieHostUrl:request.URL]) { // 添加 Header
        NSString *sessionId = [DataEngine sharedDataEngine].sessionId.length ? [DataEngine sharedDataEngine].sessionId : @"";
        NSString *timestamp = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970] * 1000]];
        NSString *enc = [[[NSString stringWithFormat:@"%@koMovie_App_Sid", timestamp] MD5String] MD5String];

        [mutableRequest addValue:sessionId forHTTPHeaderField:@"Komovie-Sid"];
        [mutableRequest addValue:timestamp forHTTPHeaderField:@"Komovie-T"];
        [mutableRequest addValue:enc forHTTPHeaderField:@"Komovie-Enc"];
    }

    [self.webView loadRequest:mutableRequest];
}

#pragma mark - SubViewController useful methods
- (void)webBack {
    if ([self webCanGoBack]) {
        [self.webView goBack];
    } else {
        [self closeViewController];
    }
}

- (void)webForward {
    [self.webView goForward];
}

- (BOOL)webCanGoBack {
    return [self.webView canGoBack];
}

/**
 * 重新加载页面。
 */
- (void)reloadPage {
    [self.webView reload];
}

#pragma mark - UIWebViewDelegate Methods
- (void)webViewDidStartLoad:(UIWebView *)aWebView {
    [self settingCloseBtnVisibility];
    [self.indicatorView startAnimating];

    self.startDate = [NSDate date];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    [self settingCloseBtnVisibility];
    [self resetRefreshHeader];
    [self.indicatorView stopAnimating];

    [self setWebTitle:[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"]];

    self.endDate = [NSDate date];

    if (LOGABLE) {
        [self writeWebViewLogger:aWebView.request.URL.absoluteString];
    }
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error {
    [self resetRefreshHeader];
    [self.indicatorView stopAnimating];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSString *urlString = [[request URL] absoluteString];

    if ([urlString isEqualToString:@"about:blank"]) {
        return NO;
    }

    // 唤起APP支付
    if ([urlString hasPrefix:PAY_URL_PREFIX]) {
        NSString *data = [urlString substringFromIndex:[PAY_URL_PREFIX length]];
        DLog(@"%@ received pay url: %@, data: %@", TAG, urlString, data);
        [self handleAppPay:data];
        return NO;
    }
    // 跳转到登录页面
    else if ([urlString hasPrefix:@"ZhangYu://app/page?name=Login"]) {
        [self navigateToLogin:urlString];
        return NO;
    }
    // 唤起本地的页面
    else if ([UrlOpenUtility handleOpenAppUrl:[request URL]]) {
        [self resetRefreshHeader];
        return NO;
    }

    return YES;
}

#pragma mark Handle pay order url
// 处理周边订单的支付
- (void)handleAppPay:(NSString *)data {
    __weak typeof(self) weakself = self;

    NSDictionary *response = (NSDictionary *) data;
    NSString *orderNo = [response objectForKey:@"orderNo"]; // 周边订单号
    NSString *notifyUrl = [response objectForKey:@"notifyUrl"]; // 接口参数
    weakself.payKomovieState = [response objectForKey:@"komovieState"]; // 原样返回给H5页面
    weakself.payCallbackUrl = [response objectForKey:@"callBackUrl"]; // 接口参数

    DLog(@"%@ from JS pay, orderNo: %@, komovieState: %@, notifyUrl: %@, callBackUrl: %@", TAG, orderNo, weakself.payKomovieState, notifyUrl, weakself.payCallbackUrl);

    PayTask *task = [[PayTask alloc] initEcshopOrder:orderNo
                                           payMethod:PayMethodAliMoblie
                                         callbackUrl:weakself.payCallbackUrl
                                           notifyUrl:notifyUrl
                                            finished:^(BOOL succeeded, NSDictionary *userInfo) {

                                                [weakself payOrderFinished:userInfo status:succeeded callbackUrl:weakself.payCallbackUrl state:weakself.payKomovieState];
                                            }];

    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
        [appDelegate showIndicatorWithTitle:@"支付订单"
                                   animated:YES
                                 fullScreen:NO
                               overKeyboard:NO
                                andAutoHide:NO];
    }
}

// 订单支付完成
- (void)payOrderFinished:(NSDictionary *)userInfo status:(BOOL)succeeded callbackUrl:(NSString *)callbackUrl state:(NSString *)komovieState {

    [appDelegate hideIndicator];
    if (succeeded) {
        NSString *payUrl = [userInfo objectForKey:@"payUrl"];
        NSString *sign = [userInfo objectForKey:@"sign"];
        [self callAlipayWithUrl:payUrl sign:sign callbackUrl:callbackUrl state:komovieState];
    } else {
        [appDelegate showAlertViewForTaskInfo:userInfo];
    }
}

//唤起支付宝支付订单
- (void)callAlipayWithUrl:(NSString *)payUrl
                     sign:(NSString *)sign
              callbackUrl:(NSString *)callbackUrl
                    state:(NSString *)komovieState {

    //获取安全支付单例并调用安全支付接口
    [[AlipaySDK defaultService] payOrder:sign
                              fromScheme:kAlipayScheme
                                callback:^(NSDictionary *resultDic) {

            DLog(@"%@ pay reslut: %@", TAG, resultDic);

            int stateStaus = [[resultDic objectForKey:@"resultStatus"] intValue];
            if (stateStaus == 9000) { //支付成功
                [self callbackPayResult:2 state:komovieState];
            }
            else {
                [self callbackPayResult:3 state:komovieState];
            }
    }];
}

// 回调支付完成的结果
- (void)callbackPayResult:(NSUInteger)payStatus state:(NSString *)komovieState {
    NSURL *url = [NSURL URLWithString:self.payCallbackUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:self.payKomovieState forHTTPHeaderField:@"Komovie-State"];
    [request addValue:[NSString stringWithFormat:@"%lu", payStatus] forHTTPHeaderField:@"Komovie-Paystatus"];
    [self loadRequest:request];
}

#pragma mark Handle navigate to login
// 判定是否需要登录 komovie://app/page?name=Login&extra1=[callbackUrl]&extra2=1
- (void)navigateToLogin:(NSString *)url {
    if ([url hasPrefix:@"ZhangYu://app/page?name=Login"]) {
        NSDictionary *dictParams = [self queryParamsFromUrl:url];
        NSString *extra1 = [dictParams kkz_stringForKey:@"extra1"];
        self.loginCallbackUrl = [extra1 URLDecodedString];
        NSString *extra2 = [dictParams kkz_stringForKey:@"extra2"];

        if ([extra2 isEqualToString:@"1"]) { // 强制登录，退出当前登录，跳转到登录页面
            [appDelegate signout];
            [self performSelector:@selector(gotoLogin) withObject:nil afterDelay:0.3];
        } else {
            if (!appDelegate.isAuthorized) { // 未登录，跳转到登录页面
                [self gotoLogin];
            } else { // 已登录，打开回调的地址，并且传递 sessionId
                if (self.loginCallbackUrl != nil && self.loginCallbackUrl != NULL) {
                    [self loadURL:self.loginCallbackUrl];
                }
            }
        }
    } else {
        [self loadURL:url];
    }
}

// 跳转到登录页面
- (void)gotoLogin {
    [[UserManager shareInstance] gotoLoginControllerFrom:self loginDelegate:self];
}

#pragma mark Login delegate
- (void)loginControllerLoginSucceed {
    if (self.loginCallbackUrl.length) {
        [self loadURL:self.loginCallbackUrl];
    } else {
        [self cancelViewController];
    }
}

- (void)loginControllerLoginCancelled {
    if (self.webView.request.URL == nil) {
        [self cancelViewController];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)resetRefreshHeader {
    [UIView animateWithDuration:0.3f
            delay:0.0f
            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
            animations:^{
                self.webHolder.contentInset = UIEdgeInsetsZero;
            }
            completion:^(BOOL finished) {
                if (self.webHolder.contentOffset.y <= 0) {
                    [self.webHolder setContentOffset:CGPointZero animated:YES];
                }
            }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isDragging) {
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}

#pragma mark - Logger
// 记录 WebView 加载的日志
- (void)writeWebViewLogger:(NSString *)url {
    [self initLogFileManagerIfNecessary];
    [self limitLogFileSize];

    if ([self.logFileManager fileExistsAtPath:self.logFilePath isDirectory:NULL]) {
        NSFileHandle *outFile;
        NSData *buffer;
        outFile = [NSFileHandle fileHandleForWritingAtPath:self.logFilePath];
        // 找到并定位到outFile的末尾位置(在此后追加文件)
        [outFile seekToEndOfFile];
        NSString *currentUrlStrChi = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *userLogInfoStrStart = [NSString stringWithFormat:@"网址：%@,请求开始时间：%@,请求结束时间：%@,请求时长：%f", currentUrlStrChi, self.startDate, self.endDate, 0 - [self.startDate timeIntervalSinceNow]];
        NSString *temp = [NSString stringWithFormat:@"\n%@", userLogInfoStrStart];
        buffer = [temp dataUsingEncoding:NSUTF8StringEncoding];
        [outFile writeData:buffer];
        [outFile closeFile];
    }
}

// 如果需要初始化日志文件的 FileManager
- (void)initLogFileManagerIfNecessary {
    if (self.logFileManager != nil && self.logFilePath != nil &&
        [self.logFileManager fileExistsAtPath:self.logFilePath
                                  isDirectory:NULL]) {
        return;
    }

    self.logFileManager = [NSFileManager defaultManager]; // 创建文件管理器
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *userLogDocumentsDirectory = [[documentPaths objectAtIndex:0] stringByAppendingString:@"/"];
    self.logFileDirectory = [userLogDocumentsDirectory stringByAppendingPathComponent:@"WebViewLog/"];
    self.logFilePath = [NSString stringWithFormat:@"WebViewLog/%@", [[DateEngine sharedDateEngine] stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd"]];
    self.logFilePath = [userLogDocumentsDirectory stringByAppendingPathComponent:self.logFilePath];

    [self initLogFile];
}

// 初始化日志文件
- (void)initLogFile {
    if (![self.logFileManager fileExistsAtPath:self.logFilePath isDirectory:NULL]) {
        NSError *error;
        [self.logFileManager removeItemAtPath:self.logFileDirectory error:&error];
        [self.logFileManager createDirectoryAtPath:self.logFileDirectory
                       withIntermediateDirectories:NO
                                        attributes:nil
                                             error:&error];
        // 写入第一行文字
        [@"KoMovieiOS" writeToFile:self.logFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    }
}

// 限制日志文件的大小，超过5M清除掉
- (void)limitLogFileSize {
    if ([self.logFileManager fileExistsAtPath:self.logFilePath isDirectory:NULL]) {
        long cacheSizeMB = [[CacheEngine sharedCacheEngine] diskCacheSizeMBOfUserlog];
        if ([self.logFileManager fileExistsAtPath:self.logFilePath] && cacheSizeMB > 5) {
            [self.logFileManager removeItemAtPath:self.logFilePath error:nil];
            [self initLogFile];
        }
    }
}

#pragma mark - Override from parent ViewController
- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return YES;
}

- (BOOL)showTitleBar {
    return NO;
}

- (void)cancelViewController {
    if ([self webCanGoBack]) {
        [self.webView goBack];
    } else {
        [super cancelViewController];
    }
}

- (void)closeViewController {
    [super cancelViewController];
}

#pragma mark - Private methods
// 判断 URL 是否为 komovie 域名的页面
- (BOOL)isKomovieHostUrl:(NSURL *)url {
    NSString *host = url.host;
    DLog(@"%@ 域名: %@", TAG, host);
    return [host hasSuffix:KOMOVIE_HOST];
}

// 把版本信息添加到浏览器的 UA 里面
- (void)addVersionInfoToUserAgent {
    NSString *userAgent = [[[UIWebView alloc] initWithFrame:CGRectZero] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    self.originalUserAgent = userAgent;
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    NSString *suffix = [NSString stringWithFormat:@"komovie_%@_ios", version];

    if ([userAgent rangeOfString:suffix].length <= 0) { // 未添加版本信息
        NSString *customUserAgent = [NSString stringWithFormat:@"%@/%@", userAgent, suffix];
        NSDictionary *dictionary = @{ @"UserAgent" : customUserAgent };
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
    }
}

// 设置页面的标题
- (void)setWebTitle:(NSString *)title {
    _webTitle = title;
    self.webTitleLabel.lampText = title;
}

// 解析 URL 的参数列表
- (NSDictionary *)queryParamsFromUrl:(NSString *)url {
    NSArray *contents = [url componentsSeparatedByString:@"?"];
    NSString *body = contents.count > 1 ? (NSString *) [contents objectAtIndex:1] : @"";
    NSArray *params = [body componentsSeparatedByString:@"&"];
    NSMutableDictionary *dictParams = [NSMutableDictionary dictionaryWithCapacity:0];
    for (int i = 0; i < params.count; i++) {
        NSArray *dictParamArray = [params[i] componentsSeparatedByString:@"="];
        NSString *dictParamKey = dictParamArray[0];
        if (dictParamKey.length > 0) {
            NSString *dictParamValue = dictParamArray[1];
            if (dictParamValue.length > 0) {
                dictParams[dictParamArray[0]] = dictParamValue;
            }
        }
    }

    return dictParams;
}

// 配置关闭按钮是否可见
- (void)settingCloseBtnVisibility {
    self.closeBtn.hidden = ![self webCanGoBack];
    [self settingTitleLabelWidth];
}

- (void)settingTitleLabelWidth {
    CGFloat left, width;
    if ([self webCanGoBack]) { // 可以返回上一页，关闭按钮显示
        left = 92;
        width = screentWith - 92 * 2;
    } else {
        left = 45;
        width = screentWith - 45 * 2;
    }

    CGRect titleRect =
            [self.webTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:15] }
                                        context:nil];

    if (titleRect.size.width > width) {
        width = titleRect.size.width;
    }
    CGRect frame = self.webTitleLabel.frame;
    frame.size.width = width;
    self.webTitleLabel.frame = frame;

    self.webTitleLabel.motionWidth = width;
    self.webTitleLabel.frame = CGRectMake(left, 20, width, 44);
}

@end
