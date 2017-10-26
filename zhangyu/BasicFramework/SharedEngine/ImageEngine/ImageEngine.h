//
//  ImageEngine.h
//  phonebook
//
//  Created by da zhang on 11-3-3.
//  Copyright 2011  . All rights reserved.
//

#import "UIImageExtra.h"

typedef void (^FinishPickingImageBlock)(BOOL succeeded, UIImage *image, NSDictionary *info);

@interface ImageEngine : NSObject <UINavigationControllerDelegate> {

    NSMutableDictionary *defaultImgDict;

    //内存中的图片image
    NSMutableDictionary *imageMemoryDict;
    //记录内存中图片的访问顺序，进行清理时的依据
    NSMutableDictionary *accessOrderDict;

    NSString *documentDir;
    NSFileManager *fileManager;
}

@property (nonatomic, copy) FinishPickingImageBlock finishBlock;
@property (nonatomic, assign) int cacheImageNum;

+ (ImageEngine *)sharedImageEngine;
- (ImageEngine *)init;
- (void)releaseImageCache;
- (void)resetCache;

//path means url
- (NSString *)getImageKeyForURL:(NSString *)path andSize:(ImageSize)size;
- (UIImage *)getImageFromMemForURL:(NSString *)path andSize:(ImageSize)size;
- (UIImage *)getImageForURL:(NSString *)path andSize:(ImageSize)size;
- (UIImage *)getImageFromDiskForURL:(NSString *)path andSize:(ImageSize)size;

//save image for url
- (void)saveImage:(UIImage *)image forURL:(NSString *)path andSize:(ImageSize)size sync:(BOOL)sync;

//sys default
- (UIImage *)getLoadingImage:(ImageSize)size;

@end
