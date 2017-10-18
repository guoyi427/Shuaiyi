//
//  KKZBaseNetRequest.m
//  NetCore_KKZ
//
//  Created by Albert on 6/20/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import "KKZBaseNetRequest.h"
#import <Mantle/MTLJSONAdapter.h>
#import <AFNetworking/AFNetworking.h>


NSString * const KKZRequestErrorMessageKey = @"kkz.error.message";
NSString * const KKZRequestErrorResponse = @"kkz.error.response";
NSString * const KKZLoginFailNotificationName = @"kkz.error.login.fail.notification";





@interface KKZBaseNetRequest ()
@property (nonatomic, copy) NSURL *baseURL;
@property (nonatomic, strong) NSDictionary *baseParams;
@property (nonatomic, copy) NSString *URLString;
@property (nonatomic, strong) NSDictionary *parserMap;
@end

@implementation KKZBaseNetRequest

//+ (void) startLogging
//{
//    [[AFNetworkActivityLogger sharedLogger] startLogging];
//}
//
//+ (void) stopLogging
//{
//    [[AFNetworkActivityLogger sharedLogger] stopLogging];
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
/**
 *  MARK: creat instance
 *
 *  @param url        base url
 *  @param baseParams base params
 *
 *  @return instance
 */
+ (_Nullable instancetype) requestWithBaseURL:(NSString *_Nonnull)url baseParams:(NSDictionary *_Nullable)baseParams
{
    KKZBaseNetRequest *instance = [KKZBaseNetRequest new];
    instance.baseURL = [NSURL URLWithString:url];
    instance.baseParams = baseParams;
    
    return instance;
}


- (AFHTTPSessionManager *) HTTPSessionManager
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 20;   // 20秒超时
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:self.baseURL
                                                                   sessionConfiguration:configuration];
    
    if (self.headerField) {
        [self.headerField enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    return sessionManager;
}


//TODO: main thread callback
-(void)GET:(NSString *)URLString parameters:(NSDictionary *)parameters
   success:(void (^)(NSDictionary * _Nullable, id _Nullable))success
   failure:(void (^)(NSError * _Nullable))failure
{
    [self GET:URLString parameters:parameters resultClass:nil success:success failure:failure];
}




/**
 *  GET
 *
 *  @param URLString  resource name
 *  @param parameters params
 *  @param parserMap   a map for parser key and Class e.g @{@"user":[User class],@"orders":[Order class]}
 *  @param a_class    class to parser
 *  @param success    success block
 *  @param failure    failure block
 */
- (NSURLSessionTask *) GET:(nullable NSString *)URLString
  parameters:(nullable NSDictionary *)parameters
resultKeyMap:(nullable NSDictionary *)parserMap
     success:(nullable void (^)(NSDictionary * _Nullable data, id _Nullable responseObject))success
     failure:(nullable void (^)(NSError *_Nullable err))failure;
{
    self.URLString = URLString;
    
    self.parserMap = parserMap;
    
    AFHTTPSessionManager *sessionManager = [self HTTPSessionManager];
    NSURLSessionTask *task = [sessionManager GET:self.URLString
             parameters:parameters progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [self parse:responseObject
                   resultKeyMap:parserMap
                        success:success
                        failure:failure];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    if (failure) {
                        failure([self networkError:error]);
                    }
                    
                }];
    return task;
}


/**
 *  MARK: GET
 *
 *  @param URLString  resource name
 *  @param parameters params
 *  @param a_class    class to parse
 *  @param success    success block
 *  @param failure    failure block
 */
- (void) GET:(NSString *)URLString
  parameters:(NSDictionary *)parameters
 resultClass:(Class<MTLModel>)a_class
     success:(nullable void (^)(id _Nullable data, id _Nullable responseObject))success
     failure:(nullable void (^)(NSError *_Nullable err))failure
{
    self.URLString = URLString;
    
    AFHTTPSessionManager *sessionManager = [self HTTPSessionManager];
    [sessionManager GET:self.URLString
             parameters:parameters progress:nil
                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    [self parse:responseObject
                   resultKeyMap:[[self class] mapDicWithClass:a_class parseKey:self.parseKey]
                        success:success
                        failure:failure];
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    if (failure) {
                        failure([self networkError:error]);
                    }
                }];
    
}


