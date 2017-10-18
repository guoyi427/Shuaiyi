//
//  KKZBaseNetRequest+Cache.h
//  NetCore_KKZ
//
//  Created by Albert on 6/29/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import <NetCore_KKZ/KKZBaseNetRequest.h>

@interface KKZBaseNetRequest (Cache)


/**
 *  GET (Cache)
 *
 *  @param URLString        resource name
 *  @param parameters       params
 *  @param a_class          class to parser
 *  @param cacheValidtime   cache valid time (minute)
 *  @param success          success block
 *  @param failure          failure block
 */
- (void) GET:(nullable NSString *)URLString
  parameters:(nullable NSDictionary *)parameters
 resultClass:(nullable Class<MTLModel>)a_class
cacheValidTime:(NSUInteger)cacheValidTime
     success:(nullable void (^)(id _Nullable data, id _Nullable respomsObject))success
     failure:(nullable void (^)(NSError *_Nullable err))failure;

/**
 *  GET  (Cache, parserMap)
 *
 *  @param URLString        resource name
 *  @param parameters       params
 *  @param parseMap         a map for parse key and Class e.g @{@"user":[User class],@"orders":[Order class]}
 *  @param cacheValidtime   cache valid time (minute)
 *  @param success          success block
 *  @param failure          failure block
 */
- (void) GET:(nullable NSString *)URLString
  parameters:(nullable NSDictionary *)parameters
resultKeyMap:(nullable NSDictionary *)parserMap
cacheValidTime:(NSUInteger)cacheValidTime
     success:(nullable void (^)(NSDictionary * _Nullable data, id _Nullable respomsObject))success
     failure:(nullable void (^)(NSError *_Nullable err))failure;


/**
 *  POST (Cache)
 *
 *  @param URLString        resource name
 *  @param parameters       params
 *  @param a_class          class to parser
 *  @param cacheValidtime   cache valid time (minute)
 *  @param success          success block
 *  @param failure          failure block
 */
- (void) POST:(nullable NSString *)URLString
  parameters:(nullable NSDictionary *)parameters
 resultClass:(nullable Class<MTLModel>)a_class
cacheValidTime:(NSUInteger)cacheValidTime
     success:(nullable void (^)(id _Nullable data, id _Nullable respomsObject))success
     failure:(nullable void (^)(NSError *_Nullable err))failure;


/**
 *  POST (Cache, parserMap)
 *
 *  @param URLString        resource name
 *  @param parameters       params
 *  @param parseMap         a map for parse key and Class e.g @{@"user":[User class],@"orders":[Order class]}
 *  @param cacheValidtime   cache valid time (minute)
 *  @param success          success block
 *  @param failure          failure block
 */
- (void) POST:(nullable NSString *)URLString
   parameters:(nullable NSDictionary *)parameters
 resultKeyMap:(nullable NSDictionary *)parserMap
cacheValidTime:(NSUInteger)cacheValidTime
      success:(nullable void (^)(id _Nullable data, id _Nullable respomsObject))success
      failure:(nullable void (^)(NSError *_Nullable err))failure;
@end
