//
//  CinemaHomeCell.h
//  CIASMovie
//
//  Created by cias on 2016/12/20.
//  Copyright © 2016年 cias. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "Cinema.h"
@protocol CinemaHomeCellDelegate <NSObject>

- (void)didSelectedMovieWithMovie:(Movie*)amovie andIndex:(NSInteger)indexpathRow;

@end


@interface CinemaHomeCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>{
    UILabel     *cinemaNameLabel;
    UILabel     *cinemaAddressLabel;
    UILabel     *promotionLabel;
    UILabel     *priceLabel;
    UILabel     *distanceLabel;
    UIView      *line;
    UILabel     *nearLabel, *comeLabel, *promotionLogoLabel;
    UIView      *cinemaFeatureView;
    UIImageView *locationImageView, *huiImageView;
}
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong)      UIView *noMovieListAlertView;
@property (nonatomic, strong) Cinema *selectCinema;
@property (nonatomic, strong) NSMutableArray *movieList;
@property (nonatomic, strong) UICollectionView *movieCollectionView;
@property (nonatomic, assign) id<CinemaHomeCellDelegate> delegate;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) NSInteger indexRow;

@property (nonatomic, strong) NSArray  *featureArr;


- (void)updateLayout;
- (void)hideMovieList;

@end
