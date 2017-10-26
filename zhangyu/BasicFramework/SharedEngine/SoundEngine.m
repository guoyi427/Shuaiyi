//
//  SoundEngine.m
//  phonebook
//
//  Created by da zhang on 11-3-3.
//  Copyright 2011  . All rights reserved.
//

#import "SoundEngine.h"

#import "UIDeviceExtra.h"
#import "NSStringExtra.h"

#import "DataEngine.h"

#import "SoundTask.h"
#import "TaskQueue.h"

NSString *const SoundReadyNotification = @"SoundReadyNotification";

#define kUsrSoundDictSize 50
#define kSoundFolderPath @"UserSounds/"
#define kSpiltSign @"|"


static SoundEngine *_soundEngine = nil;


@interface SoundEngine (Private)

//engine run method
- (void)createDirection;
- (void)insertSoundToMem:(NSData *)theSound forKey:(NSString *)theKey;

- (NSString *)getSoundIdForKey:(NSString *)soundKey;
- (void)deleteSoundForId:(NSString *)soundId;
- (void)getRemoteSoundForURL:(NSString *)path;

@end



@implementation SoundEngine

+ (SoundEngine *)sharedSoundEngine {
	@synchronized(self) {
		if (!_soundEngine) {
			_soundEngine = [[SoundEngine alloc] init];
		}
	}
	return _soundEngine;
}

- (SoundEngine *)init {
    self = [super init];
	if (self) {		
        //TODO: scan disk to reduce lacal storage
        usrSoundDict = [[NSMutableDictionary alloc] init];
        defaultSoundDict = [[NSMutableDictionary alloc] init];
        
		accessOrderDict = [[NSMutableDictionary alloc] init];
				
		NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES); 
		documentDir = [[[documentPaths objectAtIndex:0] stringByAppendingString:@"/"] retain];
        
		fileManager = [[NSFileManager defaultManager] retain];
		
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(handleSoundDownloadFinishedNotification:)
                                                 taskType:TaskTypeSoundDownload];
        
		[self createDirection];
	}
	return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self taskType:TaskTypeImageDownload];
    
	[documentDir release];
	
	[fileManager release];
	
	[usrSoundDict release];
    [defaultSoundDict release];
	[accessOrderDict release];
	
	[super dealloc];
}



#pragma mark engine run method
- (void)createDirection {
	NSString *soundPath = [documentDir stringByAppendingPathComponent:kSoundFolderPath];
	if (![fileManager fileExistsAtPath:soundPath])
		[fileManager createDirectoryAtPath:soundPath withIntermediateDirectories:NO attributes:nil error:nil];
}

- (void)insertSoundToMem:(NSData *)theSound forKey:(NSString *)theKey {
	if (!theSound || !theKey) return;
	
	@synchronized(usrSoundDict) {
		if ( ![usrSoundDict objectForKey:theKey] ) {
			if ([usrSoundDict count]==kUsrSoundDictSize) {
                [usrSoundDict removeAllObjects];
			}
			[usrSoundDict setObject:theSound forKey:theKey];
		}
	}	
}

- (void)releaseSoundCache {
	[usrSoundDict removeAllObjects];
	[accessOrderDict removeAllObjects];
}

- (void)resetCache {
    NSString *soundPath = [documentDir stringByAppendingPathComponent:kSoundFolderPath];
	if ([fileManager fileExistsAtPath:soundPath]) {
        [fileManager removeItemAtPath:soundPath error:nil];
        [self createDirection];
        
        NSError *error = nil;
        NSArray *allFiles = [fileManager contentsOfDirectoryAtPath:soundPath error:&error];
        for (NSString *file in allFiles) {
            BOOL success = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", soundPath, file]
                                                   error:&error];
            if (!success || error) {
                DLog(@"failed to remove: %@", file);
            }
        }
    }
}

- (NSData *)soundFromDiskWithName:(NSString *)soundName {
	if (!soundName) {
        return nil;
    }
	NSData *sound = [NSData dataWithContentsOfFile:[documentDir stringByAppendingString:soundName]];
	return sound;
}


- (void)postNotification:(NSString *)notificationName withInfo:(NSDictionary *)userInfo {
    NSNotification *n = [NSNotification notificationWithName:notificationName object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:n waitUntilDone:NO];
}



#pragma mark get sound with url
- (NSString *)getSoundKeyForURL:(NSString *)path {
    if (![path length]) 
        return nil;
    
	return [NSString stringWithFormat:@"%@%@", kSpiltSign, [path imageKeyFromURL]];
}

- (NSString *)getSoundIdForKey:(NSString *)soundKey {
    NSArray *spiltedName = [soundKey componentsSeparatedByString:kSpiltSign];
    if ([spiltedName count]==2) {
        return [spiltedName objectAtIndex:1];
    }
    return @"nokey";
}

