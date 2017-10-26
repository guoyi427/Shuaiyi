//
//  NetworkTask.h
//  alfaromeo.dev
//
//  Created by zhang da on 11-5-16.
//  Copyright 2011 alfaromeo.dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicTask.h"

#define kResultIsCache @"result_is_cache"

typedef enum {
  NetworkReqTypeKSSP = 0,
  NetworkReqTypeSina,
  NetworkReqTypeOther
} NetworkReqType;

enum {
  kHttpRequestErrorResponseTooLarge = -1,
  kHttpRequestErrorOnOutputStream = -2,
  kHttpRequestErrorBadContentType = -3,
  kHttpRequestErrorTimeout = -4,
  kHttpRequestErrorKKZ = -5
};

@class NetworkTask;

@class KKZAppDelegate;

typedef void (^FinishDownLoadBlock)(BOOL succeeded, NSDictionary *userInfo);

/*************************************************************************************************/
/*                                NetworkTaskCallApiParamSourceDelegate
 为API请求提供主观参数
 */
/*************************************************************************************************/
@protocol NetworkTaskApiCallParamSourceDelegate <NSObject>

@required
- (NSDictionary *)paramsForApi:(NetworkTask *)task;
@end

/*************************************************************************************************/
/*                               NetworkTaskClientCallApiDidDelegate
 API Call 成功失败回调
 */
/*************************************************************************************************/
@protocol NetworkTaskApiCallBackDelegate <NSObject>

@required
- (void)callApiDidSucceed:(NetworkTask *)task;
- (void)callApiDidFailed:(NetworkTask *)task;

@end

@interface NetworkTask : BasicTask {
  NSString *requestMethod;

  NSData *uploadBody;
  NSString *uploadName;
  NSString *uploadFile;

  BOOL doUpload, resultIsData;
  NetworkReqType requestType;

@private
  NSMutableArray *parameters;

  NSMutableData *_receiveData;
  NSURLConnection *connection;
  NSHTTPURLResponse *lastResponse;
}

@property(nonatomic, copy, readonly) NSString *appVersion;
@property(nonatomic, copy, readonly) NSString *netReqId;

@property(nonatomic, copy) NSString *requestURL;
@property(nonatomic, copy) NSURL *requestURLLast;
@property(copy) NSString *requestMethod;

@property(assign) BOOL doUpload;
@property(assign) BOOL resultIsData;
@property(nonatomic, assign) BOOL checkCached;

@property(assign) NetworkReqType requestType;

@property(copy, readwrite) NSHTTPURLResponse *lastResponse;

@property(nonatomic, copy) FinishDownLoadBlock finishBlock;
@property(nonatomic, copy) NSDate *startDate;
@property(nonatomic, copy) NSMutableString *resultOrgin;

@property(nonatomic, copy) NSString *userLogfilePath0;
@property(nonatomic, copy) NSString *userLogDocumentsDirectory;
@property(nonatomic, copy) NSString *userLogfilePath;

@property(nonatomic, strong) NSFileManager *userLogFileMgrYN;

@property(nonatomic, strong) id responseData;

@property(nonatomic, weak)
    id<NetworkTaskApiCallBackDelegate> apiCallBackDelegate;
@property(nonatomic, weak)
    id<NetworkTaskApiCallParamSourceDelegate> paramsSource;

#pragma mark child class method
- (void)addParametersWithValue:(NSString *)value forKey:(NSString *)key;
- (void)addParametersWithValue:(NSString *)value
                        forKey:(NSString *)key
                       withGBK:(BOOL)isGBK;
- (void)setUploadBody:(NSData *)theBody
             withName:(NSString *)theName
             fromFile:(NSString *)theFile;
- (void)getReady;

- (void)handleData:(NSData *)data fromCache:(BOOL)cached;
- (void)doCallBack:(BOOL)succeeded info:(id)info;

- (void)configureParams:(NSDictionary *)params;

- (NSString *)startCallApi;

/*!
 *请求图片成功返回
 @result  图片data
 @cached 是否是从缓存中取出
 */
- (void)requestSucceededWithData:(id)result fromCache:(BOOL)cached;
- (void)requestSucceededWithData:(id)result;
- (void)requestFailedWithError:(NSError *)error;
- (void)requestSucceededResponse;
- (void)uploadBytesWritten:(NSInteger)written
         totalBytesWritten:(NSInteger)totalWritten
 totalBytesExpectedToWrite:(NSInteger)totalExpectedToWrite;

- (int)cacheVaildTime;
- (BOOL)cacheForToday;
- (void)deleteCache;

@end
