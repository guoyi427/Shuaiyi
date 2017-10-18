
#import "RNCachingURLProtocol.h"
#import "Reachability.h"
#import "NSString+Sha1.h"

/******************需要屏蔽的url***********************************/
#define requestMaskURLString1 @"http://hm.baidu.com/hm.gif"
#define requestMaskURLString2 @"http://bdtest.fraudmetrix.cn/irt.gif"

/******************需要判断缓存的页面********************************/
#define DiscoverController @"DiscoverViewController"
#define HobbyViewController @"HobbyViewController"

/******************缓存的最长时间***********************************/
#define requestMaxCacheDate 2*60*60                     //2个小时

#define WORKAROUND_MUTABLE_COPY_LEAK 1

#if WORKAROUND_MUTABLE_COPY_LEAK
@interface NSURLRequest(MutableCopyWorkaround)

- (id) mutableCopyWorkaround;

@end
#endif

@interface RNCachedData : NSObject <NSCoding>
@property (nonatomic, readwrite, strong) NSData *data;
@property (nonatomic, readwrite, strong) NSURLResponse *response;
@property (nonatomic, readwrite, strong) NSURLRequest *redirectRequest;
@property (nonatomic, readwrite, strong) NSDate *writeDate;
@end

static NSString *RNCachingURLHeader = @"X-RNCache";

@interface RNCachingURLProtocol () // <NSURLConnectionDelegate, NSURLConnectionDataDelegate> iOS5-only
@property (nonatomic, readwrite, strong) NSURLConnection *connection;
@property (nonatomic, readwrite, strong) NSMutableData *data;
@property (nonatomic, readwrite, strong) NSURLResponse *response;
- (void)appendData:(NSData *)newData;
@end

static NSObject *RNCachingSupportedSchemesMonitor;
static NSSet *RNCachingSupportedSchemes;

/******************初始化全局静态数组********************************/
static NSMutableSet *searchLocalSet; //发现的页面已经加载过本地缓存url
static NSMutableSet *nearByLocalSet; //周边页面已经加载过本地缓存的

/******************初始化全局静态********************************/
static NSString *DiscoveryCacheController;
static NSString *HobbyCacheController;

static BOOL isRequestFindNet;       //发现页面是否去请求网络客户端而不是读缓存
static BOOL isRequestNearByNet;       //附近页面是否去请求网络客户端而不是读缓存
static BOOL findControllerIsLoading;  //发现页面是否正在加载请求
static BOOL nearByControllerIsLoading; //周边页面是否正在加载请求

/******************初始化全局静态字典********************************/
static NSMutableSet *loadingCacheSet;
static NSMutableArray *loadFileArray;

@implementation RNCachingURLProtocol
@synthesize connection = connection_;
@synthesize data = data_;
@synthesize response = response_;

+ (void)initialize
{
  if (self == [RNCachingURLProtocol class])
  {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RNCachingSupportedSchemesMonitor = [NSObject new];
        
        //发现的页面已经加载过的本地缓存url的数组
        searchLocalSet = [[NSMutableSet alloc] init];
        
        //周边页面已经加载过的本地缓存的url的数组
        nearByLocalSet = [[NSMutableSet alloc] init];
        
        //所有加载过的url数据
        loadingCacheSet = [[NSMutableSet alloc] init];
        
        //加载文件的数组
        loadFileArray = [[NSMutableArray alloc] initWithObjects:@"js",@"png",@"css",@"gif",@"jpg",nil];
        
        //当前缓存的Controller
        DiscoveryCacheController = nil;
        HobbyCacheController = nil;
        
    });
        
    [self setSupportedSchemes:[NSSet setWithObject:@"http"]];
  }
}

+(void)setRequestController:(NSString *)name {
    
    //判断设置控制器
    if ([name isEqualToString:HobbyViewController]) {
        HobbyCacheController = name;
    }else if ([name isEqualToString:DiscoverController]) {
        DiscoveryCacheController = name;
    }
}