/**
 *  POST
 *
 *  @param URLString  resource name
 *  @param parameters params
 *  @param parseMap   a map for parse key and Class e.g @{@"user":[User class],@"orders":[Order class]}
 *  @param success    success block
 *  @param failure    failure block
 */
- (void) POST:(nullable NSString *)URLString
   parameters:(nullable NSDictionary *)parameters
 resultKeyMap:(nullable NSDictionary *)parserMap
      success:(nullable void (^)(id _Nullable data, id _Nullable responseObject))success
      failure:(nullable void (^)(NSError *_Nullable err))failure
{
    
    self.URLString = URLString;
    
    AFHTTPSessionManager *sessionManager = [self HTTPSessionManager];
    [sessionManager POST:self.URLString
              parameters:parameters progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     
                     [self parse:responseObject
                    resultKeyMap:parserMap
                         success:success
                         failure:failure];
                     
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     
                     if (failure) {
                         failure([self networkError:error]);
                     }
                     
                 }];
    
}

/**
 *  MARK: POST
 *
 *  @param URLString  resource name
 *  @param parameters params
 *  @param a_class    class to parse
 *  @param success    success block
 *  @param failure    failure block
 */
- (void) POST:(nullable NSString *)URLString
   parameters:(nullable NSDictionary *)parameters
  resultClass:(nullable Class<MTLModel>)a_class
      success:(nullable void (^)(id _Nullable data, id _Nullable responseObject))success
      failure:(nullable void (^)(NSError *_Nullable err))failure
{
    
    self.URLString = URLString;
    
    AFHTTPSessionManager *sessionManager = [self HTTPSessionManager];
    [sessionManager POST:self.URLString
              parameters:parameters progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     
                     [self parse:responseObject
                    resultKeyMap:[[self class] mapDicWithClass:a_class parseKey:self.parseKey]
                         success:success
                         failure:failure];
                     
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     
                     if (failure) {
                         failure([self networkError:error]);
                     }
                     
                 }];

}
/**
 *  网络请求error
 *
 *  @param error error
 *
 *  @return 指定了network error code的error
 */
- (NSError *) networkError:(NSError *)error
{
    NSHTTPURLResponse *response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    
    NSInteger statusCode = response.statusCode;
    
    if (statusCode > 0 || error.code == 3840) {
        //3840为AFJSONResponseSerializer json序列化错误
        //有请求错误码
       return [NSError errorWithDomain:error.domain code:KKZ_REQUEST_STATUS_ERROR userInfo:error.userInfo];
    }
    return [NSError errorWithDomain:error.domain code:KKZ_REQUEST_STATUS_NETWORK_ERROR userInfo:error.userInfo];
}

/**
 *  MARK: upload file
 *
 *  @param URLString resource name
 *  @param fromData  form data block
 *  @param a_class   class to parse
 *  @param success   success block
 *  @param failure   failure block
 */
- (void) upload:( NSString * _Nullable)URLString
     parameters:(nullable NSDictionary *)parameters
       fromData:(nonnull void (^)(id<AFMultipartFormData> _Nonnull formData))fromData
    resultClass:(nullable Class<MTLModel>)a_class
        success:(nullable void (^)(id _Nullable data, id _Nullable responseObject))success
        failure:(nullable void (^)(NSError *_Nullable err))failure

{
    
    self.URLString = URLString;
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    if (self.headerField) {
        [self.headerField enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [serializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST"
                                                                    URLString:[NSString stringWithFormat:@"%@/%@",self.baseURL.absoluteString, self.URLString]
                                                                   parameters:parameters
                                                    constructingBodyWithBlock:fromData
                                                                        error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request
                                               progress:nil
                                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                          if (error) {
                                              if (failure) {
                                                  failure([self networkError:error]);
                                              }
                                          } else {
                                              [self parse:responseObject
                                             resultKeyMap:[[self class] mapDicWithClass:a_class parseKey:self.parseKey]
                                                  success:success
                                                  failure:failure];
                                          }
                                      }];
    
    [uploadTask resume];
}
/**
 *  parserMap
 *
 *  @param a_class  class
 *  @param parseKey parse key
 *
 *  @return a parser map dictionary
 */
+ (NSDictionary * _Nullable) mapDicWithClass:(nullable Class) a_class parseKey:(nullable NSString *)parseKey
{
    NSDictionary *dic = nil;
    
    if (parseKey.length > 0 && a_class != NULL) {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:a_class, parseKey, nil];
    }
    
    return dic;
}


