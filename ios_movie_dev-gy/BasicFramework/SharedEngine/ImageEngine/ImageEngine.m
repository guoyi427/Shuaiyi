//
//  ImageEngine.m
//  phonebook
//
//  Created by da zhang on 11-3-3.
//  Copyright 2011  . All rights reserved.
//

#import "ImageEngine.h"

#import "DataEngine.h"
#import "ImageTask.h"
#import "NSStringExtra.h"
#import "TaskQueue.h"
#import "UIDeviceExtra.h"
#import "UIImageExtra.h"

NSString *const ImageReadyNotification = @"ImageReadyNotification";

#define kImgFolderPath @"UserImages/"
#define kSpiltSign @"|"

static ImageEngine *_imageEngine = nil;

@interface ImageEngine (Private)

//engine run method
- (void)createDirection;
- (void)insertImgToMem:(UIImage *)theImg forKey:(NSString *)theKey;

- (NSString *)getImageIdForKey:(NSString *)imageKey;
- (void)deleteImageForId:(NSString *)imageId;
- (void)getRemoteImageForURL:(NSString *)path andSize:(ImageSize)size;
- (BOOL)shouldStoreImageInMemoryWithSize:(ImageSize)size;

@end

@implementation ImageEngine

@synthesize cacheImageNum;

+ (ImageEngine *)sharedImageEngine {
    @synchronized(self) {
        if (!_imageEngine) {
            _imageEngine = [[ImageEngine alloc] init];
        }
    }
    return _imageEngine;
}

- (ImageEngine *)init {
    self = [super init];
    if (self) {
        //TODO: scan disk to reduce lacal storage
        imageMemoryDict = [[NSMutableDictionary alloc] init];
        defaultImgDict = [[NSMutableDictionary alloc] init];

        accessOrderDict = [[NSMutableDictionary alloc] init];

        cacheImageNum = 30;

        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        documentDir = [[[documentPaths objectAtIndex:0] stringByAppendingString:@"/"] retain];

        fileManager = [[NSFileManager defaultManager] retain];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleImageDownloadFinishedNotification:)
                                                 taskType:TaskTypeImageDownload];

        [self createDirection];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self taskType:TaskTypeImageDownload];

    [documentDir release];

    [fileManager release];

    [imageMemoryDict release];
    [defaultImgDict release];
    [accessOrderDict release];

    [super dealloc];
}

#pragma mark engine run method
- (void)createDirection {
    NSString *imagePath = [documentDir stringByAppendingPathComponent:kImgFolderPath];
    if (![fileManager fileExistsAtPath:imagePath])
        [fileManager createDirectoryAtPath:imagePath withIntermediateDirectories:NO attributes:nil error:nil];
}

- (void)insertImgToMem:(UIImage *)theImg forKey:(NSString *)theKey {
    if (!theImg || !theKey)
        return;

    //    DLog(@"内存中图片数量,%d",[imageMemoryDict count]);
    @synchronized(imageMemoryDict) {
        if (![imageMemoryDict objectForKey:theKey]) {
            if ([imageMemoryDict count] > cacheImageNum) {
                [imageMemoryDict removeAllObjects];
            }
            [imageMemoryDict setObject:theImg forKey:theKey];
        }
    }
}

- (void)releaseImageCache {
    [imageMemoryDict removeAllObjects];
    [accessOrderDict removeAllObjects];
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
    if (!imgName) {
        return nil;
    }
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:[documentDir stringByAppendingString:imgName]];
    UIImage *drawable = [img decodedImageToSize:CGSizeZero fill:NO];
    [img release];
    return drawable;
}

//- (ImageSize)getImageSizeForKey:(NSString *)key {
//    NSArray *spiltedName = [key componentsSeparatedByString:kSpiltSign];
//    if ([spiltedName count]==2) {
//        return (ImageSize)[[spiltedName objectAtIndex:0] intValue];
//    }
//    return ImageSizeSmall;
//}

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

- (void)postNotification:(NSString *)notificationName withInfo:(NSDictionary *)userInfo {
    NSNotification *n = [NSNotification notificationWithName:notificationName object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:n waitUntilDone:NO];
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

- (void)prepareImageToMemoryForImage:(NSDictionary *)imageInfo {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSString *path = [imageInfo objectForKey:@"path"];
    ImageSize size = (ImageSize)[[imageInfo objectForKey:@"size"] intValue];

    if (!path)
        return;

    NSString *key = [self getImageKeyForURL:path andSize:size];
    UIImage *image = [self imageFromDiskWithName:[NSString stringWithFormat:@"%@%@", kImgFolderPath, key]];
    if (image) {
        if ([self shouldStoreImageInMemoryWithSize:size]) {
            [self insertImgToMem:image forKey:key];
        }
        [self postNotification:ImageReadyNotification
                        withInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       path, @"path", image, @"image", nil]];
    } else {
        [self getRemoteImageForURL:path andSize:size];
    }

    [pool release];
}

