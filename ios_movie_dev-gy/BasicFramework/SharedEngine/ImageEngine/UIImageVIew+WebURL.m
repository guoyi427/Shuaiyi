//
//  WebImageVIew.m
//  KoFashion
//
//  Created by zhoukai on 12/23/13.
//  Copyright (c) 2013 kokozu. All rights reserved.
//

#import <objc/runtime.h>
#import "UIImageVIew+WebURL.h"
#import "ImageEngineNew.h"
#import "ImageNewTask.h"
#import "TaskQueue.h"

//static const void * MyKeyIndicator = (void *)@"MyKeyIndicator";
static const void * MyKeyBlock = (void *)@"MyKeyImageWebURL";
static const void * MyKeyPath = (void *)@"MyKeyPath";
static const void * MyKeyIsCompress = (void *)@"MyKeyIsCompress";

@implementation UIImageView (WebURL)

//@dynamic delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [ImageEngineNew sharedImageEngineNew];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withURL:(NSString*)path andSize:(ImageSize)size{
    self = [self initWithFrame:frame];
    [self loadImageWithURL:path andSize:size];
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)loadImageWithURL:(NSString *)url andSize:(ImageSize)size{
    self.image = [[ImageEngineNew sharedImageEngineNew] getLoadingImage:size];
    [self setURL:url];
    [self beginImageWithURL:url andSize:size];
}

-(void)loadImageWithURL:(NSString *)url andSize:(ImageSize)size finished:(ImageShowCompleteBlock)block{
    self.image = [[ImageEngineNew sharedImageEngineNew] getLoadingImage:size];
    [self setBlock:block];
    [self setURL:url];
    [self beginImageWithURL:url andSize:size];
}

-(void)loadImageWithURL:(NSString *)url andSize:(ImageSize)size defaultImagePath:(NSString*)defaultPath{
    self.image = [UIImage imageNamed:defaultPath];
    [self setURL:url];
    [self beginImageWithURL:url andSize:size];
}


-(void)loadImageWithURL:(NSString *)url andSize:(ImageSize)size imgNameDefault:(NSString*)imgNameDefault{
   
    self.image = [UIImage imageNamed:imgNameDefault];
    [self setURL:url];
    
    [self beginImageWithURL:url andSize:size andImgName:imgNameDefault];
}

-(void)loadImageWithURL:(NSString *)url andSize:(ImageSize)size withIndicator:(UIActivityIndicatorView *)indicator{
    [self setURL:url];
    [self addIndicator:indicator];
    [self beginImageWithURL:url andSize:size];
}

-(void)loadImageWithURL:(NSString *)url andSize:(ImageSize)size withIndicator:(UIActivityIndicatorView *)indicator finished:(ImageShowCompleteBlock)block{
    
    [self setURL:url];
    [self setBlock:block];
    [self addIndicator:indicator];
    [self beginImageWithURL:url andSize:size];
}
-(void)loadImageWithURL:(NSString *)url andSize:(ImageSize)size withIndicator:(UIActivityIndicatorView *)indicator isCompress:(BOOL)isCompress finished:(ImageShowCompleteBlock)block{
    
    [self setURL:url];
    [self setBlock:block];
    [self addIndicator:indicator];
    [self setIsCompress:isCompress];
    [self beginImageWithURL:url andSize:size];
}


//--------getter,setter------------
//-(void)setIndicator:(UIActivityIndicatorView *)indicator{
//    objc_setAssociatedObject(self, MyKeyIndicator, indicator, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
//
//-(UIActivityIndicatorView *)getIndicator{
//    return objc_getAssociatedObject(self, MyKeyIndicator);
//}

