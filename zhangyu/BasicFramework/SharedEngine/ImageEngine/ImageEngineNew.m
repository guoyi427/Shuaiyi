//
//  imageEngineNew.m
//  phonebook
//
//  Created by da zhang on 11-3-3.
//  Copyright 2011  . All rights reserved.
//

#import "imageEngineNew.h"

#include <mach/mach.h>
#include <sys/sysctl.h>

#import <AssetsLibrary/AssetsLibrary.h>

#import "DataEngine.h"
#import "KKZUtility.h"
#import "NSStringExtra.h"
#import "TaskQueue.h"
#import "UIDeviceExtra.h"
#import "UIImageExtra.h"

#define kImgFolderPath @"UserImages/"
#define kSpiltSign @"|"

static ImageEngineNew *_imageEngineNew = nil;

@implementation ImageEngineNew

@synthesize cacheImageNum;

+ (ImageEngineNew *)sharedImageEngineNew {
    @synchronized(self) {
        if (!_imageEngineNew) {
            _imageEngineNew = [[ImageEngineNew alloc] init];
        }
    }
    return _imageEngineNew;
}

- (ImageEngineNew *)init {
    self = [super init];
    if (self) {
        //TODO: scan disk to reduce lacal storage
        imageMemoryDict = [[NSMutableDictionary alloc] init];
        defaultImgDict = [[NSMutableDictionary alloc] init];

        cacheImageNum = 30; //默认值

        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        documentDir = [[[documentPaths objectAtIndex:0] stringByAppendingString:@"/"] retain];

        fileManager = [[NSFileManager defaultManager] retain];

        //        NSTimer *timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
        //        [timer fire];

        [self createDirection];
    }
    return self;
}

- (void)dealloc {
    [documentDir release];
    [fileManager release];
    [imageMemoryDict release];
    [defaultImgDict release];

    [super dealloc];
}

