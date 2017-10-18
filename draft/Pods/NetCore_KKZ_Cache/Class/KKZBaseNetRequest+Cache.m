//
//  KKZBaseNetRequest+Cache.m
//  NetCore_KKZ
//
//  Created by Albert on 6/29/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import "KKZBaseNetRequest+Cache.h"
#import <CacheEngine/CacheEngine.h>
#import <CacheEngine/NSString+Sha1.h>
#import "NSURL+QueryDictionary.h"

@implementation KKZBaseNetRequest (Cache)
/**
 *  GET (Cache)
 *
 *  @param URLString  resource name
 *  @param parameters params
 *  @param a_class    class to parser
 *  @param cacheValidtime   cache valid time
 *  @param success    success block
 *  @param failure    failure block
 */
- (void) GET:(nullable NSString *)URLString
  parameters:(nullable NSDictionary *)parameters
 resultClass:(nullable Class<MTLModel>)a_class
cacheValidTime:(NSUInteger)cacheValidTime
     success:(nullable void (^)(id _Nullable data, id _Nullable respomsObject))success
     failure:(nullable void (^)(NSError *_Nullable err))failure
{
    [self GET:URLString
   parameters:parameters
 resultKeyMap:[[self class] mapDicWithClass:a_class parseKey:self.parseKey]
cacheValidTime:cacheValidTime
      success:success
      failure:failure];
}


/**
 *  GET (Cache, parserMap)
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
     failure:(nullable void (^)(NSError *_Nullable err))failure
{
    NSString *cacheId = [self cacheId:URLString parameters:parameters];
    
    if ([self checkCache:cacheId cacheValidTime:cacheValidTime success:success]) {
        return;
    }
    
    [self GET:URLString parameters:parameters resultKeyMap:parserMap success:^(id  _Nullable data, id  _Nullable respomsObject) {
        //cache cata
        if (data && cacheValidTime > 0) {
            
            //TODO: if a_class is Nil
            [[CacheEngine sharedCacheEngine] updateCacheForId:cacheId
                                                         data:[NSKeyedArchiver archivedDataWithRootObject:data]
                                                    validTime:cacheValidTime];
        }
        
        if (success) {
            success(data, respomsObject);
        }
    } failure:failure];
}


/**
 *  检查cache
 *
 *  @param cacheId        cacheId
 *  @param cacheValidTime cache valid time
 *  @param success        success block
 *
 *  @return yes: get cache, no: no cache
 */
- (BOOL) checkCache:(NSString *)cacheId
     cacheValidTime:(NSUInteger)cacheValidTime
            success:(nullable void (^)(id _Nullable data, id _Nullable respomsObject))success
{

    if (cacheValidTime > 0) {
        //get cache
        id cacheData = [[CacheEngine sharedCacheEngine] getCacheForId:cacheId validTime:cacheValidTime];
        if (cacheData && success) {
            id cacheObj = [NSKeyedUnarchiver unarchiveObjectWithData:cacheData];
            
            success(cacheObj, nil);
            return YES;
        }
        
    }
    
    return NO;
 
}

/**
 *  POST (Cache)
 *
 *  @param URLString  resource name
 *  @param parameters params
 *  @param a_class    class to parser
 *  @param cacheValidtime   cache valid time
 *  @param success    success block
 *  @param failure    failure block
 */
- (void) POST:(nullable NSString *)URLString
   parameters:(nullable NSDictionary *)parameters
  resultClass:(nullable Class<MTLModel>)a_class
cacheValidTime:(NSUInteger)cacheValidTime
      success:(nullable void (^)(id _Nullable data, id _Nullable respomsObject))success
      failure:(nullable void (^)(NSError *_Nullable err))failure

{
    [self POST:URLString
    parameters:parameters
  resultKeyMap:[[self class] mapDicWithClass:a_class parseKey:self.parseKey]
cacheValidTime:cacheValidTime
       success:success
       failure:failure];
    
}


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
      failure:(nullable void (^)(NSError *_Nullable err))failure
{
    NSString *cacheId = [self cacheId:URLString parameters:parameters];
    
    if ([self checkCache:cacheId cacheValidTime:cacheValidTime success:success]) {
        return;
    }
    
    [self POST:URLString parameters:parameters resultKeyMap:parserMap success:^(id  _Nullable data, id  _Nullable respomsObject) {
        //cache cata
        if (data && cacheValidTime > 0) {
            [[CacheEngine sharedCacheEngine] updateCacheForId:cacheId
                                                         data:[NSKeyedArchiver archivedDataWithRootObject:data]
                                                    validTime:cacheValidTime];
        }
        
        if (success) {
            success(data, respomsObject);
        }
    } failure:failure];
}


/**
 *  cache id
 *
 *  @param URLString  URL path sting
 *  @param parameters parameters
 *
 *  @return cache id
 */
-(NSString *)cacheId:(NSString *)URLString
          parameters:(NSDictionary *)parameters
{

    //去除效验参数
    NSMutableDictionary *muDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [muDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"enc"] || [key isEqualToString:@"time_stamp"]) {
            [muDic removeObjectForKey:key];
        }
    }];
    
    NSURL *newURL = nil;
    if (URLString.length > 0) {
        NSURL *url = [NSURL URLWithString:URLString relativeToURL:self.baseURL];
        newURL = url;
    }else{
        newURL = self.baseURL;
    }
    
    NSString *cacheId  = [[newURL uq_URLByAppendingQueryDictionary:muDic].absoluteString sha1];
    
    return cacheId;
    
}

@end
