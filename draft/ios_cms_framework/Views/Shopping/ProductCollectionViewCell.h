//
//  ProductCollectionViewCell.h
//  CIASMovie
//
//  Created by cias on 2016/12/26.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCollectionViewCell : UICollectionViewCell
{
    UIImageView *productPosterImage, *huiLogoImage;
    UILabel *productNameLabel, *priceLabel;

}

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productPrice;

@property (nonatomic, assign) BOOL isHui;

- (void)updateLayout;

@end
