//
//  ImageNewTask.h
//  KoFashion
//
//  Created by zhoukai on 12/23/13.
//  Copyright (c) 2013 kokozu. All rights reserved.
//

#import "NetworkTask.h"

@interface ImageNewTask : NetworkTask


@property (nonatomic, assign) ImageSize size;
@property (nonatomic, retain) NSString *imagePath;
@property (nonatomic, retain) UIImage *imageToUpload;


- (id)initImageDownLoadFromURL:(NSString *)imagePath size:(ImageSize)size finished:(FinishDownLoadBlock)block;

- (id)initImageUpload:(UIImage *)imageToUpload;
@end
