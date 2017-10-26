//
//  京东支付页面
//
//  Created by KKZ on 15/10/28.
//  Copyright © 2015年 Ariadne’s Thread Co., Ltd. All rights reserved.
//

#import "CommonViewController.h"
#import "JDPayViewController.h"
#import "OrderPayViewController.h"

#define kJDPayConfirm @"https://m.jdpay.com/wepay/web/pay/confirm"

@interface JDPayViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation JDPayViewController

#pragma mark - Lifecycle methods
- (void)viewDidLoad {
    [super viewDidLoad];

    self.kkzTitleLabel.text = @"京东支付";

    [self.view addSubview:self.webView];
}

#pragma mark Init views
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.contentPositionY + 44, screentWith, screentContentHeight - 44)];
        _webView.delegate = self;
        [_webView setScalesPageToFit:YES];
    }
    return _webView;
}

#pragma mark - Public methods
- (void)loadURL:(NSString *)url {
    NSURL *nsURL = [NSURL URLWithString:url];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:nsURL];
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    [self.webView loadRequest:request];
}

#pragma mark - UIWebView delegate methods
- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSString *urlString = [[request URL] absoluteString];

    if ([urlString hasPrefix:kJDPayConfirm]) {
        self.kkzBackBtn.hidden = YES;
    }

    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        DLog(@"callback Url ------%@", urlString);

        // komovie://payBackUrl?tradeNum=
        if ([urlString hasPrefix:[NSString stringWithFormat:@"%@?tradeNum=", self.key]]) {
            [self popViewControllerAnimated:YES];
            return NO;
        }
        // komovie://payBackUrl?token=
        else if ([urlString hasPrefix:[NSString stringWithFormat:@"%@?token=", self.key]]) {
            OrderPayViewController *ctr = [[OrderPayViewController alloc] initWithOrder:self.orderNo];
            [self pushViewController:ctr animation:CommonSwitchAnimationSwipeR2L];
            return NO;
        }
    }
    return YES;
}

#pragma mark - Override from CommonViewController methods
- (void)cancelViewController {
    [UIAlertView showAlertView:@"是否要放弃本次交易"
                    cancelText:@"取消"
                  cancelTapped:nil
                        okText:@"确定"
                      okTapped:^{

                          [super cancelViewController];
                      }];
}

@end
