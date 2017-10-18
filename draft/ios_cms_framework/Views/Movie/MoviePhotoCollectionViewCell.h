//
//  MoviePhotoCollectionViewCell.h
//  CIASMovie
//
//  Created by avatar on 2016/12/30.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviePhotoCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) UIImageView *photoPosterImage;

@property (nonatomic, strong) NSDictionary *moviePhotoInfo;

- (void)updateLayout;
@end
