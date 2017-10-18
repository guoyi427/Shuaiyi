
#import <Foundation/Foundation.h>

@interface RNCachingURLProtocol : NSURLProtocol

/**
 *  支持的缓存协议
 *
 *  @return
 */
+ (NSSet *)supportedSchemes;

/**
 *  设置支持的缓存协议
 *
 *  @param supportedSchemes
 */
+ (void)setSupportedSchemes:(NSSet *)supportedSchemes;

/**
 *  得到缓存的路径
 *
 *  @param aRequest
 *
 *  @return
 */
- (NSString *)cachePathForRequest:(NSURLRequest *)aRequest;

/**
 *  是否使用缓存
 *
 *  @return `
 */
- (BOOL) useCache;

/**
 *  设置请求的controller对象
 *
 *  @param name
 */
+(void)setRequestController:(NSString *)name;

/**
 *  清除掉WebView缓存的标识
 *
 *  @param name <#name description#>
 */
+(void)clearRequestController:(NSString *)name;

/**
 *  获取本地缓存数据的个数
 *
 *  @param localFlag 本地数据的标识符
 *
 *  @return
 */
+(NSUInteger)getLocalCacheCount:(NSString *)localFlag;

/**
 *  判断本地的网络缓存数据是否删除
 */
+(void)decideLocalWebViewCacheIsDelete;

/**
 *  发现页面是否请求网络
 *
 *  @param isRquest
 */
+(void)isRequestFindNet:(BOOL)isRquest;

/**
 *  周边页面是否请求网络
 *
 *  @param isRquest
 */
+(void)isRequestNearByNet:(BOOL)isRquest;

/**
 *  设置请求类的名字和是否正在加载
 *
 *  @param name
 *  @param isLoading
 */
+(void)setRequestController:(NSString *)name
              withIsLoading:(BOOL)isLoading;

/**
 *  清空网页缓存
 */
+(void)clearWebCache;

@end
