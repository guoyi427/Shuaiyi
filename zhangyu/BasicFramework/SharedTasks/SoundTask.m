//
//  SoundTask.m
//  kokozu
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "SoundTask.h"
#import "TaskQueue.h"
//#import "UIImageExtra.h"

@implementation SoundTask

@synthesize soundPath = _soundPath, soundToUpload = _soundToUpload;


- (id)initSoundDownloadFrom:(NSString *)soundPath {
    self = [super init];
    if (self) {
        self.taskType = TaskTypeSoundDownload;
        self.resultIsData = YES;
        
        self.soundPath = soundPath;
    }
    return self;
}

- (void)dealloc {
    self.soundPath = nil;
    self.soundToUpload = nil;
    
    [super dealloc];
}

- (void)getReady {
    if (taskType == TaskTypeSoundDownload) {
        [self setRequestURL:self.soundPath];
        [self setRequestMethod:@"GET"];
    }
}

//- (CGSize)sizeLimitForImageSize:(ImageSize)size {
//    int width = 0, height = 0;
//    switch (size) {
//        case ImageSizeTiny:
//            width = kImageTinyWidth;
//            height = 0;
//            break;
//        case ImageSizeSmall:
//            width = kImageSmallWidth;
//            height = 0;
//            break;
//        case ImageSizeMiddle:
//            width = kImageMiddleWidth;
//            height = 0;
//            break;
//        case ImageSizeLarge:
//            width = kImageLargeWidth;
//            height = 0;
//            break;
//        default:break;
//    }
//    if (retinaDisplaySupported) {
//        width *= 2;
//        height *= 2;
//    }
//    return CGSizeMake(width, height);
//}
//


#pragma mark required method
- (void)requestSucceededWithData:(id)result {

    if (taskType == TaskTypeSoundDownload) {
        
        DLog(@"sound download succeeded");
        NSData *sound = (NSData *)result;
        
        [self postNotificationSucceeded:YES
                               withInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                         sound, @"sound",
                                         self.soundPath, @"soundPath", nil]];
        
    }
}

- (void)requestFailedWithError:(NSError *)error {

    if (taskType == TaskTypeImageDownload) {
        DLog(@"sound download failed: %@", [error description]);
        [self postNotificationSucceeded:NO
                               withInfo:[NSDictionary dictionaryWithObjectsAndKeys: 
                                         self.soundPath, @"soundPath", nil]];
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