//不替换indicator
-(void)addIndicator:(UIActivityIndicatorView *)indicator{
    
//    UIActivityIndicatorView *old = [self getIndicator];
//    
//    if (old) {
//        old.hidden = NO;
//        [old startAnimating];
//    }else{
//        [self addSubview:indicator];
//        indicator.hidesWhenStopped = YES;
//        [indicator startAnimating];

//    }
    if (indicator) {
        [self addSubview:indicator];
        indicator.hidesWhenStopped = YES;
        [indicator startAnimating];
    }

}
-(UIActivityIndicatorView *)getIndicator{
    

    for (UIView *sub in [self subviews]) {
        if ([sub isKindOfClass:[UIActivityIndicatorView class]]) {
            return (UIActivityIndicatorView*)sub;
        }
    }
    return nil;
}
-(void)setBlock:(ImageShowCompleteBlock)block {
    objc_setAssociatedObject(self, MyKeyBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(ImageShowCompleteBlock)getBlock {
    return objc_getAssociatedObject(self, MyKeyBlock);
}

-(void)setURL:(NSString*)url{
    objc_setAssociatedObject(self, MyKeyPath, url, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString*)getPath{
    return objc_getAssociatedObject(self, MyKeyPath);
}

-(void)setIsCompress:(BOOL)isCompress{
    if (isCompress) {
        objc_setAssociatedObject(self, MyKeyIsCompress, @"YES", OBJC_ASSOCIATION_COPY_NONATOMIC);
    }else{
        objc_setAssociatedObject(self, MyKeyIsCompress, @"NO", OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
}
-(BOOL)getIsCompress{
    NSString *c = objc_getAssociatedObject(self, MyKeyIsCompress);
    if ([c isEqualToString:@"YES"]) {
        return YES;
    }else{
        return NO;
    }
}


//----------------找寻图片-----------------
-(void)beginImageWithURL:(NSString *)url andSize:(ImageSize)size{
    UIImage *img = [[ImageEngineNew sharedImageEngineNew] getImageFromMemForURL:url andSize:size];
    if (img) {
        [self imageShow:img];
    }else{
        self.image = [[ImageEngineNew sharedImageEngineNew] getLoadingImage:size];
        
        img = [[ImageEngineNew sharedImageEngineNew] getImageFromDiskForURL:url andSize:size];
        if (img) {
            [self imageShow:img];
            
        }else{
            
            [self requestRemoteImageForURL:url andSize:size];
            
        }
        
    }
    
}

//----------------找寻图片-----------------
-(void)beginImageWithURL:(NSString *)url andSize:(ImageSize)size andImgName:(NSString *)imgNameDefault{
    UIImage *img = [[ImageEngineNew sharedImageEngineNew] getImageFromMemForURL:url andSize:size];
    if (img) {
        [self imageShow:img];
    }else{
        

        self.image = [[ImageEngineNew sharedImageEngineNew] getLoadingImage:size andImgName:imgNameDefault];
        
        img = [[ImageEngineNew sharedImageEngineNew] getImageFromDiskForURL:url andSize:size];
        if (img) {
            [self imageShow:img];
            
        }else{
            
            [self requestRemoteImageForURL:url andSize:size andImgName:imgNameDefault];
            
        }
        
    }
    
}


- (void)requestRemoteImageForURL:(NSString *)path andSize:(ImageSize)size andImgName:(NSString *)imgNameDefault{
    
    self.image = [UIImage imageNamed:imgNameDefault];
    [NSThread detachNewThreadSelector:@selector(requestImageForURL:)
                             toTarget:self
                           withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                       path, @"path",
                                       [NSNumber numberWithInt:size], @"size", nil]];
    
    
}




- (void)requestRemoteImageForURL:(NSString *)path andSize:(ImageSize)size {
    
//    self.image = [UIImage imageNamed:@"movie_post_bg.png"];
    
    [NSThread detachNewThreadSelector:@selector(requestImageForURL:)
                             toTarget:self
                           withObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                       path, @"path",
                                       [NSNumber numberWithInt:size], @"size", nil]];
    

}

-(void)requestImageForURL:(NSDictionary *)imageInfo{
    
        NSString *path = [imageInfo objectForKey:@"path"];
        ImageSize size = (ImageSize)[[imageInfo objectForKey:@"size"] intValue];
        
        if (!path) return;
    
//        UIImageView __weak *tempSelf = self;
    
        ImageNewTask *task = [[ImageNewTask alloc] initImageDownLoadFromURL:path size:size finished:^(BOOL succeeded, NSDictionary *userInfo) {
            
            [self remoteImageForURLFinished:succeeded userInfo:userInfo];
        }];
        if ([[TaskQueue sharedTaskQueue] addTaskToQueue:task]) {
            
        }
        [task release];
    
}

-(void)remoteImageForURLFinished:(BOOL)success userInfo:(NSDictionary *)userInfo{

    if (success) {
        UIImage *img = userInfo[@"image"];
        ImageSize size = [userInfo[@"size"] intValue];
        NSString *path = userInfo[@"imagePath"];
        BOOL cache = [userInfo[@"cache"] boolValue];
        
        
        if ( [[self getPath] isEqualToString:path]) {
            NSString *key = [[ImageEngineNew sharedImageEngineNew] getImageKeyForURL:path andSize:size];
            
            if (key && img) {
                
                UIActivityIndicatorView *indicator = [self getIndicator];
                if (indicator) {
                    [indicator stopAnimating];
                    [indicator removeFromSuperview];
                }
                
                //压缩图片
                if ([self getIsCompress]) {
                    @autoreleasepool {
                        CGSize newSize = CGSizeMake(img.size.width/2, img.size.height/2);
                        UIGraphicsBeginImageContext(newSize);
                        
                        [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
                        
                        self.image = UIGraphicsGetImageFromCurrentImageContext();
                        
                        // End the context
                        UIGraphicsEndImageContext();
                        
                        img = nil;
                    }
                }else{
                    self.image = img;
                    img = nil;
                }
                
                
                if ([self getBlock]) {
                    [self getBlock]();
                }
                //                    [self imageShow:newImage];
                //保存image
                [[ImageEngineNew sharedImageEngineNew] saveImage:self.image forURL:path andSize:size sync:NO fromCache:cache];
                
            }
            
        }
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_async(queue, ^{
            
        });
        
    }
    
}

-(void)imageShow:(UIImage *)img{
    UIActivityIndicatorView *indicator = [self getIndicator];
    if (indicator) {
        [indicator stopAnimating];
    }
    self.image = img;
    
    if ([self getBlock]) {
        [self getBlock]();
    }
    [self setBlock:nil];
//    DLog(@"delegate:%@",self.delegate);
//    if (self.delegate) {
//        
//        [self.delegate imageShowComplete];
//    }
}


//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
//    @autoreleasepool {
        // Create a graphics image context
        UIGraphicsBeginImageContext(newSize);
        
        // Tell the old image to draw in this new context, with the desired
        // new size
        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        
        // Get the new image from the context
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // End the context
        UIGraphicsEndImageContext();
        
        image = nil;
        
        return newImage;
//    }
}

-(UIImage*)imageWithImage:(UIImage*)image scale:(CGFloat)scale{
    
    @autoreleasepool {
        
        NSData  *imageData = UIImageJPEGRepresentation(image , 0.5);
        return [UIImage imageWithData:imageData];
    }
}

@end
