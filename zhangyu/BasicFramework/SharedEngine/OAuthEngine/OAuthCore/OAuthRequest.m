//
//  OAuthRequest.m
//  KoMovie
//
//  Created by alfaromeo on 12-6-21.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "OAuthRequest.h"

#define kOAuthRequestTimeOutInterval   180.0
#define kOAuthRequestStringBoundary    @"293iosfksdfkiowjksdf31jsiuwq003s02dsaffafass3qw"

@interface OAuthRequest (Private)

+ (NSString *)stringFromDictionary:(NSDictionary *)dict;
+ (void)appendUTF8Body:(NSMutableData *)body dataString:(NSString *)dataString;
- (NSMutableData *)postBody;

- (void)handleResponseData:(NSData *)data;

- (void)failedWithError:(NSError *)error;
@end


@implementation OAuthRequest

@synthesize url;
@synthesize httpMethod;
@synthesize params;
@synthesize postDataType;
@synthesize httpHeaderFields;
@synthesize delegate;


#pragma mark - OAuthRequest Life Circle
- (void)dealloc {
    [url release], url = nil;
    [httpMethod release], httpMethod = nil;
    [params release], params = nil;
    [httpHeaderFields release], httpHeaderFields = nil;
    
    [responseData release];
	responseData = nil;
    
    [connection cancel];
    [connection release], connection = nil;
    
    [super dealloc];
}


#pragma mark - OAuthRequest Private Methods
+ (NSString *)stringFromDictionary:(NSDictionary *)dict {
    NSMutableArray *pairs = [NSMutableArray array];
	for (NSString *key in [dict keyEnumerator])
	{
		if (!([[dict valueForKey:key] isKindOfClass:[NSString class]]))
		{
			continue;
		}
		
		[pairs addObject:[NSString stringWithFormat:@"%@=%@", key, [[dict objectForKey:key] URLEncodedString]]];
	}
	
	return [pairs componentsJoinedByString:@"&"];
}

+ (void)appendUTF8Body:(NSMutableData *)body dataString:(NSString *)dataString {
    [body appendData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSMutableData *)postBody {
    NSMutableData *body = [NSMutableData data];
    
    if (postDataType == kOAuthRequestPostDataTypeNormal)
    {
        [OAuthRequest appendUTF8Body:body dataString:[OAuthRequest stringFromDictionary:params]];
    }
    else if (postDataType == kOAuthRequestPostDataTypeMultipart)
    {
        NSString *bodyPrefixString = [NSString stringWithFormat:@"--%@\r\n", kOAuthRequestStringBoundary];
		NSString *bodySuffixString = [NSString stringWithFormat:@"\r\n--%@--\r\n", kOAuthRequestStringBoundary];
        
        NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
        
        [OAuthRequest appendUTF8Body:body dataString:bodyPrefixString];
        
        for (id key in [params keyEnumerator]) 
		{
			if (([[params valueForKey:key] isKindOfClass:[UIImage class]]) || ([[params valueForKey:key] isKindOfClass:[NSData class]]))
			{
				[dataDictionary setObject:[params valueForKey:key] forKey:key];
				continue;
			}
			
			[OAuthRequest appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", key, [params valueForKey:key]]];
			[OAuthRequest appendUTF8Body:body dataString:bodyPrefixString];
		}
		
		if ([dataDictionary count] > 0) 
		{
			for (id key in dataDictionary) 
			{
				NSObject *dataParam = [dataDictionary valueForKey:key];
				
				if ([dataParam isKindOfClass:[UIImage class]]) 
				{
					NSData* imageData = UIImagePNGRepresentation((UIImage *)dataParam);
					[OAuthRequest appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"file.png\"\r\n", key]];
					[OAuthRequest appendUTF8Body:body dataString:@"Content-Type: image/png\r\nContent-Transfer-Encoding: binary\r\n\r\n"];
					[body appendData:imageData];
				} 
				else if ([dataParam isKindOfClass:[NSData class]]) 
				{
					[OAuthRequest appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key]];
					[OAuthRequest appendUTF8Body:body dataString:@"Content-Type: content/unknown\r\nContent-Transfer-Encoding: binary\r\n\r\n"];
					[body appendData:(NSData*)dataParam];
				}
				[OAuthRequest appendUTF8Body:body dataString:bodySuffixString];
			}
		}
    }
    
    return body;
}

