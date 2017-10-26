//
//  OAuthWebView.m
//  KoMovie
//
//  Created by alfaromeo on 12-6-21.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "OAuthWebView.h"
#import <QuartzCore/QuartzCore.h> 
#import "UIImageExtra.h"

@interface OAuthWebView (Private)

- (void)bounceOutAnimationStopped;
- (void)bounceInAnimationStopped;
- (void)bounceNormalAnimationStopped;
- (void)allAnimationsStopped;

@end

@implementation OAuthWebView

@synthesize delegate;


#pragma mark - OAuthWebView Life Circle
- (id)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, screentHeight)])
    {
        // background settings
        [self setBackgroundColor:[UIColor clearColor]];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        
        // add the panel view
        panelView = [[UIView alloc] initWithFrame:CGRectMake(0, 20 + screentContentHeight, 320, screentContentHeight)];
        [panelView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.55]];
        [[panelView layer] setMasksToBounds:NO]; // very important
        [self addSubview:panelView];
        
        UIView *topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        topBarView.backgroundColor = [UIColor blackColor];
        [panelView addSubview:topBarView];
        [topBarView release];
        
        //返回按钮
        UIButton * backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = CGRectMake(0, 0, 60, 48);
        [backBtn setImage:[UIImage imageNamed:@"web_close_icon"] forState:UIControlStateNormal];
        [backBtn setImage:[UIImage imageNamed:@"web_close_icon"] forState:UIControlStateHighlighted];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(14, 15, 18, 29)];
        [backBtn addTarget:self action:@selector(onCloseButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [topBarView addSubview:backBtn];

        
        // 标题
        UILabel * accountTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
        accountTitleLabel.font = [UIFont boldSystemFontOfSize:18];
        accountTitleLabel.textColor = [UIColor whiteColor];
        accountTitleLabel.backgroundColor = [UIColor clearColor];
        accountTitleLabel.textAlignment = NSTextAlignmentCenter;
        accountTitleLabel.text = @"登录授权";
        [topBarView addSubview:accountTitleLabel];
        [accountTitleLabel release];

        
//        //创建navbar
//        UINavigationBar *topBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//        
//        //创建navbaritem
//        UINavigationItem *topBarTitle = [[UINavigationItem alloc] initWithTitle:@"登录授权"];
//        [topBar pushNavigationItem:topBarTitle animated:YES];
//        
//        [panelView addSubview:topBar];
//        
//        //创建barbutton 创建系统样式的
//        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hide:)];
//        
//        //设置barbutton
//        topBarTitle.leftBarButtonItem = item;
//        [topBar setItems:[NSArray arrayWithObject:topBarTitle]];
//        
//        [item release];
//        [topBarTitle release];
//        [topBar release];
   
        
        // add the web view
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, screentContentHeight - 44)];
		[webView setDelegate:self];
        webView.scalesPageToFit = YES;
		[panelView addSubview:webView];
        
        
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicatorView setCenter:panelView.center];
        [self addSubview:indicatorView];
    }
    return self;
}

- (void)dealloc {
    [panelView release], panelView = nil;
    [webView release], webView = nil;
    [indicatorView release], indicatorView = nil;
    
    [super dealloc];
}


#pragma mark Actions
- (void)onCloseButtonTouched:(id)sender {
    [self hide:YES];
}


#pragma mark Animations 
- (void)bounceOutAnimationStopped {
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceInAnimationStopped)];
    [panelView setAlpha:0.8];
	[panelView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)];
	[UIView commitAnimations];
}

- (void)bounceInAnimationStopped {
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.13];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(bounceNormalAnimationStopped)];
    [panelView setAlpha:1.0];
	[panelView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)];
	[UIView commitAnimations];
}

- (void)bounceNormalAnimationStopped {
    [self allAnimationsStopped];
}

- (void)allAnimationsStopped {
    // nothing shall be done here
}


#pragma mark Dismiss
- (void)hideAndCleanUp {
	[self removeFromSuperview];
}


#pragma mark - OAuthWebView Public Methods
- (void)loadRequestWithURL:(NSURL *)url {
    NSURLRequest *request =[NSURLRequest requestWithURL:url
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                        timeoutInterval:60.0];
    [webView loadRequest:request];
}

- (void)show:(BOOL)animated {    
    UIWindow *window = appDelegate.window;
	if (!window)
    {
		window = [[UIApplication sharedApplication].windows objectAtIndex:0];
	}
  	[window addSubview:self];
    
    if (animated)
    {
        [UIView animateWithDuration:.4 animations:^{
            panelView.frame = CGRectMake(0, 20, 320, screentContentHeight);
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [self allAnimationsStopped];
    }
}

- (void)hide:(BOOL)animated {
//	if (animated)
//    {
		[UIView animateWithDuration:.3 animations:^{
            panelView.frame = CGRectMake(0, 20+screentContentHeight, 320, screentContentHeight);
        } completion:^(BOOL finished) {
            [self hideAndCleanUp];
        }];
//	} 
}


#pragma mark - UIWebViewDelegate Methods
- (void)webViewDidStartLoad:(UIWebView *)aWebView {
	[indicatorView startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
	[indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)aWebView didFailLoadWithError:(NSError *)error {
    [indicatorView stopAnimating];
}

- (BOOL)webView:(UIWebView *)aWebView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([delegate respondsToSelector:@selector(authorizeWebView:loadURL:)]) {
        [delegate authorizeWebView:self loadURL:request.URL.absoluteString];
    }

    return YES;
}

@end
