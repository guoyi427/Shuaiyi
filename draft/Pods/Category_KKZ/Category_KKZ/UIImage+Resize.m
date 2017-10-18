//
//  UIImage+Resize.m
//  Category_KKZ
//
//  Created by Albert on 8/19/16.
//  Copyright © 2016 Kokozu. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize_KKZ)

+ (UIImage *) centerResizeFrom:(UIImage *)image newSize:(CGSize)newSize bgColor:(UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor);
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, newSize.width, newSize.height));
    [image drawInRect:CGRectMake((newSize.width - image.size.width)/2, (newSize.height - image.size.height)/2, image.size.width, image.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