- (void)handleResponseData:(NSData *)data  {
    if ([delegate respondsToSelector:@selector(request:didReceiveRawData:)]) {
        [delegate request:self didReceiveRawData:data];
    }
	
//    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//	id result = [dataString objectFromJSONString];
//    [dataString release];	
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];

    
	if ([result isKindOfClass:[NSDictionary class]]) {
		if ([result objectForKey:@"error_code"] != nil 
            && [[result objectForKey:@"error_code"] intValue] != 200) {
            [self failedWithError:[NSError errorWithDomain:HttpRequestErrorDomain 
                                                      code:1 
                                                  userInfo:result]];
		}
	}
	
	 if ([delegate respondsToSelector:@selector(request:didFinishLoadingWithResult:)]) {
        [delegate request:self didFinishLoadingWithResult:(result == nil ? data : result)];
	}
}

- (void)failedWithError:(NSError *)error {
	if ([delegate respondsToSelector:@selector(request:didFailWithError:)]) {
		[delegate request:self didFailWithError:error];
	}
}


#pragma mark - OAuthRequest Public Methods
+ (OAuthRequest *)requestWithURL:(NSString *)url 
                   httpMethod:(NSString *)httpMethod 
                       params:(NSDictionary *)params
                 postDataType:(OAuthRequestPostDataType)postDataType
             httpHeaderFields:(NSDictionary *)httpHeaderFields
                     delegate:(id<OAuthRequestDelegate>)delegate {
    OAuthRequest *request = [[[OAuthRequest alloc] init] autorelease];
    
    request.url = url;
    request.httpMethod = httpMethod;
    request.params = params;
    request.postDataType = postDataType;
    request.httpHeaderFields = httpHeaderFields;
    request.delegate = delegate;
    
    return request;
}

+ (OAuthRequest *)requestWithAccessToken:(NSString *)accessToken
                                  url:(NSString *)url
                           httpMethod:(NSString *)httpMethod 
                               params:(NSDictionary *)params
                         postDataType:(OAuthRequestPostDataType)postDataType
                     httpHeaderFields:(NSDictionary *)httpHeaderFields
                             delegate:(id<OAuthRequestDelegate>)delegate {
    // add the access token field
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [mutableParams setObject:accessToken forKey:@"access_token"];
    return [OAuthRequest requestWithURL:url
                          httpMethod:httpMethod
                              params:mutableParams
                        postDataType:postDataType 
                    httpHeaderFields:httpHeaderFields
                            delegate:delegate];
}

+ (NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod {
    if (![httpMethod isEqualToString:@"GET"])
    {
        return baseURL;
    }
    
    NSURL *parsedURL = [NSURL URLWithString:baseURL];
	NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
	NSString *query = [OAuthRequest stringFromDictionary:params];
	
	return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}

- (void)connect {
    NSString *urlString = [OAuthRequest serializeURL:url params:params httpMethod:httpMethod];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
														   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
													   timeoutInterval:kOAuthRequestTimeOutInterval];
    
    [request setHTTPMethod:httpMethod];
    
    if ([httpMethod isEqualToString:@"POST"])
    {
        if (postDataType == kOAuthRequestPostDataTypeMultipart)
        {
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", kOAuthRequestStringBoundary];
            [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
        }
        
        [request setHTTPBody:[self postBody]];
    }
    
    for (NSString *key in [httpHeaderFields keyEnumerator])
    {
        [request setValue:[httpHeaderFields objectForKey:key] forHTTPHeaderField:key];
    }
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)disconnect {
    [responseData release];
	responseData = nil;
    
    [connection cancel];
    [connection release], connection = nil;
}


#pragma mark - NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	responseData = [[NSMutableData alloc] init];
	
	if ([delegate respondsToSelector:@selector(request:didReceiveResponse:)])
    {
		[delegate request:self didReceiveResponse:response];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
				  willCacheResponse:(NSCachedURLResponse*)cachedResponse  {
	return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection  {
	[self handleResponseData:responseData];
    
	[responseData release];
	responseData = nil;
    
    [connection cancel];
	[connection release];
	connection = nil;
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error {
	[self failedWithError:error];
	
	[responseData release];
	responseData = nil;
    
    [connection cancel];
	[connection release];
	connection = nil;
}

@end
