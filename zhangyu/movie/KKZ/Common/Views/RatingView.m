//
//  RatingViewController.m
//  RatingController
//
//  Created by Ajay on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "RatingView.h"

#define marginY 3

@implementation RatingView

@synthesize s1, s2, s3, s4, s5;

@synthesize unselectedImage = _unselectedImage;
@synthesize partlySelectedImage = _partlySelectedImage;
@synthesize fullySelectedImage = _fullySelectedImage;
@synthesize viewDelegate = viewDelegate_;

- (void)dealloc {
    DLog(@"RatingView dealloc");
}

- (void)setImagesDeselected:(NSString *)deselectedImage
             partlySelected:(NSString *)halfSelectedImage
               fullSelected:(NSString *)fullSelectedImage
                   iconSize:(CGSize)size
                andDelegate:(id<RatingViewDelegate>)d {
    self.unselectedImage = [UIImage imageNamed:deselectedImage];
    self.partlySelectedImage = [UIImage imageNamed:halfSelectedImage];
    //	self.partlySelectedImage = halfSelectedImage == nil ? self.unselectedImage : [UIImage imageNamed:halfSelectedImage];
    self.fullySelectedImage = [UIImage imageNamed:fullSelectedImage];

    self.viewDelegate = d;
    margin = 0.0;
    height = 0.0;
    width = 0.0;
    height = size.height;
    width = size.width;

    starRating = 0;
    lastRating = 0;
    s1 = [[UIImageView alloc] initWithImage:self.unselectedImage];
    s2 = [[UIImageView alloc] initWithImage:self.unselectedImage];
    s3 = [[UIImageView alloc] initWithImage:self.unselectedImage];
    s4 = [[UIImageView alloc] initWithImage:self.unselectedImage];
    s5 = [[UIImageView alloc] initWithImage:self.unselectedImage];

    [s1 setFrame:CGRectMake(0, 0, width, height)];
    [s2 setFrame:CGRectMake(width + marginY, 0, width, height)];
    [s3 setFrame:CGRectMake(2 * (width + marginY), 0, width, height)];
    [s4 setFrame:CGRectMake(3 * (width + marginY), 0, width, height)];
    [s5 setFrame:CGRectMake(4 * (width + marginY), 0, width, height)];

    [s1 setUserInteractionEnabled:NO];
    [s2 setUserInteractionEnabled:NO];
    [s3 setUserInteractionEnabled:NO];
    [s4 setUserInteractionEnabled:NO];
    [s5 setUserInteractionEnabled:NO];

    [self addSubview:s1];
    [self addSubview:s2];
    [self addSubview:s3];
    [self addSubview:s4];
    [self addSubview:s5];

    CGRect frame = [self frame];
    frame.size.width = (width + 2) * 5;
    frame.size.height = height;
    [self setFrame:frame];
}

- (void)setImagesDeselected:(NSString *)deselectedImage
             partlySelected:(NSString *)halfSelectedImage
               fullSelected:(NSString *)fullSelectedImage
                   iconSize:(CGSize)size
                marginWidth:(float)marginWidth
                andDelegate:(id<RatingViewDelegate>)d {
    self.unselectedImage = [UIImage imageNamed:deselectedImage];
    self.partlySelectedImage = [UIImage imageNamed:halfSelectedImage];
    //	self.partlySelectedImage = halfSelectedImage == nil ? self.unselectedImage : [UIImage imageNamed:halfSelectedImage];
    self.fullySelectedImage = [UIImage imageNamed:fullSelectedImage];

    self.viewDelegate = d;
    margin = marginWidth;
    height = 0.0;
    width = 0.0;
    height = size.height;
    width = size.width;

    starRating = 0;
    lastRating = 0;
    s1 = [[UIImageView alloc] initWithImage:self.unselectedImage];
    s2 = [[UIImageView alloc] initWithImage:self.unselectedImage];
    s3 = [[UIImageView alloc] initWithImage:self.unselectedImage];
    s4 = [[UIImageView alloc] initWithImage:self.unselectedImage];
    s5 = [[UIImageView alloc] initWithImage:self.unselectedImage];

    [s1 setFrame:CGRectMake(0, 0, width, height)];
    [s2 setFrame:CGRectMake(margin + width, 0, width, height)];
    [s3 setFrame:CGRectMake(2 * (margin + width), 0, width, height)];
    [s4 setFrame:CGRectMake(3 * (margin + width), 0, width, height)];
    [s5 setFrame:CGRectMake(4 * (margin + width), 0, width, height)];

    [s1 setUserInteractionEnabled:NO];
    [s2 setUserInteractionEnabled:NO];
    [s3 setUserInteractionEnabled:NO];
    [s4 setUserInteractionEnabled:NO];
    [s5 setUserInteractionEnabled:NO];

    [self addSubview:s1];
    [self addSubview:s2];
    [self addSubview:s3];
    [self addSubview:s4];
    [self addSubview:s5];

    CGRect frame = [self frame];
    frame.size.width = width * 5 + 4 * margin;
    frame.size.height = height;
    [self setFrame:frame];
}

