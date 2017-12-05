//
//  NetworkTask.m
//  alfaromeo.dev
//
//  Created by zhang da on 11-5-16.
//  Copyright 2011 alfaromeo.dev. All rights reserved.
//

#import "CacheEngine.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "ImageNewTask.h"
#import "NetworkTask.h"
#import "TaskQueue.h"

#import "SinaClient.h"

#import "Constants.h"
#import "UserDefault.h"

#import "NSStringExtra.h"
#import "RequestParameter.h"
#import "UIDeviceExtra.h"

#import "Constants.h"
#import "DataEngine.h"
//#import "FMDeviceManager.h"
#import "VerificationCodeController.h"
#import <AdSupport/ASIdentifierManager.h>

//添加日志
#import "Constants.h"
#import "Cryptor.h"
#import "DateEngine.h"
#import "KKZUtility.h"
#import "NSStringExtra.h"

#import "NSMutableDictionaryExtra.h"

#define kCacheServerDataTimestampKey @"server_data_timestamp"

@interface NetworkTask ()

@property(copy) NSData *uploadBody;
@property(copy) NSString *uploadName;
@property(copy) NSString *uploadFile;

- (void)updateCacheWithResult:(id)result;
- (void)deleteCache;

@end

@implementation NetworkTask

@synthesize requestMethod;
@synthesize uploadBody, uploadName, uploadFile;
@synthesize doUpload, resultIsData;
@synthesize requestType;
@synthesize appVersion = _appVersion, netReqId = _netReqId;
@synthesize requestURL = _requestURL;
@synthesize lastResponse;

#pragma mark * Properties
- (NSString *)appVersion {
  if (!_appVersion) {
    NSDictionary *softwareInfo = [[NSDictionary alloc]
        initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",
                                                          [[NSBundle mainBundle]
                                                              bundlePath],
                                                          @"Info.plist"]];
    NSString *currentVersion = [softwareInfo objectForKey:@"CFBundleVersion"];
    _appVersion = currentVersion;
  }
  return _appVersion;
}

#pragma mark Request sending methods
- (id)init {
  self = [super init];
  if (self) {
    parameters = [[NSMutableArray alloc] init];
    _receiveData = [[NSMutableData alloc] initWithCapacity:0];
  }
  return self;
}

- (void)dealloc {

  _netReqId = nil;

  _appVersion = nil;

  self.requestURL = nil;
  self.lastResponse = nil;

  _receiveData = nil;
  self.finishBlock = nil;

  self.userLogfilePath0 = nil;
  self.userLogDocumentsDirectory = nil;
  self.userLogfilePath = nil;
  self.userLogFileMgrYN = nil;

  [NSObject cancelPreviousPerformRequestsWithTarget:self
                                           selector:@selector(onTimeout)
                                             object:nil];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%d:%@", self.taskType, self.netReqId];
}

#pragma mark Utility
- (void)appendVerifyInfo {
  NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000;
  long long dTime = [[NSNumber numberWithDouble:time] longLongValue];
  [self addParametersWithValue:[NSString stringWithFormat:@"%llu", dTime]
                        forKey:@"time_stamp"];
  NSMutableString *toMD5 = [[NSMutableString alloc] init];
  @synchronized(parameters) {
    for (RequestParameter *requestParameter in parameters) {
      [toMD5 appendString:[NSString stringWithFormat:@"%@",
                                                     [requestParameter value]]];
    }
  }
  [toMD5 appendString:kKsspKey];

  NSString *toMD5Enc = [toMD5 URLEncodedString];
  toMD5Enc =
      [toMD5Enc stringByReplacingOccurrencesOfString:@"~" withString:@"%7E"];
  DLog(@"----------before:%@", toMD5Enc);
  RequestParameter *newPara = [RequestParameter
      requestParameterWithName:@"enc"
                         value:[[toMD5Enc MD5String] lowercaseString]
                       withGBK:NO];
  @synchronized(parameters) {
    [parameters addObject:newPara];
  }
}

- (NSString *)netReqId {
  if (!_netReqId) {
    if (!self.requestURL) {
      return nil;
    }

    NSMutableString *netReqId =
        [[NSMutableString alloc] initWithString:self.requestURL];
    [netReqId appendString:@"?"];

    int position = 1;

    @synchronized(parameters) {
      for (RequestParameter *requestParameter in parameters) {
        if (![requestParameter.name isEqualToString:@"time_stamp"] &&
            ![requestParameter.name isEqualToString:@"enc"]) {

          [netReqId appendString:[requestParameter URLEncodedNameValuePair]];
          if (position < [parameters count])
            [netReqId appendString:@"&"];
        }
        position++;
      }
    }

    _netReqId = [netReqId URLEncodedString];

    netReqId = nil;

    DLog(@"---------\ncache id: %@\n---------", _netReqId);
  }
  return _netReqId;
}

- (void)addParametersWithValue:(NSString *)value forKey:(NSString *)key {
  if (value && key) {
    [self addParametersWithValue:value forKey:key withGBK:NO];
  }
}

