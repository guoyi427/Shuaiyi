//
//  MallViewController.m
//  CIASMovie
//
//  Created by cias on 2016/12/7.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "MallViewController.h"
#import "DataEngine.h"
#import <Category_KKZ/NSStringExtra.h>

@interface MallViewController ()<UIWebViewDelegate>
{
     UILabel        * titleLabel;
}

@property (nonatomic, strong) UIView         *titleViewOfBar;

@end

@implementation MallViewController


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController.view removeGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
    //延伸的布局
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if (Constants.isAuthorized) {
        
    } else {
        
        //加载网页视图
        [self loadWebView];
        
        //加载滚动轮
        [self loadIndicatorView];

    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.navigationController.view addGestureRecognizer:self.navigationController.interactivePopGestureRecognizer];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.hideNavigationBar = YES;
    self.hideBackBtn = YES;
    [self setNavBarUI];
    
    //加载网页视图
    [self loadWebView];

    //加载滚动轮
    [self loadIndicatorView];
}

- (void)loadIndicatorView {
    [self.view addSubview:self.indicatorView];
}

- (void)loadWebView {
    //初始化webView对象
    NSString *userIdStr = [DataEngine sharedDataEngine].userId;
    NSString *userMoble = userIdStr.length>0? userIdStr:@"-1";
    NSString *tmpStr = [NSString stringWithFormat:@"%@%@", userMoble,@"ugbs53245b"];
    NSString *enc = [[tmpStr MD5String] lowercaseString];
    NSString *urlStr = [NSString stringWithFormat:@"http://ysp.komovie.cn/mobile/?cias_channel_id=%@&user_mobile=%@&enc=%@", @"6", userMoble, enc];
    [self loadRequestWithURL:urlStr];
    
    [self.view addSubview:self.webView];
    
}

- (void)loadRequestWithURL:(NSString *)url {
    
    //加载UIWebView的请求
    url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *requestURL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
    //        NSString *host = requestURL.host;
    //        if ([host rangeOfString:[self needToAppendDomain]].location != NSNotFound) {
    //            [self appendRequest:request];
    //        }
    [self.webView loadRequest:request];
    
    //加载滚动轮
    [self.indicatorView startAnimating];
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


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *requestURL = request.URL;
    NSString *currentUrlStr = webView.request.URL.absoluteString;
    //先判断需不需要打开页面
    NSString *urlString = [requestURL absoluteString];
    DLog(@"currentUrl : %@", currentUrlStr);
    DLog(@"callback url : %@", urlString);
    
    //MARK: --区分需不需要登录,先判断是否有? 才能进行截取，否则会报错
    if ([urlString containsString:@"?"]) {
        NSArray *paramsTmp = [urlString componentsSeparatedByString:@"?"];
        NSArray *params = [paramsTmp[1] componentsSeparatedByString:@"&"];
        DLog(@"urlString中的参数:%@", params);
        NSString *linkUrlName = @"";
        NSArray *nameArr = [[NSArray alloc] init];
        //根据name区分是影片详情还是排期列表
        if (params.count > 0) {
            for (NSString *str in params) {
                nameArr = [str componentsSeparatedByString:@"="];
                linkUrlName = nameArr[1];
                DLog(@"%@", linkUrlName);
                if ([linkUrlName isEqualToString:@"login"]) {
                    [[DataEngine sharedDataEngine] startLoginWith:YES withFinished:^(BOOL succeeded) {
                        
                        NSString *userMoble = [DataEngine sharedDataEngine].userId;
                        NSString *tmpStr = [NSString stringWithFormat:@"%@%@", userMoble,@"ugbs53245b"];
                        NSString *enc = [[tmpStr MD5String] lowercaseString];
                        NSString *urlStr = [NSString stringWithFormat:@"%@&cias_channel_id=%@&user_mobile=%@&enc=%@",currentUrlStr, @"6",userMoble, enc];
                        [self loadRequestWithURL:urlStr];
                    }];
                    return NO;
                }
            }
        }
    } else {
        //没有?，返回的是首页，之前已经加过用户信息，这里不需要再加了
//        NSString *userMoble = [DataEngine sharedDataEngine].userId;
//        NSString *tmpStr = [NSString stringWithFormat:@"%@%@", userMoble,@"ugbs53245b"];
//        NSString *enc = [[tmpStr MD5String] lowercaseString];
//        NSString *urlStr = [NSString stringWithFormat:@"%@/?cias_channel_id=%@&user_mobile=%@&enc=%@",urlString, @"6",userMoble, enc];
//        [self loadRequestWithURL:urlStr];
    }
    
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.indicatorView stopAnimating];
}


- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 69, kCommonScreenWidth, kCommonScreenHeight-64-49)];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
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

- (void)setNavBarUI{
    UINavigationBar *bar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, kCommonScreenWidth, 69)];
    [bar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:[UIConstants sharedDataEngine].navigationBarBackgroundColor]]
             forBarPosition:UIBarPositionAny
                 barMetrics:UIBarMetricsDefault];
    [self.view addSubview:bar];
    bar.alpha = 1.0;
    self.navBar = bar;
    UIView *barLine = [[UIView alloc]initWithFrame:CGRectMake(0, 68.5, kCommonScreenWidth, 0.5)];
    barLine.backgroundColor = [UIColor colorWithHex:@"#e0e0e0"];
    [bar addSubview:barLine];
    
    
    [self.view addSubview:self.titleViewOfBar];
    titleLabel.text = [NSString stringWithFormat:@"%@", @"商城"];
    
}
//MARK: 初始化导航栏标题
- (UIView *)titleViewOfBar {
    if (!_titleViewOfBar) {
        NSString *titleStr = @"绑定未来影院通州北苑...";
        CGSize titleStrSize = [KKZTextUtility measureText:titleStr size:CGSizeMake(500, 500) font:[UIFont systemFontOfSize:18]];
        _titleViewOfBar = [[UIView alloc] initWithFrame:CGRectMake(60, 30, kCommonScreenWidth - 60*2, titleStrSize.height)];
        titleLabel = [[UILabel alloc] init];
        [_titleViewOfBar addSubview:titleLabel];
        
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = titleStr;
        titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        titleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleViewOfBar.mas_left).offset((kCommonScreenWidth - 60*2 - titleStrSize.width)/2);
            make.top.bottom.equalTo(_titleViewOfBar);
            make.size.mas_offset(CGSizeMake(titleStrSize.width+5, titleStrSize.height));
        }];
    }
    return _titleViewOfBar;
}



/**
 *  MARK: 返回按钮->会员卡列表页
 */
- (void)backItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