- (void)getRemoteImageForURL:(NSString *)path andSize:(ImageSize)size {
    NSString *key = [self getImageKeyForURL:path andSize:size];
    if (!key)
        return;

    ImageTask *task = [[ImageTask alloc] initImageDownloadFrom:path size:size];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
    [task release];
}

- (UIImage *)getImageForURL:(NSString *)path andSize:(ImageSize)size {
    NSString *key = [self getImageKeyForURL:path andSize:size];
    if (!key)
        return nil;

    UIImage *img = [imageMemoryDict objectForKey:key];
    if (![imageMemoryDict objectForKey:key]) {
        img = [self getLoadingImage:size];
        [NSThread detachNewThreadSelector:@selector(prepareImageToMemoryForImage:)
                                 toTarget:self
                               withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                path, @"path",
                                                                [NSNumber numberWithInt:size], @"size", nil]];
    }
    return img;
}

- (UIImage *)getImageFromMemForURL:(NSString *)path andSize:(ImageSize)size {
    NSString *key = [self getImageKeyForURL:path andSize:size];
    if (!key)
        return nil;

    UIImage *img = [imageMemoryDict objectForKey:key];
    if (!img) {
        img = [self getLoadingImage:size];
    }
    return img;
}

- (UIImage *)getImageFromDiskForURL:(NSString *)path andSize:(ImageSize)size {
    NSString *key = [self getImageKeyForURL:path andSize:size];
    if (!key)
        return nil;

    UIImage *img = [self imageFromDiskWithName:[NSString stringWithFormat:@"%@%@", kImgFolderPath, key]];
    if (img) {
        return img;
    } else {
        [self getRemoteImageForURL:path andSize:size];
        return [self getLoadingImage:size];
    }
}

#pragma mark save image for url
- (void)saveImage:(UIImage *)image forURL:(NSString *)path andSize:(ImageSize)size sync:(BOOL)sync {
    NSString *key = [self getImageKeyForURL:path andSize:size];

    if (key) {
        if (sync) {
            DLog(@"write image to disk on main thread:%@", path);
            if (![UIImagePNGRepresentation(image)
                        writeToFile:[NSString stringWithFormat:@"%@%@%@", documentDir, kImgFolderPath, key]
                            options:NSAtomicWrite
                              error:nil])
                [self createDirection];

            //            获得图片下载的路径，通过NSFileManager removeItemAtPath
            //            NSString *localPath = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents"] ;
            //            NSFileManager *fileManager = [NSFileManager defaultManager];
            //            NSArray *fileArray = [fileManager contentsOfDirectoryAtPath:localPath error:nil];
            //            for (NSString *str in fileArray) {
            //                NSString *filePath = [localPath stringByAppendingPathComponent:str];
            //                [fileManager removeItemAtPath:filePath error:nil];
            //            }
            //            删除documents目录下的所有文件

        } else {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                DLog(@"write image to disk:%@", path);
                if (![UIImagePNGRepresentation(image)
                            writeToFile:[NSString stringWithFormat:@"%@%@%@", documentDir, kImgFolderPath, key]
                                options:NSAtomicWrite
                                  error:nil])
                    [self createDirection];

            });
        }
    }
}

#pragma mark http request
- (void)handleImageDownloadFinishedNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];

    ImageSize size = (ImageSize)[[userInfo objectForKey:@"size"] intValue];
    NSString *imagePath = [userInfo objectForKey:@"imagePath"];
    UIImage *image = [userInfo objectForKey:@"image"];

    NSString *key = [self getImageKeyForURL:imagePath andSize:size];
    if (key && image) {
        //NSString *imageId = [self getImageIdForKey:key];
        //[self deleteImageForId:imageId];
        //        ImageSize size = [self getImageSizeForKey:key];
        if ([self shouldStoreImageInMemoryWithSize:size]) {
            [self insertImgToMem:image forKey:key];
        }
        [self saveImage:image forURL:imagePath andSize:size sync:NO];
        [self postNotification:ImageReadyNotification
                        withInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       imagePath, @"path", image, @"image", nil]];
    }
}

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

- (UIImage *)getLoadingImage:(ImageSize)size andPlaceholderImg:(UIImage *)placeholderImg {
    return placeholderImg;
}

@end
