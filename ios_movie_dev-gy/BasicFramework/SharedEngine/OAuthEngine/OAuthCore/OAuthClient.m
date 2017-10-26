//
//  OAuthClient.m
//  KoMovie
//
//  Created by alfaromeo on 12-6-21.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "OAuthClient.h"
#import "OAuthRequest.h"
#import "SFHFKeychainUtilsY.h"


@interface OAuthClient ()

- (void)readAuthorizeDataFromKeychain;
- (void)deleteAuthorizeDataInKeychain;

@end


@implementation OAuthClient

@synthesize userId, accessToken, code, expireTime;
@synthesize appKey = _appKey, appSecret = _appSecret, redirectURI = _redirectURI;
@synthesize loginBlock = _loginBlock, logoutBlock = _logoutBlock;


#pragma mark - OAuthClient Life Circle
- (id)init {
    if (self = [super init]) {                
        [self readAuthorizeDataFromKeychain];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self taskType:TaskTypeQuerySelfSinaInfo];

    self.appKey = nil;
    self.appSecret = nil;
    
    self.userId = nil;
    self.accessToken = nil;
    self.code = nil;
    
    self.redirectURI = nil;
    
    self.loginBlock = nil, self.logoutBlock = nil;

    [super dealloc];
}



#pragma mark kinds of properties
- (NSString *)keychainServiceKey { 
    return [NSString stringWithFormat:@"%@_keychain", NSStringFromClass([self class])]; 
}

- (NSString *)uidKey { 
    return [NSString stringWithFormat:@"%@_uid", NSStringFromClass([self class])]; 
}

- (NSString *)tokenKey { 
    return [NSString stringWithFormat:@"%@_token", NSStringFromClass([self class])]; 
}

- (NSString *)expiretimeKey { 
    return [NSString stringWithFormat:@"%@_expire", NSStringFromClass([self class])]; 
}

- (NSString *)reqCodeURL { return nil; }

- (NSDictionary *)reqCodeParams { return nil; }

- (NSString *)reqTokenURL { return nil; }

- (NSDictionary *)reqTokenParams { return nil; }



#pragma mark - OAuthClient Private Methods
- (void)saveAuthorizeDataToKeychain {    
    [SFHFKeychainUtilsY storeUsername:[self uidKey]
                         andPassword:userId 
                      forServiceName:[self keychainServiceKey] 
                      updateExisting:YES 
                               error:nil];
	[SFHFKeychainUtilsY storeUsername:[self tokenKey]
                         andPassword:accessToken 
                      forServiceName:[self keychainServiceKey]  
                      updateExisting:YES 
                               error:nil];
	[SFHFKeychainUtilsY storeUsername:[self expiretimeKey]
                         andPassword:[NSString stringWithFormat:@"%lf", expireTime] 
                      forServiceName:[self keychainServiceKey]  
                      updateExisting:YES 
                               error:nil];
}

- (void)readAuthorizeDataFromKeychain {
    self.userId = [SFHFKeychainUtilsY getPasswordForUsername:[self uidKey]
                                             andServiceName:[self keychainServiceKey]  
                                                      error:nil];
    self.accessToken = [SFHFKeychainUtilsY getPasswordForUsername:[self tokenKey]
                                                  andServiceName:[self keychainServiceKey]  
                                                           error:nil];
    self.expireTime = [[SFHFKeychainUtilsY getPasswordForUsername:[self expiretimeKey]  
                                                  andServiceName:[self keychainServiceKey]  
                                                           error:nil] doubleValue];
}

- (void)deleteAuthorizeDataInKeychain {
    self.userId = nil;
    self.accessToken = nil;
    self.expireTime = 0;
    
    [SFHFKeychainUtilsY deleteItemForUsername:[self uidKey]
                              andServiceName:[self keychainServiceKey]  
                                       error:nil];
	[SFHFKeychainUtilsY deleteItemForUsername:[self tokenKey] 
                              andServiceName:[self keychainServiceKey] 
                                       error:nil];
	[SFHFKeychainUtilsY deleteItemForUsername:[self expiretimeKey]  
                              andServiceName:[self keychainServiceKey]  
                                       error:nil];
}



#pragma mark - OAuthClient Public Methods
- (void)loginFinished:(void (^)(OAuthClient *client, BOOL finished))aBlock {
    NSString *urlString = nil;
    if (reqTokenFromCode) {
        urlString = [OAuthRequest serializeURL:[self reqCodeURL]
                                        params:[self reqCodeParams]
                                    httpMethod:@"GET"];
    } else {
        urlString = [OAuthRequest serializeURL:[self reqTokenURL]
                                        params:[self reqTokenParams]
                                    httpMethod:@"GET"];
    }
    
    webView = [[OAuthWebView alloc] init];
    [webView setDelegate:self];
    [webView loadRequestWithURL:[NSURL URLWithString:urlString]];
    [webView show:YES];
    [webView release];

    self.loginBlock = aBlock;
}

- (void)logoutFinished:(void (^)(OAuthClient *client))aBlock {
    [self deleteAuthorizeDataInKeychain];

    self.logoutBlock = aBlock;
    self.logoutBlock(self);
}

- (void)login {
    NSString *urlString = nil;
    if (reqTokenFromCode) {
        urlString = [OAuthRequest serializeURL:[self reqCodeURL]
                                        params:[self reqCodeParams]
                                    httpMethod:@"GET"];
    } else {
        urlString = [OAuthRequest serializeURL:[self reqTokenURL]
                                        params:[self reqTokenParams]
                                    httpMethod:@"GET"];
    }

    webView = [[OAuthWebView alloc] init];
    [webView setDelegate:self];
    [webView loadRequestWithURL:[NSURL URLWithString:urlString]];
    [webView show:YES];
    [webView release];
}

- (void)logout {
    [self deleteAuthorizeDataInKeychain];
    
    self.logoutBlock(self);
}

- (BOOL)isLoggedIn {
    return userId && accessToken && (expireTime > 0);
}

- (BOOL)isAuthorizeExpired {
    if (!userId || [[NSDate date] timeIntervalSince1970] > expireTime) {
        // force to log out
        [self deleteAuthorizeDataInKeychain];
        return YES;
    }
    return NO;
}

- (void)removeDelegate:(id)theDelegate {

}



#pragma mark - OAuthWebViewDelegate Methods
- (void)authorizeWebView:(OAuthWebView *)webView loadURL:(NSString *)reqURL {

}



@end
