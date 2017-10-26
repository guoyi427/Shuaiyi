//
//  SoundEngine.h
//  phonebook
//
//  Created by da zhang on 11-3-3.
//  Copyright 2011  . All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"


@interface SoundEngine : NSObject {
    NSMutableDictionary *defaultSoundDict;
    
    //内存中的语音
	NSMutableDictionary *usrSoundDict;
    //记录内存中语音的访问顺序，进行清理时的依据
	NSMutableDictionary *accessOrderDict;

    NSString *documentDir;
	NSFileManager *fileManager;
    
}

+ (SoundEngine *)sharedSoundEngine;
- (SoundEngine *)init;
- (void)releaseSoundCache;
- (void)resetCache;

//path means url
- (NSString *)getSoundKeyForURL:(NSString *)path;
- (NSData *)getSoundFromMemForURL:(NSString *)path;
- (NSData *)getSoundForURL:(NSString *)path;
- (NSData *)getSoundFromDiskForURL:(NSString *)path;

- (void)getRemoteSoundForURL:(NSString *)path completion:(void(^)(NSData*))completionWithDownloadedData;
- (void)getSoundFromDiskForURL:(NSString *)path completion:(void (^)(NSData *, BOOL))completionWithSoundYesIfFromCache;
//save image for url
- (void)saveSound:(NSData *)sound forURL:(NSString *)path sync:(BOOL)sync;



@end
