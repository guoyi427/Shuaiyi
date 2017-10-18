//
//  CPCropperView.h
//  Cinephile
//
//  Created by Albert on 15/12/2016.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPCropperView : UIView
@property (nonatomic, assign) CGSize cropSize;
@property (nonatomic, strong) UIImage *image;
@property (readonly, nonatomic, strong) UIImageView *imageView;
@property (readonly, nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIBezierPath *cropMaskPath;
@property (nonatomic, strong) UIView *cropMaskView;
@property (nonatomic, readonly) UIView *borderView;
@property (nonatomic, assign) CGFloat cropDisplayScale; //defaults to 1.0f
@property (nonatomic, assign) UIOffset cropDisplayOffset; //defaults to UIOffsetZero
@property (nonatomic, assign) BOOL cropsImageToCircle; // defaults to NO
@property (nonatomic, assign) BOOL leavesUnfilledRegionsTransparent; // defaults to NO
@property (nonatomic, assign) BOOL allowsNegativeSpaceInCroppedImage; //defaults to NO

- (void)renderCroppedImage:(void (^)(UIImage *croppedImage, CGRect cropRect))completionBlock;
@end
