//
//  MovieListPosterCollectionViewCell.h
//  CIASMovie
//
//  Created by cias on 2016/12/16.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieSmallPosterCollectionViewCell : UICollectionViewCell

{
    UIImageView *moviePosterImage, *huiLogoImage;
    UILabel *movieNameLabel;
    UILabel *scoreLabel, *screenTypeLabel, *preSellLabel;
    
}
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *movieName;
@property (nonatomic, copy) NSString *point;
@property (nonatomic, copy) NSString *availableScreenType;

@property (nonatomic, assign) BOOL isPreSell;


- (void)updateLayout;


@end
