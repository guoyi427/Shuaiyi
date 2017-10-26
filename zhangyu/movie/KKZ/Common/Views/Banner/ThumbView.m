//
//  ThumbView.m
//
//  Created by zhang da on 10-10-20.
//  Copyright 2010 Ariadne’s Thread Co., Ltd All rights reserved.
//

#import "ThumbView.h"

#import "ImageEngine.h"

@implementation ThumbView {

    UIImageView *imageView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
    }
    return self;
}

- (void)updateLayout {
    UIImageView *iv = [[UIImageView alloc] init];
    [iv loadImageWithURL:self.imagePath andSize:ImageSizeMiddle finished:^{
        imageView.image = iv.image;
    }];
}

@end