+(void)clearRequestController:(NSString *)name {
    if ([name isEqualToString:HobbyViewController]) {
        HobbyCacheController = nil;
    }else if ([name isEqualToString:DiscoverController]) {
        DiscoveryCacheController = nil;
    }
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSString *urlString = request.URL.absoluteString;
//    NSLog(@"request===%@",urlString);
    if ([[self supportedSchemes] containsObject:[[request URL] scheme]]
        &&([request valueForHTTPHeaderField:RNCachingURLHeader] == nil)
        && (DiscoveryCacheController || HobbyCacheController)
        && [loadFileArray containsObject:[urlString pathExtension]])
    {
//        NSLog(@"sucess===%@",urlString);
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
  return request;
}

- (NSString *)cachePathForRequest:(NSURLRequest *)aRequest
{
    //cache文件夹的路径
    NSString *destinationPath = [[self class] webViewCachePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:destinationPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fileName = [[[aRequest URL] absoluteString] sha1];
    return [destinationPath stringByAppendingPathComponent:fileName];
}

+ (NSString *)webViewCachePath {
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *cacheDir = @"";
    if ([DiscoveryCacheController isEqualToString:DiscoverController]) {
        cacheDir = DiscoverController;
    }else if([HobbyCacheController isEqualToString:HobbyViewController]) {
        cacheDir = HobbyViewController;
    }
    return [cachesPath stringByAppendingPathComponent:cacheDir];
}

/**
 *  获取本地缓存数据的个数
 *
 *  @param localFlag
 *
 *  @return
 */
+(NSUInteger)getLocalCacheCount:(NSString *)localFlag{
    if ([localFlag isEqualToString:HobbyViewController]) {
        NSLog(@"附近的人===%lu",(unsigned long)nearByLocalSet.count);
        return nearByLocalSet.count;
    }else if ([localFlag isEqualToString:DiscoverController]) {
        return searchLocalSet.count;
    }
    return 0;
}

/**
 *  是否删除本地的数据
 */
+(void)decideLocalWebViewCacheIsDelete{
    
    //拿出当前的时间
    NSDate *currentDate = [NSDate date];
    
    //获取一个文件的信息
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[self class] webViewCachePath]]) {
        NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:[[self class] webViewCachePath]
                                                                                  error:nil];
        
        NSDate *firstData = [fileInfo objectForKey:NSFileModificationDate];
        NSTimeInterval interval = [currentDate timeIntervalSinceDate:firstData];
        if (interval > requestMaxCacheDate) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:[[self class] webViewCachePath]
                                                       error:&error];
            if(!error){
                //如果移除文件夹无错误的话就移除掉所有元素
                if ([DiscoveryCacheController isEqualToString:DiscoverController]) {
                    [searchLocalSet removeAllObjects];
                    [[NSNotificationCenter defaultCenter] postNotificationName:DiscoverController
                                                                        object:nil];
                }else if([HobbyCacheController isEqualToString:HobbyViewController]) {
                    [nearByLocalSet removeAllObjects];
                    [[NSNotificationCenter defaultCenter] postNotificationName:HobbyViewController
                                                                        object:nil];
                }
            }
        }
    }
}

+(void)clearWebCache {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *discoverCacheDir = DiscoverController;
    NSString *hobbyCacheDir = HobbyViewController;
    NSString *finalDiscoverDir = [cachesPath stringByAppendingPathComponent:discoverCacheDir];
    NSString *finalHobby = [cachesPath stringByAppendingPathComponent:hobbyCacheDir];
    //移除掉发现页面缓存
    NSError *discoverError = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:finalDiscoverDir]) {
        [[NSFileManager defaultManager] removeItemAtPath:finalDiscoverDir
                                                   error:&discoverError];
    }
    
    if (!discoverError) {
        [searchLocalSet removeAllObjects];
        [[NSNotificationCenter defaultCenter] postNotificationName:DiscoverController
                                                            object:nil];
    }
    
    //移除掉周边页面的缓存
    NSError *hobbyError = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:finalHobby]) {
        [[NSFileManager defaultManager] removeItemAtPath:finalHobby
                                                   error:&hobbyError];
    }
    
    if (!hobbyError) {
        [nearByLocalSet removeAllObjects];
        [[NSNotificationCenter defaultCenter] postNotificationName:HobbyViewController
                                                            object:nil];
    }
}

/**
 *  是否刷新发现的请求
 *
 *  @param isRquest
 */
+(void)isRequestFindNet:(BOOL)isRquest {
    isRequestFindNet = isRquest;
}

