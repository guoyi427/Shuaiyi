//
//  ImageScrollView.h
//  simpleread
//
//  Created by zhang da on 11-4-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollView : UIScrollView <UIScrollViewDelegate> {
    UIImageView *imageView;
    int index;
    NSString *imageURL;

    BOOL loaded;
}

@property (assign) int index;
@property (nonatomic, retain) NSString *imageURL;
//@property (nonatomic, retain) UIImage *saveImage;
- (void)loadImage;

@end
