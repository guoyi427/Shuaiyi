//
//  ImageNewTask.m
//  KoFashion
//
//  Created by zhoukai on 12/23/13.
//  Copyright (c) 2013 kokozu. All rights reserved.
//

#import "ImageNewTask.h"

@implementation ImageNewTask

@synthesize imagePath = _imagePath, imageToUpload = _imageToUpload, size = _size;

- (id)initImageUpload:(UIImage *)imageToUpload {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeImageUpload;
        self.imageToUpload = imageToUpload;
    }
    return self;
}


-(id)initImageDownLoadFromURL:(NSString *)imagePath size:(ImageSize)size finished:(FinishDownLoadBlock)block{
    self = [super init];
    if (self) {
        self.taskType = TaskTypeImageDownload;
        self.resultIsData = YES;
        
        self.imagePath = imagePath;
        self.size = size;
        self.finishBlock = block;
        [self setThreadPriority:2.0];
    }
    return self;
}

- (void)dealloc {
    self.imagePath = nil;
    self.imageToUpload = nil;
    
    [super dealloc];
}

- (void)getReady {
    if (taskType == TaskTypeImageUpload) {
    }
    if (taskType == TaskTypeImageDownload) {
        NSString *formatedUrl = [self.imagePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self setRequestURL:formatedUrl];
        [self setRequestMethod:@"GET"];
    }
}

- (CGSize)sizeLimitForImageSize:(ImageSize)size {
    int width = 0, height = 0;
    switch (size) {
        case ImageSizeTiny:
            width = kImageTinyWidth;
            height = 0;
            break;
        case ImageSizeSmall:
            width = kImageSmallWidth;
            height = 0;
            break;
        case ImageSizeMiddle:
            width = kImageMiddleWidth;
            height = 0;
            break;
        case ImageSizeLarge:
            width = kImageLargeWidth;
            height = 0;
            break;
        default:break;
    }
    if (retinaDisplaySupported) {
        width *= 2;
        height *= 2;
    }
    return CGSizeMake(width, height);
}



#pragma mark required method
- (void)requestSucceededWithData:(id)result fromCache:(BOOL)cached {
    if (taskType == TaskTypeImageUpload) {
        DLog(@"image upload succeeded");
        [self postNotificationSucceeded:YES
                               withInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                         self.identifier, @"taskId", nil]];
    }
    if (taskType == TaskTypeImageDownload) {
        
//        DLog(@"image download succeeded");
        UIImage *img = [UIImage imageWithData:(NSData *)result];
        if (self.size != ImageSizeOrign) {
            img = [img decodedImageToSize:[self sizeLimitForImageSize:self.size]
                                     fill:NO];

        }
        
        
        [self doCallBack:YES info:[NSDictionary dictionaryWithObjectsAndKeys:
                                   img, @"image",
                                   [NSNumber numberWithInt:_size], @"size",
                                   self.imagePath, @"imagePath",
                                   @(cached), @"cache", nil]];
//        [self postNotificationSucceeded:YES
//                               withInfo:[NSDictionary dictionaryWithObjectsAndKeys:
//                                         img, @"image",
//                                         [NSNumber numberWithInt:_size], @"size",
//                                         self.imagePath, @"imagePath", nil]];
        
    }
}

- (void)requestFailedWithError:(NSError *)error {
    if (taskType == TaskTypeImageUpload) {
        DLog(@"image upload failed: %@", [error description]);
        [self postNotificationSucceeded:NO withInfo:nil];
    }
    if (taskType == TaskTypeImageDownload) {
        DLog(@"image download failed: %@", [error description]);
        [self doCallBack:NO info:[NSDictionary dictionaryWithObjectsAndKeys:
                                  self.imagePath, @"imagePath", nil]];
//        
//        [self postNotificationSucceeded:NO
//                               withInfo:[NSDictionary dictionaryWithObjectsAndKeys:
//                                         self.imagePath, @"imagePath", nil]];
    }
}

- (void)requestSucceededResponse {
    //if needed do something after connected to net, handle here
}

// upload process
- (void)uploadBytesWritten:(NSInteger)written
         totalBytesWritten:(NSInteger)totalWritten
 totalBytesExpectedToWrite:(NSInteger)totalExpectedToWrite {
    //just for upload task
}

@end
