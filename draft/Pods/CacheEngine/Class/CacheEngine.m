
//
//  CacheEngine.m
//  KoMovie
//
//  Created by alfaromeo on 12-6-5.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import "CacheEngine.h"
#import "RNCachingURLProtocol.h"

#define kDisableCache 0
#define KCachePrefix @"Cache_"
#define kCacheFolderPath @"UserCaches/"   //网络请求后的缓存数据路径
#define kCacheLogFolderPath @"KoMovie/"   //网络请求的日期路径
static CacheEngine * _sharedCacheEngine = nil;


@interface CacheEngine ()

- (void)createDirection;
- (NSString *)cacheFilePathForId:(NSString *)cacheId;

@end



@implementation CacheEngine



+ (CacheEngine *)sharedCacheEngine {
    @synchronized(self) {
        if ( _sharedCacheEngine == nil ) {
            _sharedCacheEngine = [[CacheEngine alloc] init];
        }
        return _sharedCacheEngine;
    }
}

- (id)init {
	self = [super init];
    
    if (self) {
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		documentDir = [[[documentPaths objectAtIndex:0] stringByAppendingString:@"/"] retain];
		fileManager = [[NSFileManager defaultManager] retain];
        [self createDirection];
    }
    
	return self;
}

- (void)dealloc {
    
    [documentDir release];
	[fileManager release];
    
	[super dealloc];
}



#pragma mark utility
- (void)createDirection {
	NSString *imagePath = [documentDir stringByAppendingPathComponent:kCacheFolderPath];
	if (![fileManager fileExistsAtPath:imagePath])
		[fileManager createDirectoryAtPath:imagePath
               withIntermediateDirectories:NO
                                attributes:nil
                                     error:nil];
}

- (long)diskCacheSizeMB {
    
    //获取用户的网络请求缓存数据
    NSString *requestCache = [documentDir stringByAppendingPathComponent:@"UserCaches/"];
    
    //请求音频的缓存数据
    NSString *audioCachePath = [documentDir stringByAppendingPathComponent:@"UserData/"];
    
    //获取图片下载的缓存数据
    NSString *imageCachePath = [documentDir stringByAppendingPathComponent:@"UserImages/"];
    
    //获取请求的日志下载路径
    NSString *logCachePath = [documentDir stringByAppendingPathComponent:@"KoMovie/"];
    
    //发现的网页缓存数据路径
    NSString *discoverPath = [documentDir stringByAppendingPathComponent:@"DiscoverViewController"];
   
    //周边的网页缓存数据路径
    NSString *hobbyPath = [documentDir stringByAppendingPathComponent:@"HobbyViewController"];
    
    //将四个路径下的文件加起来
    long sizeY = [self fileSizeAtFile:requestCache];
    sizeY += [self fileSizeAtFile:audioCachePath];
    sizeY += [self fileSizeAtFile:imageCachePath];
    sizeY += [self fileSizeAtFile:logCachePath];
    sizeY += [self fileSizeAtFile:discoverPath];
    sizeY += [self fileSizeAtFile:hobbyPath];
    return sizeY / 1000;
}


- (long)diskCacheSizeMBOfUserlog {
    
    NSString *imagePath4 = [documentDir stringByAppendingPathComponent:@"KoMovie/"];
    
    long sizeY = [self fileSizeAtFile:imagePath4];
    
    return sizeY / 1000;
    
    
}


- (long)fileSizeAtFile:(NSString *)file{
    // 1.文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 2.判断file是否存在
    BOOL isDirectory = NO;
    BOOL fileExists = [mgr fileExistsAtPath:file isDirectory:&isDirectory];
    // 文件\文件夹不存在
    if (fileExists == NO) return 0;
    
    // 3.判断file是否为文件夹
    if (isDirectory) { // 是文件夹
        NSArray *subpaths = [mgr contentsOfDirectoryAtPath:file error:nil];
        long totalSize = 0;
        for (NSString *subpath in subpaths) {
            NSString *fullSubpath = [file stringByAppendingPathComponent:subpath];
            totalSize += [self fileSizeAtFile:fullSubpath];
        }
        return totalSize;
    }
    else { // 不是文件夹, 文件
        // 直接计算当前文件的尺寸
        NSDictionary *attr = [mgr attributesOfItemAtPath:file error:nil];
//        DLog(@"[[attr objectForKey:NSFileSize] longLongValue] === %lld",[[attr objectForKey:NSFileSize] longLongValue]);
//         DLog(@"[[attr objectForKey:NSFileSize] longLongValue] / 1024.0 / 1024.0 === %f",[[attr objectForKey:NSFileSize] longLongValue] / 1024.0 / 1024.0);
        return [[attr objectForKey:NSFileSize] longLongValue] * 1000 / 1024.0 / 1024.0;
        
    }
    
}