- (void)displayRating:(float)rating {
    [s1 setImage:self.unselectedImage];
    [s2 setImage:self.unselectedImage];
    [s3 setImage:self.unselectedImage];
    [s4 setImage:self.unselectedImage];
    [s5 setImage:self.unselectedImage];

    float decimal = rating * 2;

    if (decimal >= 9.5) {
        [s1 setImage:self.fullySelectedImage];
        [s2 setImage:self.fullySelectedImage];
        [s3 setImage:self.fullySelectedImage];
        [s4 setImage:self.fullySelectedImage];
        [s5 setImage:self.fullySelectedImage];
    } else if (decimal >= 8.5) {
        [s1 setImage:self.fullySelectedImage];
        [s2 setImage:self.fullySelectedImage];
        [s3 setImage:self.fullySelectedImage];
        [s4 setImage:self.fullySelectedImage];
        [s5 setImage:self.partlySelectedImage];
    } else if (decimal >= 7.5) {
        [s1 setImage:self.fullySelectedImage];
        [s2 setImage:self.fullySelectedImage];
        [s3 setImage:self.fullySelectedImage];
        [s4 setImage:self.fullySelectedImage];
    } else if (decimal >= 6.5) {
        [s1 setImage:self.fullySelectedImage];
        [s2 setImage:self.fullySelectedImage];
        [s3 setImage:self.fullySelectedImage];
        [s4 setImage:self.partlySelectedImage];
    } else if (decimal >= 5.5) {
        [s1 setImage:self.fullySelectedImage];
        [s2 setImage:self.fullySelectedImage];
        [s3 setImage:self.fullySelectedImage];
    } else if (decimal >= 4.5) {
        [s1 setImage:self.fullySelectedImage];
        [s2 setImage:self.fullySelectedImage];
        [s3 setImage:self.partlySelectedImage];
    } else if (decimal >= 3.5) {
        [s1 setImage:self.fullySelectedImage];
        [s2 setImage:self.fullySelectedImage];
    } else if (decimal >= 2.5) {
        [s1 setImage:self.fullySelectedImage];
        [s2 setImage:self.partlySelectedImage];
    } else if (decimal >= 1.5) {
        [s1 setImage:self.fullySelectedImage];
    } else if (decimal >= 0.5) {
        [s1 setImage:self.partlySelectedImage];
    }

    starRating = rating;
    lastRating = rating;
    [self.viewDelegate ratingChanged:rating];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint pt = [[touches anyObject] locationInView:self];
    float newRating = ((int) (pt.x / (width / 2 + margin / 2)) + 1) / 2.0;
    if (newRating < 0.5 || newRating > 5)
        return;

    if (newRating != lastRating)
        [self displayRating:newRating];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesMoved:touches withEvent:event];
    DLog(@"aaaa");
}

- (float)rating {
    return starRating;
}

@end
