//
//  ImageTask.h
//  kokozu
//
//  Created by da zhang on 11-5-16.
//  Copyright 2011年 kokozu. All rights reserved.
//

#import "NetworkTask.h"

@interface ImageTask : NetworkTask {

}

@property (nonatomic, assign) ImageSize size;
@property (nonatomic, retain) NSString *imagePath;
@property (nonatomic, retain) UIImage *imageToUpload;


- (id)initImageUpload:(UIImage *)imageToUpload;
- (id)initImageDownloadFrom:(NSString *)imagePath size:(ImageSize)size;

@end
