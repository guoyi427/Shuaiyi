//
//  ProductCollectionViewCell.m
//  CIASMovie
//
//  Created by cias on 2016/12/26.
//  Copyright © 2016年 cias. All rights reserved.
//

#import "ProductCollectionViewCell.h"
#import <Category_KKZ/UIImage+Resize.h>
#import <SDWebImage/UIImageView+WebCache.h>
@implementation ProductCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        productPosterImage = [UIImageView new];
        productPosterImage.backgroundColor = [UIColor clearColor];
        productPosterImage.layer.cornerRadius = 3.5;
        productPosterImage.clipsToBounds = YES;
        productPosterImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:productPosterImage];
        [productPosterImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 38, 0));
        }];
        
         huiLogoImage = [UIImageView new];
         huiLogoImage.backgroundColor = [UIColor clearColor];
         huiLogoImage.image = [UIImage imageNamed:@"hui_tag1"];
         [productPosterImage addSubview:huiLogoImage];
         huiLogoImage.clipsToBounds = YES;
         huiLogoImage.contentMode = UIViewContentModeScaleAspectFit;
         [huiLogoImage mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.top.equalTo(productPosterImage);
         make.width.height.equalTo(@(34));
         
         }];
        
        self.productName = @"神奇动物在哪里";
        productNameLabel = [UILabel new];
        productNameLabel.font = [UIFont systemFontOfSize:13];
        productNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
        productNameLabel.backgroundColor = [UIColor clearColor];
        productNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:productNameLabel];
        [productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.top.equalTo(productPosterImage.mas_bottom).offset(8);
            make.height.equalTo(@(15));
        }];
        self.productPrice = @"￥55";
        priceLabel = [UILabel new];
        priceLabel.font = [UIFont systemFontOfSize:10];
        priceLabel.textColor = [UIColor colorWithHex:@"#ff9900"];//b2b2b2
        priceLabel.backgroundColor = [UIColor clearColor];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.top.equalTo(productNameLabel.mas_bottom);
            make.height.equalTo(@(15));
        }];

    }
    return self;
}

- (void)updateLayout{
//    UIImage *placeHolderImage = [UIImage centerResizeFrom:[UIImage imageNamed:@"goods_nopic"] newSize:productPosterImage.frame.size bgColor:[UIColor whiteColor]];
    UIImage *placeHolderImage = [UIImage centerResizeFrom:[UIImage imageNamed:@"goods_nopic"] newSize:CGSizeMake(self.frame.size.width, self.frame.size.height-38) bgColor:[UIColor whiteColor]];
    huiLogoImage.hidden = YES;
    [productPosterImage sd_setImageWithURL:[CIASPublicUtility getUrlDeleteChineseWithString:self.imageUrl] placeholderImage:placeHolderImage];
    productNameLabel.text = self.productName;
    priceLabel.text = [NSString stringWithFormat:@"¥%.2f", self.productPrice.floatValue];
}
 
@end
