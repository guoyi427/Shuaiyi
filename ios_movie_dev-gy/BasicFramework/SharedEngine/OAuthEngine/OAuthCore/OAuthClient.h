//
//  OAuthClient.h
//  KoMovie
//
//  Created by alfaromeo on 12-6-21.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "OAuthWebView.h"


@interface OAuthClient : NSObject <OAuthWebViewDelegate> {
    NSString *userId, *accessToken, *code;
    NSTimeInterval  expireTime;
        
    BOOL reqTokenFromCode;
    
    OAuthWebView *webView;
}

@property (copy, nonatomic) void (^loginBlock)(OAuthClient *client, BOOL succeeded);
@property (copy, nonatomic) void (^logoutBlock)(OAuthClient *client);

@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) NSString *code;

@property (nonatomic, assign) NSTimeInterval expireTime;

@property (nonatomic, retain) NSString *appKey;
@property (nonatomic, retain) NSString *appSecret;
@property (nonatomic, retain) NSString *redirectURI;


- (void)loginFinished:(void (^)(OAuthClient *client, BOOL succeeded))aBlock;
- (void)logoutFinished:(void (^)(OAuthClient *client))aBlock;

- (BOOL)isLoggedIn;
- (BOOL)isAuthorizeExpired;

- (void)saveAuthorizeDataToKeychain;

- (NSString *)reqCodeURL;
- (NSDictionary *)reqCodeParams;
- (NSString *)reqTokenURL;
- (NSDictionary *)reqTokenParams;

@end
