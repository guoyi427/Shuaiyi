//
//  TaobaoClient.m
//  KoMovie
//
//  Created by alfaromeo on 12-6-21.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "TaobaoClient.h"


static TaobaoClient * _sharedTaobaoClient = nil;

@implementation TaobaoClient

- (id)init {
    self = [super init];
    if (self) {
        self.appKey = @"21005502";
        self.appSecret = @"8e8d5dbb2b84efdc40ebeabcfa0b1072";
        self.redirectURI = @"http://m.kokozu.net/kologin/callback.php";
    }
    return self;
}

- (void)dealloc {
    
    [super dealloc];
}

+ (TaobaoClient *)sharedTaobaoClient {
    @synchronized(self) {
        if ( _sharedTaobaoClient == nil ) {
            _sharedTaobaoClient = [[TaobaoClient alloc] init];
        }
        return _sharedTaobaoClient;
    }
}



#pragma mark req config part
/*
 response_type 是 此流程下，该值固定为token
 client_id 是 即创建应用时的Appkey
 redirect_uri 可选 应用的回调地址， 如果有值，则回调到这个地址，没有就到默认地址。
 state 否 状态参数，由应用自定义，颁发授权后会原封不动返回
 scope 否（短授权为必须 权限参数，API组名串，多个组名时，用“，”分隔，目前支持参数：promotion,item,usergrade
 view 是 授权页面类型， wap（无线端
 */
- (NSString *)reqTokenURL {
    return @"https://oauth.taobao.com/authorize";
}

- (NSDictionary *)reqTokenParams {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.appKey, @"client_id",
            @"token", @"response_type",
            ([self.redirectURI length]? self.redirectURI: @"http://"), @"redirect_uri",
            @"wap", @"view", nil];
}



#pragma mark - OAuthWebViewDelegate Methods
- (void)authorizeWebView:(OAuthWebView *)wbView loadURL:(NSString *)reqURL {
    DLog(@"%@", reqURL);
    //http://oauth.kokozu.net/
    //#access_token=610282441f4f93fcff6b71611ee29fe71d4ba3b187c91b890288879
    //&token_type=Bearer
    //&expires_in=86400
    //&refresh_token=6100424da5e7960cc0d0ef3f172815e619a81bd992effa190288879
    //&re_expires_in=2592000
    //&mobile_token=bacc98ff5c09a1bed18474d7f84138f2
    //&taobao_user_id=90288879
    //&taobao_user_nick=ipj4ever
    //&state=
    
    NSDictionary *dict = [reqURL URLParams];
    
    NSString *token = [dict objectForKey:@"access_token"];
    NSString *userID = [dict objectForKey:@"taobao_user_id"];
    NSInteger seconds = [[dict objectForKey:@"expires_in"] intValue];
    
    if (token && userID) {
        [webView hide:YES];        

        self.accessToken = token;
        self.userId = userID;
        self.expireTime = [[NSDate date] timeIntervalSince1970] + seconds;
        
        [self saveAuthorizeDataToKeychain];
        
        self.loginBlock(self, YES);
    }
}



@end