/**
 *  URLString get method, to prevent nil
 *
 *  @return URLString
 */
- (NSString *) URLString
{
    if (_URLString == nil) {
        return @"";
    }
    
    return _URLString;
}

/**
 *  MARK: parser
 *
 *  @param responseObject resonse
 *  @param a_class        class to parse
 *  @param success        success block
 *  @param failure        failure block
 */
- (void) parse:(id)responseObject
  resultKeyMap:(NSDictionary *)parserMap
       success:(void (^)(id data, id _Nullable responseObject))success
       failure:(nullable void (^)(NSError *_Nullable err))failure
{
    
    __block NSError *error = nil;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dicResponse = responseObject;
        //status code
        NSInteger status = [[dicResponse objectForKey:@"status"] integerValue];
        
        switch (status) {
            case KKZ_REQUEST_STATUS_SUCCESS:
            {
                //                NSAssert1((a_class != NULL && self.paserKey.length != 0), @"%@ need define parserKey", NSStringFromClass(a_class));
                
                if (parserMap.count != 0) {
                    
                    NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithCapacity:parserMap.count];
                    [parserMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([obj conformsToProtocol:@protocol(MTLJSONSerializing)]) {
                            id value = [responseObject objectForKey:key];
                            Class a_class = obj;
                            id model = nil;
                            
                            if ([value isKindOfClass:[NSDictionary class]]) {
                                model = [MTLJSONAdapter modelOfClass:a_class
                                                  fromJSONDictionary:value
                                                               error:&error];
                            }else if([value isKindOfClass:[NSArray class]]){
                                model = [MTLJSONAdapter modelsOfClass:a_class
                                                        fromJSONArray:value
                                                                error:&error];
                            }
                            
                            if (model) {
                                [resultDic  setObject:model forKey:key];
                            }
                        }else{
                            // TODO: define err
                        }
                        
                    }];
                    
                    
                    if (error == nil) {
                        if (success) {
                            if (self.parseKey.length > 0) {
                                //使用parseKey，单个modle解析
                                success([resultDic allValues].firstObject, dicResponse);
                                
                            }else{
                                //使用了parseMap，则回调参数为Dictionary
                                success([resultDic copy], dicResponse);
                            }
                        }
                    }else{
                        if (failure) {
                            NSError *errorPaser = [NSError errorWithDomain:error.domain code:KKZ_REQUEST_STATUS_ERROR userInfo:error.userInfo];
                            failure(errorPaser);
                        }
                    }
                }else{
                    if (success) {
                        success(nil, dicResponse);
                    }
                }
                
                
            }
                break ;
            case KKZ_REQUEST_STATUS_LOGIN_FAIL:
                error = [self paserErr:[NSString stringWithFormat:@"%@%@",self.baseURL, self.URLString] code:KKZ_REQUEST_STATUS_LOGIN_FAIL respons:responseObject];
                
                //post login fail notification
                [[NSNotificationCenter defaultCenter] postNotificationName:KKZLoginFailNotificationName object:nil];
                break;
            case KKZ_REQUEST_STATUS_WRONG_CODE:
                error = [self paserErr:[NSString stringWithFormat:@"%@%@",self.baseURL, self.URLString] code:KKZ_REQUEST_STATUS_WRONG_CODE respons:responseObject];
                break;
                
            default:
                error = [self paserErr:[NSString stringWithFormat:@"%@%@",self.baseURL, self.URLString] code:status respons:responseObject];
                
                break;
        }
        
        if (error && failure) {
            failure(error);
        }
        
    }
    
}

- (NSError *_Nullable) paserErr:(NSString *)domain code:(NSInteger) code respons:(id _Nullable)responseObject
{
    NSError *error = nil;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dicResponse = responseObject;
        NSString *errorMessage = [dicResponse objectForKey:@"message"] ? [dicResponse objectForKey:@"message"] : [dicResponse objectForKey:@"error"];
        
        error = [NSError errorWithDomain:domain
                                    code:code
                                userInfo:errorMessage ? @{KKZRequestErrorMessageKey : errorMessage, KKZRequestErrorResponse : responseObject} : @{KKZRequestErrorResponse : responseObject}];
        
    }
    
    return error;
    
}

@end