- (void)deleteSoundForId:(NSString *)soundId {
    NSString *path = nil;
	//get reference direction
	NSArray *files = [fileManager subpathsOfDirectoryAtPath:[NSString stringWithFormat:@"%@%@", documentDir, kSoundFolderPath] error:nil];
	for (int i=0; i<[files count]; i++) {
        path = [files objectAtIndex:i];
        NSString *iId = [self getSoundIdForKey:path];
		if ( iId && [iId isEqualToString:soundId]) {
            if ([fileManager fileExistsAtPath:path] == YES) 
                [fileManager removeItemAtPath:path error:nil];
        }
    }
}

- (void)prepareSoundToMemoryForSound:(NSDictionary *)soundInfo {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    NSString *path = [soundInfo objectForKey:@"path"];
    
    if (!path) return;
    
    NSString *key = [self getSoundKeyForURL:path];
    NSData *sound = [self soundFromDiskWithName:[NSString stringWithFormat:@"%@%@", kSoundFolderPath, key]];
    if (sound) {
        [self postNotification:ImageReadyNotification 
                      withInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                path, @"path", sound, @"sound", nil]];
    } else {
        [self getRemoteSoundForURL:path];
    }

    [pool release];
}

- (void)getRemoteSoundForURL:(NSString *)path {    
   
}

- (void)getRemoteSoundForURL:(NSString *)path completion:(void (^)(NSData *))completionWithDownloadedData {
    NSString *key = [self getSoundKeyForURL:path];
    if (!key) return;
    
    SoundTask *task = [[SoundTask alloc] initSoundDownloadFrom:path];
    if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
    }
    [task release];
}


- (NSData *)getSoundForURL:(NSString *)path {
    NSString *key = [self getSoundKeyForURL:path];
    if (!key) return nil;
    
    NSData *sound = [usrSoundDict objectForKey:key];
    if (![usrSoundDict objectForKey:key]) {
//        img = [self getLoadingImage:size];
        [NSThread detachNewThreadSelector:@selector(prepareSoundToMemoryForSound:)
                                 toTarget:self 
                               withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                           path, @"path", nil]];
    }
    return sound;
}


- (NSData *)getSoundFromMemForURL:(NSString *)path {
    NSString *key = [self getSoundKeyForURL:path];
    if (!key) return nil;
    
    NSData *sound = [usrSoundDict objectForKey:key];
    
    return sound;
}

- (NSData *)getSoundFromDiskForURL:(NSString *)path  {
    NSString *key = [self getSoundKeyForURL:path];
    if (!key) return nil;
    
    NSData *sound = [self soundFromDiskWithName:[NSString stringWithFormat:@"%@%@", kSoundFolderPath, key]];
    if (sound) {
        return sound;
    } else {
        [self getRemoteSoundForURL:path];
        return nil;
    }
}

- (void)getSoundFromDiskForURL:(NSString *)path completion:(void (^)(NSData *, BOOL))completionWithSoundYesIfFromCache {
//    NSString *key = [self getSoundKeyForURL:path];
//    if (!key) return;
//    
//    NSData *sound = [self soundFromDiskWithName:[NSString stringWithFormat:@"%@%@", kSoundFolderPath, key]];
//    if (sound.length > 0) {
//        completionWithSoundYesIfFromCache(sound, YES);
//    } else {
//        [self queueRequest:urlPath completion:^(NSData *data) {
//            UIImage *image = [UIImage imageWithData:data];
//            completionWithImageYesIfFromCache(image, NO);
//        }];
//    }
}


#pragma mark save Sound for url
- (void)saveSound:(NSData *)sound forURL:(NSString *)path sync:(BOOL)sync {
    NSString *key = [self getSoundKeyForURL:path ];
    
    if (key) {
        if (sync) {
            DLog(@"write sound to disk on main thread:%@", path);
            if ( ![sound
                   writeToFile:[NSString stringWithFormat:@"%@%@%@", documentDir, kSoundFolderPath, key]
                   options:NSAtomicWrite error:nil] )
                [self createDirection];
        } else {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                DLog(@"write sound to disk:%@", path);
                if ( ![sound
                       writeToFile:[NSString stringWithFormat:@"%@%@%@", documentDir, kSoundFolderPath, key]
                       options:NSAtomicWrite error:nil] )
                    [self createDirection];
                
            });
        }
    }
}



#pragma mark http request
- (void)handleSoundDownloadFinishedNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    NSString *soundPath = [userInfo objectForKey:@"soundPath"];
    NSData *sound = [userInfo objectForKey:@"sound"];

	NSString *key = [self getSoundKeyForURL:soundPath];
    if (key && sound) {
        //NSString *imageId = [self getImageIdForKey:key];
        //[self deleteImageForId:imageId];
    
        [self saveSound:sound forURL:soundPath sync:NO];
        [self postNotification:SoundReadyNotification
                      withInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                soundPath, @"path", sound, @"sound", nil]];
    }
}


@end
