//
//  QQClient.m
//  KoMovie
//
//  Created by alfaromeo on 12-6-21.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "QQClient.h"


static QQClient * _sharedQQClient = nil;

@implementation QQClient

@synthesize request;

- (id)init {
    self = [super init];
    if (self) {
        self.appKey = @"100284763";
        self.appSecret = @"1e226cc12b09a1aa9c0cb88e1b807d04";
        self.redirectURI = @"http://movie.kokozu.net/oauth2/qqcallback";
    }
    return self;
}

- (void)dealloc {
    [request setDelegate:nil];
    [request disconnect];
    self.request = nil;
    
    [super dealloc];
}

+ (QQClient *)sharedQQClient {
    @synchronized(self) {
        if ( _sharedQQClient == nil ) {
            _sharedQQClient = [[QQClient alloc] init];
        }
        return _sharedQQClient;
    }
}



#pragma mark req config part
- (NSString *)reqTokenURL {
    return @"https://graph.qq.com/oauth2.0/authorize";
}

- (NSDictionary *)reqTokenParams {    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"token", @"response_type",
                                   self.appKey, @"client_id",
                                   @"user_agent", @"type",
                                   ([self.redirectURI length]? self.redirectURI: @"http://"), @"redirect_uri",
                                   @"mobile", @"display",
								   [NSString stringWithFormat:@"%f",[[[UIDevice currentDevice] systemVersion] floatValue]],@"status_os",
								   [[UIDevice currentDevice] name],@"status_machine",
                                   @"v2.0",@"status_version",
                                   nil];
    NSArray *permissions = [[NSArray arrayWithObjects:
                             @"get_user_info",@"add_share", @"add_topic",@"add_one_blog", @"list_album", 
                             @"upload_pic",@"list_photo", @"add_album", @"check_page_fans",nil] retain];
	if (permissions) {
		NSString *scope = [permissions componentsJoinedByString:@","];
		[params setValue:scope forKey:@"scope"];
	}
    
    [permissions release];
    
    return params;
}

- (void)requestOpenIdWithToken:(NSString *)token {
    [request setDelegate:nil];
    [request disconnect];
    self.request = nil;
    
    self.request = [OAuthRequest requestWithURL:@"https://graph.z.qq.com/moc2/me"
                                     httpMethod:@"GET"
                                         params:[NSDictionary dictionaryWithObject:token forKey:@"access_token"]
                                   postDataType:kOAuthRequestPostDataTypeNormal
                               httpHeaderFields:nil 
                                       delegate:self];
    [request connect];
}



#pragma mark - OAuthWebViewDelegate Methods
- (void)authorizeWebView:(OAuthWebView *)wbView loadURL:(NSString *)reqURL {
    DLog(@"%@", reqURL);
    //http://www.qq.com/?#access_token=0EC39B01209CBE4AA4572696CD054CC5&expires_in=7776000

    NSDictionary *dict = [reqURL URLParams];
    
    NSString *token = [dict objectForKey:@"access_token"];
    NSInteger seconds = [[dict objectForKey:@"expires_in"] intValue];
    
    if (token && seconds) {
        self.accessToken = token;
        self.expireTime = [[NSDate date] timeIntervalSince1970] + seconds;

        [self requestOpenIdWithToken:accessToken];        
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
    
    if ([result isKindOfClass:[NSData class]]) {
        NSString *responseString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [responseString URLParams];
        [responseString release];
        NSString *uId = [dict objectForKey:@"openid"];
        if (uId) {
            DLog(@"%@", uId);

            if (webView) {
                [webView hide:YES];  
            }
            

            self.userId = uId;
            
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
