//
//  RatingViewController.h
//  RatingController
//
//  Created by Ajay on 2/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RatingViewDelegate
- (void)ratingChanged:(CGFloat)newRating;
@end

@interface RatingView : UIView {
    UIImageView *s1, *s2, *s3, *s4, *s5;
    //id<RatingViewDelegate> viewDelegate;

    float starRating, lastRating;
    float height, width, margin; // of each image of the star!
}

@property (nonatomic, weak) id<RatingViewDelegate> viewDelegate;

@property (nonatomic, strong) UIImage *unselectedImage;
@property (nonatomic, strong) UIImage *partlySelectedImage;
@property (nonatomic, strong) UIImage *fullySelectedImage;

@property (nonatomic, strong) UIImageView *s1;
@property (nonatomic, strong) UIImageView *s2;
@property (nonatomic, strong) UIImageView *s3;
@property (nonatomic, strong) UIImageView *s4;
@property (nonatomic, strong) UIImageView *s5;

- (void)setImagesDeselected:(NSString *)unselectedImage
             partlySelected:(NSString *)partlySelectedImage
               fullSelected:(NSString *)fullSelectedImage
                   iconSize:(CGSize)size
                andDelegate:(id<RatingViewDelegate>)d;

- (void)setImagesDeselected:(NSString *)unselectedImage
             partlySelected:(NSString *)partlySelectedImage
               fullSelected:(NSString *)fullSelectedImage
                   iconSize:(CGSize)size
                marginWidth:(float)margin
                andDelegate:(id<RatingViewDelegate>)d;

- (void)displayRating:(float)rating;
- (float)rating;

@end
