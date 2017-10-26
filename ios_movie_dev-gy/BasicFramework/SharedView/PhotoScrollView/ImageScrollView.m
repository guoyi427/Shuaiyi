//
//  ImageScrollView.m
//  simpleread
//
//  Created by zhang da on 11-4-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ImageScrollView.h"
#import "ImageEngine.h"

#define ZOOM_STEP 1.5

@interface ImageScrollView ()

- (void)displayImage:(UIImage *)image;

@end

@implementation ImageScrollView


@synthesize index;
@synthesize imageURL;

- (void)setImageURL:(NSString *)value {
    if (![imageURL isEqualToString:value]) {
        [imageURL release];
        imageURL = [value retain];
        
        imageView.image = nil;
        
        loaded = NO;
    }
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        [self addGestureRecognizer:doubleTap];
        [doubleTap release];
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screentWith, screentHeight)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        [imageView release];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(handleImageReadyNotification
                                                                    :)
                                                     name:ImageReadyNotification 
                                                   object:nil];

    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ImageReadyNotification object:nil];

    [imageURL release];
    
    [super dealloc];
}



#pragma mark utility
- (void)loadImage {
    if (!loaded) {
        UIImage *img = [[ImageEngine sharedImageEngine] getImageFromDiskForURL:imageURL 
                                                                       andSize:ImageSizeOrign];
 
        if (img) {
            loaded = YES;
            [self displayImage:img];
        }
    }
}

- (void)layoutSubviews  {
    [super layoutSubviews];
    
    // center the image as it becomes smaller than the size of the screen
    //设置图片视图位置
    [self setImageViewPosition];
}

- (void)setImageViewPosition {
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    imageView.frame = frameToCenter;
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = self.frame.size.height / scale;
    zoomRect.size.width  = self.frame.size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    float newScale = 1.0 * ZOOM_STEP;
//    self.zoomScale * ZOOM_STEP;

    if (self.zoomScale == self.maximumZoomScale) {
        newScale = self.minimumZoomScale;
    }
    if (newScale > self.maximumZoomScale) {
        newScale = self.maximumZoomScale;
    }
    if (newScale != self.zoomScale) {
        CGRect zoomRect = [self zoomRectForScale:newScale 
                                      withCenter:[gestureRecognizer locationInView:imageView]];
        DLog(@"%@", NSStringFromCGRect(zoomRect));
        [self zoomToRect:zoomRect animated:YES];
    }
}

- (void)handleImageReadyNotification:(NSNotification *)notification {
    NSDictionary *dict = [notification userInfo];
    NSString *path = [dict objectForKey:@"path"];
    
    if ([path isEqualToString:imageURL]) {
        UIImage *image = [dict kkz_objForKey:@"image"];
        if (image) {
            loaded = YES;
            [self displayImage:image];
        } else {
            [self loadImage];
        }
    }
}



#pragma mark UIScrollView delegate methods
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
}



#pragma mark Configure scrollView to display new image
- (void)setMaxMinZoomScalesForCurrentBounds {
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = imageView.bounds.size;
    
    // calculate min/max zoomscale
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    CGFloat maxScale = 1.5;
//    / [[UIScreen mainScreen] scale];
    
    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.) 
    if (minScale > maxScale) {
        minScale = maxScale;
    }
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}

- (void)displayImage:(UIImage *)image {
    // reset our zoomScale to 1.0 before doing any further calculations
//    self.zoomScale = 1.0;
    
    // make a new UIImageView for the new image
    CGSize boundsSize = self.bounds.size;
    CGFloat xScale = boundsSize.width / image.size.width;
    CGFloat yScale = boundsSize.height / image.size.height;
    CGFloat minScale = MIN(xScale, yScale);
    
    
    imageView.frame = CGRectMake(0, 0, image.size.width * minScale, image.size.height * minScale);
    imageView.image = image;
//    self.contentSize = image.size;
    [self setImageViewPosition];
//    NSLog(@"image1====%@",NSStringFromCGRect(imageView.frame));
    
//    [self setMaxMinZoomScalesForCurrentBounds];
//    NSLog(@"image2====%@",NSStringFromCGRect(imageView.frame));
//    self.zoomScale = self.minimumZoomScale;
//    NSLog(@"123====%f",self.minimumZoomScale);
//    NSLog(@"image3====%@",NSStringFromCGRect(imageView.frame));
}


@end