- (void)addParametersWithValue:(NSString *)value
                        forKey:(NSString *)key
                       withGBK:(BOOL)isGBK {
  if (value && key) {
    RequestParameter *newPara =
        [RequestParameter requestParameterWithName:key
                                             value:value
                                           withGBK:isGBK];
    if (newPara) {

      @synchronized(parameters) {
        if ([parameters count]) {
          for (int i = 0; i < [parameters count]; i++) {
            RequestParameter *para = [parameters objectAtIndex:i];
            if ([key compare:para.name] == NSOrderedAscending) {
              [parameters insertObject:newPara atIndex:i];

              return;
            }
          }
        }

        [parameters addObject:newPara];
      }
    }
  }
}

- (void)setUploadBody:(NSData *)theBody
             withName:(NSString *)theName
             fromFile:(NSString *)theFile {
  self.uploadBody = theBody;
  self.uploadName = theName;
  self.uploadFile = theFile;
  self.doUpload = YES;
}

- (void)setBodyFor:(NSMutableURLRequest *)request {
  NSMutableString *encodedParameterPairs =
      [[NSMutableString alloc] initWithCapacity:256];

  int position = 1;

  if (requestType == NetworkReqTypeKSSP && !self.resultIsData) {
    //需要写入的字符串
    self.startDate = [NSDate date];
    //        DLog(@"self.startDate ========== %@",self.startDate);

    // 创建文件管理器
    self.userLogFileMgrYN = [NSFileManager defaultManager];
    //        //指向文件目录
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(
        NSCachesDirectory, NSUserDomainMask, YES);

    self.userLogDocumentsDirectory =
        [[documentPaths objectAtIndex:0] stringByAppendingString:@"/"];
    //创建一个目录
    self.userLogfilePath0 = [self.userLogDocumentsDirectory
        stringByAppendingPathComponent:@"KoMovie/"];
    self.userLogfilePath = [NSString
        stringWithFormat:@"KoMovie/%@", [[DateEngine sharedDateEngine]
                                            stringFromDate:[NSDate date]
                                                withFormat:@"yyyy-MM-dd"]];
    self.userLogfilePath = [self.userLogDocumentsDirectory
        stringByAppendingPathComponent:self.userLogfilePath];

    if ([self.userLogFileMgrYN fileExistsAtPath:self.userLogfilePath
                                    isDirectory:NULL]) {

      long cacheSizeMB =
          [[CacheEngine sharedCacheEngine] diskCacheSizeMBOfUserlog];

      if ([self.userLogFileMgrYN fileExistsAtPath:self.userLogfilePath] &&
          cacheSizeMB > 5) {
        [self.userLogFileMgrYN removeItemAtPath:self.userLogfilePath error:nil];
      }
    }

    //        DLog(@"userLogfilePath === %@",self.userLogfilePath);
    if (![self.userLogFileMgrYN fileExistsAtPath:self.userLogfilePath
                                     isDirectory:NULL]) {

      NSError *error;

      [self.userLogFileMgrYN removeItemAtPath:self.userLogfilePath0
                                        error:&error];

      [self.userLogFileMgrYN createDirectoryAtPath:self.userLogfilePath0
                       withIntermediateDirectories:NO
                                        attributes:nil
                                             error:&error];

      NSString *startLogString = [NSString stringWithFormat:@"KoMovieiOS"];
      //写入文件
      NSError *__autoreleasing writeToFileError;
      [startLogString writeToFile:self.userLogfilePath
                       atomically:YES
                         encoding:NSUTF8StringEncoding
                            error:&writeToFileError];
    }

    [self appendVerifyInfo];
  }

  for (RequestParameter *requestParameter in parameters) {
    //        DLog(@"params请求参数:%@", [requestParameter description]);
    [encodedParameterPairs
        appendString:[requestParameter URLEncodedNameValuePair]];
    if (position < [parameters count])
      [encodedParameterPairs appendString:@"&"];
    position++;
  }

  if ([[request HTTPMethod] isEqualToString:@"GET"] ||
      [[request HTTPMethod] isEqualToString:@"DELETE"]) {
    if ([encodedParameterPairs length]) {
      NSString *urlStr =
          [NSString stringWithFormat:@"%@?%@", [[request URL] absoluteString],
                                     encodedParameterPairs];
      NSURL *tmpUrl = [[NSURL alloc] initWithString:urlStr];
      [request setURL:tmpUrl];
    }

    [self printBeforeRequestLog:request:encodedParameterPairs];

  } else {
    // POST, PUT
    if (!uploadBody) {

      NSData *postbody =
          [encodedParameterPairs dataUsingEncoding:NSUTF8StringEncoding];
      [request setHTTPBody:postbody];
      NSString *contentLength = [[NSString alloc]
          initWithFormat:@"%lu", (unsigned long)[postbody length]];
      [request setValue:contentLength forHTTPHeaderField:@"Content-Length"];

    } else {
      if (!uploadName) {

        [request setHTTPBody:uploadBody];

      } else {
        NSMutableString *postBody = [[NSMutableString alloc] init];
        NSString *stringBoundary =
            [NSString stringWithFormat:@"0xKhTmLbOuNdArY"];

        // set header
        [request addValue:[NSString stringWithFormat:
                                        @"multipart/form-data; boundary=%@",
                                        stringBoundary]
            forHTTPHeaderField:@"Content-Type"];

        [postBody appendString:[NSString stringWithFormat:@"--%@\r\n",
                                                          stringBoundary]];

        // Adds post data
        NSString *endItemBoundary =
            [NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary];
        NSUInteger i = 0;
        for (RequestParameter *requestParameter in parameters) {

          //减少一个\r\n modified by zk
          [postBody
              appendString:[NSString stringWithFormat:@"Content-Disposition: "
                                                      @"form-data; "
                                                      @"name=\"%@\"\r\n",
                                                      requestParameter.name]];
          // add by zk
          [postBody
              appendString:@"Content-Type: text/plain; charset=UTF-8\r\n\r\n"];
          // end by zk
          [postBody appendString:requestParameter.value];

          i++;
          if (i != [parameters count] ||
              [parameters count] > 0) { // Only add the boundary if this is not
                                        // the last item in the post body
            [postBody appendString:endItemBoundary];
          }
        }

        // Adds files to upload
        [postBody
            appendString:[NSString stringWithFormat:@"Content-Disposition: "
                                                    @"form-data; name=\"%@\"; "
                                                    @"filename=\"%@\"\r\n",
                                                    uploadName, uploadFile]];
        if (uploadFile) {
          CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(
              kUTTagClassFilenameExtension,
              (__bridge CFStringRef)[uploadFile pathExtension], NULL);
          if (UTI) {
            CFStringRef mime =
                UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
            [postBody
                appendString:[NSString
                                 stringWithFormat:@"Content-Type: %@\r\n\r\n",
                                                  (__bridge NSString *)mime]];
            if (mime != nil) {
              CFRelease(mime);
            }
            CFRelease(UTI);
          }
        }

        NSMutableData *body = [[NSMutableData alloc] init];
        [body appendData:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:uploadBody];

        // just for debug
        [postBody appendString:@"here is binary data"];
        [postBody appendString:[NSString stringWithFormat:@"\r\n--%@--\r\n",
                                                          stringBoundary]];
        DLog(@"####\nbody:\n%@####", postBody);

        [body appendData:[[NSString
                             stringWithFormat:@"\r\n--%@--\r\n", stringBoundary]
                             dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];

        NSString *contentLength =
            [[NSString alloc] initWithFormat:@"%ld", sizeof([body bytes])];
        [request setValue:contentLength forHTTPHeaderField:@"Content-Length"];
      }
    }
    [self printBeforeRequestLog:request:encodedParameterPairs];
  }
}

- (void)updateCacheWithResult:(id)result {
  if ([self cacheForToday]) {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components =
        [calendar components:NSHourCalendarUnit | NSMinuteCalendarUnit
                    fromDate:[NSDate date]];
    NSInteger hour = components.hour;
    NSInteger minute = components.minute;

    NSInteger minLeft = (24 - hour) * 60 - minute;

    [[CacheEngine sharedCacheEngine]
        updateCacheForId:self.netReqId
                    data:result
               validTime:MIN([self cacheVaildTime], minLeft)];

  } else {
    [[CacheEngine sharedCacheEngine] updateCacheForId:self.netReqId
                                                 data:result
                                            validTime:[self cacheVaildTime]];
  }
}

- (void)deleteCache {
  [[CacheEngine sharedCacheEngine] deleteCacheForId:self.netReqId];
}

#pragma mark nsoperation utility
- (void)operationDidStart {
  [super operationDidStart];

  [[TaskQueue sharedTaskQueue] changeNetworkActivityIndicatorStatus:YES];

  //    [self getReady];

  //缓存时间，如果时间内，并且有cache，直接返回数据。
  if ([self cacheVaildTime] > 0) {

    if (taskType == TaskTypeKotaUserDetail) {

      if (![[NetworkUtil me] reachable]) {

        id cacheData = [[CacheEngine sharedCacheEngine]
            getCacheForId:self.netReqId
                validTime:[self cacheVaildTime]];
        if (cacheData) {
          [self handleData:cacheData fromCache:YES];
          [self finishWithError:nil];
          return;
        }
      }

    } else {

      id cacheData =
          [[CacheEngine sharedCacheEngine] getCacheForId:self.netReqId
                                               validTime:[self cacheVaildTime]];
      if (cacheData) {
        [self handleData:cacheData fromCache:YES];
        [self finishWithError:nil];
        return;
      }
    }
  }

  NSMutableURLRequest *theRequest = nil;
  theRequest = [[NSMutableURLRequest alloc]
          initWithURL:[NSURL URLWithString:self.requestURL]
          cachePolicy:NSURLRequestReloadIgnoringCacheData
      timeoutInterval:kHttpRequestTimeout];

  [theRequest setHTTPShouldHandleCookies:NO];
  [theRequest setValue:@"gzip,deflate" forHTTPHeaderField:@"Accept-Encoding"];

  if (self.requestType == NetworkReqTypeKSSP) {
    [theRequest setValue:[[UIDevice currentDevice] MACAddress]
        forHTTPHeaderField:@"mobile_id"];
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)) {
      [theRequest setValue:[[[ASIdentifierManager sharedManager]
                               advertisingIdentifier] UUIDString]
          forHTTPHeaderField:@"mobile_idfa"];
    }
    [theRequest setValue:[[UIDevice currentDevice] platform]
        forHTTPHeaderField:@"mobile_model"];
    [theRequest setValue:kChannelId forHTTPHeaderField:@"channel_id"];
    [theRequest setValue:kChannelName forHTTPHeaderField:@"channel_name"];
    [theRequest setValue:[DataEngine sharedDataEngine].sessionId
        forHTTPHeaderField:@"session_id"];
    [theRequest setValue:[self appVersion] forHTTPHeaderField:@"version"];

    [theRequest setValue:APP_UUID forHTTPHeaderField:@"app_uuid"];

    [theRequest setValue:[[UIDevice currentDevice] model]
        forHTTPHeaderField:@"deviceType"]; // 设备类型：iPhone/touch
    [theRequest setValue:[[UIDevice currentDevice] systemVersion]
        forHTTPHeaderField:@"os"]; // 系统版本号

    if ([USER_LATITUDE length]) {
      [theRequest setValue:USER_LATITUDE forHTTPHeaderField:@"latitude"];
    }

    if ([USER_LONGITUDE length]) {

      [theRequest setValue:USER_LONGITUDE forHTTPHeaderField:@"longitude"];
    }
  }

  if (requestMethod)
    [theRequest setHTTPMethod:requestMethod];
  [self setBodyFor:theRequest];
  DLog(@"theRequest===%@", [theRequest URL]);
  self.requestURLLast = [theRequest URL];
  connection = [[NSURLConnection alloc] initWithRequest:theRequest
                                               delegate:self
                                       startImmediately:NO];

  [connection start];

  [self performSelector:@selector(onTimeout)
             withObject:nil
             afterDelay:kHttpRequestTimeout];
}