/**
 *  网络请求后的缓存数据
 *
 *  @param cacheId 请求缓存的Id
 *  @param data    要缓存的数据
 *  @param minute  有效时间
 */
- (void)updateCacheForId:(NSString *)cacheId
                    data:(NSData *)data
               validTime:(NSInteger)minute {
#if kDisableCache
    return;
#else
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString *cachePath =[self cacheFilePathForId:cacheId];
        if (cachePath) {
            NSError *error = nil;
            @synchronized(self) {
                [data writeToFile:cachePath
                          options:NSDataWritingAtomic
                            error:&error];
            }
            if (error) {
                [self createDirection];
            }
        }
    });
#endif
}

- (id)getCacheForId:(NSString *)cacheId validTime:(int)minute {
#if kDisableCache
    return nil;
#else
    NSString *cachePath =[self cacheFilePathForId:cacheId];
    NSDictionary *fileAttribs = [[NSFileManager defaultManager] attributesOfItemAtPath:cachePath error:nil];
    NSDate *modificationDate = [fileAttribs fileModificationDate];
    
    if ( !modificationDate || minute <=0 || [modificationDate timeIntervalSinceNow] < -minute*60 ) {
        [self deleteCacheForId:cacheId];
        return nil;
    } else {
        return [NSData dataWithContentsOfFile:cachePath];
    }
#endif
}



#pragma mark cache basic framework
- (NSString *)cacheFilePathForId:(NSString *)cacheId {
    if ([cacheId length]) {
        return [NSString stringWithFormat:@"%@%@%@%@", documentDir, kCacheFolderPath, KCachePrefix, cacheId];
    }
    return nil;
}

- (void)deleteCacheForId:(NSString *)cacheId {
    NSString *cachePath =[self cacheFilePathForId:cacheId];
    if (cachePath) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            
            @synchronized(self) {
                [fileManager removeItemAtPath:cachePath error:nil];
            }
        });
    }
}

- (void)deleteCacheIdLike:(NSString *)keyword {
    if (keyword) {
        NSString *encodedKeyword = [keyword URLEncodedString];
        NSString *imagePath = [documentDir stringByAppendingPathComponent:kCacheFolderPath];
        if ([fileManager fileExistsAtPath:imagePath]) {
            NSError *error = nil;
            NSArray *allFiles = [fileManager contentsOfDirectoryAtPath:imagePath error:&error];
            for (NSString *file in allFiles) {
                if ([file rangeOfString:encodedKeyword].location != NSNotFound) {
                    BOOL success = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", imagePath, file]
                                                           error:&error];
                    if (!success || error) {
                        NSLog(@"failed to remove: %@", file);
                    }
                }
            }
        }
    }
}

- (void)resetCache {
    NSString *imagePath = [documentDir stringByAppendingPathComponent:kCacheFolderPath];
	if ([fileManager fileExistsAtPath:imagePath]) {
        [fileManager removeItemAtPath:imagePath error:nil];
        [self createDirection];
    }
    
    NSString *logPath = [documentDir stringByAppendingPathComponent:kCacheLogFolderPath];
    if ([fileManager fileExistsAtPath:logPath]) {
        [fileManager removeItemAtPath:logPath error:nil];
//        [self createDirection];
    }

    //清除网页缓存
    [RNCachingURLProtocol clearWebCache];
}


-(void)clearCaches
{
    
    NSString *userCatchesPath = [documentDir stringByAppendingPathComponent:@"UserCaches/"];
    NSString *userLogPath = [documentDir stringByAppendingPathComponent:@"KoMovie/"];

    
    if ([fileManager fileExistsAtPath:userCatchesPath]) {
        [fileManager removeItemAtPath:userCatchesPath error:nil];
        NSError *error = nil;
        NSArray *allFiles = [fileManager contentsOfDirectoryAtPath:userCatchesPath error:&error];
        for (NSString *file in allFiles) {
            BOOL success = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", userCatchesPath, file]
                                                   error:&error];
            if (!success || error) {
                NSLog(@"failed to remove: %@", file);
            }
        }
    }
    
    if ([fileManager fileExistsAtPath:userLogPath]) {
        [fileManager removeItemAtPath:userLogPath error:nil];
        NSError *error = nil;
        NSArray *allFiles = [fileManager contentsOfDirectoryAtPath:userLogPath error:&error];
        for (NSString *file in allFiles) {
            BOOL success = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", userLogPath, file]
                                                   error:&error];
            if (!success || error) {
                NSLog(@"failed to remove: %@", file);
            }
        }
    }

    //清除网页缓存
    [RNCachingURLProtocol clearWebCache];
}


@end
