//
//  WebNewViewController.h
//  CIASMovie
//
//  Created by avatar on 2017/5/17.
//  Copyright © 2017年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebNewViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, copy) NSString *webViewTitle;

/**
 *  网页视图
 */

@property (nonatomic, strong) UIWebView *webView;

/**
  * 请求的地址
  */

@property (nonatomic, strong) NSString *requestURL;

/**
 * 加载URL地址。
 *
 * @param url URL
 */

-(void)loadRequestWithURL:(NSString *)url;


/**
  * 重新加载页面。
  */
- (void)reloadPage;

/**
  * 滚动轮
  */
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;


@end