/**
 *  是否刷新附近的人请求
 *
 *  @param isRquest
 */
+(void)isRequestNearByNet:(BOOL)isRquest {
    isRequestNearByNet = isRquest;
}

/**
 *  设置当前Controller是否正在加载
 *
 *  @param name
 *  @param isLoading
 */
+(void)setRequestController:(NSString *)name
              withIsLoading:(BOOL)isLoading{
    if ([name isEqualToString:HobbyViewController]) {
        nearByControllerIsLoading = isLoading;
    }else if ([name isEqualToString:DiscoverController]) {
        findControllerIsLoading = isLoading;
    }
}

/**
 *  开始下载
 */
- (void)startLoading
{
    
    if ((isRequestFindNet && [DiscoveryCacheController isEqualToString:DiscoverController])
        || (isRequestNearByNet && [HobbyCacheController isEqualToString:HobbyViewController])) {
        NSString *url = self.request.URL.absoluteString;
        if ([url rangeOfString:requestMaskURLString1].location != NSNotFound
            || [url rangeOfString:requestMaskURLString2].location != NSNotFound) {
            [[self client] URLProtocol:self
                      didFailWithError:[NSError errorWithDomain:NSURLErrorDomain
                                                           code:NSURLErrorCannotConnectToHost
                                                       userInfo:nil]];
        }else {
            [self beginNetWorkRequest];
        }
    }else {
        
        //先读取缓存
        RNCachedData *cache = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cachePathForRequest:[self request]]];
        if (cache) {
            //缓存的URL
            NSData *data = [cache data];
            NSURLResponse *response = [cache response];
            NSURLRequest *redirectRequest = [cache redirectRequest];
            if (redirectRequest) {
                [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
            } else {
                if (response) {
                    NSLog(@"缓存====%@",[[response URL] absoluteString]);
                    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
                    [[self client] URLProtocol:self didLoadData:data];
                    [[self client] URLProtocolDidFinishLoading:self];
                }else{
                    [[self client] URLProtocol:self
                              didFailWithError:[NSError errorWithDomain:NSURLErrorDomain
                                                                   code:NSURLErrorCannotConnectToHost
                                                               userInfo:nil]];
                }
            }
            if ([DiscoveryCacheController isEqualToString:DiscoverController]) {
                [searchLocalSet addObject:self.request.URL.absoluteString];
            }else if ([HobbyCacheController isEqualToString:HobbyViewController]) {
                [nearByLocalSet addObject:self.request.URL.absoluteString];
            }
        }
        else {
            
            //开始网络请求
            NSString *url = self.request.URL.absoluteString;
            if ([url rangeOfString:requestMaskURLString1].location != NSNotFound
                || [url rangeOfString:requestMaskURLString2].location != NSNotFound) {
                [[self client] URLProtocol:self
                          didFailWithError:[NSError errorWithDomain:NSURLErrorDomain
                                                               code:NSURLErrorCannotConnectToHost
                                                           userInfo:nil]];
            }else {
                [self beginNetWorkRequest];
            }
        }
    }
}

/**
 *  开始网络请求
 */
- (void)beginNetWorkRequest{
    
    if (![self useCache]) {
        
        //存储已经加载过请求的url
//        [loadingCacheSet addObject:self.request.URL.absoluteString];
        //请求网络
        NSMutableURLRequest *connectionRequest =
#if WORKAROUND_MUTABLE_COPY_LEAK
        [[self request] mutableCopyWorkaround];
#else
        [[self request] mutableCopy];
#endif
        //我们需要标记这个请求头以至于我们知道在+[NSURLProtocol canInitWithRequest:]不处理它
        [connectionRequest setValue:@"请求" forHTTPHeaderField:RNCachingURLHeader];
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:connectionRequest
                                                                    delegate:self];
        NSLog(@"请求的URL====%@",[[[self request] URL] absoluteString]);
        [self setConnection:connection];
    }
}

- (void)stopLoading
{
  [[self connection] cancel];
}

