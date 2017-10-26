//
//  CommentSucceedViewController.m
//  KoMovie
//
//  Created by KKZ on 15/11/3.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "CommentSucceedViewController.h"
#import "ImageEngine.h"
#import "ShareView.h"

@interface CommentSucceedViewController ()

@end

@implementation CommentSucceedViewController

- (void)dealloc {

    webHolder.delegate = nil;
    webHolder = nil;

    web.delegate = nil;
    web = nil;
}

- (id)init {
    self = [super init];
    if (self) {
        [self addVersionInfoToUserAgent];
        CGFloat viewPositionY = runningOniOS7 ? 20 : 0;
        web = [[UIWebView alloc] initWithFrame:CGRectMake(0, viewPositionY + 44, screentWith, screentContentHeight - 44)];

        web.delegate = self;

        [web setScalesPageToFit:YES];
    }
    return self;
}

#pragma mark - Utilities
// 把版本信息添加到浏览器的 UA 里面
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

- (void)viewDidLoad {
    [super viewDidLoad];

    backBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    backBtn.frame = CGRectMake(0, 3, 60, 38);

    [backBtn setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];

    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(9.5, 11, 9, 29)];

    [backBtn addTarget:self action:@selector(cancelViewController) forControlEvents:UIControlEventTouchUpInside];

    [self.navBarView addSubview:backBtn];

    //右边分享按钮
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(screentWith - 60, 0, 60, 40);
    [rightBtn setImage:[UIImage imageNamed:@"cinema_Ticket_share"] forState:UIControlStateNormal];
    [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 25, 10, 15)];
    [rightBtn addTarget:self action:@selector(shareToWeiXin) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:rightBtn];

    // 标题

    self.kkzTitleLabel.text = @"评论成功";

    [self.view addSubview:web];
}

- (void)shareToWeiXin {

    UIImageView *imgV = [[UIImageView alloc] init];

    [imgV loadImageWithURL:self.sharePicUrl andSize:ImageSizeSmall];
    [[ShareEngine shareEngine] shareToWeiXin:self.shareContent
                                       title:self.titile
                                       image:imgV.image
                                         url:self.shareDetailUrl
                                    soundUrl:nil
                                    delegate:self
                                   mediaType:2
                                        type:ShareTypeWeixiTimeline];
}

- (void)loadURL:(NSString *)url {
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:req];
    [web loadRequest:req];
}

- (void)cancelViewController {
    [self popViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PoptoCommentList" object:nil];
}

#pragma mark override from CommonViewController

- (BOOL)showNavBar {
    return TRUE;
}

- (BOOL)showBackButton {
    return TRUE;
}

- (BOOL)showTitleBar {
    return TRUE;
}
@end