#pragma mark EngineNew run method
- (void)createDirection {
    NSString *imagePath = [documentDir stringByAppendingPathComponent:kImgFolderPath];
    if (![fileManager fileExistsAtPath:imagePath]) {
        [fileManager createDirectoryAtPath:imagePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
}

- (void)releaseImageCache {
    [imageMemoryDict removeAllObjects];
    [defaultImgDict removeAllObjects];
}

- (void)resetCache {
    NSString *imagePath = [documentDir stringByAppendingPathComponent:kImgFolderPath];
    if ([fileManager fileExistsAtPath:imagePath]) {
        [fileManager removeItemAtPath:imagePath error:nil];
        [self createDirection];

        NSError *error = nil;
        NSArray *allFiles = [fileManager contentsOfDirectoryAtPath:imagePath error:&error];
        for (NSString *file in allFiles) {
            BOOL success = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", imagePath, file]
                                                   error:&error];
            if (!success || error) {
                DLog(@"failed to remove: %@", file);
            }
        }
    }
}

- (UIImage *)imageFromDiskWithName:(NSString *)imgName {
    if (imgName) {
        //        DLog(@"\n图片从磁盘取出path:%@",imgName);

        UIImage *img = [[UIImage alloc] initWithContentsOfFile:[documentDir stringByAppendingString:imgName]];

        UIImage *drawable = [img decodedImageToSize:CGSizeZero fill:NO];
        [img release];
        return drawable;

    } else {
        return nil;
    }
}

//得到图片大小
- (int)getImageSizeForKey:(NSString *)key {
    NSArray *spiltedName = [key componentsSeparatedByString:kSpiltSign];
    if ([spiltedName count] == 2) {
        return (ImageSize)[[spiltedName objectAtIndex:0] intValue];
    }
    return ImageSizeSmall;
}

- (BOOL)shouldStoreImageInMemoryWithSize:(ImageSize)size {
    switch (size) {
        case ImageSizeTiny:
            return YES;
        case ImageSizeSmall:
            return YES;
        case ImageSizeMiddle:
            return NO;
        case ImageSizeLarge:
            return NO;
        default:
            return NO;
    }
}

#pragma mark get image with url
- (NSString *)getImageKeyForURL:(NSString *)path andSize:(ImageSize)size {
    if (![path length])
        return nil;

    return [NSString stringWithFormat:@"%d%@%@", size, kSpiltSign, [path imageKeyFromURL]];
}

- (NSString *)getImageIdForKey:(NSString *)imageKey {
    NSArray *spiltedName = [imageKey componentsSeparatedByString:kSpiltSign];
    if ([spiltedName count] == 2) {
        return [spiltedName objectAtIndex:1];
    }
    return @"nokey";
}

- (void)deleteImageForId:(NSString *)imageId {
    NSString *path = nil;
    //get reference direction
    NSArray *files = [fileManager subpathsOfDirectoryAtPath:[NSString stringWithFormat:@"%@%@", documentDir, kImgFolderPath] error:nil];
    for (int i = 0; i < [files count]; i++) {
        path = [files objectAtIndex:i];
        NSString *iId = [self getImageIdForKey:path];
        if (iId && [iId isEqualToString:imageId]) {
            if ([fileManager fileExistsAtPath:path] == YES)
                [fileManager removeItemAtPath:path error:nil];
        }
    }
}

- (UIImage *)getImageFromMemForURL:(NSString *)path andSize:(ImageSize)size {
    NSString *key = [self getImageKeyForURL:path andSize:size];
    if (key) {
        //        DLog(@"\n图片从内存取出key:%@",key);
        UIImage *img = [imageMemoryDict objectForKey:key];
        return img;
    } else {
        return nil;
    }
}

- (UIImage *)getImageFromDiskForURL:(NSString *)path andSize:(ImageSize)size {
    NSString *key = [self getImageKeyForURL:path andSize:size];
    if (key) {
        UIImage *img = [self imageFromDiskWithName:[NSString stringWithFormat:@"%@%@", kImgFolderPath, key]];
        if (img) {
            [self saveImageToMemory:img forKey:key];
        }
        return img;
    } else {
        return nil;
    }
}

#pragma mark save image for url
- (void)saveImage:(UIImage *)image forURL:(NSString *)path andSize:(ImageSize)imageSize sync:(BOOL)sync fromCache:(BOOL)cache {
    NSString *key = [self getImageKeyForURL:path andSize:imageSize];

    if ([self shouldStoreImageInMemoryWithSize:imageSize]) {
        [self saveImageToMemory:image forKey:key];
    }

    //    int size = [self getImageSizeForKey:key];
    [self saveImageToDisk:image forURL:path andSize:imageSize sync:NO fromCache:cache];
}

- (void)saveImageToMemory:(UIImage *)theImg forKey:(NSString *)theKey {
    if (!theImg || !theKey)
        return;

    //    DLog(@"\n图片存入内存中数量%d：key %@",[imageMemoryDict count],theKey);
    @synchronized(imageMemoryDict) {
        if (![imageMemoryDict objectForKey:theKey]) {
            if ([imageMemoryDict count] > cacheImageNum) {
                [imageMemoryDict removeAllObjects];
            }
            [imageMemoryDict setObject:theImg forKey:theKey];
        }
    }
}

- (void)saveImageToDisk:(UIImage *)image forURL:(NSString *)path andSize:(ImageSize)size sync:(BOOL)sync fromCache:(BOOL)cache {
    NSString *key = [self getImageKeyForURL:path andSize:size];

    NSString *imagePath = [NSString stringWithFormat:@"%@%@%@", documentDir, kImgFolderPath, key];

    if (![fileManager fileExistsAtPath:imagePath]) {
        if (key) {
            if (sync) {
                //                DLog(@"\n图片存入磁盘在主线程中:%@\n%@", path,key);
                if (![UIImagePNGRepresentation(image)
                            writeToFile:imagePath
                                options:NSAtomicWrite
                                  error:nil]) {

                    [self createDirection];
                }
            } else {
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                dispatch_async(queue, ^{
                    //                    DLog(@"\n图片存入磁盘:%@\n%@", path,key);
                    if (![UIImagePNGRepresentation(image)
                                writeToFile:imagePath
                                    options:NSAtomicWrite
                                      error:nil]) {

                        [self createDirection];
                    }

                });
            }
        }
    }
}

#pragma mark loadingImage
- (UIImage *)getLoadingImage:(ImageSize)size {
    if (size == ImageSizeLarge || size == ImageSizeOrign) {
        return nil;
    }
    NSString *imgName = ((size == ImageSizeSmall || size == ImageSizeTiny) ? @"loadingChip" : @"loading");

    UIImage *inMem = [defaultImgDict objectForKey:imgName];
    if (inMem) {
        return inMem;
    } else {
        UIImage *img = [UIImage imageNamed:imgName];
        if (img) {
            [defaultImgDict setObject:img forKey:imgName];
        }
    }
    return [defaultImgDict objectForKey:imgName];
}

- (UIImage *)getLoadingImage:(ImageSize)size andImgName:(NSString *)imgNameDefault {
    if (size == ImageSizeLarge || size == ImageSizeOrign) {
        return nil;
    }
    NSString *imgName = imgNameDefault;

    UIImage *inMem = [defaultImgDict objectForKey:imgName];
    if (inMem) {
        return inMem;
    } else {
        UIImage *img = [UIImage imageNamed:imgName];
        if (img) {
            [defaultImgDict setObject:img forKey:imgName];
        }
    }
    return [defaultImgDict objectForKey:imgName];
}

@end
