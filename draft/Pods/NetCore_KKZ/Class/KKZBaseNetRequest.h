//
//  KKZBaseNetRequest.h
//  NetCore_KKZ
//
//  Created by Albert on 6/20/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFURLRequestSerialization.h>
#import <Mantle/MTLModel.h>


/**
 *  请求错误message key
 */
FOUNDATION_EXPORT NSString * const _Nonnull KKZRequestErrorMessageKey;

/**
 *  请求错误response key
 */
FOUNDATION_EXPORT NSString * const _Nonnull KKZRequestErrorResponse;
/**
 *  接口返回用户登录失败 notification name
 */
FOUNDATION_EXPORT NSString * const _Nonnull KKZLoginFailNotificationName;



/**
 *  error code
 */
typedef NS_ENUM(NSUInteger, REQUEST_STATUS_CODE) {
   /**
    *  成功
    */
   KKZ_REQUEST_STATUS_SUCCESS = 0,
   /**
    *  登录失败
    */
   KKZ_REQUEST_STATUS_LOGIN_FAIL = -99,
   /**
    *  验证码失效
    */
   KKZ_REQUEST_STATUS_WRONG_CODE = -89,
   /**
    *  网络请求失败
    */
   KKZ_REQUEST_STATUS_NETWORK_ERROR = 1000,
   /**
    *  数据解析出错、网络请求错误 404 500 等
    */
   KKZ_REQUEST_STATUS_ERROR = 1001,
   
};

@interface KKZBaseNetRequest : NSObject
@property (readonly, copy) NSURL * _Nonnull baseURL;
@property (readonly, strong) NSDictionary * _Nullable baseParams;
@property (nonatomic, strong) NSDictionary * _Nullable headerField;

/**
 *  start showing log
 */
//+ (void) startLogging;
/**
 *  stop showing log
 */
//+ (void) stopLogging;

/**
 *  creat instance
 *
 *  @param url        base url
 *  @param baseParams base params
 *
 *  @return instance
 */
+ (_Nullable instancetype) requestWithBaseURL:(NSString *_Nonnull)url baseParams:(NSDictionary *_Nullable)baseParams;


/**
 *  GET
 *
 *  @param URLString  resource name
 *  @param parameters params
 *  @param success    success block, datatype is NSArray or NSDictionary
 *  @param failure    failure block
 */
- (void) GET:(nullable NSString *)URLString
  parameters:(nullable NSDictionary *)parameters
     success:(nullable void (^)(NSDictionary * _Nullable data, id _Nullable responseObject))success
     failure:(nullable void (^)(NSError *_Nullable err))failure;


/**
 *  GET
 *
 *  @param URLString  resource name
 *  @param parameters params
 *  @param parseMap   a map for parse key and Class e.g @{@"user":[User class],@"orders":[Order class]}
 *  @param success    success block, data contains @{@"user":User, @"orders":Orders}
 *  @param failure    failure block
 */
- (NSURLSessionTask *) GET:(nullable NSString *)URLString
                parameters:(nullable NSDictionary *)parameters
              resultKeyMap:(nullable NSDictionary *)parserMap
                   success:(nullable void (^)(NSDictionary * _Nullable data, id _Nullable responseObject))success
                   failure:(nullable void (^)(NSError *_Nullable err))failure;


/**
 *  model parse key
 */
@property (nonatomic, copy) NSString * _Nullable parseKey;



/**
 *  GET
 *
 *  @param URLString  resource name
 *  @param parameters params
 *  @param a_class    class to parse
 *  @param success    success block
 *  @param failure    failure block
 */
- (void) GET:(nullable NSString *)URLString
  parameters:(nullable NSDictionary *)parameters
 resultClass:(nullable Class<MTLModel>)a_class
     success:(nullable void (^)(id _Nullable data, id _Nullable responseObject))success
     failure:(nullable void (^)(NSError *_Nullable err))failure;


/**
 *  POST
 *
 *  @param URLString  resource name
 *  @param parameters params
 *  @param parseMap   a map for parse key and Class e.g @{@"user":[User class],@"orders":[Order class]}
 *  @param success    success block, data contains @{@"user":User, @"orders":Orders}
 *  @param failure    failure block
 */
- (void) POST:(nullable NSString *)URLString
   parameters:(nullable NSDictionary *)parameters
resultKeyMap:(nullable NSDictionary *)parserMap
      success:(nullable void (^)(id _Nullable data, id _Nullable responseObject))success
      failure:(nullable void (^)(NSError *_Nullable err))failure;


/**
 *  POST
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
     failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 *  upload file
 *
 *  @param URLString    resource name
 *  @param parameters   parameters
 *  @param fromData     form data block
 *  @param a_class      class to parse
 *  @param success      success block
 *  @param failure      failure block
 */
- (void) upload:( NSString * _Nullable)URLString
     parameters:(nullable NSDictionary *)parameters
       fromData:(nonnull void (^)(id<AFMultipartFormData> _Nonnull formData))fromData
    resultClass:(nullable Class<MTLModel>)a_class
        success:(nullable void (^)(id _Nullable data, id _Nullable responseObject))success
        failure:(nullable void (^)(NSError *_Nullable err))failure;


/**
 *  parserMap
 *
 *  @param a_class  class
 *  @param parseKey parse key
 *
 *  @return a parser map dictionary
 */
+ (NSDictionary * _Nullable) mapDicWithClass:(nullable Class) a_class parseKey:(nullable NSString *)parseKey;
@end
