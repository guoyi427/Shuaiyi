//
//  OAuthRequest.h
//  KoMovie
//
//  Created by alfaromeo on 12-6-21.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kOAuthRequestPostDataTypeNone,
	kOAuthRequestPostDataTypeNormal,		// for normal data post, such as "user=name&password=psd"
	kOAuthRequestPostDataTypeMultipart,     // for uploading images and files.
}OAuthRequestPostDataType;


@class OAuthRequest;

@protocol OAuthRequestDelegate <NSObject>

@optional

- (void)request:(OAuthRequest *)request didReceiveResponse:(NSURLResponse *)response;
- (void)request:(OAuthRequest *)request didReceiveRawData:(NSData *)data;
- (void)request:(OAuthRequest *)request didFailWithError:(NSError *)error;
- (void)request:(OAuthRequest *)request didFinishLoadingWithResult:(id)result;

@end

@interface OAuthRequest : NSObject
{
    NSString                *url;
    NSString                *httpMethod;
    NSDictionary            *params;
    OAuthRequestPostDataType   postDataType;
    NSDictionary            *httpHeaderFields;
    
    NSURLConnection         *connection;
    NSMutableData           *responseData;
    
    id<OAuthRequestDelegate>   delegate;
}

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *httpMethod;
@property (nonatomic, retain) NSDictionary *params;
@property OAuthRequestPostDataType postDataType;
@property (nonatomic, retain) NSDictionary *httpHeaderFields;
@property (nonatomic, assign) id<OAuthRequestDelegate> delegate;

+ (OAuthRequest *)requestWithURL:(NSString *)url 
                   httpMethod:(NSString *)httpMethod 
                       params:(NSDictionary *)params
                 postDataType:(OAuthRequestPostDataType)postDataType
             httpHeaderFields:(NSDictionary *)httpHeaderFields
                     delegate:(id<OAuthRequestDelegate>)delegate;

+ (OAuthRequest *)requestWithAccessToken:(NSString *)accessToken
                                  url:(NSString *)url
                           httpMethod:(NSString *)httpMethod 
                               params:(NSDictionary *)params
                         postDataType:(OAuthRequestPostDataType)postDataType
                     httpHeaderFields:(NSDictionary *)httpHeaderFields
                             delegate:(id<OAuthRequestDelegate>)delegate;

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;

- (void)connect;
- (void)disconnect;

@end
