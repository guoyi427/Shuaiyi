//
//  SinaClient.m
//  KoMovie
//
//  Created by alfaromeo on 12-6-21.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "SinaClient.h"


static SinaClient * _sharedSinaClient = nil;

@implementation SinaClient

@synthesize request;

- (id)init {
    self = [super init];
    if (self) {  
        reqTokenFromCode = YES;
        
        self.appKey = kSinaKey;
        self.appSecret = kSinaSecret;
        self.redirectURI = kSinaCallback;
    }
    return self;
}

- (void)dealloc {
    [request setDelegate:nil];
    [request disconnect];
    self.request = nil;
    
    [super dealloc];
}

+ (SinaClient *)sharedSinaClient {
    @synchronized(self) {
        if ( _sharedSinaClient == nil ) {
            _sharedSinaClient = [[SinaClient alloc] init];
        }
        return _sharedSinaClient;
    }
}



#pragma mark req config part
- (NSString *)reqCodeURL {
    return @"https://api.weibo.com/oauth2/authorize";
}

- (NSDictionary *)reqCodeParams {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.appKey, @"client_id",
            @"code", @"response_type",
            @"true", @"forcelogin",
            ([self.redirectURI length]? self.redirectURI: @"http://"), @"redirect_uri",
            @"mobile", @"display", nil];
}

- (NSString *)reqTokenURL {
    return @"https://api.weibo.com/oauth2/access_token";
}

- (NSDictionary *)reqTokenParams {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.appKey, @"client_id",
            self.appSecret, @"client_secret",
            @"authorization_code", @"grant_type",
            ([self.redirectURI length]? self.redirectURI: @"http://"), @"redirect_uri", 
            code, @"code", nil];
}



#pragma mark utility
- (void)startXAuthWithId:(NSString *)theUserID andPassword:(NSString *)thePassword {
    self.userId = theUserID;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            self.appKey, @"client_id",
                            self.appSecret, @"client_secret",
                            @"password", @"grant_type",
                            ([self.redirectURI length]? self.redirectURI: @"http://"), @"redirect_uri", 
                            userId, @"username",
                            thePassword, @"password", nil];
    
    [request disconnect];
    
    self.request = [OAuthRequest requestWithURL:[self reqTokenURL]
                                     httpMethod:@"POST"
                                         params:params
                                   postDataType:kOAuthRequestPostDataTypeNormal
                               httpHeaderFields:nil 
                                       delegate:self];
    
    [request connect];
}

- (void)requestAccessTokenWithAuthorizeCode:(NSString *)code {
    [request setDelegate:nil];
    [request disconnect];
    self.request = nil;
    
    self.request = [OAuthRequest requestWithURL:[self reqTokenURL]
                                     httpMethod:@"POST"
                                         params:[self reqTokenParams]
                                   postDataType:kOAuthRequestPostDataTypeNormal
                               httpHeaderFields:nil 
                                       delegate:self];
    
    [request connect];
}



#pragma mark - OAuthWebViewDelegate Methods
- (void)authorizeWebView:(OAuthWebView *)wbView loadURL:(NSString *)reqURL {
    DLog(@"%@", reqURL);
    
    NSRange range = [reqURL rangeOfString:@"code="];
    if (range.location != NSNotFound) {
        NSString *theCode = [reqURL substringFromIndex:range.location + range.length];

        if (![theCode isEqualToString:@"21330"]) {
            self.code = theCode;
            [self requestAccessTokenWithAuthorizeCode:code];
        }
    }
}



#pragma mark - OAuthRequestDelegate Methods
- (void)request:(OAuthRequest *)theReqest didFailWithError:(NSError *)error {
    self.loginBlock(self, NO);
    
    [request setDelegate:nil];
    [request disconnect];
    self.request = nil;
}

- (void)request:(OAuthRequest *)theRequest didFinishLoadingWithResult:(id)result {
    BOOL success = NO;
    if ([result isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)result;
        
        NSString *token = [dict objectForKey:@"access_token"];
        NSString *userID = [dict objectForKey:@"uid"];
        NSInteger seconds = [[dict objectForKey:@"expires_in"] intValue];
        
        success = token && userID;
        
        if (success) {
            [webView hide:YES];        

            self.accessToken = token;
            self.userId = userID;
            self.expireTime = [[NSDate date] timeIntervalSince1970] + seconds;
            
            [self saveAuthorizeDataToKeychain];
            
            self.loginBlock(self, YES);
        }
    }
    
    // should not be possible
    if (!success) {
        [self request:request didFailWithError:nil];
    }
    
    [request setDelegate:nil];
    [request disconnect];
    self.request = nil;
}



@end
