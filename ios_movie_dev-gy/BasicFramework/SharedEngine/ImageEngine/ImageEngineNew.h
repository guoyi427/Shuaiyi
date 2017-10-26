//
//  ImageEngineNew.h
//  phonebook
//
//  Created by da zhang on 11-3-3.
//  Copyright 2011  . All rights reserved.
//

#import "UIImageExtra.h"

typedef void (^FinishPickingImageBlock0)(BOOL succeeded, UIImage *image, NSDictionary *info);

@interface ImageEngineNew : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {

    NSMutableDictionary *defaultImgDict;

    //内存中的图片image
    NSMutableDictionary *imageMemoryDict;
    //记录内存中图片的访问顺序，进行清理时的依据
    NSMutableDictionary *accessOrderDict;

    NSString *documentDir;
    NSFileManager *fileManager;
}

@property (nonatomic, copy) FinishPickingImageBlock0 finishBlock;
@property (nonatomic, assign) int cacheImageNum;

+ (ImageEngineNew *)sharedImageEngineNew;
- (ImageEngineNew *)init;
- (void)releaseImageCache;
- (void)resetCache;

//path means url
- (NSString *)getImageKeyForURL:(NSString *)path andSize:(ImageSize)size;
- (UIImage *)getImageFromMemForURL:(NSString *)path andSize:(ImageSize)size;
- (UIImage *)getImageFromDiskForURL:(NSString *)path andSize:(ImageSize)size;

//save image for url
- (void)saveImage:(UIImage *)image forURL:(NSString *)path andSize:(ImageSize)size sync:(BOOL)sync fromCache:(BOOL)cache;

//sys default
- (UIImage *)getLoadingImage:(ImageSize)size;
- (UIImage *)getLoadingImage:(ImageSize)size andImgName:(NSString *)imgNameDefault;

@end