// NSURLConnnect

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
  if (response != nil) {
      NSMutableURLRequest *redirectableRequest =
#if WORKAROUND_MUTABLE_COPY_LEAK
      [request mutableCopyWorkaround];
#else
      [request mutableCopy];
#endif
    [redirectableRequest setValue:nil forHTTPHeaderField:RNCachingURLHeader];

      NSString *cachePath = [self cachePathForRequest:[self request]];
      RNCachedData *cache = [RNCachedData new];
      [cache setResponse:response];
      [cache setData:[self data]];
      [cache setWriteDate:[NSDate date]];
      [cache setRedirectRequest:redirectableRequest];
    
      [NSKeyedArchiver archiveRootObject:cache toFile:cachePath];
      [[self client] URLProtocol:self
          wasRedirectedToRequest:redirectableRequest
                redirectResponse:response];
      return redirectableRequest;
    } else {
        return request;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  [[self client] URLProtocol:self didLoadData:data];
  [self appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[self client] URLProtocol:self didFailWithError:error];
    [self setConnection:nil];
    [self setData:nil];
    [self setResponse:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  [self setResponse:response];
  [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{    
    [[self client] URLProtocolDidFinishLoading:self];
    if ([self data] && [self data].length > 0) {
        
        NSString *cachePath = [self cachePathForRequest:[self request]];
        RNCachedData *cache = [RNCachedData new];
        [cache setResponse:[self response]];
        [cache setData:[self data]];
        [cache setWriteDate:[NSDate date]];
        
        //如果归档成功的话就清除掉此次网络请求
        if ([NSKeyedArchiver archiveRootObject:cache toFile:cachePath]) {
            [self setConnection:nil];
            [self setData:nil];
            [self setResponse:nil];
        }
    }
}

- (BOOL) useCache 
{
    BOOL reachable = (BOOL) [[Reachability reachabilityWithHostName:[[[self request] URL] host]] currentReachabilityStatus] != NotReachable;
    return !reachable;
}

- (void)appendData:(NSData *)newData
{
  if ([self data] == nil) {
    [self setData:[newData mutableCopy]];
  }
  else {
    [[self data] appendData:newData];
  }
}

+ (NSSet *)supportedSchemes {
  NSSet *supportedSchemes;
  @synchronized(RNCachingSupportedSchemesMonitor)
  {
    supportedSchemes = RNCachingSupportedSchemes;
  }
  return supportedSchemes;
}

+ (void)setSupportedSchemes:(NSSet *)supportedSchemes
{
  @synchronized(RNCachingSupportedSchemesMonitor)
  {
    RNCachingSupportedSchemes = supportedSchemes;
  }
}

@end

static NSString *const kDataKey = @"data";
static NSString *const kResponseKey = @"response";
static NSString *const kRedirectRequestKey = @"redirectRequest";
static NSString *const KDateKey = @"writeDate";

@implementation RNCachedData
@synthesize data = data_;
@synthesize response = response_;
@synthesize redirectRequest = redirectRequest_;
@synthesize writeDate = writeDate_;

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self data] forKey:kDataKey];
    [aCoder encodeObject:[self response] forKey:kResponseKey];
    [aCoder encodeObject:[self redirectRequest] forKey:kRedirectRequestKey];
    [aCoder encodeObject:[self writeDate] forKey:KDateKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self != nil) {
      [self setData:[aDecoder decodeObjectForKey:kDataKey]];
      [self setResponse:[aDecoder decodeObjectForKey:kResponseKey]];
      [self setRedirectRequest:[aDecoder decodeObjectForKey:kRedirectRequestKey]];
      [self setWriteDate:[aDecoder decodeObjectForKey:KDateKey]];
    }
  return self;
}

@end

#if WORKAROUND_MUTABLE_COPY_LEAK
@implementation NSURLRequest(MutableCopyWorkaround)

- (id) mutableCopyWorkaround {
    NSMutableURLRequest *mutableURLRequest = [[NSMutableURLRequest alloc] initWithURL:[self URL]
                                                                          cachePolicy:[self cachePolicy]
                                                                      timeoutInterval:[self timeoutInterval]];
    [mutableURLRequest setAllHTTPHeaderFields:[self allHTTPHeaderFields]];
    if ([self HTTPBodyStream]) {
        [mutableURLRequest setHTTPBodyStream:[self HTTPBodyStream]];
    } else {
        [mutableURLRequest setHTTPBody:[self HTTPBody]];
    }
    [mutableURLRequest setHTTPMethod:[self HTTPMethod]];
    
    return mutableURLRequest;
}

@end
#endif
