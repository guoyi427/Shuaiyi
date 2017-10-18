//
//  MoviePhotoCollectionViewCell.m
//  CIASMovie
//
//  Created by avatar on 2016/12/30.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "MoviePhotoCollectionViewCell.h"

#import <Category_KKZ/UIImage+Resize.h>
#import <SDWebImage/UIImageView+WebCache.h>


@implementation MoviePhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 3.5;
        self.clipsToBounds = YES;
        
        _photoPosterImage = [UIImageView new];
        _photoPosterImage.backgroundColor = [UIColor whiteColor];
        _photoPosterImage.layer.cornerRadius = 3.5;
        _photoPosterImage.clipsToBounds = YES;
        _photoPosterImage.contentMode = UIViewContentModeScaleAspectFill;
        
        [self addSubview:_photoPosterImage];
        [_photoPosterImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

- (void)updateLayout{
    UIImage *placeHolderImage = [UIImage centerResizeFrom:[UIImage imageNamed:@"goods_nopic"] newSize:self.photoPosterImage.frame.size bgColor:[UIColor whiteColor]];
    [self.photoPosterImage sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:[self.moviePhotoInfo kkz_stringForKey:@"url"]] placeholderImage:placeHolderImage];
}

- (UIImage*)imageCompressWithSimple:(UIImage*)image scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
