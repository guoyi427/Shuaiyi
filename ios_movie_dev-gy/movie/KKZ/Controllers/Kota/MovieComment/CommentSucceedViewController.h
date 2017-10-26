//
//  CommentSucceedViewController.h
//  KoMovie
//
//  Created by KKZ on 15/11/3.
//  Copyright © 2015年 kokozu. All rights reserved.
//

#import "CommonViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApiObject.h"

@interface CommentSucceedViewController : CommonViewController <UIScrollViewDelegate, UIWebViewDelegate, ISSShareViewDelegate> {
    UIScrollView *webHolder;
    UIButton *backBtn;
    UIButton *rightBtn;
    UIWebView *web;
}

@property (nonatomic, copy) NSString *shareContent;
@property (nonatomic, copy) NSString *sharePicUrl;
@property (nonatomic, copy) NSString *titile;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *shareDetailUrl;

- (void)loadURL:(NSString *)url;

@end
