//
//  OAuthWebView.h
//  KoMovie
//
//  Created by alfaromeo on 12-6-21.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OAuthWebView;

@protocol OAuthWebViewDelegate <NSObject>

- (void)authorizeWebView:(OAuthWebView *)webView loadURL:(NSString *)reqURL;

@end

@interface OAuthWebView : UIView <UIWebViewDelegate> {
    UIView *panelView;
    UIActivityIndicatorView *indicatorView;
	UIWebView *webView;
    
    UIInterfaceOrientation previousOrientation;
    
    id<OAuthWebViewDelegate> delegate;
}

@property (nonatomic, assign) id<OAuthWebViewDelegate> delegate;

- (void)loadRequestWithURL:(NSURL *)url;

- (void)show:(BOOL)animated;

- (void)hide:(BOOL)animated;

@end