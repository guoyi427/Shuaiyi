//
//  CacheEngine.h
//  KoMovie
//
//  Created by alfaromeo on 12-6-5.
//  Copyright (c) 2012年 kokozu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheEngine : NSObject {

    NSString *documentDir;
	NSFileManager *fileManager;
    
}

+ (CacheEngine *)sharedCacheEngine;
- (void)resetCache;

-(void)clearCaches;

/**
 * Get disk cache size in MB.
 */
- (long) diskCacheSizeMB;

//获取日志文件的大小
- (long) diskCacheSizeMBOfUserlog;

- (void)updateCacheForId:(NSString *)cacheId data:(NSData *)data validTime:(NSInteger)minute;
- (id)getCacheForId:(NSString *)cacheId validTime:(int)minute;
- (void)deleteCacheForId:(NSString *)cacheId;
- (void)deleteCacheIdLike:(NSString *)keyword;

@end