- (void)operationWillFinish {

  [connection cancel];

  connection = nil;

  [[TaskQueue sharedTaskQueue] changeNetworkActivityIndicatorStatus:NO];
}

- (void)finishWithError:(NSError *)theError {
  if (theError) {
    //        DLog(@"\n\n########request请求:%@#########\n|error错误:%@\n############################\n\n",
    //             self.identifier,
    //             [[theError userInfo] objectForKey:@"errorLog"]);

    if ([self.userLogFileMgrYN fileExistsAtPath:self.userLogfilePath
                                    isDirectory:NULL]) {

      NSFileHandle *outFile;
      NSData *buffer;
      outFile = [NSFileHandle fileHandleForWritingAtPath:self.userLogfilePath];
      //找到并定位到outFile的末尾位置(在此后追加文件)

      [outFile seekToEndOfFile];

      NSDictionary *logicErrorDict =
          [[theError userInfo] objectForKey:@"LogicError"];

      NSString *logicErrorStr = logicErrorDict[@"error"];

      NSString *logicErrorStrChi = [logicErrorStr
          stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

      NSString *userLogInfoStr4 = [NSString
          stringWithFormat:@"iOS,%@,%@,%@,%f",
                           [NSString stringWithFormat:@"%@", self.startDate],
                           self.requestURL, logicErrorStrChi,
                           0 - [self.startDate timeIntervalSinceNow]];

      //            DLog(@"logicErrorStrChi ========== %@",logicErrorStrChi);

      //            NSString *userLogString = [Cryptor encodeDES:userLogInfoStr4
      //            key:kKDesLogKey];

      NSString *temp = [NSString stringWithFormat:@"\n%@", userLogInfoStr4];
      buffer = [temp dataUsingEncoding:NSUTF8StringEncoding];
      [outFile writeData:buffer];
      //关闭读写文件
      [outFile closeFile];
    }

    [self requestFailedWithError:theError];
  }
  [super finishWithError:theError];
}

#pragma mark child class required method
- (int)cacheVaildTime {
  //分钟
  return 0;
}

- (BOOL)cacheForToday {
  return NO;
}

- (void)getReady {
  // first, generate proper url

  // second, set para and method(post...) to request
}

- (void)requestSucceededResponse {
}

// upload process
- (void)uploadBytesWritten:(NSInteger)written
         totalBytesWritten:(NSInteger)totalWritten
 totalBytesExpectedToWrite:(NSInteger)totalExpectedToWrite {
}

// called after a connection has been succeeded
- (void)requestSucceededWithData:(id)result {
  // operation data here
  // we can olny operate data in self.manage context, and never do that in
  // dataengine cotext
  // after make changes in self.managedContext, call save to sync with
  // dataengine managedContext
  // post success notification
}

- (void)requestSucceededWithData:(id)result fromCache:(BOOL)cached {
}

// called when there are error occurred
- (void)requestFailedWithError:(NSError *)error {
  // do operation and post failed notification
  [self postNotificationSucceeded:NO withInfo:[error userInfo]];
}

- (void)weiboAuthError {
  [[SinaClient sharedSinaClient] logoutFinished:^(OAuthClient *client){

  }];

  UIAlertView *alertView =
      [[UIAlertView alloc] initWithTitle:@""
                                 message:@"微博认证信息失效, "
                                         @"请重新绑定微博并注意帐号安全哦"
                                delegate:nil
                       cancelButtonTitle:@"好的"
                       otherButtonTitles:nil, nil];
  [alertView show];
}

- (void)loginExpired:(NSDictionary *)result {
  /*
   {
   error = "Login is expired.";
   status = "-1";
   }
   */
  [appDelegate signout];
}

- (void)addOrderExpired:(NSDictionary *)result {
  NSDictionary *dict = (NSDictionary *)result;

  NSString *actionName = dict[@"action"];
  NSDictionary *codes = [dict kkz_objForKey:@"code"];
  NSString *codeKey = @"";
  NSString *codeUrl = @"";
  if ([codes isKindOfClass:[NSDictionary class]]) {
    codeKey = codes[@"codeKey"];
    codeUrl = codes[@"codeUrl"];
  }

  //    DLog(@"code_key == %@  codeUrl == %@ action_name ==
  //    %@",codeKey,codeUrl,actionName);

  VerificationCodeController *ctr = [[VerificationCodeController alloc] init];
  ctr.actionName = actionName;
  ctr.codeUrl = codeUrl;
  ctr.codeKey = codeKey;

  CommonViewController *parentCtr =
      [KKZUtility getRootNavagationLastTopController];
  [parentCtr pushViewController:ctr animation:CommonSwitchAnimationBounce];
}

- (void)showAddintegralNotice:(NSDictionary *)integral {
  NSString *title = integral[@"content"];
  NSString *score = integral[@"integral"];
  NSString *iconPath = integral[@"icon"];
  [appDelegate showIntegralViewWithTitle:title
                                andScore:score
                             andIconPath:iconPath];
}

- (void)handleData:(NSData *)data fromCache:(BOOL)cached {
  id result = nil;

  //是图片data
  if (self.resultIsData) {
    result = data;
    if ([self isKindOfClass:[ImageNewTask class]]) {
      [self requestSucceededWithData:result fromCache:cached];
    } else {
      [self requestSucceededWithData:result];
    }
  } else {

    if (requestType == NetworkReqTypeKSSP) {

      if (cached) {
        NSError *error;
        result =
            [NSJSONSerialization JSONObjectWithData:data
                                            options:NSJSONReadingMutableLeaves
                                              error:&error];
        if (self.checkCached) {
          [self requestSucceededWithData:result fromCache:cached];

        } else {
          [self requestSucceededWithData:result];
        }
      } else {

        NSMutableString *responseString =
            [[NSMutableString alloc] initWithData:data
                                         encoding:NSUTF8StringEncoding];
        self.resultOrgin = responseString;
        DLog(@"%@ 网络请求返回原始数据 %@", self.requestURLLast,
             self.resultOrgin);
        [responseString
            replaceOccurrencesOfString:@"\t"
                            withString:@"\\t"
                               options:NSCaseInsensitiveSearch
                                 range:NSMakeRange(0, [responseString length])];
        [responseString
            replaceOccurrencesOfString:@"\\v"
                            withString:@""
                               options:NSCaseInsensitiveSearch
                                 range:NSMakeRange(0, [responseString length])];
        NSData *aData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        result =
            [NSJSONSerialization JSONObjectWithData:aData
                                            options:NSJSONReadingMutableLeaves
                                              error:&error];

        if ([result isKindOfClass:[NSDictionary class]]) {
          int status = [[result objectForKey:@"status"] intValue];
          if (status == -88 || status == -99) {
            [self loginExpired:result];

            NSMutableDictionary *resultCurrent =
                [[NSMutableDictionary alloc] initWithDictionary:result];
            resultCurrent[@"error"] = @"";
            NSError *tmpError = [[NSError alloc]
                initWithDomain:NSURLErrorDomain
                          code:kHttpRequestErrorKKZ
                      userInfo:[NSDictionary
                                   dictionaryWithObject:resultCurrent
                                                 forKey:kHttpLogicErrorKey]];
            [self finishWithError:tmpError];
              [[DataEngine sharedDataEngine] startLoginFinished:^(BOOL succeeded) {
                  
              }];
          } else if (status == -89) {

            //                        DLog(@"需要调用图片验证码接口");

            [self addOrderExpired:result];

            NSMutableDictionary *resultCurrent =
                [[NSMutableDictionary alloc] initWithDictionary:result];

            resultCurrent[@"error"] = @"";

            NSError *tmpError = [[NSError alloc]
                initWithDomain:NSURLErrorDomain
                          code:kHttpRequestErrorKKZ
                      userInfo:[NSDictionary
                                   dictionaryWithObject:resultCurrent
                                                 forKey:kHttpLogicErrorKey]];
            [self finishWithError:tmpError];

          } else if (status == 0) {
            NSMutableDictionary *finalRes =
                [[NSMutableDictionary alloc] initWithDictionary:result];
            [finalRes setObj:[NSNumber numberWithBool:cached]
                      forKey:kResultIsCache];
            if (!cached) {
              [finalRes
                  setObj:[NSNumber numberWithDouble:
                                       [NSDate timeIntervalSinceReferenceDate]]
                  forKey:kCacheServerDataTimestampKey];
            }

            if ([[result allKeys] containsObject:@"integral"] &&
                taskType != TaskTypeRewardScore) {
              NSDictionary *integralDict = [result objectForKey:@"integral"];
              //弹出积分提醒的消息
              [self performSelector:@selector(showAddintegralNotice:)
                         withObject:integralDict
                         afterDelay:0.1];
            }

            //                        DLog(@"request succeeded, and handle
            //                        data");

            if (taskType == TaskTypeKotaUserDetail &&
                [[NetworkUtil me] reachable]) {

              [self updateCacheWithResult:data];

            } else {

              if (!cached && [self cacheVaildTime] > 0) {
                // NSError *error;
                [self updateCacheWithResult:
                          data]; //[NSJSONSerialization
                                 //JSONObjectWithData:jsonData
                                 //options:NSJSONReadingMutableLeaves
                                 //error:&error]];//]data];
              }
            }

            if (taskType == TaskTypeGetCityList) {
              NSString *plistPath =
                  [[NSBundle mainBundle] pathForResource:@"citylist"
                                                  ofType:@"plist"];
              NSError *__autoreleasing writeToFileError;
              [self.resultOrgin writeToFile:plistPath
                                 atomically:YES
                                   encoding:NSUTF8StringEncoding
                                      error:&writeToFileError];

            } else {
              if ([self.userLogFileMgrYN fileExistsAtPath:self.userLogfilePath
                                              isDirectory:NULL]) {

                NSFileHandle *outFile;
                NSData *buffer;

                outFile = [NSFileHandle
                    fileHandleForWritingAtPath:self.userLogfilePath];

                if (outFile == nil) {
                  DLog(@"Open of file for writing failed");
                }

                //找到并定位到outFile的末尾位置(在此后追加文件)
                [outFile seekToEndOfFile];

                //                                DLog(@"self.startDate succeed
                //                                ==========
                //                                %@",self.startDate);

                NSString *userLogInfoStr3 = [NSString
                    stringWithFormat:@"iOS,%@,%@,%@,%f",
                                     [NSString stringWithFormat:@"%@",
                                                                self.startDate],
                                     self.requestURL, self.resultOrgin,
                                     0 - [self.startDate timeIntervalSinceNow]];

                //读取inFile并且将其内容写到outFile中
                //                            NSString *userLogString = [Cryptor
                //                            encodeDES:userLogInfoStr3
                //                            key:kKDesLogKey];

                NSString *temp =
                    [NSString stringWithFormat:@"\n%@", userLogInfoStr3];
                buffer = [temp dataUsingEncoding:NSUTF8StringEncoding];

                //                        buffer = [userLogInfoStr3
                //                        dataUsingEncoding:NSUTF8StringEncoding];
                [outFile writeData:buffer];

                //关闭读写文件
                [outFile closeFile];
              }
            }

            if (self.checkCached) {
              [self requestSucceededWithData:finalRes fromCache:cached];

            } else {
              [self requestSucceededWithData:finalRes];
            }

            // [self requestSucceededWithData:finalRes];

          } else {
            if ([self cacheVaildTime] > 0)
              [self deleteCache];

            NSError *tmpError = [[NSError alloc]
                initWithDomain:NSURLErrorDomain
                          code:kHttpRequestErrorKKZ
                      userInfo:[NSDictionary
                                   dictionaryWithObject:result
                                                 forKey:kHttpLogicErrorKey]];
            [self finishWithError:tmpError];
          }
        } else {

          if ([self cacheVaildTime] > 0)
            [self deleteCache];

          NSError *tmpError =
              [[NSError alloc] initWithDomain:NSURLErrorDomain
                                         code:kHttpRequestErrorKKZ
                                     userInfo:nil];
          [self finishWithError:tmpError];
        }
      }

    } else {

      if (!cached)
        [self printDidFinishedLog:result];
    }
  }
  if (requestType == NetworkReqTypeSina) {
    //            NSString *dataString = [[NSString alloc] initWithData:data
    //            encoding:NSUTF8StringEncoding];
    NSError *error;
    result = [NSJSONSerialization JSONObjectWithData:data
                                             options:NSJSONReadingMutableLeaves
                                               error:&error];
    //            [dataString release];

    if ([result isKindOfClass:[NSDictionary class]]) {
      if ([result objectForKey:@"error_code"] != nil &&
          [[result objectForKey:@"error_code"] intValue] != 200) {

        if ([self cacheVaildTime] > 0)
          [self deleteCache];

        DLog(@"error occured when fetch weibo content");

        NSError *tmpError = [[NSError alloc]
            initWithDomain:NSURLErrorDomain
                      code:kHttpRequestErrorKKZ
                  userInfo:[NSDictionary
                               dictionaryWithObject:result
                                             forKey:kHttpLogicErrorKey]];
        [self finishWithError:tmpError];

      } else {
        if (!cached && [self cacheVaildTime] > 0)
          [self updateCacheWithResult:data];
        if (self.checkCached) {
          [self requestSucceededWithData:result fromCache:cached];

        } else {
          [self requestSucceededWithData:result];
        }
      }
    } else {
      NSError *tmpError = [[NSError alloc] initWithDomain:NSURLErrorDomain
                                                     code:kHttpRequestErrorKKZ
                                                 userInfo:nil];
      [self finishWithError:tmpError];
    }

    if (!cached)
      [self printDidFinishedLog:result];
  }

  if (requestType == NetworkReqTypeOther) {
    //            NSString *dataString = [[NSString alloc] initWithData:data
    //            encoding:NSUTF8StringEncoding];
    NSError *error;
    result = [NSJSONSerialization JSONObjectWithData:data
                                             options:NSJSONReadingMutableLeaves
                                               error:&error];
    //            [dataString release];
    // warning other task not support cache

    if (self.checkCached) {
      [self requestSucceededWithData:result fromCache:cached];

    } else {
      [self requestSucceededWithData:result];
    }
    [self printDidFinishedLog:result];
  }
}

- (void)doCallBack:(BOOL)succeeded info:(id)info {
  if (self.finishBlock) {
    dispatch_async(dispatch_get_main_queue(), ^{
      self.finishBlock(succeeded, info);
      self.finishBlock = nil;

    });
  }
}

- (void)configureParams:(NSDictionary *)params {
}

- (NSString *)startCallApi {

  //私有参数
  //获取私有参数
  NSDictionary *privateDict = [self.paramsSource paramsForApi:self];
  [self configureParams:privateDict];
  return [[TaskQueue sharedTaskQueue] addTaskToQueue:self];
}

#pragma mark NSURLConnection delegate
- (void)onTimeout {
  DLog(@"%@ HttpRequest timeout请求超时 !!! %@", self.identifier,
       self.requestURL);
  //    NSDictionary *LogicError = [NSDictionary
  //    dictionaryWithObject:[NSDictionary
  //    dictionaryWithObject:@"请求超时，请检查你的网络连接。" forKey:@"error"]
  //    forKey:@"LogicError"];
  //    NSError *failConnectError = [NSError errorWithDomain:NSURLErrorDomain
  //                                                    code:kHttpRequestErrorTimeout
  //                                                userInfo:LogicError];

  NSError *tmpError = [[NSError alloc]
      initWithDomain:NSURLErrorDomain
                code:kHttpRequestErrorTimeout
            userInfo:@{
              @"LogicError" : @{
                @"error" : @"请求超时，请检查你的网络连接。",
                timeOutErrorKey : @(1)
              }
            }];
  [self finishWithError:tmpError];
  //    [tmpError release];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *)response {
  assert((response == nil) ||
         [response isKindOfClass:[NSHTTPURLResponse class]]);

  self.lastResponse = (NSHTTPURLResponse *)response;
  return request;
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response {
  [_receiveData setLength:0];

  [NSObject cancelPreviousPerformRequestsWithTarget:self
                                           selector:@selector(onTimeout)
                                             object:nil];

  self.lastResponse = (NSHTTPURLResponse *)response;
  NSInteger statusCode = self.lastResponse.statusCode;

  if ((statusCode / 100) == 2) {
    [self requestSucceededResponse];
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  assert(data != nil);

  [NSObject cancelPreviousPerformRequestsWithTarget:self
                                           selector:@selector(onTimeout)
                                             object:nil];

  [_receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  [NSObject cancelPreviousPerformRequestsWithTarget:self
                                           selector:@selector(onTimeout)
                                             object:nil];

  NSError *tmpError = nil;

  NSInteger statusCode = self.lastResponse.statusCode;
  if (statusCode < 100 || statusCode >= 300) {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(
        kCFStringEncodingGB_18030_2000);
    NSString *responseString =
        [[NSString alloc] initWithData:_receiveData encoding:enc];
    id result = responseString;

    if (requestType == NetworkReqTypeSina) {
      NSError *error;
      result =
          [NSJSONSerialization JSONObjectWithData:_receiveData
                                          options:NSJSONReadingMutableLeaves
                                            error:&error];
      if (result && [result isKindOfClass:[NSDictionary class]]) {
        if ([result objectForKey:@"error_code"] != nil &&
            [[result objectForKey:@"error_code"] intValue] != 200) {
          int errorCode = [[result objectForKey:@"error_code"] intValue];
          /*
           21314 ： Token已经被使用
           21315 ： Token已经过期
           21316 ： Token不合法
           21317 ： Token不合法
           21318 ： Pin码认证失败
           21319 ： 授权关系已经被解除
           21332 ： access_token 无效
           */
          if (errorCode == 21314 || errorCode == 21315 || errorCode == 21316 ||
              errorCode == 21317 || errorCode == 21318 || errorCode == 21319 ||
              errorCode == 21332 || errorCode == 21301) {
            [self weiboAuthError];
          }
          DLog(@"error occured when fetch weibo content");
        }
      }
      [self printDidFinishedLog:result];
    }

    //错误信息封装
    NSDictionary *LogicError = [NSDictionary
        dictionaryWithObject:[NSDictionary
                                 dictionaryWithObject:result ? result
                                                             : @"请求失败"
                                               forKey:@"error"]
                      forKey:@"LogicError"];
    tmpError = [NSError errorWithDomain:HttpRequestErrorDomain
                                   code:statusCode
                               userInfo:LogicError];

    result = nil;
  }

  if (![self.lastResponse MIMEType])
    tmpError = [NSError errorWithDomain:HttpRequestErrorDomain
                                   code:kHttpRequestErrorBadContentType
                               userInfo:nil];

  if (tmpError) {
    [self finishWithError:tmpError];
  } else {
    [self handleData:_receiveData fromCache:NO];
    [self finishWithError:nil];
  }
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {

  //取消超时连接
  [NSObject cancelPreviousPerformRequestsWithTarget:self
                                           selector:@selector(onTimeout)
                                             object:nil];
  //-1009 似乎已断开与互联网的连接
  //-1004
  if (error.code == -1004 || error.code == -1009) {
    NSDictionary *LogicError = [NSDictionary
        dictionaryWithObject:[NSDictionary
                                 dictionaryWithObject:error.localizedDescription
                                               forKey:@"error"]
                      forKey:@"LogicError"];
    NSError *failConnectError = [NSError errorWithDomain:error.domain
                                                    code:error.code
                                                userInfo:LogicError];
    [self finishWithError:failConnectError];
  } else {
    [self finishWithError:error];
  }
}

- (BOOL)connection:(NSURLConnection *)connection
    canAuthenticateAgainstProtectionSpace:
        (NSURLProtectionSpace *)protectionSpace {
  if ([[protectionSpace authenticationMethod]
          isEqualToString:NSURLAuthenticationMethodServerTrust]) {
    DLog(@"Server Trust will be checked");
    return YES;
  }
  return NO;
}

- (void)connection:(NSURLConnection *)connection
    didReceiveAuthenticationChallenge:
        (NSURLAuthenticationChallenge *)challenge {
  SecTrustRef trustRef = challenge.protectionSpace.serverTrust;
  SecTrustResultType result = 0;
  NSURLCredential *credential = nil;

  SecTrustEvaluate(trustRef, &result);
  credential = [NSURLCredential credentialForTrust:trustRef];
  if (credential) {
    [challenge.sender useCredential:credential
         forAuthenticationChallenge:challenge];
  } else {
    [challenge.sender
        continueWithoutCredentialForAuthenticationChallenge:challenge];
  }
}

- (void)connection:(NSURLConnection *)connection
              didSendBodyData:(NSInteger)written
            totalBytesWritten:(NSInteger)totalWritten
    totalBytesExpectedToWrite:(NSInteger)totalExpectedToWrite {
  // TODO: every 5% make a callback
  if (doUpload) {
    [self uploadBytesWritten:written
                totalBytesWritten:totalWritten
        totalBytesExpectedToWrite:totalExpectedToWrite];
  }
}

- (void)printBeforeRequestLog:(NSURLRequest *)
                      request:(NSMutableString *)encodedParameterPairs {
  DLog(@"\n\n########################\n|request开始请求，请求类 <%@ %p> "
       @"\n|请求类型-请求 \n|调用方法 %@ \n|唯一标示%@#########\n|url: "
       @"%@\n|paras: %@\n|header头: %@\n############################\n\n",
       [self class], self, NSStringFromSelector(_cmd), self.identifier,
       [request URL], encodedParameterPairs, [request allHTTPHeaderFields]);

  //    NSArray *syms = [NSThread  callStackSymbols];
  //    if ([syms count] > 1) {
  //
  //        //        DLog(@"%@",syms[0]);
  //        //        DLog(@"%@",syms[1]);
  //        //        DLog(@"%@",syms[2]);
  //                for (NSString *object in syms) {
  //                    DLog(@"%@",object);
  //                }
  //    }else{
  //
  //    }
}
- (void)printDidFinishedLog:(id)result {
  NSError *error = nil;
  if (result == nil) {
    DLog(@"\n##########################\n|响应请求，调用类 <%@ %p> "
         @"\n|请求类型-响应 \n|调用方法 %@ \n|唯一标示:%@ "
         @"\n|result结果:\n############################\n\n",
         [self class], self, NSStringFromSelector(_cmd), self.identifier);
    return;
  }
  NSData *jsonData =
      [NSJSONSerialization dataWithJSONObject:result
                                      options:NSJSONWritingPrettyPrinted
                                        error:&error];
  NSString *jsonString =
      [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

  NSArray *syms = [NSThread callStackSymbols];
  if ([syms count] > 1) {
    DLog(@"\n##########################\n|响应请求，调用类 <%@ %p> "
         @"\n|请求类型-响应 \n|调用方法 %@ \n|唯一标示:%@ "
         @"\n|result结果:%@\n############################\n\n",
         [self class], self, NSStringFromSelector(_cmd), self.identifier,
         jsonString);
    //        DLog(@"%@",syms[0]);
    //        DLog(@"%@",syms[1]);
    //        DLog(@"%@",syms[2]);
    //        for (NSString *object in syms) {
    //            DLog(@"%@",object);
    //        }
  } else {
    DLog(@"\n##########################\n|响应请求，调用类 <%@ %p> "
         @"\n|请求类型-响应 \n|调用方法 %@ \n|唯一标示:%@ "
         @"\n|result结果:%@\n############################\n\n",
         [self class], self, NSStringFromSelector(_cmd), self.identifier,
         jsonString);
  }
}

@end
