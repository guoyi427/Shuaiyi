//
//  ImageTask.h
//  kokozu
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "NetworkTask.h"

@interface SoundTask : NetworkTask {

}

@property (nonatomic, retain) NSString *soundPath;
@property (nonatomic, retain) UIImage *soundToUpload;


- (id)initSoundDownloadFrom:(NSString *)soundPath;

@end
