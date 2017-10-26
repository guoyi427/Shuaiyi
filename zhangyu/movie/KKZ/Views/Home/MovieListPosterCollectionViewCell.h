//
//  MovieListPosterCollectionViewCell.h
//  CIASMovie
//
//  Created by cias on 2016/12/16.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieListPosterCollectionViewCell : UICollectionViewCell

{
    UIImageView *huiLogoImage;
    UILabel *movieNameLabel;
    UILabel *scoreLabel, *screenTypeLabel, *preSellLabel;
    
}
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *movieName;
@property (nonatomic, copy) NSString *point;
@property (nonatomic, copy) NSString *availableScreenType;
@property (nonatomic, copy) NSString *moviePublishDate;
@property (nonatomic, strong) UIImageView *moviePosterImage;

@property (nonatomic, assign) BOOL isPresell;
@property (nonatomic, assign) BOOL isSale;

@property (nonatomic, copy) NSString *posterImageBackColor ;


- (void)updateLayout;


@end
